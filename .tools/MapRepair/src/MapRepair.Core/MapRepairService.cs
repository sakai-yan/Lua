using System.Text;
using System.Text.RegularExpressions;
using MapRepair.Core.Internal;
using MapRepair.Core.Internal.Gui;
using MapRepair.Core.Internal.Mpq;

namespace MapRepair.Core;

public sealed class MapRepairService
{
    private static readonly Regex TrigStrReferenceRegex = new(
        "\"TRIGSTR_(\\d+)\"",
        RegexOptions.Compiled | RegexOptions.CultureInvariant);

    private static readonly IReadOnlyDictionary<string, string> RebuiltObjectFileNameByEmbeddedSlkEntry =
        new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            [@"units\abilitybuffdata.slk"] = "war3map.w3h",
            [@"Units\AbilityData.slk"] = "war3map.w3a",
            [@"Units\ItemData.slk"] = "war3map.w3t",
            [@"Units\UnitAbilities.slk"] = "war3map.w3u",
            [@"Units\UnitBalance.slk"] = "war3map.w3u",
            [@"units\unitdata.slk"] = "war3map.w3u",
            [@"Units\unitUI.slk"] = "war3map.w3u",
            [@"units\unitweapons.slk"] = "war3map.w3u",
            [@"units\upgradedata.slk"] = "war3map.w3q"
        };

    public InspectResult Inspect(string inputMapPath)
    {
        if (string.IsNullOrWhiteSpace(inputMapPath))
        {
            throw new ArgumentException("Input map path cannot be empty.", nameof(inputMapPath));
        }

        var preserved = new List<string>();
        var missing = new List<string>();
        var unreadable = new List<string>();
        var warnings = new List<string>();
        var recoverable = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        using var archive = MpqArchiveReader.Open(inputMapPath);
        var candidates = CollectCandidateNames(archive, warnings);

        foreach (var fileName in candidates)
        {
            var result = archive.ReadFile(fileName);
            if (!result.Exists)
            {
                if (MapFileNames.RecoverableEntries.Contains(fileName, StringComparer.OrdinalIgnoreCase))
                {
                    missing.Add(fileName);
                    recoverable.Add(fileName);
                }

                continue;
            }

            if (!result.Readable)
            {
                unreadable.Add(fileName);
                if (MapFileNames.RecoverableEntries.Contains(fileName, StringComparer.OrdinalIgnoreCase))
                {
                    recoverable.Add(fileName);
                }

                if (!string.IsNullOrWhiteSpace(result.Warning))
                {
                    warnings.Add(result.Warning!);
                }

                continue;
            }

            preserved.Add(fileName);
        }

        if (!preserved.Contains(MapFileNames.ScriptJ, StringComparer.OrdinalIgnoreCase) &&
            !preserved.Contains(MapFileNames.ScriptLua, StringComparer.OrdinalIgnoreCase))
        {
            warnings.Add("The map contains neither `war3map.j` nor `war3map.lua`; the editor may regenerate script data on the next save.");
        }

        return new InspectResult(
            Path.GetFullPath(inputMapPath),
            true,
            preserved.OrderBy(path => path, StringComparer.OrdinalIgnoreCase).ToArray(),
            missing.OrderBy(path => path, StringComparer.OrdinalIgnoreCase).ToArray(),
            unreadable.OrderBy(path => path, StringComparer.OrdinalIgnoreCase).ToArray(),
            recoverable.OrderBy(path => path, StringComparer.OrdinalIgnoreCase).ToArray(),
            warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray());
    }

    public RepairResult Repair(RepairOptions options)
    {
        ArgumentNullException.ThrowIfNull(options);

        var inputPath = Path.GetFullPath(options.InputMapPath);
        var outputPath = Path.GetFullPath(options.OutputMapPath);
        if (string.Equals(inputPath, outputPath, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException("Output map path must be different from the input map path.");
        }

        if (!options.OverwriteOutput && File.Exists(outputPath))
        {
            throw new IOException($"Output map already exists: {outputPath}");
        }

        var repository = RepositoryLocator.Locate();
        var templates = new TemplateRepository(repository);
        var templateInfo = new W3iIniTemplateLoader().Load(templates.ReadMapInfoTemplate());
        var gameArchiveSource = new GameArchiveSource(WarcraftArchiveLocator.Locate());
        var preserved = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var generated = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var omitted = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var warnings = new List<string>();
        var outputEntries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
        var preservedArtifacts = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
        var fallbackLevel = MapRepairFallbackLevel.None;
        RecoveredGuiReconstructionResult? recoveredGui = null;
        IReadOnlyList<War3ImportEntry>? sourceImportEntries = null;

        using var archive = MpqArchiveReader.Open(inputPath);
        var candidates = CollectCandidateNames(archive, warnings);
        var importResult = archive.ReadFile(MapFileNames.Imports);
        if (importResult.Exists && importResult.Readable && importResult.Data is not null)
        {
            sourceImportEntries = War3ImportFileReader.ReadEntries(importResult.Data);
        }
        else if (!string.IsNullOrWhiteSpace(importResult.Warning))
        {
            warnings.Add(importResult.Warning!);
        }

        foreach (var fileName in candidates)
        {
            var result = archive.ReadFile(fileName);
            if (!result.Exists)
            {
                continue;
            }

            if (!result.Readable || result.Data is null)
            {
                omitted.Add(fileName);
                if (!string.IsNullOrWhiteSpace(result.Warning))
                {
                    warnings.Add(result.Warning!);
                }

                var rawBackup = archive.ReadRawFile(fileName);
                if (rawBackup.Exists && rawBackup.Readable && rawBackup.Data is not null)
                {
                    var backupName = BuildPreservedEntryPath("raw", fileName, ".rawbin");
                    StorePreservedArtifact(preservedArtifacts, backupName, rawBackup.Data, warnings, fileName);
                }

                continue;
            }

            outputEntries[fileName] = result.Data;
            preserved.Add(fileName);
        }

        RepairMissingScriptStringTableReferences(outputEntries, preserved, generated, warnings);
        PreserveReferencedAssets(archive, outputEntries, preserved, omitted, warnings, preservedArtifacts);

        var slkRebuilder = new SlkObjectRebuilder(gameArchiveSource);
        foreach (var rebuilt in slkRebuilder.Rebuild(outputEntries))
        {
            var shouldApply = !outputEntries.TryGetValue(rebuilt.FileName, out var existingObjectData) ||
                              !ObjectDataValidator.LooksValid(existingObjectData);
            if (!shouldApply)
            {
                continue;
            }

            BackupExistingEntry(outputEntries, preservedArtifacts, warnings, rebuilt.FileName);
            outputEntries[rebuilt.FileName] = rebuilt.Data;
            preserved.Remove(rebuilt.FileName);
            generated.Add(rebuilt.FileName);
            foreach (var warning in rebuilt.Warnings)
            {
                warnings.Add(warning);
            }
        }

        PreserveReferencedAssets(archive, outputEntries, preserved, omitted, warnings, preservedArtifacts);
        PruneRedundantModelAliases(outputEntries, preserved, warnings);
        WarnAboutUnresolvedModelTextures(outputEntries, gameArchiveSource, warnings);
        PruneEmbeddedObjectSourceSlks(outputEntries, preserved, warnings);

        var rebuiltImportEntries = ImportListWriter.CollectImportEntries(outputEntries.Keys, sourceImportEntries);
        if (rebuiltImportEntries.Count > 0)
        {
            outputEntries[MapFileNames.Imports] = ImportListWriter.Write(rebuiltImportEntries);
            generated.Add(MapFileNames.Imports);
            warnings.Add($"Rebuilt `war3map.imp` with {rebuiltImportEntries.Count} import/override paths.");
        }

        foreach (var objectFileName in MapFileNames.ObjectDataEntries)
        {
            if (generated.Contains(objectFileName))
            {
                continue;
            }

            if (!outputEntries.TryGetValue(objectFileName, out var objectData))
            {
                continue;
            }

            if (ObjectDataValidator.LooksValid(objectData))
            {
                continue;
            }

            BackupExistingEntry(outputEntries, preservedArtifacts, warnings, objectFileName);
            outputEntries[objectFileName] = ObjectDataWriter.WriteEmpty();
            preserved.Remove(objectFileName);
            generated.Add(objectFileName);
            warnings.Add($"`{objectFileName}` had an invalid object-data header and was replaced with an empty object-data file for editor compatibility.");
        }

        TerrainInfo terrain;
        if (outputEntries.TryGetValue(MapFileNames.Terrain, out var terrainBytes) &&
            W3eReader.TryReadTerrainInfo(terrainBytes, out terrain))
        {
            // keep original terrain
        }
        else
        {
            terrainBytes = templates.ReadTerrainTemplate();
            if (!W3eReader.TryReadTerrainInfo(terrainBytes, out terrain))
            {
                throw new InvalidDataException("Repository template `War3/map/war3map.w3e` could not be parsed.");
            }

            outputEntries[MapFileNames.Terrain] = terrainBytes;
            outputEntries[MapFileNames.Shadows] = templates.ReadShadowTemplate();
            preserved.Remove(MapFileNames.Terrain);
            preserved.Remove(MapFileNames.Shadows);
            generated.Add(MapFileNames.Terrain);
            generated.Add(MapFileNames.Shadows);
            fallbackLevel = Max(fallbackLevel, MapRepairFallbackLevel.TemplateTerrainFallback);
            warnings.Add("Original `war3map.w3e` was missing or unreadable; terrain and shadows were restored from repository templates.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.MapInfo))
        {
            outputEntries[MapFileNames.MapInfo] =
                W3iBinaryWriter.Write(templateInfo, terrain, Path.GetFileNameWithoutExtension(outputPath));
            generated.Add(MapFileNames.MapInfo);
            fallbackLevel = Max(fallbackLevel, MapRepairFallbackLevel.RebuiltMapInfo);
            warnings.Add("Original `war3map.w3i` was missing or unreadable; map info was rebuilt from the repository template and final terrain.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.Pathing))
        {
            outputEntries[MapFileNames.Pathing] = WpmWriter.Write(terrain);
            generated.Add(MapFileNames.Pathing);
            warnings.Add("Missing `war3map.wpm`; rebuilt an empty pathing map using the final terrain size.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.Doodads))
        {
            outputEntries[MapFileNames.Doodads] = DoodadWriter.WriteEmptyDoodads();
            generated.Add(MapFileNames.Doodads);
            warnings.Add("Missing `war3map.doo`; generated an empty doodad file.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.Units))
        {
            outputEntries[MapFileNames.Units] = DoodadWriter.WriteEmptyUnits();
            generated.Add(MapFileNames.Units);
            warnings.Add("Missing `war3mapUnits.doo`; generated an empty unit file.");
        }

        TryRebuildPanelsFromScript(outputEntries, generated, warnings);

        if (!outputEntries.ContainsKey(MapFileNames.Regions))
        {
            outputEntries[MapFileNames.Regions] = EditorPanelWriters.WriteEmptyRegions();
            generated.Add(MapFileNames.Regions);
            warnings.Add("Missing `war3map.w3r`; generated an empty region file.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.Cameras))
        {
            outputEntries[MapFileNames.Cameras] = EditorPanelWriters.WriteEmptyCameras();
            generated.Add(MapFileNames.Cameras);
            warnings.Add("Missing `war3map.w3c`; generated an empty camera file.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.Sounds))
        {
            outputEntries[MapFileNames.Sounds] = EditorPanelWriters.WriteEmptySounds();
            generated.Add(MapFileNames.Sounds);
            warnings.Add("Missing `war3map.w3s`; generated an empty sound file.");
        }

        var hasPreservedScript = outputEntries.ContainsKey(MapFileNames.ScriptJ) ||
                                 outputEntries.ContainsKey(MapFileNames.ScriptLua);
        var hasPreservedJassScript = outputEntries.ContainsKey(MapFileNames.ScriptJ);
        var hasPreservedLuaScript = outputEntries.ContainsKey(MapFileNames.ScriptLua);
        var needsTriggerReconstruction =
            !outputEntries.ContainsKey(MapFileNames.TriggerData) ||
            !outputEntries.ContainsKey(MapFileNames.TriggerStrings);

        if (needsTriggerReconstruction && hasPreservedJassScript)
        {
            recoveredGui = TryReconstructGuiTriggersFromJass(
                repository.RootPath,
                outputEntries,
                preserved,
                generated,
                warnings,
                preservedArtifacts);
        }
        else if (needsTriggerReconstruction && hasPreservedLuaScript)
        {
            warnings.Add("Missing `war3map.wtg/wct`; automatic GUI reconstruction currently supports only `war3map.j`, so Lua-script maps still keep trigger metadata absent.");
        }

        if (!outputEntries.ContainsKey(MapFileNames.TriggerData))
        {
            if (hasPreservedScript)
            {
                warnings.Add(
                    "Missing `war3map.wtg`; the protected source map only preserves compiled script and does not contain GUI trigger metadata. " +
                    "Left trigger data absent instead of injecting a repository template, because the original trigger tree cannot be reconstructed from this artifact.");
            }
            else
            {
                outputEntries[MapFileNames.TriggerData] = templates.ReadTriggerDataTemplate();
                generated.Add(MapFileNames.TriggerData);
                fallbackLevel = Max(fallbackLevel, MapRepairFallbackLevel.TriggerTemplateFallback);
                warnings.Add("Missing `war3map.wtg`; restored the repository trigger template.");
            }
        }

        if (!outputEntries.ContainsKey(MapFileNames.TriggerStrings))
        {
            if (hasPreservedScript)
            {
                warnings.Add(
                    "Missing `war3map.wct`; the protected source map does not contain original trigger comment/custom-text metadata. " +
                    "Left trigger custom-text data absent instead of injecting a repository template, because the original editor view cannot be reconstructed.");
            }
            else
            {
                outputEntries[MapFileNames.TriggerStrings] = templates.ReadTriggerStringsTemplate();
                generated.Add(MapFileNames.TriggerStrings);
                fallbackLevel = Max(fallbackLevel, MapRepairFallbackLevel.TriggerTemplateFallback);
                warnings.Add("Missing `war3map.wct`; restored the repository trigger-string template.");
            }
        }

        if (!outputEntries.ContainsKey(MapFileNames.ScriptJ) &&
            !outputEntries.ContainsKey(MapFileNames.ScriptLua))
        {
            warnings.Add("The repaired map still contains neither `war3map.j` nor `war3map.lua`; the editor may regenerate script data on the next save.");
        }

        EnsureEditorPanelEntry(outputEntries, generated, warnings, MapFileNames.Regions, EditorPanelWriters.WriteEmptyRegions, "war3map.w3r", "regions");
        EnsureEditorPanelEntry(outputEntries, generated, warnings, MapFileNames.Cameras, EditorPanelWriters.WriteEmptyCameras, "war3map.w3c", "cameras");
        EnsureEditorPanelEntry(outputEntries, generated, warnings, MapFileNames.Sounds, EditorPanelWriters.WriteEmptySounds, "war3map.w3s", "sounds");
        OverwritePanelsFromScript(outputEntries, generated, warnings);

        var listFileEntries = outputEntries.Keys
            .Where(name => !string.Equals(name, MapFileNames.ListFile, StringComparison.OrdinalIgnoreCase))
            .OrderBy(name => name, StringComparer.OrdinalIgnoreCase)
            .ToArray();
        outputEntries[MapFileNames.ListFile] = Encoding.UTF8.GetBytes(string.Join("\r\n", listFileEntries) + "\r\n");
        generated.Add(MapFileNames.ListFile);
        preserved.Remove(MapFileNames.ListFile);

        Directory.CreateDirectory(Path.GetDirectoryName(outputPath) ?? ".");
        MpqArchiveWriter.WriteArchive(outputPath, outputEntries);
        WarnIfSiblingWorkspaceTriggerFilesAreStale(outputPath, outputEntries, warnings);

        var reportDirectory = string.IsNullOrWhiteSpace(options.ReportDirectory)
            ? Path.Combine(Path.GetDirectoryName(outputPath) ?? ".", "MapRepairReports")
            : Path.GetFullPath(options.ReportDirectory);
        WritePreservedArtifacts(reportDirectory, preservedArtifacts);
        if (recoveredGui is { Succeeded: true, Document: not null })
        {
            RecoveredGuiArtifactsWriter.Write(reportDirectory, recoveredGui, recoveredGui.Document);
        }

        var reportPayload = new RepairReportPayload(
            inputPath,
            outputPath,
            repository.RootPath,
            fallbackLevel,
            preserved.OrderBy(name => name, StringComparer.OrdinalIgnoreCase).ToArray(),
            generated.OrderBy(name => name, StringComparer.OrdinalIgnoreCase).ToArray(),
            omitted.OrderBy(name => name, StringComparer.OrdinalIgnoreCase).ToArray(),
            warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray(),
            recoveredGui?.Summary,
            recoveredGui?.TriggerArtifacts.Select(static artifact => artifact.Risk).ToArray() ?? []);
        var (jsonPath, markdownPath) = RepairReportWriter.Write(reportDirectory, reportPayload);

        return new RepairResult(
            outputPath,
            fallbackLevel,
            reportPayload.PreservedFiles,
            reportPayload.GeneratedFiles,
            reportPayload.OmittedFiles,
            reportPayload.Warnings,
            jsonPath,
            markdownPath);
    }

    private static IReadOnlyList<string> CollectCandidateNames(MpqArchiveReader archive, ICollection<string> warnings)
    {
        var candidates = new HashSet<string>(MapFileNames.StandardEntries, StringComparer.OrdinalIgnoreCase);

        var listfileResult = archive.ReadFile(MapFileNames.ListFile);
        if (listfileResult.Exists && listfileResult.Readable && listfileResult.Data is not null)
        {
            foreach (var line in Encoding.UTF8.GetString(listfileResult.Data)
                         .Split(['\r', '\n', '\0'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (!string.IsNullOrWhiteSpace(line))
                {
                    candidates.Add(line.Replace('/', '\\'));
                }
            }
        }
        else if (!string.IsNullOrWhiteSpace(listfileResult.Warning))
        {
            warnings.Add(listfileResult.Warning!);
        }

        var importResult = archive.ReadFile(MapFileNames.Imports);
        if (importResult.Exists && importResult.Readable && importResult.Data is not null)
        {
            foreach (var path in War3ImportFileReader.ReadImportedPaths(importResult.Data))
            {
                candidates.Add(path);
            }
        }
        else if (!string.IsNullOrWhiteSpace(importResult.Warning))
        {
            warnings.Add(importResult.Warning!);
        }

        var uiConfigResult = archive.ReadFile(MapFileNames.UiConfig);
        if (uiConfigResult.Exists && uiConfigResult.Readable && uiConfigResult.Data is not null)
        {
            candidates.Add(MapFileNames.UiConfig);
            foreach (var packageName in TextFileCodec.Decode(uiConfigResult.Data).Text
                         .Replace("\r\n", "\n", StringComparison.Ordinal)
                         .Split('\n', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (string.IsNullOrWhiteSpace(packageName))
                {
                    continue;
                }

                var prefix = $@"ui\{packageName}\";
                candidates.Add(prefix + "action.txt");
                candidates.Add(prefix + "call.txt");
                candidates.Add(prefix + "condition.txt");
                candidates.Add(prefix + "event.txt");
                candidates.Add(prefix + MapFileNames.UiTriggerData);
                candidates.Add(prefix + MapFileNames.UiTriggerStrings);
            }
        }
        else if (!string.IsNullOrWhiteSpace(uiConfigResult.Warning))
        {
            warnings.Add(uiConfigResult.Warning!);
        }

        return candidates.OrderBy(name => name, StringComparer.OrdinalIgnoreCase).ToArray();
    }

    private static void PreserveReferencedAssets(
        MpqArchiveReader archive,
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ISet<string> omitted,
        ICollection<string> warnings,
        IDictionary<string, byte[]> preservedArtifacts)
    {
        var addedReferenceSources = 0;
        foreach (var fileName in ReferencedAssetCollector.GetReferenceSourceEntryNames())
        {
            if (outputEntries.ContainsKey(fileName))
            {
                continue;
            }

            if (!TryPreserveEntry(archive, outputEntries, preserved, omitted, warnings, preservedArtifacts, fileName))
            {
                continue;
            }

            addedReferenceSources++;
        }

        var recoveredReferencedAssets = 0;
        while (true)
        {
            var recoveredThisPass = 0;
            var referenceEntries = outputEntries is IReadOnlyDictionary<string, byte[]> readOnlyOutputEntries
                ? readOnlyOutputEntries
                : new Dictionary<string, byte[]>(outputEntries, StringComparer.OrdinalIgnoreCase);
            foreach (var assetPath in ReferencedAssetCollector.Collect(referenceEntries))
            {
                if (outputEntries.ContainsKey(assetPath))
                {
                    continue;
                }

                if (!TryPreserveReferencedEntry(archive, outputEntries, preserved, omitted, warnings, preservedArtifacts, assetPath))
                {
                    continue;
                }

                recoveredReferencedAssets++;
                recoveredThisPass++;
            }

            if (recoveredThisPass == 0)
            {
                break;
            }
        }

        if (addedReferenceSources > 0)
        {
            warnings.Add($"Preserved {addedReferenceSources} known SLK/profile source entries that were missing from the initial archive candidate list.");
        }

        if (recoveredReferencedAssets > 0)
        {
            warnings.Add($"Preserved {recoveredReferencedAssets} referenced asset files inferred from object-data, script, text, SLK, or model texture paths.");
        }
    }

    private static void PruneRedundantModelAliases(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ICollection<string> warnings)
    {
        var referenceEntries = outputEntries is IReadOnlyDictionary<string, byte[]> readOnlyOutputEntries
            ? readOnlyOutputEntries
            : new Dictionary<string, byte[]>(outputEntries, StringComparer.OrdinalIgnoreCase);
        var referencedAssets = new HashSet<string>(
            ReferencedAssetCollector.Collect(referenceEntries)
                .Select(NormalizeReferencedPath)
                .Where(path => !string.IsNullOrWhiteSpace(path)),
            StringComparer.OrdinalIgnoreCase);

        var prunedMdxAliases = PruneUnreferencedModelAliases(
            outputEntries,
            preserved,
            referencedAssets,
            ".mdx",
            ".mdl");
        var prunedMdlAliases = PruneUnreferencedModelAliases(
            outputEntries,
            preserved,
            referencedAssets,
            ".mdl",
            ".mdx");

        if (prunedMdxAliases.Count == 0 && prunedMdlAliases.Count == 0)
        {
            return;
        }

        warnings.Add(
            $"Pruned {prunedMdxAliases.Count + prunedMdlAliases.Count} unreferenced source model aliases because the detected references only required the opposite extension variants (`.mdx` -> `.mdl`: {prunedMdxAliases.Count}, `.mdl` -> `.mdx`: {prunedMdlAliases.Count}).");
    }

    private static IReadOnlyList<string> PruneUnreferencedModelAliases(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        IReadOnlySet<string> referencedAssets,
        string sourceExtension,
        string requiredExtension)
    {
        var prunedAliases = new List<string>();
        foreach (var entryPath in outputEntries.Keys.ToArray())
        {
            if (!Path.GetExtension(entryPath).Equals(sourceExtension, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var normalizedEntryPath = NormalizeReferencedPath(entryPath);
            if (string.IsNullOrWhiteSpace(normalizedEntryPath) ||
                referencedAssets.Contains(normalizedEntryPath))
            {
                continue;
            }

            var requiredAliases = BuildEquivalentModelAliasPaths(normalizedEntryPath, requiredExtension);
            var hasReferencedRequiredAlias = requiredAliases.Any(aliasPath =>
                outputEntries.ContainsKey(aliasPath) &&
                referencedAssets.Contains(aliasPath));
            if (!hasReferencedRequiredAlias)
            {
                continue;
            }

            outputEntries.Remove(entryPath);
            preserved.Remove(entryPath);
            prunedAliases.Add(entryPath);
        }

        return prunedAliases;
    }

    private static bool TryPreserveReferencedEntry(
        MpqArchiveReader archive,
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ISet<string> omitted,
        ICollection<string> warnings,
        IDictionary<string, byte[]> preservedArtifacts,
        string referencedPath)
    {
        var targetPath = NormalizeReferencedPath(referencedPath);
        if (string.IsNullOrWhiteSpace(targetPath))
        {
            return false;
        }

        if (outputEntries.ContainsKey(targetPath))
        {
            return true;
        }

        foreach (var candidatePath in BuildReferencedPathCandidates(targetPath))
        {
            if (outputEntries.TryGetValue(candidatePath, out var existingData))
            {
                outputEntries[targetPath] = existingData;
                preserved.Add(targetPath);
                omitted.Remove(targetPath);
                AddModelFormatWarningIfNeeded(targetPath, candidatePath, existingData, warnings);
                return true;
            }

            var result = archive.ReadFile(candidatePath);
            if (!result.Exists)
            {
                continue;
            }

            if (!result.Readable || result.Data is null)
            {
                if (!string.IsNullOrWhiteSpace(result.Warning))
                {
                    warnings.Add(result.Warning!);
                }

                var rawBackup = archive.ReadRawFile(candidatePath);
                if (rawBackup.Exists && rawBackup.Readable && rawBackup.Data is not null)
                {
                    var backupName = BuildPreservedEntryPath("raw", candidatePath, ".rawbin");
                    StorePreservedArtifact(preservedArtifacts, backupName, rawBackup.Data, warnings, candidatePath);
                }

                continue;
            }

            outputEntries[targetPath] = result.Data;
            preserved.Add(targetPath);
            omitted.Remove(targetPath);
            if (!candidatePath.Equals(targetPath, StringComparison.OrdinalIgnoreCase))
            {
                omitted.Remove(candidatePath);
            }

            AddModelFormatWarningIfNeeded(targetPath, candidatePath, result.Data, warnings);

            return true;
        }

        return false;
    }

    private static IReadOnlyList<string> BuildReferencedPathCandidates(string referencedPath)
    {
        var normalized = NormalizeReferencedPath(referencedPath);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return [];
        }

        var candidates = new List<string>();
        void Add(string path)
        {
            if (string.IsNullOrWhiteSpace(path) ||
                candidates.Contains(path, StringComparer.OrdinalIgnoreCase))
            {
                return;
            }

            candidates.Add(path);
        }

        Add(normalized);

        if (normalized.StartsWith("war3mapImported", StringComparison.OrdinalIgnoreCase) &&
            !normalized.StartsWith(@"war3mapImported\", StringComparison.OrdinalIgnoreCase))
        {
            var suffix = normalized["war3mapImported".Length..].TrimStart('\\', '/');
            Add($@"war3mapImported\{suffix}");
        }

        var extension = Path.GetExtension(normalized);
        if (extension.Equals(".mdl", StringComparison.OrdinalIgnoreCase))
        {
            Add(Path.ChangeExtension(normalized, ".mdx"));
        }
        else if (extension.Equals(".mdx", StringComparison.OrdinalIgnoreCase))
        {
            Add(Path.ChangeExtension(normalized, ".mdl"));
        }

        var fileName = Path.GetFileName(normalized);
        var hasDirectory = normalized.Contains('\\');
        if (normalized.StartsWith(@"war3mapImported\", StringComparison.OrdinalIgnoreCase))
        {
            var withoutImportedPrefix = normalized[@"war3mapImported\".Length..];
            Add(withoutImportedPrefix);

            if (extension.Equals(".mdl", StringComparison.OrdinalIgnoreCase))
            {
                Add(Path.ChangeExtension(withoutImportedPrefix, ".mdx"));
            }
            else if (extension.Equals(".mdx", StringComparison.OrdinalIgnoreCase))
            {
                Add(Path.ChangeExtension(withoutImportedPrefix, ".mdl"));
            }
        }

        if (!hasDirectory && !string.IsNullOrWhiteSpace(fileName))
        {
            Add($@"war3mapImported\{fileName}");

            if (extension.Equals(".mdl", StringComparison.OrdinalIgnoreCase))
            {
                Add($@"war3mapImported\{Path.ChangeExtension(fileName, ".mdx")}");
            }
            else if (extension.Equals(".mdx", StringComparison.OrdinalIgnoreCase))
            {
                Add($@"war3mapImported\{Path.ChangeExtension(fileName, ".mdl")}");
            }
        }

        return candidates;
    }

    private static IReadOnlyList<string> BuildEquivalentModelAliasPaths(string entryPath, string targetExtension)
    {
        var normalized = NormalizeReferencedPath(entryPath);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return [];
        }

        var targetPath = Path.ChangeExtension(normalized, targetExtension);
        return BuildReferencedPathCandidates(targetPath)
            .Select(NormalizeReferencedPath)
            .Where(path => !string.IsNullOrWhiteSpace(path) &&
                           Path.GetExtension(path).Equals(targetExtension, StringComparison.OrdinalIgnoreCase))
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static string NormalizeReferencedPath(string referencedPath)
    {
        var normalized = referencedPath.Replace('/', '\\').Trim().TrimStart('\\');
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return string.Empty;
        }

        if (normalized.StartsWith("war3mapImported", StringComparison.OrdinalIgnoreCase) &&
            !normalized.StartsWith(@"war3mapImported\", StringComparison.OrdinalIgnoreCase))
        {
            var suffix = normalized["war3mapImported".Length..].TrimStart('\\', '/');
            normalized = $@"war3mapImported\{suffix}";
        }

        return normalized;
    }

    private static void AddModelFormatWarningIfNeeded(
        string targetPath,
        string sourcePath,
        byte[] data,
        ICollection<string> warnings)
    {
        if (!Path.GetExtension(targetPath).Equals(".mdl", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        if (!ModelTextureDependencyCollector.LooksLikeBinaryMdx(data))
        {
            return;
        }

        warnings.Add(
            $"`{targetPath}` was rebuilt from `{sourcePath}` using a binary `MDX` payload. " +
            "The archive path now matches the `.mdl` reference, but the model format still does not match the `.mdl` extension and the editor may continue treating it as missing.");
    }

    private static void WarnAboutUnresolvedModelTextures(
        IReadOnlyDictionary<string, byte[]> outputEntries,
        GameArchiveSource gameArchiveSource,
        ICollection<string> warnings)
    {
        var gameArchiveHits = new Dictionary<string, bool>(StringComparer.OrdinalIgnoreCase);
        foreach (var entry in outputEntries)
        {
            if (!ModelTextureDependencyCollector.LooksLikeModelFile(entry.Key))
            {
                continue;
            }

            foreach (var texturePath in ModelTextureDependencyCollector.CollectTexturePaths(entry.Key, entry.Value))
            {
                var normalizedTexturePath = NormalizeReferencedPath(texturePath);
                if (string.IsNullOrWhiteSpace(normalizedTexturePath) ||
                    outputEntries.ContainsKey(normalizedTexturePath))
                {
                    continue;
                }

                if (!gameArchiveHits.TryGetValue(normalizedTexturePath, out var existsInGameArchives))
                {
                    existsInGameArchives = gameArchiveSource.TryRead(normalizedTexturePath) is not null;
                    gameArchiveHits[normalizedTexturePath] = existsInGameArchives;
                }

                if (existsInGameArchives)
                {
                    continue;
                }

                warnings.Add(
                    $"`{entry.Key}` references texture `{normalizedTexturePath}`, but that texture was not found in the repaired archive or the detected Warcraft archives. " +
                    "If the model still renders incorrectly, restore the texture under this exact path.");
            }
        }
    }

    private static bool TryPreserveEntry(
        MpqArchiveReader archive,
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ISet<string> omitted,
        ICollection<string> warnings,
        IDictionary<string, byte[]> preservedArtifacts,
        string fileName)
    {
        var result = archive.ReadFile(fileName);
        if (!result.Exists)
        {
            return false;
        }

        if (!result.Readable || result.Data is null)
        {
            omitted.Add(fileName);
            if (!string.IsNullOrWhiteSpace(result.Warning))
            {
                warnings.Add(result.Warning!);
            }

            var rawBackup = archive.ReadRawFile(fileName);
            if (rawBackup.Exists && rawBackup.Readable && rawBackup.Data is not null)
            {
                var backupName = BuildPreservedEntryPath("raw", fileName, ".rawbin");
                StorePreservedArtifact(preservedArtifacts, backupName, rawBackup.Data, warnings, fileName);
            }

            return false;
        }

        outputEntries[fileName] = result.Data;
        preserved.Add(fileName);
        return true;
    }

    private static void RepairMissingScriptStringTableReferences(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ISet<string> generated,
        ICollection<string> warnings)
    {
        var referencedIds = CollectReferencedTrigStrIds(outputEntries);
        if (referencedIds.Count == 0)
        {
            return;
        }

        DecodedTextFile decodedWts;
        var hadWts = outputEntries.TryGetValue(MapFileNames.Strings, out var wtsBytes) && wtsBytes is not null;
        if (hadWts)
        {
            decodedWts = TextFileCodec.Decode(wtsBytes!);
        }
        else
        {
            decodedWts = new DecodedTextFile(string.Empty, new UTF8Encoding(false));
        }

        var existingIds = new HashSet<int>(JassPanelInference.ParseWts(decodedWts.Text).Keys);
        var missingIds = referencedIds
            .Where(id => !existingIds.Contains(id))
            .OrderBy(id => id)
            .ToArray();
        if (missingIds.Length == 0)
        {
            return;
        }

        var builder = new StringBuilder(decodedWts.Text);
        if (builder.Length > 0 && !decodedWts.Text.EndsWith("\n", StringComparison.Ordinal) && !decodedWts.Text.EndsWith("\r", StringComparison.Ordinal))
        {
            builder.Append("\r\n");
        }

        if (builder.Length > 0)
        {
            builder.Append("\r\n");
        }

        foreach (var id in missingIds)
        {
            builder
                .Append("STRING ")
                .Append(id)
                .Append("\r\n{\r\nTRIGSTR_")
                .Append(id.ToString("000"))
                .Append("\r\n}\r\n\r\n");
        }

        outputEntries[MapFileNames.Strings] = TextFileCodec.Encode(decodedWts with { Text = builder.ToString() });
        preserved.Remove(MapFileNames.Strings);
        generated.Add(MapFileNames.Strings);
        warnings.Add(
            $"Added {missingIds.Length} placeholder `TRIGSTR_*` definitions to `war3map.wts` because the preserved script references them but the protected source string table does not.");
    }

    private static IReadOnlySet<int> CollectReferencedTrigStrIds(IDictionary<string, byte[]> outputEntries)
    {
        var ids = new HashSet<int>();
        foreach (var scriptEntryName in new[] { MapFileNames.ScriptJ, MapFileNames.ScriptLua })
        {
            if (!outputEntries.TryGetValue(scriptEntryName, out var scriptBytes) || scriptBytes is null)
            {
                continue;
            }

            var scriptText = TextFileCodec.Decode(scriptBytes).Text;
            foreach (Match match in TrigStrReferenceRegex.Matches(scriptText))
            {
                if (int.TryParse(match.Groups[1].Value, out var id))
                {
                    ids.Add(id);
                }
            }
        }

        return ids;
    }

    private static MapRepairFallbackLevel Max(MapRepairFallbackLevel left, MapRepairFallbackLevel right) =>
        (MapRepairFallbackLevel)Math.Max((int)left, (int)right);

    private static void BackupExistingEntry(
        IDictionary<string, byte[]> outputEntries,
        IDictionary<string, byte[]> preservedArtifacts,
        ICollection<string> warnings,
        string originalName)
    {
        if (!outputEntries.TryGetValue(originalName, out var originalData))
        {
            return;
        }

        var backupName = BuildPreservedEntryPath("original", originalName, ".bin");
        if (preservedArtifacts.ContainsKey(backupName))
        {
            return;
        }

        StorePreservedArtifact(preservedArtifacts, backupName, originalData, warnings, originalName);
    }

    private static string BuildPreservedEntryPath(string category, string originalName, string suffix)
    {
        var normalized = originalName.Replace('/', '\\').TrimStart('\\');
        return $@"MapRepairPreserved\{category}\{normalized}{suffix}";
    }

    private static void TryRebuildPanelsFromScript(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> generated,
        ICollection<string> warnings)
    {
        if (!outputEntries.TryGetValue(MapFileNames.ScriptJ, out var scriptBytes))
        {
            return;
        }

        var scriptText = Encoding.UTF8.GetString(scriptBytes);
        var wts = outputEntries.TryGetValue(MapFileNames.Strings, out var wtsBytes)
            ? JassPanelInference.ParseWts(Encoding.UTF8.GetString(wtsBytes))
            : new Dictionary<int, string>();

        if (!outputEntries.ContainsKey(MapFileNames.Regions))
        {
            var regions = JassPanelInference.InferRegions(scriptText);
            if (regions.Count > 0)
            {
                outputEntries[MapFileNames.Regions] = PanelContentWriters.WriteRegions(regions);
                generated.Add(MapFileNames.Regions);
                warnings.Add($"Inferred {regions.Count} regions from war3map.j into `war3map.w3r`.");
            }
        }

        if (!outputEntries.ContainsKey(MapFileNames.Cameras))
        {
            var cameras = JassPanelInference.InferCameras(scriptText);
            if (cameras.Count > 0)
            {
                outputEntries[MapFileNames.Cameras] = PanelContentWriters.WriteCameras(cameras);
                generated.Add(MapFileNames.Cameras);
                warnings.Add($"Inferred {cameras.Count} cameras from war3map.j into `war3map.w3c`.");
            }
        }

        if (!outputEntries.ContainsKey(MapFileNames.Sounds))
        {
            var sounds = JassPanelInference.InferSounds(scriptText, wts);
            if (sounds.Count > 0)
            {
                outputEntries[MapFileNames.Sounds] = PanelContentWriters.WriteSounds(sounds);
                generated.Add(MapFileNames.Sounds);
                warnings.Add($"Inferred {sounds.Count} sounds from war3map.j/WTS into `war3map.w3s`.");
            }
        }
    }

    private static void OverwritePanelsFromScript(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> generated,
        ICollection<string> warnings)
    {
        if (!outputEntries.TryGetValue(MapFileNames.ScriptJ, out var scriptBytes))
        {
            return;
        }

        var scriptText = Encoding.UTF8.GetString(scriptBytes);
        var wts = outputEntries.TryGetValue(MapFileNames.Strings, out var wtsBytes)
            ? JassPanelInference.ParseWts(Encoding.UTF8.GetString(wtsBytes))
            : new Dictionary<int, string>();

        var regions = JassPanelInference.InferRegions(scriptText);
        if (regions.Count > 0)
        {
            outputEntries[MapFileNames.Regions] = PanelContentWriters.WriteRegions(regions);
            generated.Add(MapFileNames.Regions);
            warnings.Add($"Inferred {regions.Count} regions from war3map.j into `war3map.w3r`.");
        }

        var cameras = JassPanelInference.InferCameras(scriptText);
        if (cameras.Count > 0)
        {
            outputEntries[MapFileNames.Cameras] = PanelContentWriters.WriteCameras(cameras);
            generated.Add(MapFileNames.Cameras);
            warnings.Add($"Inferred {cameras.Count} cameras from war3map.j into `war3map.w3c`.");
        }

        var sounds = JassPanelInference.InferSounds(scriptText, wts);
        if (sounds.Count > 0)
        {
            outputEntries[MapFileNames.Sounds] = PanelContentWriters.WriteSounds(sounds);
            generated.Add(MapFileNames.Sounds);
            warnings.Add($"Inferred {sounds.Count} sounds from war3map.j/WTS into `war3map.w3s`.");
        }
    }

    private static void EnsureEditorPanelEntry(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> generated,
        ICollection<string> warnings,
        string fileName,
        Func<byte[]> factory,
        string displayName,
        string panelName)
    {
        if (outputEntries.ContainsKey(fileName))
        {
            return;
        }

        outputEntries[fileName] = factory();
        generated.Add(fileName);
        warnings.Add($"Missing `{displayName}`; generated an empty {panelName} file.");
    }

    private static void StorePreservedArtifact(
        IDictionary<string, byte[]> preservedArtifacts,
        string backupName,
        byte[] data,
        ICollection<string> warnings,
        string originalName)
    {
        if (preservedArtifacts.ContainsKey(backupName))
        {
            return;
        }

        preservedArtifacts[backupName] = data;
        warnings.Add($"Preserved the original `{originalName}` payload under report artifact `{backupName}`.");
    }

    private static void WritePreservedArtifacts(string reportDirectory, IReadOnlyDictionary<string, byte[]> preservedArtifacts)
    {
        foreach (var artifact in preservedArtifacts)
        {
            var outputPath = Path.Combine(reportDirectory, "preserved", artifact.Key);
            var directoryPath = Path.GetDirectoryName(outputPath);
            if (!string.IsNullOrWhiteSpace(directoryPath))
            {
                Directory.CreateDirectory(directoryPath);
            }

            File.WriteAllBytes(outputPath, artifact.Value);
        }
    }

    private static void WarnIfSiblingWorkspaceTriggerFilesAreStale(
        string outputPath,
        IReadOnlyDictionary<string, byte[]> outputEntries,
        ICollection<string> warnings)
    {
        var outputDirectory = Path.GetDirectoryName(outputPath);
        if (string.IsNullOrWhiteSpace(outputDirectory))
        {
            return;
        }

        var workspaceRoot = Path.Combine(outputDirectory, Path.GetFileNameWithoutExtension(outputPath));
        var workspaceMapDirectory = Path.Combine(workspaceRoot, "map");
        if (!Directory.Exists(workspaceMapDirectory))
        {
            return;
        }

        var staleWorkspaceFiles = new List<string>();
        TrackStaleWorkspaceFile(workspaceMapDirectory, outputEntries, MapFileNames.TriggerData, staleWorkspaceFiles);
        TrackStaleWorkspaceFile(workspaceMapDirectory, outputEntries, MapFileNames.TriggerStrings, staleWorkspaceFiles);
        if (staleWorkspaceFiles.Count == 0)
        {
            return;
        }

        warnings.Add(
            $"Detected an existing sibling unpacked workspace `{workspaceRoot}` whose `{string.Join("`, `", staleWorkspaceFiles)}` file(s) do not match the newly repaired archive. " +
            "MapRepair refreshed only the `.w3x`; re-export or resync that unpacked workspace before opening triggers in an external editor.");
    }

    private static void TrackStaleWorkspaceFile(
        string workspaceMapDirectory,
        IReadOnlyDictionary<string, byte[]> outputEntries,
        string entryName,
        ICollection<string> staleWorkspaceFiles)
    {
        if (!outputEntries.TryGetValue(entryName, out var expectedBytes))
        {
            return;
        }

        var workspaceFilePath = Path.Combine(workspaceMapDirectory, entryName);
        if (!File.Exists(workspaceFilePath))
        {
            return;
        }

        var workspaceBytes = File.ReadAllBytes(workspaceFilePath);
        if (!workspaceBytes.AsSpan().SequenceEqual(expectedBytes))
        {
            staleWorkspaceFiles.Add($@"map\{entryName}");
        }
    }

    private static void PruneEmbeddedObjectSourceSlks(
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ICollection<string> warnings)
    {
        var prunedEntries = new List<string>();

        foreach (var entryName in ReferencedAssetCollector.GetSlkEntryNames())
        {
            if (!RebuiltObjectFileNameByEmbeddedSlkEntry.TryGetValue(entryName, out var rebuiltObjectFileName) ||
                !outputEntries.ContainsKey(rebuiltObjectFileName) ||
                !outputEntries.Remove(entryName))
            {
                continue;
            }

            preserved.Remove(entryName);
            prunedEntries.Add(entryName);
        }

        if (prunedEntries.Count == 0)
        {
            return;
        }

        warnings.Add(
            $"Pruned {prunedEntries.Count} embedded object-source SLK entries after rebuilding object data so later `w3x2lni` exports do not inherit stale map SLK metadata.");
    }

    private static RecoveredGuiReconstructionResult TryReconstructGuiTriggersFromJass(
        string repositoryRoot,
        IDictionary<string, byte[]> outputEntries,
        ISet<string> preserved,
        ISet<string> generated,
        ICollection<string> warnings,
        IDictionary<string, byte[]> preservedArtifacts)
    {
        var scriptBytes = outputEntries[MapFileNames.ScriptJ];
        var scriptText = TextFileCodec.Decode(scriptBytes).Text;
        var metadata = GuiMetadataCatalog.Load(repositoryRoot, (IReadOnlyDictionary<string, byte[]>)outputEntries);
        var reconstruction = new JassGuiReconstructionParser().Reconstruct(scriptText, metadata);

        if (!reconstruction.Succeeded || reconstruction.Document is null)
        {
            warnings.Add("Attempted to reconstruct `war3map.wtg/wct` from `war3map.j`, but no legal trigger tree could be produced.");
            foreach (var note in reconstruction.Summary.Notes)
            {
                warnings.Add(note);
            }

            return reconstruction;
        }

        var wtgBytes = LegacyGuiBinaryCodec.WriteWtg(reconstruction.Document);
        if (!YdweWtgCompatibilityValidator.TryValidate(wtgBytes, metadata, out var compatibilityFailure))
        {
            warnings.Add($"Reconstructed `war3map.wtg` failed YDWE-compatible validation: {compatibilityFailure}");
            return reconstruction;
        }

        var wctBytes = LegacyGuiBinaryCodec.WriteWct(reconstruction.Document);
        if (outputEntries.ContainsKey(MapFileNames.TriggerData))
        {
            BackupExistingEntry(outputEntries, preservedArtifacts, warnings, MapFileNames.TriggerData);
        }

        if (outputEntries.ContainsKey(MapFileNames.TriggerStrings))
        {
            BackupExistingEntry(outputEntries, preservedArtifacts, warnings, MapFileNames.TriggerStrings);
        }

        outputEntries[MapFileNames.TriggerData] = wtgBytes;
        outputEntries[MapFileNames.TriggerStrings] = wctBytes;
        preserved.Remove(MapFileNames.TriggerData);
        preserved.Remove(MapFileNames.TriggerStrings);
        generated.Add(MapFileNames.TriggerData);
        generated.Add(MapFileNames.TriggerStrings);

        warnings.Add(
            $"Reconstructed {reconstruction.Summary.TriggerCount} GUI trigger(s) and {reconstruction.Summary.VariableCount} GUI variable(s) from `war3map.j`.");
        if (reconstruction.Summary.CustomTextTriggerCount > 0)
        {
            warnings.Add(
                $"{reconstruction.Summary.CustomTextTriggerCount} reconstructed trigger(s) used custom-text fallback because their compiled structure could not be safely mapped back into editable GUI nodes.");
        }

        foreach (var note in reconstruction.Summary.Notes)
        {
            warnings.Add(note);
        }

        return reconstruction;
    }
}
