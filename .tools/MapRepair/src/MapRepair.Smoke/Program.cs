using System.Text;
using System.Text.Json;
using System.Reflection;
using System.Diagnostics;
using MapRepair.Core;
using MapRepair.Core.Internal;
using MapRepair.Core.Internal.Gui;
using MapRepair.Core.Internal.Mpq;

var repository = RepositoryLocator.Locate();
var templates = new TemplateRepository(repository);
var templateInfo = new W3iIniTemplateLoader().Load(templates.ReadMapInfoTemplate());
var terrainBytes = templates.ReadTerrainTemplate();
if (!W3eReader.TryReadTerrainInfo(terrainBytes, out var terrain))
{
    throw new InvalidOperationException("模板地形不可解析。");
}

var tempRoot = Path.Combine(Path.GetTempPath(), "MapRepairSmoke", Guid.NewGuid().ToString("N"));
Directory.CreateDirectory(tempRoot);

try
{
    var scriptPath = Path.Combine(repository.RootPath, "War3", "map", "war3map.j");
    var service = new MapRepairService();
    var guiMetadata = GuiMetadataCatalog.Load(repository.RootPath, new Dictionary<string, byte[]>());

    RunScenario(
        "healthy",
        CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true),
        expectedGenerated: []);

    RunScenario(
        "missing-triggers",
        CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiRecoveryScript()),
        expectedGenerated: [MapFileNames.TriggerData, MapFileNames.TriggerStrings]);

    RunScenario(
        "missing-triggers-no-script",
        CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true),
        expectedGenerated: [MapFileNames.TriggerData, MapFileNames.TriggerStrings]);

    RunScenario(
        "missing-w3i",
        CreateArchiveEntries(includeScript: true, includeW3i: false, includeTerrain: true, includeTriggers: true, includeDoodads: true),
        expectedGenerated: [MapFileNames.MapInfo]);

    RunScenario(
        "missing-terrain",
        CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: false, includeTriggers: true, includeDoodads: true),
        expectedGenerated: [MapFileNames.Terrain]);

    RunScenario(
        "missing-doo",
        CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: false),
        expectedGenerated: [MapFileNames.Doodads, MapFileNames.Units]);

    RunImportScenario();
    RunMissingTrigStrScenario();
    RunLegacyGuiBinaryRoundtripScenario();
    RunGuiVariableRecoveryScenario();
    RunGuiActionOnlyTriggerScenario();
    RunEventlessGuiFallbackScenario();
    RunExecutedEventlessGuiTriggerScenario();
    RunLargeStructuredSetVariableTriggerScenario();
    RunStringHeavyQuestTimerFallbackScenario();
    RunCustomTextCallbackClosureScenario();
    RunCustomTextLocalClosureScenario();
    RunCustomTextSourceSliceGlobalsScenario();
    RunOpaqueInitFallbackScenario();
    RunGuiExtensionCompatibilityFallbackScenario();
    RunQuotedYdweExtensionMetadataScenario();
    RunMapLocalExtensionRecoveryScenario();
    RunGuiConditionGuardScenario();
    RunGuiGuardedComparisonConditionRecoveryScenario();
    RunGuiMultiGuardConditionRecoveryScenario();
    RunGuiActionIfThenElseChildBlockRecoveryScenario();
    RunGuiArrayIndexedHelperConditionRecoveryScenario();
    RunAlmostAllCustomPseudoGuiFallbackScenario();
    RunSmallBranchyPseudoGuiFallbackScenario();
    RunMediumBranchyPseudoGuiFallbackScenario();
    RunMediumControlPseudoGuiFallbackScenario();
    RunFocusedMixedPseudoGuiFallbackScenario();
    RunGuardedMixedPseudoGuiFallbackScenario();
    RunScriptSideEffectMixedPseudoGuiFallbackScenario();
    RunFinalStableBandPseudoGuiFallbackScenario();
    RunCompactControlHeavyPseudoGuiFallbackScenario();
    RunCompactGuardedPseudoGuiFallbackScenario();
    RunScriptHeavyPseudoGuiFallbackScenario();
    RunCompactPseudoGuiFallbackScenario();
    RunMediumPseudoGuiFallbackScenario();
    RunLargePseudoGuiFallbackScenario();
    RunGuiReconstructionFailureScenario();
    RunSampleGuiReconstructionScenario();
    RunStaleSiblingWorkspaceWarningScenario();
    RunW2lLniReconstructionScenario();
    RunObjectDataReferencedAssetScenario();
    RunTextMdlTextureDependencyScenario();
    RunBinaryModelTextureWarningScenario();
    RunMdlToMdxFallbackScenario();
    RunMdxToMdlFallbackScenario();
    RunScriptMdlToMdxFallbackScenario();
    RunScriptMdxToMdlFallbackScenario();
    RunRawStringFallbackScenario();
    RunMetadataEnumTypingScenario();

    Console.WriteLine($"MapRepair smoke passed. Temp root: {tempRoot}");
    return 0;

    Dictionary<string, byte[]> CreateArchiveEntries(bool includeScript, bool includeW3i, bool includeTerrain, bool includeTriggers, bool includeDoodads, byte[]? scriptOverride = null)
    {
        var entries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);

        if (scriptOverride is not null)
        {
            entries[MapFileNames.ScriptJ] = scriptOverride;
        }
        else if (includeScript)
        {
            entries[MapFileNames.ScriptJ] = File.ReadAllBytes(scriptPath);
        }

        if (includeW3i)
        {
            entries[MapFileNames.MapInfo] = W3iBinaryWriter.Write(templateInfo, terrain, "SmokeMap");
        }

        if (includeTerrain)
        {
            entries[MapFileNames.Terrain] = terrainBytes;
            entries[MapFileNames.Pathing] = WpmWriter.Write(terrain);
        }

        if (includeTriggers)
        {
            entries[MapFileNames.TriggerData] = templates.ReadTriggerDataTemplate();
            entries[MapFileNames.TriggerStrings] = templates.ReadTriggerStringsTemplate();
        }

        if (includeDoodads)
        {
            entries[MapFileNames.Doodads] = DoodadWriter.WriteEmptyDoodads();
            entries[MapFileNames.Units] = DoodadWriter.WriteEmptyUnits();
        }

        entries[MapFileNames.ListFile] = Array.Empty<byte>();
        return entries;
    }

    void RunScenario(string name, Dictionary<string, byte[]> entries, IReadOnlyList<string> expectedGenerated)
    {
        Console.WriteLine($"[smoke] {name}");
        var inputPath = Path.Combine(tempRoot, $"{name}.w3x");
        var outputPath = Path.Combine(tempRoot, $"{name}_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, $"{name}_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        var inspectResult = service.Inspect(outputPath);

        Assert(File.Exists(outputPath), $"{name}: repaired map not written");
        Assert(inspectResult.PreservedFiles.Contains(MapFileNames.MapInfo, StringComparer.OrdinalIgnoreCase), $"{name}: output missing w3i");
        Assert(inspectResult.PreservedFiles.Contains(MapFileNames.Terrain, StringComparer.OrdinalIgnoreCase), $"{name}: output missing w3e");
        Assert(inspectResult.PreservedFiles.Contains(MapFileNames.Pathing, StringComparer.OrdinalIgnoreCase), $"{name}: output missing wpm");

        if (!entries.ContainsKey(MapFileNames.TriggerData) &&
            !entries.ContainsKey(MapFileNames.TriggerStrings) &&
            entries.ContainsKey(MapFileNames.ScriptJ))
        {
            using var archive = MpqArchiveReader.Open(outputPath);
            if (expectedGenerated.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase) ||
                expectedGenerated.Contains(MapFileNames.TriggerStrings, StringComparer.OrdinalIgnoreCase))
            {
                Assert(archive.ReadFile(MapFileNames.TriggerData).Exists, $"{name}: expected repaired map to reconstruct war3map.wtg");
                Assert(archive.ReadFile(MapFileNames.TriggerStrings).Exists, $"{name}: expected repaired map to reconstruct war3map.wct");
            }
            else
            {
                Assert(!archive.ReadFile(MapFileNames.TriggerData).Exists, $"{name}: expected repaired map to keep war3map.wtg absent when only compiled script is available");
                Assert(!archive.ReadFile(MapFileNames.TriggerStrings).Exists, $"{name}: expected repaired map to keep war3map.wct absent when only compiled script is available");
            }
        }

        foreach (var generatedFile in expectedGenerated)
        {
            Assert(repairResult.GeneratedFiles.Contains(generatedFile, StringComparer.OrdinalIgnoreCase), $"{name}: expected generated file {generatedFile}");
        }
    }

    void RunImportScenario()
    {
        Console.WriteLine("[smoke] imports");
        const string standardArchivePath = @"war3mapImported\standard.blp";
        const string standardStoredPath = "standard.blp";
        const string customArchivePath = @"UI\Custom\panel.blp";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[standardArchivePath] = [1, 2, 3];
        entries[customArchivePath] = [4, 5, 6];
        entries[MapFileNames.Imports] = ImportListWriter.Write(
        [
            new War3ImportEntry(War3ImportEntry.StandardPathFlagLegacy, standardStoredPath),
            new War3ImportEntry(War3ImportEntry.CustomPathFlagLegacy, customArchivePath),
        ]);

        var inputPath = Path.Combine(tempRoot, "imports.w3x");
        var outputPath = Path.Combine(tempRoot, "imports_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "imports_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "imports: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "imports: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);

        var standardEntry = repairedEntries.FirstOrDefault(entry =>
            entry.ArchivePath.Equals(standardArchivePath, StringComparison.OrdinalIgnoreCase));
        var customEntry = repairedEntries.FirstOrDefault(entry =>
            entry.ArchivePath.Equals(customArchivePath, StringComparison.OrdinalIgnoreCase));

        Assert(standardEntry is not null, "imports: missing standard-path entry");
        Assert(customEntry is not null, "imports: missing custom-path entry");
        Assert(standardEntry!.Flag == War3ImportEntry.StandardPathFlagLegacy, "imports: standard flag not preserved");
        Assert(customEntry!.Flag == War3ImportEntry.CustomPathFlagLegacy, "imports: custom flag not preserved");
        Assert(standardEntry.StoredPath.Equals(standardStoredPath, StringComparison.OrdinalIgnoreCase), "imports: standard stored path changed");
        Assert(customEntry.StoredPath.Equals(customArchivePath, StringComparison.OrdinalIgnoreCase), "imports: custom stored path changed");
    }

    void RunMissingTrigStrScenario()
    {
        Console.WriteLine("[smoke] missing-trigstr");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true);
        entries[MapFileNames.ScriptJ] = Encoding.UTF8.GetBytes("""
function main takes nothing returns nothing
    call CreateTextTagUnitBJ("TRIGSTR_116", null, 0, 10, 100, 100, 100, 0)
endfunction
""");
        entries[MapFileNames.Strings] = Encoding.UTF8.GetBytes("""
STRING 1560
{
already-here
}
""");

        var inputPath = Path.Combine(tempRoot, "missing-trigstr.w3x");
        var outputPath = Path.Combine(tempRoot, "missing-trigstr_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "missing-trigstr_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Strings, StringComparer.OrdinalIgnoreCase),
            "missing-trigstr: expected repaired wts");
        Assert(repairResult.Warnings.Any(warning => warning.Contains("placeholder `TRIGSTR_*` definitions", StringComparison.OrdinalIgnoreCase)),
            "missing-trigstr: expected placeholder trigstr warning");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtsResult = archive.ReadFile(MapFileNames.Strings);
        Assert(wtsResult.Exists && wtsResult.Readable && wtsResult.Data is not null,
            "missing-trigstr: repaired wts unreadable");
        var wtsText = Encoding.UTF8.GetString(wtsResult.Data!);
        Assert(wtsText.Contains("STRING 116", StringComparison.Ordinal), "missing-trigstr: missing STRING 116 definition");
        Assert(wtsText.Contains("TRIGSTR_116", StringComparison.Ordinal), "missing-trigstr: placeholder text not written");
    }

    void RunObjectDataReferencedAssetScenario()
    {
        const string iconPath = @"ReplaceableTextures\CommandButtons\CustomIcon.blp";
        const string modelPath = @"war3mapImported\custom_model.mdx";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[MapFileNames.ListFile] = Array.Empty<byte>();
        entries[iconPath] = [1, 3, 5, 7];
        entries[modelPath] = [2, 4, 6, 8];
        entries["war3map.w3u"] = ObjectDataFileWriter.Write(
        [
            new ObjectDefinition(
                "hfoo",
                "u999",
                true,
                [
                    new ObjectModification("uico", ObjectValueKind.String, iconPath),
                    new ObjectModification("umdl", ObjectValueKind.String, modelPath),
                ])
        ]);

        var inputPath = Path.Combine(tempRoot, "objectdata-assets.w3x");
        var outputPath = Path.Combine(tempRoot, "objectdata-assets_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "objectdata-assets_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "objectdata-assets: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var iconResult = archive.ReadFile(iconPath);
        var modelResult = archive.ReadFile(modelPath);
        Assert(iconResult.Exists && iconResult.Readable, "objectdata-assets: icon path not preserved");
        Assert(modelResult.Exists && modelResult.Readable, "objectdata-assets: model path not preserved");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "objectdata-assets: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(iconPath, StringComparison.OrdinalIgnoreCase)),
            "objectdata-assets: icon path missing from rebuilt imp");
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(modelPath, StringComparison.OrdinalIgnoreCase)),
            "objectdata-assets: model path missing from rebuilt imp");
    }

    void RunTextMdlTextureDependencyScenario()
    {
        const string modelPath = @"war3mapImported\textured_model.mdl";
        const string texturePath = @"war3mapImported\textured_model.blp";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[modelPath] = CreateTextMdlWithTextures(texturePath);
        entries[texturePath] = [7, 7, 7, 7];
        entries["war3map.w3d"] = ObjectDataFileWriter.Write(
        [
            new ObjectDefinition(
                "LTlt",
                "d998",
                true,
                [
                    new ObjectModification("dfil", ObjectValueKind.String, modelPath),
                ])
        ]);

        var inputPath = Path.Combine(tempRoot, "mdl-texture-dependency.w3x");
        var outputPath = Path.Combine(tempRoot, "mdl-texture-dependency_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "mdl-texture-dependency_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "mdl-texture-dependency: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var modelResult = archive.ReadFile(modelPath);
        var textureResult = archive.ReadFile(texturePath);
        Assert(modelResult.Exists && modelResult.Readable, "mdl-texture-dependency: model path not preserved");
        Assert(textureResult.Exists && textureResult.Readable, "mdl-texture-dependency: texture dependency not preserved");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "mdl-texture-dependency: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(modelPath, StringComparison.OrdinalIgnoreCase)),
            "mdl-texture-dependency: model path missing from rebuilt imp");
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(texturePath, StringComparison.OrdinalIgnoreCase)),
            "mdl-texture-dependency: texture dependency missing from rebuilt imp");
    }

    void RunBinaryModelTextureWarningScenario()
    {
        const string modelPath = @"war3mapImported\missing_texture_model.mdl";
        const string missingTexturePath = @"war3mapImported\missing_texture.blp";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[modelPath] = CreateBinaryMdxWithTextures(missingTexturePath);
        entries["war3map.w3d"] = ObjectDataFileWriter.Write(
        [
            new ObjectDefinition(
                "LTlt",
                "d997",
                true,
                [
                    new ObjectModification("dfil", ObjectValueKind.String, modelPath),
                ])
        ]);

        var inputPath = Path.Combine(tempRoot, "missing-model-texture-warning.w3x");
        var outputPath = Path.Combine(tempRoot, "missing-model-texture-warning_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "missing-model-texture-warning_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.Warnings.Any(warning =>
                warning.Contains(modelPath, StringComparison.OrdinalIgnoreCase) &&
                warning.Contains(missingTexturePath, StringComparison.OrdinalIgnoreCase)),
            "missing-model-texture-warning: expected unresolved texture warning");
    }

    void RunMetadataEnumTypingScenario()
    {
        var deathTypeEntry = new ObjectMetadataEntry(
            "udea",
            "deathType",
            "UnitData",
            -1,
            0,
            0,
            "deathType",
            string.Empty,
            UseUnit: true,
            UseHero: true,
            UseBuilding: true,
            UseItem: false,
            UseSpecific: false,
            SpecificTargets: null);

        var moveTypeEntry = new ObjectMetadataEntry(
            "umvt",
            "movetp",
            "UnitData",
            -1,
            0,
            0,
            "moveType",
            string.Empty,
            UseUnit: true,
            UseHero: true,
            UseBuilding: true,
            UseItem: false,
            UseSpecific: false,
            SpecificTargets: null);

        var hotkeyEntry = new ObjectMetadataEntry(
            "uhot",
            "Hotkey",
            "ItemData",
            -1,
            0,
            0,
            "char",
            string.Empty,
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: true,
            UseSpecific: false,
            SpecificTargets: null);

        var boolEntry = new ObjectMetadataEntry(
            "ubdg",
            "isbldg",
            "UnitData",
            -1,
            0,
            0,
            "bool",
            string.Empty,
            UseUnit: true,
            UseHero: true,
            UseBuilding: true,
            UseItem: false,
            UseSpecific: false,
            SpecificTargets: null);

        Assert(
            SlkObjectRebuilder.TryBuildModification(deathTypeEntry, "2", out var deathTypeModification) &&
            deathTypeModification.ValueKind == ObjectValueKind.Int &&
            Equals(deathTypeModification.Value, 2),
            "metadata-enum-typing: deathType should serialize as integer object-data");

        Assert(
            SlkObjectRebuilder.TryBuildModification(moveTypeEntry, "foot", out var moveTypeModification) &&
            moveTypeModification.ValueKind == ObjectValueKind.String &&
            Equals(moveTypeModification.Value, "foot"),
            "metadata-enum-typing: moveType should remain string object-data");

        Assert(
            SlkObjectRebuilder.TryBuildModification(hotkeyEntry, "1", out var hotkeyModification) &&
            hotkeyModification.ValueKind == ObjectValueKind.String &&
            Equals(hotkeyModification.Value, "1"),
            "metadata-enum-typing: char fields such as Hotkey should remain string object-data even when numeric-looking");

        Assert(
            SlkObjectRebuilder.TryBuildModification(boolEntry, "TRUE", out var boolModification) &&
            boolModification.ValueKind == ObjectValueKind.Int &&
            Equals(boolModification.Value, 1),
            "metadata-enum-typing: bool fields should still serialize as integer object-data");

        var buttonPosXEntry = new ObjectMetadataEntry(
            "ubpx",
            "Buttonpos",
            "ItemData",
            1,
            0,
            0,
            "int",
            string.Empty,
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: true,
            UseSpecific: false,
            SpecificTargets: null);

        var buttonPosYEntry = new ObjectMetadataEntry(
            "ubpy",
            "Buttonpos",
            "ItemData",
            2,
            0,
            0,
            "int",
            string.Empty,
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: true,
            UseSpecific: false,
            SpecificTargets: null);

        Assert(
            SlkObjectRebuilder.TryNormalizeRawValue(buttonPosXEntry, "0,2", out var buttonPosX) &&
            buttonPosX == "0" &&
            SlkObjectRebuilder.TryNormalizeRawValue(buttonPosYEntry, "0,2", out var buttonPosY) &&
            buttonPosY == "2",
            "metadata-enum-typing: indexed metadata fields should split comma-delimited values");

        Assert(
            !SlkObjectRebuilder.TryNormalizeRawValue(buttonPosXEntry, ",2", out _),
            "metadata-enum-typing: missing indexed value should be skipped instead of serialized as a string");

        var applyProfileOverrides = typeof(SlkObjectRebuilder).GetMethod(
            "ApplyProfileOverrides",
            BindingFlags.NonPublic | BindingFlags.Static)!;
        var profileOverride = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            ["Buttonpos"] = "0,2"
        };
        var profileModifications = new List<ObjectModification>();
        applyProfileOverrides.Invoke(null, [new[] { buttonPosXEntry, buttonPosYEntry }, profileOverride, profileModifications, null]);

        Assert(
            profileModifications.Count == 2 &&
            profileModifications.Any(mod => mod.RawCode == "ubpx" && mod.ValueKind == ObjectValueKind.Int && Equals(mod.Value, 0)) &&
            profileModifications.Any(mod => mod.RawCode == "ubpy" && mod.ValueKind == ObjectValueKind.Int && Equals(mod.Value, 2)),
            "metadata-enum-typing: profile overrides should expand indexed metadata fields into separate object-data modifications");

        var implicitButtonPosXEntry = buttonPosXEntry with { Index = 0 };
        var implicitProfileModifications = new List<ObjectModification>();
        applyProfileOverrides.Invoke(null, [new[] { implicitButtonPosXEntry, buttonPosYEntry }, profileOverride, implicitProfileModifications, null]);

        Assert(
            implicitProfileModifications.Count == 2 &&
            implicitProfileModifications.Any(mod => mod.RawCode == "ubpx" && mod.ValueKind == ObjectValueKind.Int && Equals(mod.Value, 0)) &&
            implicitProfileModifications.Any(mod => mod.RawCode == "ubpy" && mod.ValueKind == ObjectValueKind.Int && Equals(mod.Value, 2)),
            "metadata-enum-typing: grouped profile overrides should treat an unindexed first component as implicit index 1");

        var blizzardDataAEntry = new ObjectMetadataEntry(
            "Hbz1",
            "Data",
            "AbilityData",
            -1,
            1,
            4,
            "int",
            "AHbz",
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: false,
            UseSpecific: false,
            SpecificTargets: null);

        var itemArmorEntry = new ObjectMetadataEntry(
            "Idef",
            "Data",
            "AbilityData",
            -1,
            1,
            4,
            "int",
            "AIde",
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: true,
            UseSpecific: false,
            SpecificTargets: null);

        var bloodlustDataBEntry = new ObjectMetadataEntry(
            "Blo2",
            "Data",
            "AbilityData",
            -1,
            2,
            4,
            "unreal",
            "Afzy",
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: false,
            UseSpecific: false,
            SpecificTargets: null);

        var abilitySpecificEntry = new ObjectMetadataEntry(
            "Hbh5",
            "Data",
            "AbilityData",
            -1,
            5,
            4,
            "bool",
            string.Empty,
            UseUnit: false,
            UseHero: false,
            UseBuilding: false,
            UseItem: true,
            UseSpecific: true,
            SpecificTargets: "AHbh,ACbh,ANbh,ANb2,AIbx");

        var buildAbilityModifications = typeof(SlkObjectRebuilder).GetMethod(
            "BuildAbilityModifications",
            BindingFlags.NonPublic | BindingFlags.Static)!;
        var abilityWarnings = new List<string>();

        var customArmorMods = (List<ObjectModification>)buildAbilityModifications.Invoke(
            null,
            ["A033", "AIde", new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) { ["DataA1"] = "8" }, null, new[] { blizzardDataAEntry, itemArmorEntry }, abilityWarnings])!;
        Assert(
            customArmorMods.Count == 1 &&
            customArmorMods[0].RawCode == "Idef" &&
            customArmorMods[0].ValueKind == ObjectValueKind.Int &&
            Equals(customArmorMods[0].Value, 8),
            "metadata-enum-typing: custom item-armor abilities should resolve DataA through the matching ability section instead of unrelated rawcodes");

        var unrelatedSectionMods = (List<ObjectModification>)buildAbilityModifications.Invoke(
            null,
            ["ACce", "ACce", new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) { ["DataA1"] = "0.3" }, null, new[] { blizzardDataAEntry, itemArmorEntry }, abilityWarnings])!;
        Assert(
            unrelatedSectionMods.Count == 0,
            "metadata-enum-typing: abilities without a matching section-specific Data mapping should skip the field instead of binding an unrelated rawcode");

        var bloodlustMods = (List<ObjectModification>)buildAbilityModifications.Invoke(
            null,
            ["A08O", "Afzy", new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) { ["DataB1"] = "0.4" }, null, new[] { blizzardDataAEntry, bloodlustDataBEntry }, abilityWarnings])!;
        Assert(
            bloodlustMods.Count == 1 &&
            bloodlustMods[0].RawCode == "Blo2" &&
            bloodlustMods[0].ValueKind == ObjectValueKind.Unreal &&
            Equals(bloodlustMods[0].Value, 0.4f),
            "metadata-enum-typing: bloodlust-family custom abilities should resolve DataB through the matching section");

        var bashSpecificMods = (List<ObjectModification>)buildAbilityModifications.Invoke(
            null,
            ["AIbx", "AIbx", new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase) { ["DataE1"] = "TRUE" }, null, new[] { abilitySpecificEntry }, abilityWarnings])!;
        Assert(
            bashSpecificMods.Count == 1 &&
            bashSpecificMods[0].RawCode == "Hbh5" &&
            bashSpecificMods[0].ValueKind == ObjectValueKind.Int &&
            Equals(bashSpecificMods[0].Value, 1),
            "metadata-enum-typing: ability-specific metadata should still win when the target ability is explicitly listed");
    }

    void RunMdlToMdxFallbackScenario()
    {
        const string referencedModelPath = "custom_doodad.mdl";
        const string archiveModelPath = "custom_doodad.mdx";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[archiveModelPath] = [9, 8, 7, 6];
        entries["war3map.w3d"] = ObjectDataFileWriter.Write(
        [
            new ObjectDefinition(
                "LTlt",
                "d999",
                true,
                [
                    new ObjectModification("dfil", ObjectValueKind.String, referencedModelPath),
                ])
        ]);

        var inputPath = Path.Combine(tempRoot, "mdl-mdx-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "mdl-mdx-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "mdl-mdx-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "mdl-mdx-fallback: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var referencedResult = archive.ReadFile(referencedModelPath);
        var archiveResult = archive.ReadFile(archiveModelPath);
        Assert(referencedResult.Exists && referencedResult.Readable, "mdl-mdx-fallback: referenced mdl path not preserved");
        Assert(!archiveResult.Exists, "mdl-mdx-fallback: source mdx path should not outrank the referenced mdl path");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "mdl-mdx-fallback: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(referencedModelPath, StringComparison.OrdinalIgnoreCase)),
            "mdl-mdx-fallback: referenced mdl path missing from rebuilt imp");
        Assert(!repairedEntries.Any(entry => entry.ArchivePath.Equals(archiveModelPath, StringComparison.OrdinalIgnoreCase)),
            "mdl-mdx-fallback: source mdx path should not outrank the referenced mdl path in rebuilt imp");
    }

    void RunScriptMdlToMdxFallbackScenario()
    {
        const string referencedModelPath = @"war3mapImported\script_model.mdl";
        const string archiveModelPath = @"war3mapImported\script_model.mdx";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[archiveModelPath] = [5, 6, 7, 8];
        entries[MapFileNames.ScriptJ] = Encoding.UTF8.GetBytes($$"""
function main takes nothing returns nothing
    call Preload("{{referencedModelPath}}")
endfunction
""");

        var inputPath = Path.Combine(tempRoot, "script-mdl-mdx-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "script-mdl-mdx-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "script-mdl-mdx-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "script-mdl-mdx-fallback: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var referencedResult = archive.ReadFile(referencedModelPath);
        var archiveResult = archive.ReadFile(archiveModelPath);
        Assert(referencedResult.Exists && referencedResult.Readable, "script-mdl-mdx-fallback: referenced mdl path not preserved");
        Assert(!archiveResult.Exists, "script-mdl-mdx-fallback: source mdx path should not outrank the script mdl path");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "script-mdl-mdx-fallback: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(referencedModelPath, StringComparison.OrdinalIgnoreCase)),
            "script-mdl-mdx-fallback: script mdl path missing from rebuilt imp");
        Assert(!repairedEntries.Any(entry => entry.ArchivePath.Equals(archiveModelPath, StringComparison.OrdinalIgnoreCase)),
            "script-mdl-mdx-fallback: source mdx path should not outrank the script mdl path in rebuilt imp");
    }

    void RunMdxToMdlFallbackScenario()
    {
        const string referencedModelPath = "custom_effect.mdx";
        const string archiveModelPath = "custom_effect.mdl";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[archiveModelPath] = [4, 3, 2, 1];
        entries["war3map.w3d"] = ObjectDataFileWriter.Write(
        [
            new ObjectDefinition(
                "LTlt",
                "d998",
                true,
                [
                    new ObjectModification("dfil", ObjectValueKind.String, referencedModelPath),
                ])
        ]);

        var inputPath = Path.Combine(tempRoot, "mdx-mdl-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "mdx-mdl-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "mdx-mdl-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "mdx-mdl-fallback: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var referencedResult = archive.ReadFile(referencedModelPath);
        var archiveResult = archive.ReadFile(archiveModelPath);
        Assert(referencedResult.Exists && referencedResult.Readable, "mdx-mdl-fallback: referenced mdx path not preserved");
        Assert(!archiveResult.Exists, "mdx-mdl-fallback: source mdl path should not outrank the referenced mdx path");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "mdx-mdl-fallback: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(referencedModelPath, StringComparison.OrdinalIgnoreCase)),
            "mdx-mdl-fallback: referenced mdx path missing from rebuilt imp");
        Assert(!repairedEntries.Any(entry => entry.ArchivePath.Equals(archiveModelPath, StringComparison.OrdinalIgnoreCase)),
            "mdx-mdl-fallback: source mdl path should not outrank the referenced mdx path in rebuilt imp");
    }

    void RunScriptMdxToMdlFallbackScenario()
    {
        const string referencedModelPath = @"war3mapImported\script_model_reverse.mdx";
        const string archiveModelPath = @"war3mapImported\script_model_reverse.mdl";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[archiveModelPath] = [8, 7, 6, 5];
        entries[MapFileNames.ScriptJ] = Encoding.UTF8.GetBytes($$"""
function main takes nothing returns nothing
    call Preload("{{referencedModelPath}}")
endfunction
""");

        var inputPath = Path.Combine(tempRoot, "script-mdx-mdl-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "script-mdx-mdl-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "script-mdx-mdl-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "script-mdx-mdl-fallback: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var referencedResult = archive.ReadFile(referencedModelPath);
        var archiveResult = archive.ReadFile(archiveModelPath);
        Assert(referencedResult.Exists && referencedResult.Readable, "script-mdx-mdl-fallback: referenced mdx path not preserved");
        Assert(!archiveResult.Exists, "script-mdx-mdl-fallback: source mdl path should not outrank the script mdx path");

        var importResult = archive.ReadFile(MapFileNames.Imports);
        Assert(importResult.Exists && importResult.Readable && importResult.Data is not null, "script-mdx-mdl-fallback: repaired imp unreadable");
        var repairedEntries = War3ImportFileReader.ReadEntries(importResult.Data!);
        Assert(repairedEntries.Any(entry => entry.ArchivePath.Equals(referencedModelPath, StringComparison.OrdinalIgnoreCase)),
            "script-mdx-mdl-fallback: script mdx path missing from rebuilt imp");
        Assert(!repairedEntries.Any(entry => entry.ArchivePath.Equals(archiveModelPath, StringComparison.OrdinalIgnoreCase)),
            "script-mdx-mdl-fallback: source mdl path should not outrank the script mdx path in rebuilt imp");
    }

    void RunRawStringFallbackScenario()
    {
        const string referencedModelPath = "broken_doodad.mdl";
        const string archiveModelPath = "broken_doodad.mdx";

        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        entries[archiveModelPath] = [6, 7, 8, 9];
        entries["war3map.w3d"] = Encoding.ASCII.GetBytes($"garbage\0{referencedModelPath}\0more-garbage");

        var inputPath = Path.Combine(tempRoot, "raw-string-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "raw-string-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "raw-string-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.Imports, StringComparer.OrdinalIgnoreCase), "raw-string-fallback: expected rebuilt imp");

        using var archive = MpqArchiveReader.Open(outputPath);
        var referencedResult = archive.ReadFile(referencedModelPath);
        var archiveResult = archive.ReadFile(archiveModelPath);
        Assert(referencedResult.Exists && referencedResult.Readable, "raw-string-fallback: referenced mdl path from raw-string fallback not preserved");
        Assert(!archiveResult.Exists, "raw-string-fallback: source mdx path should not outrank the referenced mdl path");
    }

    void RunGuiVariableRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-variable-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "gui-variable-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-variable-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-variable-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-variable-recovery: expected reconstructed wtg");
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerStrings, StringComparer.OrdinalIgnoreCase), "gui-variable-recovery: expected reconstructed wct");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-variable-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-variable-recovery: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-variable-recovery: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-variable-recovery", wtg.Data!);
        Assert(document.Variables.Count == 3, "gui-variable-recovery: expected 3 recovered GUI variables");
        Assert(document.Variables.Any(variable => variable.Name == "udg_Count" && variable.DefaultValue == "7"), "gui-variable-recovery: integer default missing");
        Assert(document.Variables.Any(variable => variable.Name == "udg_Name" && variable.DefaultValue == "Recovered"), "gui-variable-recovery: string default missing");
        Assert(document.Variables.Any(variable => variable.Name == "udg_Array" && variable.IsArray), "gui-variable-recovery: array variable missing");
        Assert(document.Triggers.Count == 1, "gui-variable-recovery: expected 1 recovered trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-variable-recovery: expected GUI trigger reconstruction");
        Assert(document.Triggers[0].Events.Count == 1, "gui-variable-recovery: expected one recovered GUI event");
        Assert(document.Triggers[0].Actions.Count > 0, "gui-variable-recovery: expected recovered actions");
        Assert(Directory.Exists(Path.Combine(reportDir, "RecoveredGui")), "gui-variable-recovery: expected recovered GUI report artifacts");
    }

    void RunLegacyGuiBinaryRoundtripScenario()
    {
        Console.WriteLine("[smoke] legacy-gui-roundtrip");
        var timerEvent = new LegacyGuiNode(LegacyGuiFunctionKind.Event, "TriggerRegisterTimerEventPeriodic");
        timerEvent.Arguments.Add(LegacyGuiArgument.Constant("0.25"));
        var conditionalAction = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "IfThenElseMultiple");
        var conditionBlock = new LegacyGuiNodeBlock("conditions");
        var conditionNode = new LegacyGuiNode(LegacyGuiFunctionKind.Condition, "OperatorCompareBoolean");
        conditionNode.Arguments.Add(LegacyGuiArgument.Preset("true"));
        conditionNode.Arguments.Add(LegacyGuiArgument.Preset("OperatorEqualENE"));
        conditionNode.Arguments.Add(LegacyGuiArgument.Preset("true"));
        conditionBlock.Nodes.Add(conditionNode);
        var thenBlock = new LegacyGuiNodeBlock("then");
        var initGameCacheCall = new LegacyGuiNode(LegacyGuiFunctionKind.Call, "InitGameCache");
        initGameCacheCall.Arguments.Add(LegacyGuiArgument.Constant("RoundtripCache"));
        var flushGameCache = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "FlushGameCache");
        flushGameCache.Arguments.Add(LegacyGuiArgument.Call(initGameCacheCall));
        thenBlock.Nodes.Add(flushGameCache);
        thenBlock.Nodes.Add(new LegacyGuiNode(LegacyGuiFunctionKind.Action, "DoNothing"));
        conditionalAction.ChildBlocks.Add(conditionBlock);
        conditionalAction.ChildBlocks.Add(thenBlock);
        var document = new LegacyGuiDocument(
            [new LegacyGuiCategory(0, "Recovered GUI")],
            [new LegacyGuiVariable("udg_Count", "integer", false, "3")],
            [
                new LegacyGuiTrigger
                {
                    Name = "Roundtrip Trigger",
                    Description = string.Empty,
                    Type = 0,
                    Enabled = true,
                    IsCustomText = false,
                    StartsClosed = false,
                    RunOnMapInit = false,
                    CategoryId = 0,
                    CustomText = string.Empty
                }
            ],
            "Recovered from war3map.j",
            string.Empty);
        document.Triggers[0].Events.Add(timerEvent);
        document.Triggers[0].Actions.Add(conditionalAction);

        var wtg = LegacyGuiBinaryCodec.WriteWtg(document);
        var wct = LegacyGuiBinaryCodec.WriteWct(document);
        Assert(Encoding.UTF8.GetString(wtg, 0, 4) == "WTG!", "legacy-gui-roundtrip: invalid WTG signature bytes");
        using (var rawReader = new BinaryReader(new MemoryStream(wtg), Encoding.UTF8, leaveOpen: false))
        {
            _ = rawReader.ReadBytes(4);
            Assert(rawReader.ReadInt32() == 7, "legacy-gui-roundtrip: invalid WTG version");
            Assert(rawReader.ReadInt32() == 1, "legacy-gui-roundtrip: invalid category count");
            Assert(rawReader.ReadInt32() == 0, "legacy-gui-roundtrip: invalid category id");
            while (rawReader.ReadByte() != 0)
            {
            }

            Assert(rawReader.ReadInt32() == 0, "legacy-gui-roundtrip: invalid category comment");
            Assert(rawReader.ReadInt32() == 2, "legacy-gui-roundtrip: invalid variable header");
        }
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg, guiMetadata, out var validationFailure), $"legacy-gui-roundtrip: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("legacy-gui-roundtrip", wtg);
        AssertOriginalYdweDebugWalkPasses("legacy-gui-roundtrip", wtg);

        var roundtrip = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg, wct, guiMetadata);

        Assert(roundtrip.Categories.Count == 1, "legacy-gui-roundtrip: category count changed");
        Assert(roundtrip.Variables.Count == 1, "legacy-gui-roundtrip: variable count changed");
        Assert(roundtrip.Triggers.Count == 1, "legacy-gui-roundtrip: trigger count changed");
        Assert(roundtrip.Triggers[0].Events.Count == 1, "legacy-gui-roundtrip: event count changed");
        Assert(roundtrip.Triggers[0].Actions.Count == 1, "legacy-gui-roundtrip: action count changed");
        Assert(roundtrip.Triggers[0].Actions[0].ChildBlocks.Count == 2, "legacy-gui-roundtrip: child block count changed");
        Assert(roundtrip.Triggers[0].Actions[0].ChildBlocks[1].Nodes.Count == 2, "legacy-gui-roundtrip: then block node count changed");
        Assert(roundtrip.Triggers[0].Actions[0].ChildBlocks[1].Nodes[0].Name == "FlushGameCache", "legacy-gui-roundtrip: inserted-call action missing");
        Assert(roundtrip.Triggers[0].Actions[0].ChildBlocks[1].Nodes[0].Arguments[0].Kind == LegacyGuiArgumentKind.Call, "legacy-gui-roundtrip: inserted call argument kind changed");
        Assert(roundtrip.Triggers[0].Actions[0].ChildBlocks[1].Nodes[0].Arguments[0].CallNode?.Name == "InitGameCache", "legacy-gui-roundtrip: inserted call node name changed");
    }

    void RunGuiConditionGuardScenario()
    {
        Console.WriteLine("[smoke] gui-condition-guard");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiRecoveryScriptWithGuardCondition());
        var inputPath = Path.Combine(tempRoot, "gui-condition-guard.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-condition-guard_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-condition-guard_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-condition-guard: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-condition-guard: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-condition-guard: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-condition-guard: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-condition-guard: expected GUI trigger");
        Assert(document.Triggers[0].Conditions.Count == 0, "gui-condition-guard: expected unsupported root condition to move into guard actions");
        Assert(document.Triggers[0].Actions.Count >= 4, "gui-condition-guard: expected guard actions plus callback action");
        Assert(document.Triggers[0].Actions[0].Name == "CustomScriptCode", "gui-condition-guard: expected custom-script guard prelude");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-condition-guard: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-condition-guard", wtg.Data!);
    }

    void RunGuiGuardedComparisonConditionRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-guarded-comparison-condition-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiGuardedComparisonConditionRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "gui-guarded-comparison-condition-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-guarded-comparison-condition-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-guarded-comparison-condition-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-guarded-comparison-condition-recovery: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-guarded-comparison-condition-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-guarded-comparison-condition-recovery: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 2, "gui-guarded-comparison-condition-recovery: expected two triggers");

        var itemCodeTrigger = document.Triggers[0];
        Assert(!itemCodeTrigger.IsCustomText, "gui-guarded-comparison-condition-recovery: expected item-code trigger to remain GUI");
        Assert(itemCodeTrigger.Conditions.Count == 1, "gui-guarded-comparison-condition-recovery: expected item-code trigger to recover one GUI condition");
        Assert(itemCodeTrigger.Conditions[0].Name == "OperatorCompareItemCode", "gui-guarded-comparison-condition-recovery: expected item-code comparison condition");
        Assert(itemCodeTrigger.Actions.Count == 1, "gui-guarded-comparison-condition-recovery: expected one item-code action");
        Assert(itemCodeTrigger.Actions[0].Name == "RemoveItem", "gui-guarded-comparison-condition-recovery: expected item-code action recovery without guard prelude");

        var booleanTrigger = document.Triggers[1];
        Assert(!booleanTrigger.IsCustomText, "gui-guarded-comparison-condition-recovery: expected boolean trigger to remain GUI");
        Assert(booleanTrigger.Conditions.Count == 1, "gui-guarded-comparison-condition-recovery: expected boolean trigger to recover one GUI condition");
        Assert(booleanTrigger.Conditions[0].Name == "OperatorCompareBoolean", "gui-guarded-comparison-condition-recovery: expected boolean comparison condition");
        Assert(booleanTrigger.Actions.Count == 1, "gui-guarded-comparison-condition-recovery: expected one boolean action");
        Assert(booleanTrigger.Actions[0].Name == "DoNothing", "gui-guarded-comparison-condition-recovery: expected boolean action recovery without guard prelude");

        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-guarded-comparison-condition-recovery: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-guarded-comparison-condition-recovery", wtg.Data!);
    }

    void RunGuiMultiGuardConditionRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-multi-guard-condition-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiMultiGuardConditionRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "gui-multi-guard-condition-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-multi-guard-condition-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-multi-guard-condition-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-multi-guard-condition-recovery: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-multi-guard-condition-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-multi-guard-condition-recovery: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-multi-guard-condition-recovery: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-multi-guard-condition-recovery: expected GUI trigger");
        Assert(document.Triggers[0].Conditions.Count == 3, "gui-multi-guard-condition-recovery: expected three recovered GUI conditions");
        Assert(document.Triggers[0].Conditions[0].Name == "OperatorCompareItemCode", "gui-multi-guard-condition-recovery: expected item-code comparison condition");
        Assert(document.Triggers[0].Conditions[1].Name == "OperatorCompareBoolean", "gui-multi-guard-condition-recovery: expected hero-type boolean condition");
        Assert(document.Triggers[0].Conditions[2].Name == "OperatorCompareBoolean", "gui-multi-guard-condition-recovery: expected tauren-type boolean condition");
        Assert(document.Triggers[0].Actions.Count == 1, "gui-multi-guard-condition-recovery: expected one recovered action");
        Assert(document.Triggers[0].Actions[0].Name == "DoNothing", "gui-multi-guard-condition-recovery: expected direct action without guard prelude");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-multi-guard-condition-recovery: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-multi-guard-condition-recovery", wtg.Data!);
        AssertOriginalYdweDebugWalkPasses("gui-multi-guard-condition-recovery", wtg.Data!);
    }

    void RunGuiActionIfThenElseChildBlockRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-action-if-then-else-child-block-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiActionIfThenElseChildBlockRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "gui-action-if-then-else-child-block-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-action-if-then-else-child-block-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-action-if-then-else-child-block-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-action-if-then-else-child-block-recovery: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-action-if-then-else-child-block-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-action-if-then-else-child-block-recovery: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-action-if-then-else-child-block-recovery: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-action-if-then-else-child-block-recovery: expected GUI trigger");
        Assert(document.Triggers[0].Actions.Count == 1, "gui-action-if-then-else-child-block-recovery: expected one recovered root action");
        Assert(document.Triggers[0].Actions[0].Name == "IfThenElseMultiple", "gui-action-if-then-else-child-block-recovery: expected IfThenElseMultiple root action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks.Count == 3, "gui-action-if-then-else-child-block-recovery: expected condition, then, and else blocks");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[0].Nodes.Count == 1, "gui-action-if-then-else-child-block-recovery: expected one recovered condition");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[0].Nodes[0].Name == "OperatorCompareInteger", "gui-action-if-then-else-child-block-recovery: expected guarded helper comparison recovery");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[1].Nodes.Count == 1, "gui-action-if-then-else-child-block-recovery: expected one then action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[1].Nodes[0].Name == "SetTimeOfDay", "gui-action-if-then-else-child-block-recovery: expected structured then action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[2].Nodes.Count == 1, "gui-action-if-then-else-child-block-recovery: expected one else action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[2].Nodes[0].Name == "DoNothing", "gui-action-if-then-else-child-block-recovery: expected structured else action");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-action-if-then-else-child-block-recovery: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-action-if-then-else-child-block-recovery", wtg.Data!);
        AssertOriginalYdweDebugWalkPasses("gui-action-if-then-else-child-block-recovery", wtg.Data!);
    }

    void RunGuiArrayIndexedHelperConditionRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-array-indexed-helper-condition-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiArrayIndexedHelperConditionRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "gui-array-indexed-helper-condition-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-array-indexed-helper-condition-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-array-indexed-helper-condition-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-array-indexed-helper-condition-recovery: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-array-indexed-helper-condition-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-array-indexed-helper-condition-recovery: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-array-indexed-helper-condition-recovery: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-array-indexed-helper-condition-recovery: expected GUI trigger");
        Assert(document.Triggers[0].Actions.Count == 1, "gui-array-indexed-helper-condition-recovery: expected one recovered root action");
        Assert(document.Triggers[0].Actions[0].Name == "IfThenElseMultiple", "gui-array-indexed-helper-condition-recovery: expected IfThenElseMultiple root action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks.Count == 3, "gui-array-indexed-helper-condition-recovery: expected condition, then, and else blocks");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[0].Nodes.Count == 1, "gui-array-indexed-helper-condition-recovery: expected one recovered condition");

        var conditionNode = document.Triggers[0].Actions[0].ChildBlocks[0].Nodes[0];
        Assert(conditionNode.Name == "OperatorCompareInteger", "gui-array-indexed-helper-condition-recovery: expected integer comparison condition");
        Assert(conditionNode.Arguments[0].Kind == LegacyGuiArgumentKind.Call, "gui-array-indexed-helper-condition-recovery: expected left condition argument to stay a call");
        var getHeroLevelCall = conditionNode.Arguments[0].CallNode;
        Assert(getHeroLevelCall is not null && getHeroLevelCall.Name == "GetHeroLevel", "gui-array-indexed-helper-condition-recovery: expected GetHeroLevel call");
        Assert(getHeroLevelCall.Arguments[0].Kind == LegacyGuiArgumentKind.Variable && getHeroLevelCall.Arguments[0].ArrayIndex is not null, "gui-array-indexed-helper-condition-recovery: expected array-backed hero argument");
        Assert(getHeroLevelCall.Arguments[0].ArrayIndex!.Kind == LegacyGuiArgumentKind.Call, "gui-array-indexed-helper-condition-recovery: expected array index to stay a call");
        Assert(getHeroLevelCall.Arguments[0].ArrayIndex!.CallNode is not null && getHeroLevelCall.Arguments[0].ArrayIndex!.CallNode!.Name == "GetConvertedPlayerId", "gui-array-indexed-helper-condition-recovery: expected GetConvertedPlayerId array index");

        Assert(document.Triggers[0].Actions[0].ChildBlocks[1].Nodes.Count == 1, "gui-array-indexed-helper-condition-recovery: expected one then action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[1].Nodes[0].Name == "SetTimeOfDay", "gui-array-indexed-helper-condition-recovery: expected structured then action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[2].Nodes.Count == 1, "gui-array-indexed-helper-condition-recovery: expected one else action");
        Assert(document.Triggers[0].Actions[0].ChildBlocks[2].Nodes[0].Name == "DoNothing", "gui-array-indexed-helper-condition-recovery: expected structured else action");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-array-indexed-helper-condition-recovery: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-array-indexed-helper-condition-recovery", wtg.Data!);
        AssertOriginalYdweDebugWalkPasses("gui-array-indexed-helper-condition-recovery", wtg.Data!);
    }

    void RunGuiActionOnlyTriggerScenario()
    {
        Console.WriteLine("[smoke] gui-action-only-trigger");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateActionOnlyGuiScript());
        var inputPath = Path.Combine(tempRoot, "gui-action-only-trigger.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-action-only-trigger_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-action-only-trigger_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-action-only-trigger: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-action-only-trigger: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-action-only-trigger: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-action-only-trigger: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-action-only-trigger: expected GUI trigger");
        Assert(document.Triggers[0].Events.Count == 0, "gui-action-only-trigger: expected zero GUI events");
        Assert(document.Triggers[0].Actions.Count == 1, "gui-action-only-trigger: expected one action");
        Assert(document.Triggers[0].Actions[0].Name == "SetVariable", "gui-action-only-trigger: expected structured set-variable action");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-action-only-trigger: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-action-only-trigger", wtg.Data!);
    }

    void RunEventlessGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-eventless-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateEventlessGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-eventless-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-eventless-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-eventless-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-eventless-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-eventless-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-eventless-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-eventless-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-eventless-fallback: expected eventless multi-action trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-eventless-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-eventless-fallback: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-eventless-fallback", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("function Trig_Eventless_Actions", StringComparison.Ordinal), "gui-eventless-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-eventless-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-eventless-fallback", wtg.Data!);
    }

    void RunExecutedEventlessGuiTriggerScenario()
    {
        Console.WriteLine("[smoke] gui-executed-eventless-trigger");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateExecutedEventlessGuiScript());
        var inputPath = Path.Combine(tempRoot, "gui-executed-eventless-trigger.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-executed-eventless-trigger_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-executed-eventless-trigger_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-executed-eventless-trigger: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-executed-eventless-trigger: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-executed-eventless-trigger: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-executed-eventless-trigger: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-executed-eventless-trigger: expected executed eventless trigger to stay GUI");
        Assert(document.Triggers[0].Events.Count == 0, "gui-executed-eventless-trigger: expected zero GUI events");
        Assert(document.Triggers[0].Actions.Count == 2, "gui-executed-eventless-trigger: expected two structured actions");
        Assert(document.Triggers[0].Actions.All(static action => action.Name == "SetVariable"), "gui-executed-eventless-trigger: expected structured set-variable actions");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-executed-eventless-trigger: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-executed-eventless-trigger", wtg.Data!);
    }

    void RunLargeStructuredSetVariableTriggerScenario()
    {
        Console.WriteLine("[smoke] gui-large-structured-setvariable-trigger");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateLargeStructuredSetVariableScript());
        var inputPath = Path.Combine(tempRoot, "gui-large-structured-setvariable-trigger.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-large-structured-setvariable-trigger_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-large-structured-setvariable-trigger_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-large-structured-setvariable-trigger: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-large-structured-setvariable-trigger: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-large-structured-setvariable-trigger: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-large-structured-setvariable-trigger: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-large-structured-setvariable-trigger: expected large structured trigger to stay GUI");
        Assert(document.Triggers[0].Events.Count == 1, "gui-large-structured-setvariable-trigger: expected one timer event");
        Assert(document.Triggers[0].Actions.Count == 300, "gui-large-structured-setvariable-trigger: expected 300 structured actions");
        Assert(document.Triggers[0].Actions.All(static action => action.Name == "SetVariable"), "gui-large-structured-setvariable-trigger: expected only SetVariable actions");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-large-structured-setvariable-trigger: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-large-structured-setvariable-trigger", wtg.Data!);
    }

    void RunStringHeavyQuestTimerFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-string-heavy-quest-timer-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateStringHeavyQuestTimerScript());
        var inputPath = Path.Combine(tempRoot, "gui-string-heavy-quest-timer-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-string-heavy-quest-timer-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-string-heavy-quest-timer-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-string-heavy-quest-timer-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-string-heavy-quest-timer-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-string-heavy-quest-timer-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-string-heavy-quest-timer-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-string-heavy-quest-timer-fallback: expected trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-string-heavy-quest-timer-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-string-heavy-quest-timer-fallback: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-string-heavy-quest-timer-fallback", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("function Trig_StringHeavyQuestTimer_Actions", StringComparison.Ordinal), "gui-string-heavy-quest-timer-fallback: expected action function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_StringHeavyQuestTimer", StringComparison.Ordinal), "gui-string-heavy-quest-timer-fallback: expected init function preservation in custom text");
        Assert(System.Text.RegularExpressions.Regex.Matches(document.Triggers[0].CustomText, @"\bCreateQuestBJ\s*\(").Count == 10, "gui-string-heavy-quest-timer-fallback: expected all quest actions to stay in custom text");
        var actionIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "Trig_StringHeavyQuestTimer_Actions");
        var initIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "InitTrig_StringHeavyQuestTimer");
        Assert(actionIndex >= 0 && actionIndex < initIndex, "gui-string-heavy-quest-timer-fallback: expected action function to remain before init registration");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-string-heavy-quest-timer-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-string-heavy-quest-timer-fallback", wtg.Data!);
    }

    void RunCustomTextCallbackClosureScenario()
    {
        Console.WriteLine("[smoke] gui-custom-text-callback-closure");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCustomTextCallbackClosureScript());
        var inputPath = Path.Combine(tempRoot, "gui-custom-text-callback-closure.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-custom-text-callback-closure_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-custom-text-callback-closure_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-custom-text-callback-closure: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-custom-text-callback-closure: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-custom-text-callback-closure: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-custom-text-callback-closure: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-custom-text-callback-closure: expected trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-custom-text-callback-closure: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-custom-text-callback-closure: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-custom-text-callback-closure", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("function Trig_CustomTextCallbackClosure_Func001A", StringComparison.Ordinal), "gui-custom-text-callback-closure: expected callback helper preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_CustomTextCallbackClosure_Actions", StringComparison.Ordinal), "gui-custom-text-callback-closure: expected action function preservation in custom text");
        var helperIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "Trig_CustomTextCallbackClosure_Func001A");
        var actionIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "Trig_CustomTextCallbackClosure_Actions");
        var initIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "InitTrig_CustomTextCallbackClosure");
        Assert(helperIndex >= 0 && helperIndex < actionIndex, "gui-custom-text-callback-closure: expected callback helpers to stay in source order before the root action body");
        Assert(actionIndex >= 0 && actionIndex < initIndex, "gui-custom-text-callback-closure: expected the trigger init registration to remain after the action body in source order");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-custom-text-callback-closure: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-custom-text-callback-closure", wtg.Data!);
    }

    void RunCustomTextLocalClosureScenario()
    {
        Console.WriteLine("[smoke] gui-custom-text-local-closure");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCustomTextLocalClosureScript());
        var inputPath = Path.Combine(tempRoot, "gui-custom-text-local-closure.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-custom-text-local-closure_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-custom-text-local-closure_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-custom-text-local-closure: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-custom-text-local-closure: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-custom-text-local-closure: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 2, "gui-custom-text-local-closure: expected two triggers");
        Assert(document.Triggers[0].IsCustomText, "gui-custom-text-local-closure: expected primary trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-custom-text-local-closure: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-custom-text-local-closure: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-custom-text-local-closure", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("function Trig_LocalClosure_Actions", StringComparison.Ordinal), "gui-custom-text-local-closure: expected local action function preservation");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_LocalClosure", StringComparison.Ordinal), "gui-custom-text-local-closure: expected local init function preservation");
        Assert(!document.Triggers[0].CustomText.Contains("function SharedHelper", StringComparison.Ordinal), "gui-custom-text-local-closure: should not pull direct external helper definitions into the trigger chunk");
        Assert(!document.Triggers[0].CustomText.Contains("function Trig_Other_Actions", StringComparison.Ordinal), "gui-custom-text-local-closure: should not pull other trigger bodies into the trigger chunk");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-custom-text-local-closure: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-custom-text-local-closure", wtg.Data!);
    }

    void RunCustomTextSourceSliceGlobalsScenario()
    {
        Console.WriteLine("[smoke] gui-custom-text-source-slice-globals");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCustomTextSourceSliceGlobalsScript());
        var inputPath = Path.Combine(tempRoot, "gui-custom-text-source-slice-globals.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-custom-text-source-slice-globals_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-custom-text-source-slice-globals_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-custom-text-source-slice-globals: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-custom-text-source-slice-globals: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-custom-text-source-slice-globals: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-custom-text-source-slice-globals: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-custom-text-source-slice-globals: expected trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-custom-text-source-slice-globals: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-custom-text-source-slice-globals: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-custom-text-source-slice-globals", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("// Trigger: SourceSliceGlobals", StringComparison.Ordinal), "gui-custom-text-source-slice-globals: expected trigger comment header preservation");
        Assert(!document.Triggers[0].CustomText.Contains("/////////////", StringComparison.Ordinal), "gui-custom-text-source-slice-globals: expected decorative comment-only preambles to be stripped");
        Assert(document.Triggers[0].CustomText.Contains("globals", StringComparison.Ordinal), "gui-custom-text-source-slice-globals: expected trigger-local globals preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("integer customSliceCounter = 0", StringComparison.Ordinal), "gui-custom-text-source-slice-globals: expected custom global variable preservation");
        var globalsIndex = document.Triggers[0].CustomText.IndexOf("globals", StringComparison.Ordinal);
        var actionIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "Trig_SourceSliceGlobals_Actions");
        var initIndex = GetFunctionDeclarationIndex(document.Triggers[0].CustomText, "InitTrig_SourceSliceGlobals");
        Assert(globalsIndex >= 0 && globalsIndex < actionIndex, "gui-custom-text-source-slice-globals: expected trigger-local globals ahead of the action function");
        Assert(actionIndex >= 0 && actionIndex < initIndex, "gui-custom-text-source-slice-globals: expected source-order action body ahead of init registration");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-custom-text-source-slice-globals: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-custom-text-source-slice-globals", wtg.Data!);
    }

    void RunOpaqueInitFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-opaque-init-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateOpaqueInitFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-opaque-init-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-opaque-init-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-opaque-init-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-opaque-init-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-opaque-init-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-opaque-init-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-opaque-init-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-opaque-init-fallback: expected opaque init registration trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-opaque-init-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-opaque-init-fallback: custom-text trigger should not keep flattened actions");
        AssertHasEditorCustomTextHeader("gui-opaque-init-fallback", document.Triggers[0].CustomText);
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_OpaqueInit", StringComparison.Ordinal), "gui-opaque-init-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function OpaqueRegister", StringComparison.Ordinal), "gui-opaque-init-fallback: expected opaque helper preservation in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-opaque-init-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-opaque-init-fallback", wtg.Data!);
    }

    void RunGuiExtensionCompatibilityFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-extension-compatibility-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateExtensionCompatibilityFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-extension-compatibility-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-extension-compatibility-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-extension-compatibility-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-extension-compatibility-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-extension-compatibility-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-extension-compatibility-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-extension-compatibility-fallback: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-extension-compatibility-fallback: expected GUI trigger");
        Assert(document.Triggers[0].Events.Count == 1, "gui-extension-compatibility-fallback: expected one base-compatible event");
        Assert(document.Triggers[0].Actions.Count == 3, "gui-extension-compatibility-fallback: expected three preserved actions");
        Assert(document.Triggers[0].Actions[0].Name == "DisplayTextToPlayer", "gui-extension-compatibility-fallback: expected DisplayTextToPlayer structured recovery");
        Assert(document.Triggers[0].Actions[1].Name == "RemoveLocation", "gui-extension-compatibility-fallback: expected RemoveLocation structured recovery");
        Assert(document.Triggers[0].Actions[2].Name == "FlushGameCache", "gui-extension-compatibility-fallback: expected FlushGameCache structured recovery");
        Assert(document.Triggers[0].Actions[2].Arguments.Count == 1 &&
               document.Triggers[0].Actions[2].Arguments[0].CallNode?.Name == "InitGameCache",
            "gui-extension-compatibility-fallback: expected nested InitGameCache call recovery");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-extension-compatibility-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-extension-compatibility-fallback", wtg.Data!);
        AssertOriginalYdweDebugWalkPasses("gui-extension-compatibility-fallback", wtg.Data!);
    }

    void RunMapLocalExtensionRecoveryScenario()
    {
        Console.WriteLine("[smoke] gui-map-local-extension-recovery");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateMapLocalExtensionRecoveryScript());
        entries[@"ui\config"] = Encoding.UTF8.GetBytes("custompkg\n");
        entries[@"ui\custompkg\action.txt"] = Encoding.UTF8.GetBytes("""
[MapLocalDisplay]
title = "Map-local display"
description = "Map-local display ${Text}"
category = TC_CUSTOM
[[.args]]
type = string
""");
        entries[@"ui\custompkg\call.txt"] = Encoding.UTF8.GetBytes("""
[MapLocalMakeMessage]
title = "Map-local message"
description = "Map-local message ${Text}"
category = TC_CUSTOM
returns = string
[[.args]]
type = string
""");

        var inputPath = Path.Combine(tempRoot, "gui-map-local-extension-recovery.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-map-local-extension-recovery_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-map-local-extension-recovery_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-map-local-extension-recovery: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var config = archive.ReadFile(@"ui\config");
        var actionMetadata = archive.ReadFile(@"ui\custompkg\action.txt");
        var callMetadata = archive.ReadFile(@"ui\custompkg\call.txt");
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(config.Exists && config.Readable, "gui-map-local-extension-recovery: expected map-local ui config to be preserved");
        Assert(actionMetadata.Exists && actionMetadata.Readable, "gui-map-local-extension-recovery: expected map-local action metadata to be preserved");
        Assert(callMetadata.Exists && callMetadata.Readable, "gui-map-local-extension-recovery: expected map-local call metadata to be preserved");
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-map-local-extension-recovery: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-map-local-extension-recovery: repaired wct unreadable");

        var mapLocalMetadata = GuiMetadataCatalog.Load(repository.RootPath, new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase)
        {
            [@"ui\config"] = config.Data!,
            [@"ui\custompkg\action.txt"] = actionMetadata.Data!,
            [@"ui\custompkg\call.txt"] = callMetadata.Data!,
        });

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, mapLocalMetadata);
        Assert(document.Triggers.Count == 1, "gui-map-local-extension-recovery: expected one trigger");
        Assert(!document.Triggers[0].IsCustomText, "gui-map-local-extension-recovery: expected GUI trigger");
        Assert(document.Triggers[0].Events.Count == 1, "gui-map-local-extension-recovery: expected one recovered event");
        Assert(document.Triggers[0].Actions.Count == 1, "gui-map-local-extension-recovery: expected one recovered action");
        Assert(document.Triggers[0].Actions[0].Name == "MapLocalDisplay", "gui-map-local-extension-recovery: expected map-local action recovery");
        Assert(document.Triggers[0].Actions[0].Arguments.Count == 1, "gui-map-local-extension-recovery: expected one map-local action argument");
        Assert(document.Triggers[0].Actions[0].Arguments[0].CallNode?.Name == "MapLocalMakeMessage", "gui-map-local-extension-recovery: expected nested map-local call recovery");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, mapLocalMetadata, out var validationFailure), $"gui-map-local-extension-recovery: validator failed: {validationFailure}");
    }

    void RunQuotedYdweExtensionMetadataScenario()
    {
        Console.WriteLine("[smoke] quoted-ydwe-extension-metadata");

        Assert(guiMetadata.TryGetEntry(LegacyGuiFunctionKind.Action, " CreateUnit", out var rawCreateUnitAction),
            "quoted-ydwe-extension-metadata: expected raw Action/ CreateUnit to resolve from YDWE metadata");
        Assert(guiMetadata.TryGetEntry(LegacyGuiFunctionKind.Action, "CreateUnit", out var createUnitAction),
            "quoted-ydwe-extension-metadata: expected Action/CreateUnit to resolve from YDWE metadata");
        Assert(guiMetadata.TryGetEntry(LegacyGuiFunctionKind.Call, "CreateUnit", out var createUnitCall),
            "quoted-ydwe-extension-metadata: expected Call/CreateUnit to resolve from YDWE metadata");
        Assert(guiMetadata.TryGetEntry(LegacyGuiFunctionKind.Action, " CreateUnitAtLoc", out var rawCreateUnitAtLocAction),
            "quoted-ydwe-extension-metadata: expected raw Action/ CreateUnitAtLoc to resolve from YDWE metadata");
        Assert(guiMetadata.TryGetEntry(LegacyGuiFunctionKind.Action, "CreateUnitAtLoc", out var createUnitAtLocAction),
            "quoted-ydwe-extension-metadata: expected Action/CreateUnitAtLoc to resolve from YDWE metadata");

        Assert(ReferenceEquals(rawCreateUnitAction, createUnitAction),
            "quoted-ydwe-extension-metadata: expected raw and normalized Action/CreateUnit lookup to share one entry");
        Assert(ReferenceEquals(rawCreateUnitAtLocAction, createUnitAtLocAction),
            "quoted-ydwe-extension-metadata: expected raw and normalized Action/CreateUnitAtLoc lookup to share one entry");
        Assert(string.Equals(createUnitAction.Name, " CreateUnit", StringComparison.Ordinal),
            "quoted-ydwe-extension-metadata: expected healthy-sample raw action metadata name for CreateUnit");
        Assert(string.Equals(createUnitCall.Name, "CreateUnit", StringComparison.Ordinal),
            "quoted-ydwe-extension-metadata: expected standard raw call metadata name for CreateUnit");
        Assert(string.Equals(createUnitAtLocAction.Name, " CreateUnitAtLoc", StringComparison.Ordinal),
            "quoted-ydwe-extension-metadata: expected healthy-sample raw action metadata name for CreateUnitAtLoc");
        Assert(createUnitAction.Source.Contains(@"\.tools\YDWE\share\mpq\ydwe\action.txt", StringComparison.OrdinalIgnoreCase),
            "quoted-ydwe-extension-metadata: expected CreateUnit action metadata to come from the YDWE package");
        Assert(createUnitCall.Source.Contains(@"\.tools\YDWE\share\mpq\ydwe\call.txt", StringComparison.OrdinalIgnoreCase),
            "quoted-ydwe-extension-metadata: expected CreateUnit call metadata to come from the YDWE package");
    }

    void RunGuiReconstructionFailureScenario()
    {
        Console.WriteLine("[smoke] gui-reconstruction-failure");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: Encoding.UTF8.GetBytes("""
function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Missing()
endfunction
"""));
        var inputPath = Path.Combine(tempRoot, "gui-reconstruction-failure.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-reconstruction-failure_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-reconstruction-failure_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.Warnings.Any(warning => warning.Contains("Attempted to reconstruct `war3map.wtg/wct`", StringComparison.OrdinalIgnoreCase)),
            "gui-reconstruction-failure: expected reconstruction failure warning");

        using var archive = MpqArchiveReader.Open(outputPath);
        Assert(!archive.ReadFile(MapFileNames.TriggerData).Exists, "gui-reconstruction-failure: wtg should remain absent after failed reconstruction");
        Assert(!archive.ReadFile(MapFileNames.TriggerStrings).Exists, "gui-reconstruction-failure: wct should remain absent after failed reconstruction");
    }

    void RunLargePseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-large-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateLargePseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-large-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-large-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-large-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-large-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-large-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-large-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-large-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-large-pseudo-fallback: expected large pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-large-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-large-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-large-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_LargePseudo_Actions", StringComparison.Ordinal), "gui-large-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-large-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-large-pseudo-fallback", wtg.Data!);
    }

    void RunMediumPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-medium-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateMediumPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-medium-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-medium-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-medium-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-medium-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-medium-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-medium-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-medium-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-medium-pseudo-fallback: expected medium pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-medium-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-medium-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-medium-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_MediumPseudo_Actions", StringComparison.Ordinal), "gui-medium-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-medium-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-medium-pseudo-fallback", wtg.Data!);
    }

    void RunCompactPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-compact-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCompactPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-compact-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-compact-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-compact-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-compact-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-compact-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-compact-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-compact-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-compact-pseudo-fallback: expected compact pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-compact-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-compact-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-compact-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_CompactPseudo_Actions", StringComparison.Ordinal), "gui-compact-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-compact-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-compact-pseudo-fallback", wtg.Data!);
    }

    void RunScriptHeavyPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-script-heavy-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateScriptHeavyPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-script-heavy-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-script-heavy-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-script-heavy-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-script-heavy-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-script-heavy-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-script-heavy-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-script-heavy-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-script-heavy-pseudo-fallback: expected script-heavy pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-script-heavy-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-script-heavy-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-script-heavy-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_ScriptHeavyPseudo_Actions", StringComparison.Ordinal), "gui-script-heavy-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-script-heavy-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-script-heavy-pseudo-fallback", wtg.Data!);
    }

    void RunAlmostAllCustomPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-all-custom-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateAlmostAllCustomPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-all-custom-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-all-custom-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-all-custom-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-all-custom-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-all-custom-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-all-custom-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-all-custom-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-all-custom-pseudo-fallback: expected almost-all-custom pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-all-custom-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-all-custom-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-all-custom-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_AllCustomPseudo_Actions", StringComparison.Ordinal), "gui-all-custom-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-all-custom-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-all-custom-pseudo-fallback", wtg.Data!);
    }

    void RunSmallBranchyPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-small-branchy-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateSmallBranchyPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-small-branchy-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-small-branchy-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-small-branchy-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-small-branchy-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-small-branchy-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-small-branchy-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == 1, "gui-small-branchy-pseudo-fallback: expected one trigger");
        Assert(document.Triggers[0].IsCustomText, "gui-small-branchy-pseudo-fallback: expected small branch-heavy pseudo-GUI trigger to fall back to custom text");
        Assert(document.Triggers[0].Events.Count == 0, "gui-small-branchy-pseudo-fallback: custom-text trigger should use an empty GUI tree");
        Assert(document.Triggers[0].Actions.Count == 0, "gui-small-branchy-pseudo-fallback: custom-text trigger should not keep flattened actions");
        Assert(document.Triggers[0].CustomText.Contains("function InitTrig_", StringComparison.Ordinal), "gui-small-branchy-pseudo-fallback: expected init function preservation in custom text");
        Assert(document.Triggers[0].CustomText.Contains("function Trig_SmallBranchyPseudo_Actions", StringComparison.Ordinal), "gui-small-branchy-pseudo-fallback: expected original action function in custom text");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-small-branchy-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-small-branchy-pseudo-fallback", wtg.Data!);
    }

    void RunMediumBranchyPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-medium-branchy-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateMediumBranchyPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-medium-branchy-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-medium-branchy-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-medium-branchy-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-medium-branchy-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-medium-branchy-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-medium-branchy-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-medium-branchy-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 20,
            maxActionCount: 95,
            minCustomScriptCount: 14,
            minControlFlowCount: 7);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-medium-branchy-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-medium-branchy-pseudo-fallback", wtg.Data!);
    }

    void RunMediumControlPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-medium-control-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateMediumControlPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-medium-control-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-medium-control-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-medium-control-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-medium-control-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-medium-control-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-medium-control-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-medium-control-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 20,
            maxActionCount: 95,
            minCustomScriptCount: 15,
            minControlFlowCount: 5);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-medium-control-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-medium-control-pseudo-fallback", wtg.Data!);
    }

    void RunFocusedMixedPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-focused-mixed-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateFocusedMixedPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-focused-mixed-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-focused-mixed-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-focused-mixed-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-focused-mixed-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-focused-mixed-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-focused-mixed-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-focused-mixed-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 15,
            maxActionCount: 19,
            minCustomScriptCount: 6,
            minControlFlowCount: 2);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-focused-mixed-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-focused-mixed-pseudo-fallback", wtg.Data!);
    }

    void RunGuardedMixedPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-guarded-mixed-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuardedMixedPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-guarded-mixed-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-guarded-mixed-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-guarded-mixed-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-guarded-mixed-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-guarded-mixed-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-guarded-mixed-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-guarded-mixed-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 12,
            maxActionCount: 19,
            minCustomScriptCount: 6,
            minControlFlowCount: 3);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-guarded-mixed-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-guarded-mixed-pseudo-fallback", wtg.Data!);
    }

    void RunScriptSideEffectMixedPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-script-side-effect-mixed-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateScriptSideEffectMixedPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-script-side-effect-mixed-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-script-side-effect-mixed-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-script-side-effect-mixed-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-script-side-effect-mixed-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-script-side-effect-mixed-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-script-side-effect-mixed-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-script-side-effect-mixed-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 12,
            maxActionCount: 19,
            minCustomScriptCount: 5,
            minControlFlowCount: 2);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-script-side-effect-mixed-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-script-side-effect-mixed-pseudo-fallback", wtg.Data!);
    }

    void RunFinalStableBandPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-final-stable-band-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateFinalStableBandPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-final-stable-band-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-final-stable-band-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-final-stable-band-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-final-stable-band-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-final-stable-band-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-final-stable-band-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-final-stable-band-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 12,
            maxActionCount: 19,
            minCustomScriptCount: 4,
            minControlFlowCount: 3);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-final-stable-band-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-final-stable-band-pseudo-fallback", wtg.Data!);
    }

    void RunCompactControlHeavyPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-compact-control-heavy-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCompactControlHeavyPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-compact-control-heavy-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-compact-control-heavy-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-compact-control-heavy-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-compact-control-heavy-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-compact-control-heavy-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-compact-control-heavy-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-compact-control-heavy-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 8,
            maxActionCount: 11,
            minCustomScriptCount: 6,
            minControlFlowCount: 6);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-compact-control-heavy-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-compact-control-heavy-pseudo-fallback", wtg.Data!);
    }

    void RunCompactGuardedPseudoGuiFallbackScenario()
    {
        Console.WriteLine("[smoke] gui-compact-guarded-pseudo-fallback");
        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateCompactGuardedPseudoGuiFallbackScript());
        var inputPath = Path.Combine(tempRoot, "gui-compact-guarded-pseudo-fallback.w3x");
        var outputPath = Path.Combine(tempRoot, "gui-compact-guarded-pseudo-fallback_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "gui-compact-guarded-pseudo-fallback_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "gui-compact-guarded-pseudo-fallback: expected reconstructed wtg");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "gui-compact-guarded-pseudo-fallback: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "gui-compact-guarded-pseudo-fallback: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        AssertGuiSkeletonRetained(
            "gui-compact-guarded-pseudo-fallback",
            document,
            reportDir,
            minActionCount: 5,
            maxActionCount: 7,
            minCustomScriptCount: 4,
            minControlFlowCount: 3);
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"gui-compact-guarded-pseudo-fallback: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("gui-compact-guarded-pseudo-fallback", wtg.Data!);
    }

    void RunSampleGuiReconstructionScenario()
    {
        Console.WriteLine("[smoke] sample-gui-reconstruction");
        var sampleScriptPath = Path.Combine(repository.RootPath, ".tools", "MapRepair", "[0]一世之尊(地形开始) (2)", "map", MapFileNames.ScriptJ);
        if (!File.Exists(sampleScriptPath))
        {
            return;
        }

        var scriptBytes = File.ReadAllBytes(sampleScriptPath);
        var scriptText = TextFileCodec.Decode(scriptBytes).Text;
        var expectedTriggerCount = System.Text.RegularExpressions.Regex.Matches(scriptText, @"^\s*call\s+InitTrig_[A-Za-z0-9_]+\s*\(\s*\)\s*$", System.Text.RegularExpressions.RegexOptions.Multiline).Count;
        var expectedVariableCount = System.Text.RegularExpressions.Regex.Matches(scriptText, @"^\s*(?:constant\s+)?[A-Za-z0-9_]+\s+(?:array\s+)?udg_[A-Za-z0-9_]+(?:\s*=.*)?$", System.Text.RegularExpressions.RegexOptions.Multiline).Count;

        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: scriptBytes);
        var inputPath = Path.Combine(tempRoot, "sample-gui-reconstruction.w3x");
        var outputPath = Path.Combine(tempRoot, "sample-gui-reconstruction_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "sample-gui-reconstruction_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerData, StringComparer.OrdinalIgnoreCase), "sample-gui-reconstruction: expected reconstructed wtg");
        Assert(repairResult.GeneratedFiles.Contains(MapFileNames.TriggerStrings, StringComparer.OrdinalIgnoreCase), "sample-gui-reconstruction: expected reconstructed wct");

        using var archive = MpqArchiveReader.Open(outputPath);
        var wtg = archive.ReadFile(MapFileNames.TriggerData);
        var wct = archive.ReadFile(MapFileNames.TriggerStrings);
        Assert(wtg.Exists && wtg.Readable && wtg.Data is not null, "sample-gui-reconstruction: repaired wtg unreadable");
        Assert(wct.Exists && wct.Readable && wct.Data is not null, "sample-gui-reconstruction: repaired wct unreadable");

        var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtg.Data!, wct.Data!, guiMetadata);
        Assert(document.Triggers.Count == expectedTriggerCount, $"sample-gui-reconstruction: expected {expectedTriggerCount} reconstructed triggers");
        Assert(document.Variables.Count == expectedVariableCount, $"sample-gui-reconstruction: expected {expectedVariableCount} reconstructed variables");
        Assert(YdweWtgCompatibilityValidator.TryValidate(wtg.Data!, guiMetadata, out var validationFailure), $"sample-gui-reconstruction: validator failed: {validationFailure}");
        AssertOriginalYdweCheckerPasses("sample-gui-reconstruction", wtg.Data!);
        Assert(Directory.Exists(Path.Combine(reportDir, "RecoveredGui")), "sample-gui-reconstruction: expected debug artifact directory");
        AssertTriggerRiskIndexCoverage("sample-gui-reconstruction", reportDir, expectedTriggerCount);
    }

    void RunStaleSiblingWorkspaceWarningScenario()
    {
        Console.WriteLine("[smoke] stale-sibling-workspace-warning");
        var entries = CreateArchiveEntries(includeScript: true, includeW3i: true, includeTerrain: true, includeTriggers: true, includeDoodads: true);
        var inputPath = Path.Combine(tempRoot, "stale-sibling-workspace-warning.w3x");
        var outputPath = Path.Combine(tempRoot, "stale-sibling-workspace-warning_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "stale-sibling-workspace-warning_report");
        var workspaceMapDirectory = Path.Combine(tempRoot, "stale-sibling-workspace-warning_repaired", "map");

        Directory.CreateDirectory(workspaceMapDirectory);
        File.WriteAllBytes(Path.Combine(workspaceMapDirectory, MapFileNames.TriggerData), [0x00, 0x01, 0x02]);
        File.WriteAllBytes(Path.Combine(workspaceMapDirectory, MapFileNames.TriggerStrings), [0x03, 0x04, 0x05]);

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        var repairResult = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));

        Assert(repairResult.Warnings.Any(warning =>
                warning.Contains("sibling unpacked workspace", StringComparison.OrdinalIgnoreCase) &&
                warning.Contains(@"map\war3map.wtg", StringComparison.OrdinalIgnoreCase) &&
                warning.Contains(@"map\war3map.wct", StringComparison.OrdinalIgnoreCase)),
            "stale-sibling-workspace-warning: expected stale workspace warning");
    }

    void RunW2lLniReconstructionScenario()
    {
        Console.WriteLine("[smoke] w2l-lni-reconstruction");
        if (!string.Equals(Environment.GetEnvironmentVariable("MAPREPAIR_SMOKE_RUN_W2L"), "1", StringComparison.Ordinal))
        {
            Console.WriteLine("[smoke] w2l-lni-reconstruction skipped: set MAPREPAIR_SMOKE_RUN_W2L=1 to enable the optional staged w2l.exe check");
            return;
        }

        var entries = CreateArchiveEntries(includeScript: false, includeW3i: true, includeTerrain: true, includeTriggers: false, includeDoodads: true, scriptOverride: CreateGuiRecoveryScript());
        var inputPath = Path.Combine(tempRoot, "w2l-gui-reconstruction.w3x");
        var outputPath = Path.Combine(tempRoot, "w2l-gui-reconstruction_repaired.w3x");
        var reportDir = Path.Combine(tempRoot, "w2l-gui-reconstruction_report");

        MpqArchiveWriter.WriteArchive(inputPath, entries);
        _ = service.Repair(new RepairOptions(inputPath, outputPath, reportDir));

        var toolRoot = Path.Combine(tempRoot, "w2l-stage");
        PrepareW2lStage(toolRoot);
        var lniOutput = Path.Combine(tempRoot, "w2l-output");
        Directory.CreateDirectory(lniOutput);

        var process = Process.Start(new ProcessStartInfo
        {
            FileName = Path.Combine(toolRoot, "w2l.exe"),
            Arguments = $"lni \"{outputPath}\" \"{lniOutput}\"",
            WorkingDirectory = toolRoot,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true
        });
        Assert(process is not null, "w2l-gui-reconstruction: failed to start w2l.exe");
        process!.WaitForExit();
        var stdout = process.StandardOutput.ReadToEnd();
        var stderr = process.StandardError.ReadToEnd();
        Assert(process.ExitCode == 0,
            $"w2l-gui-reconstruction: staged w2l.exe failed: {FormatProcessOutput(stdout.Trim(), stderr.Trim())}");

        Assert(Directory.Exists(lniOutput), "w2l-gui-reconstruction: expected lni output directory");
    }

    byte[] CreateGuiRecoveryScript(bool includeRootCondition = false)
    {
        var conditionLine = includeRootCondition
            ? "    call TriggerAddCondition(gg_trg_Recovered, Condition(function Trig_RecoveredConditions))\r\n"
            : string.Empty;
        var conditionFunction = includeRootCondition
            ? """
function Trig_RecoveredConditions takes nothing returns boolean
    return true
endfunction

"""
            : string.Empty;

        return Encoding.UTF8.GetBytes($$"""
globals
    trigger gg_trg_Recovered = null
    integer udg_Count = 0
    string udg_Name = ""
    integer array udg_Array
endglobals

function InitGlobals takes nothing returns nothing
    set udg_Count = 7
    set udg_Name = "Recovered"
endfunction

{{conditionFunction}}function Trig_RecoveredActions takes nothing returns nothing
    call BJDebugMsg("Recovered trigger fired")
endfunction

function InitTrig_Recovered takes nothing returns nothing
    set gg_trg_Recovered = CreateTrigger()
            call TriggerRegisterTimerEventPeriodic(gg_trg_Recovered, 0.25)
{{conditionLine}}    call TriggerAddAction(gg_trg_Recovered, function Trig_RecoveredActions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Recovered()
endfunction

function main takes nothing returns nothing
    call InitGlobals()
    call InitCustomTriggers()
    call ConditionalTriggerExecute(gg_trg_Recovered)
endfunction
""");
    }

    byte[] CreateGuiRecoveryScriptWithGuardCondition()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_Recovered = null
endglobals

function Trig_RecoveredConditions takes nothing returns boolean
    local boolean ok = true
    return ok
endfunction

function Trig_RecoveredActions takes nothing returns nothing
    local integer count = 1
    call BJDebugMsg("Recovered trigger fired")
    if count > 0 then
        call BJDebugMsg("Guard preserved")
    endif
endfunction

function InitTrig_Recovered takes nothing returns nothing
    set gg_trg_Recovered = CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Recovered, 0.25)
    call TriggerAddCondition(gg_trg_Recovered, Condition(function Trig_RecoveredConditions))
    call TriggerAddAction(gg_trg_Recovered, function Trig_RecoveredActions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Recovered()
endfunction

function main takes nothing returns nothing
    call InitCustomTriggers()
endfunction
""");
    }

    byte[] CreateGuiGuardedComparisonConditionRecoveryScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_GuardedItemCode = null
    trigger gg_trg_GuardedBoolean = null
endglobals

function Trig_GuardedItemCode_Conditions takes nothing returns boolean
    if ( not ( GetItemTypeId(GetManipulatedItem()) == 'I000' ) ) then
        return false
    endif
    return true
endfunction

function Trig_GuardedItemCode_Actions takes nothing returns nothing
    call RemoveItem(GetManipulatedItem())
endfunction

function InitTrig_GuardedItemCode takes nothing returns nothing
    set gg_trg_GuardedItemCode = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_GuardedItemCode, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_GuardedItemCode, Condition(function Trig_GuardedItemCode_Conditions))
    call TriggerAddAction(gg_trg_GuardedItemCode, function Trig_GuardedItemCode_Actions)
endfunction

function Trig_GuardedBoolean_Conditions takes nothing returns boolean
    if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true ) ) then
        return false
    endif
    return true
endfunction

function Trig_GuardedBoolean_Actions takes nothing returns nothing
    call DoNothing()
endfunction

function InitTrig_GuardedBoolean takes nothing returns nothing
    set gg_trg_GuardedBoolean = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_GuardedBoolean, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_GuardedBoolean, Condition(function Trig_GuardedBoolean_Conditions))
    call TriggerAddAction(gg_trg_GuardedBoolean, function Trig_GuardedBoolean_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_GuardedItemCode()
    call InitTrig_GuardedBoolean()
endfunction
""");
    }

    byte[] CreateGuiMultiGuardConditionRecoveryScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_MultiGuard = null
endglobals

function Trig_MultiGuard_Conditions takes nothing returns boolean
    if ( not ( GetItemTypeId(GetManipulatedItem()) == 'I000' ) ) then
        return false
    endif
    if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) == true ) ) then
        return false
    endif
    if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_TAUREN) == false ) ) then
        return false
    endif
    return true
endfunction

function Trig_MultiGuard_Actions takes nothing returns nothing
    call DoNothing()
endfunction

function InitTrig_MultiGuard takes nothing returns nothing
    set gg_trg_MultiGuard = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_MultiGuard, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddCondition(gg_trg_MultiGuard, Condition(function Trig_MultiGuard_Conditions))
    call TriggerAddAction(gg_trg_MultiGuard, function Trig_MultiGuard_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_MultiGuard()
endfunction
""");
    }

    byte[] CreateGuiActionIfThenElseChildBlockRecoveryScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_ActionIfElse = null
endglobals

function Trig_ActionIfElse_Func001C takes nothing returns boolean
    if ( not ( 2 >= ( GetHeroLevel(GetTriggerUnit()) + 1 ) ) ) then
        return false
    endif
    return true
endfunction

function Trig_ActionIfElse_Actions takes nothing returns nothing
    if ( Trig_ActionIfElse_Func001C() ) then
        call SetTimeOfDay(12.00)
    else
        call DoNothing()
    endif
endfunction

function InitTrig_ActionIfElse takes nothing returns nothing
    set gg_trg_ActionIfElse = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ActionIfElse, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(gg_trg_ActionIfElse, function Trig_ActionIfElse_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_ActionIfElse()
endfunction
""");
    }

    byte[] CreateGuiArrayIndexedHelperConditionRecoveryScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_ArrayIndexedHelper = null
    unit array udg_HERO
endglobals

function Trig_ArrayIndexedHelper_Func001C takes nothing returns boolean
    if ( not ( GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]) >= 39 ) ) then
        return false
    endif
    return true
endfunction

function Trig_ArrayIndexedHelper_Actions takes nothing returns nothing
    if ( Trig_ArrayIndexedHelper_Func001C() ) then
        call SetTimeOfDay(12.00)
    else
        call DoNothing()
    endif
endfunction

function InitTrig_ArrayIndexedHelper takes nothing returns nothing
    set gg_trg_ArrayIndexedHelper = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ(gg_trg_ArrayIndexedHelper, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    call TriggerAddAction(gg_trg_ArrayIndexedHelper, function Trig_ArrayIndexedHelper_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_ArrayIndexedHelper()
endfunction
""");
    }

    byte[] CreateActionOnlyGuiScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_ActionOnly = null
    integer udg_Value = 0
endglobals

function Trig_ActionOnly_Actions takes nothing returns nothing
    set udg_Value = 3
endfunction

function InitTrig_ActionOnly takes nothing returns nothing
    set gg_trg_ActionOnly = CreateTrigger()
    call TriggerAddAction(gg_trg_ActionOnly, function Trig_ActionOnly_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_ActionOnly()
endfunction
""");
    }

    byte[] CreateCustomTextCallbackClosureScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_CustomTextCallbackClosure = null
endglobals

function Trig_CustomTextCallbackClosure_Func001A takes nothing returns nothing
    call BJDebugMsg("callback")
endfunction

function Trig_CustomTextCallbackClosure_Actions takes nothing returns nothing
    call ForForce(GetPlayersAll(), function Trig_CustomTextCallbackClosure_Func001A)
    call BJDebugMsg("body")
endfunction

function InitTrig_CustomTextCallbackClosure takes nothing returns nothing
    set gg_trg_CustomTextCallbackClosure = CreateTrigger()
    call TriggerAddAction(gg_trg_CustomTextCallbackClosure, function Trig_CustomTextCallbackClosure_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_CustomTextCallbackClosure()
endfunction
""");
    }

    byte[] CreateCustomTextLocalClosureScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_LocalClosure = null
    trigger gg_trg_Other = null
endglobals

function SharedHelper takes nothing returns nothing
    call Trig_Other_Actions()
endfunction

function Trig_LocalClosure_Actions takes nothing returns nothing
    call ExecuteFunc("SharedHelper")
endfunction

function InitTrig_LocalClosure takes nothing returns nothing
    set gg_trg_LocalClosure = CreateTrigger()
    call TriggerAddAction(gg_trg_LocalClosure, function Trig_LocalClosure_Actions)
endfunction

function Trig_Other_Actions takes nothing returns nothing
    call DoNothing()
endfunction

function InitTrig_Other takes nothing returns nothing
    set gg_trg_Other = CreateTrigger()
    call TriggerAddAction(gg_trg_Other, function Trig_Other_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_LocalClosure()
    call InitTrig_Other()
endfunction
""");
    }

    byte[] CreateOpaqueInitFallbackScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_OpaqueInit = null
endglobals

function OpaqueRegister takes trigger trig returns nothing
    call ConvertRace(0)
endfunction

function Trig_OpaqueInit_Actions takes nothing returns nothing
    call DoNothing()
endfunction

function InitTrig_OpaqueInit takes nothing returns nothing
    set gg_trg_OpaqueInit = CreateTrigger()
    call OpaqueRegister(gg_trg_OpaqueInit)
    call TriggerAddAction(gg_trg_OpaqueInit, function Trig_OpaqueInit_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_OpaqueInit()
endfunction
""");
    }

    byte[] CreateCustomTextSourceSliceGlobalsScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_SourceSliceGlobals = null
endglobals

/////////////
//===========================================================================
// Trigger: SourceSliceGlobals
//===========================================================================
globals
    integer customSliceCounter = 0
endglobals

function Trig_SourceSliceGlobals_Actions takes nothing returns nothing
    set customSliceCounter = customSliceCounter + 1
    call BJDebugMsg(I2S(customSliceCounter))
endfunction

function InitTrig_SourceSliceGlobals takes nothing returns nothing
    set gg_trg_SourceSliceGlobals = CreateTrigger()
    call TriggerAddAction(gg_trg_SourceSliceGlobals, function Trig_SourceSliceGlobals_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_SourceSliceGlobals()
endfunction
""");
    }

    byte[] CreateEventlessGuiFallbackScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_Eventless = null
    integer udg_EventlessValue = 0
endglobals

function Trig_Eventless_Actions takes nothing returns nothing
    set udg_EventlessValue = 1
    set udg_EventlessValue = 2
endfunction

function InitTrig_Eventless takes nothing returns nothing
    set gg_trg_Eventless = CreateTrigger()
    call TriggerAddAction(gg_trg_Eventless, function Trig_Eventless_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Eventless()
endfunction
""");
    }

    byte[] CreateExecutedEventlessGuiScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_ExecutedEventless = null
    integer array udg_ExecutedEventlessCodes
endglobals

function Trig_ExecutedEventless_Actions takes nothing returns nothing
    set udg_ExecutedEventlessCodes[1]='osw1'
    set udg_ExecutedEventlessCodes[2]='osw2'
endfunction

function InitTrig_ExecutedEventless takes nothing returns nothing
    set gg_trg_ExecutedEventless = CreateTrigger()
    call TriggerAddAction(gg_trg_ExecutedEventless, function Trig_ExecutedEventless_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_ExecutedEventless()
endfunction

function RunExecutedEventless takes nothing returns nothing
    call TriggerExecute(gg_trg_ExecutedEventless)
endfunction

function main takes nothing returns nothing
    call InitCustomTriggers()
    call RunExecutedEventless()
endfunction
""");
    }

    byte[] CreateLargeStructuredSetVariableScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_LargeSetVariable = null");
        builder.AppendLine("    integer array udg_LargeSetVariableCodes");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_LargeSetVariable_Actions takes nothing returns nothing");
        for (var index = 1; index <= 300; index++)
        {
            builder.AppendLine($"    set udg_LargeSetVariableCodes[{index}]='I000'");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_LargeSetVariable takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_LargeSetVariable = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventSingle(gg_trg_LargeSetVariable, 1.00)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_LargeSetVariable, function Trig_LargeSetVariable_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_LargeSetVariable()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateStringHeavyQuestTimerScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_StringHeavyQuestTimer = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_StringHeavyQuestTimer_Actions takes nothing returns nothing");
        for (var index = 1; index <= 10; index++)
        {
            var description = new string((char)('A' + (index % 5)), 220);
            builder.AppendLine($"    call CreateQuestBJ(bj_QUESTTYPE_REQ_DISCOVERED, \"Quest {index}\", \"{description}\", \"ReplaceableTextures\\\\CommandButtons\\\\BTNAmbush.blp\")");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_StringHeavyQuestTimer takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_StringHeavyQuestTimer = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventSingle(gg_trg_StringHeavyQuestTimer, 1.00)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_StringHeavyQuestTimer, function Trig_StringHeavyQuestTimer_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_StringHeavyQuestTimer()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateExtensionCompatibilityFallbackScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_ExtensionFallback = null
    rect gg_rct_Fallback = null
endglobals

function Trig_ExtensionFallback_Actions takes nothing returns nothing
    call DisplayTextToPlayer(Player(0), 0.00, 0.00, "Fallback")
    call RemoveLocation(GetRectCenter(gg_rct_Fallback))
    call FlushGameCache(InitGameCache("Cache"))
endfunction

function InitTrig_ExtensionFallback takes nothing returns nothing
    set gg_trg_ExtensionFallback = CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_ExtensionFallback, 1.00)
    call TriggerAddAction(gg_trg_ExtensionFallback, function Trig_ExtensionFallback_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_ExtensionFallback()
endfunction
""");
    }

    byte[] CreateMapLocalExtensionRecoveryScript()
    {
        return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_MapLocal = null
endglobals

function Trig_MapLocal_Actions takes nothing returns nothing
    call MapLocalDisplay(MapLocalMakeMessage("Fallback"))
endfunction

function InitTrig_MapLocal takes nothing returns nothing
    set gg_trg_MapLocal = CreateTrigger()
    call TriggerRegisterTimerEventSingle(gg_trg_MapLocal, 1.00)
    call TriggerAddAction(gg_trg_MapLocal, function Trig_MapLocal_Actions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_MapLocal()
endfunction
""");
    }

    byte[] CreateLargePseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_LargePseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_LargePseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 48; index++)
        {
            builder.AppendLine("    if true then");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    else");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    endif");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_LargePseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_LargePseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_LargePseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_LargePseudo, function Trig_LargePseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_LargePseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateMediumPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_MediumPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_MediumPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 24; index++)
        {
            builder.AppendLine("    if true then");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    else");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    endif");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_MediumPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_MediumPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_MediumPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_MediumPseudo, function Trig_MediumPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_MediumPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateCompactPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_CompactPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 10; index++)
        {
            builder.AppendLine("    if true then");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    else");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    endif");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_CompactPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_CompactPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_CompactPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_CompactPseudo, function Trig_CompactPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_CompactPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateScriptHeavyPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_ScriptHeavyPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_ScriptHeavyPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 24; index++)
        {
            builder.AppendLine($"    call ExecuteFunc(\"LinearStep{index:D2}\")");
        }

        for (var index = 0; index < 6; index++)
        {
            builder.AppendLine("    call DoNothing()");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_ScriptHeavyPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_ScriptHeavyPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_ScriptHeavyPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_ScriptHeavyPseudo, function Trig_ScriptHeavyPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_ScriptHeavyPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateAlmostAllCustomPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_AllCustomPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_AllCustomPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 25; index++)
        {
            builder.AppendLine($"    call ExecuteFunc(\"AllCustomStep{index:D2}\")");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_AllCustomPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_AllCustomPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_AllCustomPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_AllCustomPseudo, function Trig_AllCustomPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_AllCustomPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateSmallBranchyPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_SmallBranchyPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_SmallBranchyPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 6; index++)
        {
            builder.AppendLine("    if true then");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    else");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    endif");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_SmallBranchyPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_SmallBranchyPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_SmallBranchyPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_SmallBranchyPseudo, function Trig_SmallBranchyPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_SmallBranchyPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateMediumBranchyPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_MediumBranchyPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_MediumBranchyPseudo_Actions takes nothing returns nothing");
        for (var index = 0; index < 4; index++)
        {
            builder.AppendLine("    if true then");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    else");
            builder.AppendLine("        call DoNothing()");
            builder.AppendLine("    endif");
        }

        builder.AppendLine("    call ExecuteFunc(\"MediumBranchyStep00\")");
        builder.AppendLine("    call ExecuteFunc(\"MediumBranchyStep01\")");
        builder.AppendLine("    call DoNothing()");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_MediumBranchyPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_MediumBranchyPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_MediumBranchyPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_MediumBranchyPseudo, function Trig_MediumBranchyPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_MediumBranchyPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateMediumControlPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_MediumControlPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_MediumControlPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    if true then");
        builder.AppendLine("        call DoNothing()");
        builder.AppendLine("    endif");
        builder.AppendLine("    loop");
        builder.AppendLine("        exitwhen true");
        builder.AppendLine("    endloop");
        for (var index = 0; index < 10; index++)
        {
            builder.AppendLine($"    call ExecuteFunc(\"MediumControlStep{index:D2}\")");
        }

        for (var index = 0; index < 4; index++)
        {
            builder.AppendLine("    call DoNothing()");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_MediumControlPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_MediumControlPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_MediumControlPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_MediumControlPseudo, function Trig_MediumControlPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_MediumControlPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateFocusedMixedPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_FocusedMixedPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_FocusedMixedPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    if true then");
        builder.AppendLine("        call ExecuteFunc(\"FocusedMixedStep00\")");
        builder.AppendLine("    endif");
        for (var index = 1; index <= 6; index++)
        {
            builder.AppendLine($"    call ExecuteFunc(\"FocusedMixedStep{index:D2}\")");
        }

        for (var index = 0; index < 6; index++)
        {
            builder.AppendLine("    call DoNothing()");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_FocusedMixedPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_FocusedMixedPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_FocusedMixedPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_FocusedMixedPseudo, function Trig_FocusedMixedPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_FocusedMixedPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateGuardedMixedPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_GuardedMixedPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_GuardedMixedPseudo_Conditions takes nothing returns boolean");
        builder.AppendLine("    if true then");
        builder.AppendLine("        return true");
        builder.AppendLine("    endif");
        builder.AppendLine("    return false");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_GuardedMixedPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    if true then");
        builder.AppendLine("        call ExecuteFunc(\"GuardedMixedStep00\")");
        builder.AppendLine("    else");
        builder.AppendLine("        call ExecuteFunc(\"GuardedMixedStep01\")");
        builder.AppendLine("    endif");
        for (var index = 0; index < 6; index++)
        {
            builder.AppendLine("    call DoNothing()");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_GuardedMixedPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_GuardedMixedPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_GuardedMixedPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddCondition(gg_trg_GuardedMixedPseudo, Condition(function Trig_GuardedMixedPseudo_Conditions))");
        builder.AppendLine("    call TriggerAddAction(gg_trg_GuardedMixedPseudo, function Trig_GuardedMixedPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_GuardedMixedPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateScriptSideEffectMixedPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_ScriptSideEffectMixedPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_ScriptSideEffectMixedPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    if true then");
        builder.AppendLine("        call RemoveLocation(null)");
        builder.AppendLine("    else");
        builder.AppendLine("        call SetCameraTargetControllerNoZForPlayer(Player(0), null, 0, 0, false)");
        builder.AppendLine("    endif");
        builder.AppendLine("    call DisplayTextToPlayer(Player(0), 0, 0, \"mixed\")");
        for (var index = 0; index < 7; index++)
        {
            builder.AppendLine("    call DoNothing()");
        }

        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_ScriptSideEffectMixedPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_ScriptSideEffectMixedPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_ScriptSideEffectMixedPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddAction(gg_trg_ScriptSideEffectMixedPseudo, function Trig_ScriptSideEffectMixedPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_ScriptSideEffectMixedPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateFinalStableBandPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_FinalStableBandPseudo = null");
        builder.AppendLine("    trigger gg_trg_Reused = null");
        builder.AppendLine("    location udg_SP = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_FinalStableBandPseudo_Conditions takes nothing returns boolean");
        builder.AppendLine("    if true then");
        builder.AppendLine("        return true");
        builder.AppendLine("    endif");
        builder.AppendLine("    return false");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_FinalStableBandPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    call DisableTrigger(GetTriggeringTrigger())");
        builder.AppendLine("    set udg_SP = GetUnitLoc(GetTriggerUnit())");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0001, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0002, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0003, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0004, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0005, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0006, 851990, udg_SP)");
        builder.AppendLine("    call IssuePointOrderByIdLoc(gg_unit_hfoo_0007, 851990, udg_SP)");
        builder.AppendLine("    call RemoveLocation(udg_SP)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_FinalStableBandPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_FinalStableBandPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterTimerEventPeriodic(gg_trg_FinalStableBandPseudo, 0.25)");
        builder.AppendLine("    call TriggerAddCondition(gg_trg_FinalStableBandPseudo, Condition(function Trig_FinalStableBandPseudo_Conditions))");
        builder.AppendLine("    call TriggerAddAction(gg_trg_FinalStableBandPseudo, function Trig_FinalStableBandPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_FinalStableBandPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateCompactControlHeavyPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_CompactControlHeavyPseudo = null");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactControlHeavyPseudo_Conditions takes nothing returns boolean");
        builder.AppendLine("    if true then");
        builder.AppendLine("        return false");
        builder.AppendLine("    endif");
        builder.AppendLine("    return true");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactControlHeavyPseudo_Func001C takes nothing returns boolean");
        builder.AppendLine("    return true");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactControlHeavyPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    if (Trig_CompactControlHeavyPseudo_Func001C()) then");
        builder.AppendLine("        call UnitRemoveItemSwapped(GetManipulatedItem(), GetTriggerUnit())");
        builder.AppendLine("        call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()), 0, 0, \"compact\")");
        builder.AppendLine("    else");
        builder.AppendLine("        call DoNothing()");
        builder.AppendLine("    endif");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_CompactControlHeavyPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_CompactControlHeavyPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterAnyUnitEventBJ(gg_trg_CompactControlHeavyPseudo, EVENT_PLAYER_UNIT_PICKUP_ITEM)");
        builder.AppendLine("    call TriggerAddCondition(gg_trg_CompactControlHeavyPseudo, Condition(function Trig_CompactControlHeavyPseudo_Conditions))");
        builder.AppendLine("    call TriggerAddAction(gg_trg_CompactControlHeavyPseudo, function Trig_CompactControlHeavyPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_CompactControlHeavyPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    byte[] CreateCompactGuardedPseudoGuiFallbackScript()
    {
        var builder = new StringBuilder();
        builder.AppendLine("globals");
        builder.AppendLine("    trigger gg_trg_CompactGuardedPseudo = null");
        builder.AppendLine("    integer array udg_LOST_ITEM");
        builder.AppendLine("endglobals");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactGuardedPseudo_Conditions takes nothing returns boolean");
        builder.AppendLine("    if true then");
        builder.AppendLine("        return true");
        builder.AppendLine("    endif");
        builder.AppendLine("    return false");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactGuardedPseudo_Func001A takes nothing returns nothing");
        builder.AppendLine("    call DoNothing()");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function Trig_CompactGuardedPseudo_Actions takes nothing returns nothing");
        builder.AppendLine("    call RemoveItem(GetManipulatedItem())");
        builder.AppendLine("    call ForForce(GetPlayersAll(), function Trig_CompactGuardedPseudo_Func001A)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitTrig_CompactGuardedPseudo takes nothing returns nothing");
        builder.AppendLine("    set gg_trg_CompactGuardedPseudo = CreateTrigger()");
        builder.AppendLine("    call TriggerRegisterAnyUnitEventBJ(gg_trg_CompactGuardedPseudo, EVENT_PLAYER_UNIT_USE_ITEM)");
        builder.AppendLine("    call TriggerAddCondition(gg_trg_CompactGuardedPseudo, Condition(function Trig_CompactGuardedPseudo_Conditions))");
        builder.AppendLine("    call TriggerAddAction(gg_trg_CompactGuardedPseudo, function Trig_CompactGuardedPseudo_Actions)");
        builder.AppendLine("endfunction");
        builder.AppendLine();
        builder.AppendLine("function InitCustomTriggers takes nothing returns nothing");
        builder.AppendLine("    call InitTrig_CompactGuardedPseudo()");
        builder.AppendLine("endfunction");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    void AssertGuiSkeletonRetained(
        string scenarioName,
        LegacyGuiDocument document,
        string reportDir,
        int minActionCount,
        int maxActionCount,
        int minCustomScriptCount,
        int minControlFlowCount)
    {
        Assert(document.Triggers.Count == 1, $"{scenarioName}: expected one trigger");
        var trigger = document.Triggers[0];
        Assert(!trigger.IsCustomText, $"{scenarioName}: expected the trigger to keep a GUI skeleton");
        Assert(trigger.Events.Count > 0, $"{scenarioName}: expected the GUI trigger to keep at least one event");
        Assert(trigger.Actions.Count > 0, $"{scenarioName}: expected the GUI trigger to keep actions");
        Assert(string.IsNullOrEmpty(trigger.CustomText), $"{scenarioName}: GUI trigger should not spill whole-trigger custom text into WCT");

        var indexPath = Path.Combine(reportDir, "RecoveredGui", "index.json");
        Assert(File.Exists(indexPath), $"{scenarioName}: expected RecoveredGui/index.json");
        using var indexDocument = JsonDocument.Parse(File.ReadAllText(indexPath, Encoding.UTF8));
        Assert(indexDocument.RootElement.ValueKind == JsonValueKind.Array, $"{scenarioName}: expected trigger risk index array");
        Assert(indexDocument.RootElement.GetArrayLength() == 1, $"{scenarioName}: expected exactly one trigger risk entry");

        var entry = indexDocument.RootElement[0];
        Assert(!entry.GetProperty("isCustomText").GetBoolean(), $"{scenarioName}: expected non-custom-text risk entry");
        Assert((entry.GetProperty("fallbackReason").GetString() ?? string.Empty).Length == 0, $"{scenarioName}: expected empty fallbackReason");

        var reportPath = Path.Combine(reportDir, "repair-report.json");
        Assert(File.Exists(reportPath), $"{scenarioName}: expected repair-report.json");
        using var reportDocument = JsonDocument.Parse(File.ReadAllText(reportPath, Encoding.UTF8));
        Assert(reportDocument.RootElement.TryGetProperty("RecoveredGuiTriggerIndex", out var reportIndex), $"{scenarioName}: expected RecoveredGuiTriggerIndex in repair-report.json");
        Assert(reportIndex.ValueKind == JsonValueKind.Array, $"{scenarioName}: expected repair report trigger risk array");
        Assert(reportIndex.GetArrayLength() == 1, $"{scenarioName}: expected exactly one repair report trigger risk entry");
    }

    void AssertTriggerRiskIndexCoverage(string scenarioName, string reportDir, int expectedCount)
    {
        var indexPath = Path.Combine(reportDir, "RecoveredGui", "index.json");
        Assert(File.Exists(indexPath), $"{scenarioName}: expected RecoveredGui/index.json");
        using var indexDocument = JsonDocument.Parse(File.ReadAllText(indexPath, Encoding.UTF8));
        Assert(indexDocument.RootElement.ValueKind == JsonValueKind.Array, $"{scenarioName}: expected trigger risk index array");
        Assert(indexDocument.RootElement.GetArrayLength() == expectedCount, $"{scenarioName}: expected trigger risk index to cover every recovered trigger");

        var reportPath = Path.Combine(reportDir, "repair-report.json");
        Assert(File.Exists(reportPath), $"{scenarioName}: expected repair-report.json");
        using var reportDocument = JsonDocument.Parse(File.ReadAllText(reportPath, Encoding.UTF8));
        Assert(reportDocument.RootElement.TryGetProperty("RecoveredGuiTriggerIndex", out var reportIndex), $"{scenarioName}: expected RecoveredGuiTriggerIndex in repair-report.json");
        Assert(reportIndex.ValueKind == JsonValueKind.Array, $"{scenarioName}: expected repair report trigger risk array");
        Assert(reportIndex.GetArrayLength() == expectedCount, $"{scenarioName}: expected repair report trigger risk index to cover every recovered trigger");
    }

    void PrepareW2lStage(string stageRoot)
    {
        if (Directory.Exists(stageRoot))
        {
            Directory.Delete(stageRoot, recursive: true);
        }

        Directory.CreateDirectory(stageRoot);
        var sourceRoot = GetFirstExistingDirectory(
            Path.Combine(repository.RootPath, ".canon", "w3x2lni"),
            Path.Combine(repository.RootPath, ".tools", "w3x2lni"));
        Assert(sourceRoot is not null, "Missing w3x2lni runtime under .canon/w3x2lni or .tools/w3x2lni");
        var verifiedSourceRoot = sourceRoot!;
        File.Copy(Path.Combine(verifiedSourceRoot, "w2l.exe"), Path.Combine(stageRoot, "w2l.exe"), overwrite: true);

        CopyDirectory(Path.Combine(verifiedSourceRoot, "bin"), Path.Combine(stageRoot, "bin"));
        CopyDirectory(Path.Combine(verifiedSourceRoot, "script"), Path.Combine(stageRoot, "script"));
        CopyDirectory(Path.Combine(verifiedSourceRoot, "data"), Path.Combine(stageRoot, "data"));

        var configPath = Path.Combine(verifiedSourceRoot, "config.ini");
        var configText = File.ReadAllText(configPath, Encoding.UTF8)
            .Replace("data_ui = ${YDWE}", "data_ui = ${DATA}", StringComparison.Ordinal);
        File.WriteAllText(Path.Combine(stageRoot, "config.ini"), configText, Encoding.UTF8);

        // Keep the staged w2l smoke path headless: when staged w2l.exe fails, record stderr/stdout
        // instead of spawning the crash-report message box through push_error.lua.
        var pushErrorPath = Path.Combine(stageRoot, "script", "gui", "push_error.lua");
        if (File.Exists(pushErrorPath))
        {
            var pushErrorText = File.ReadAllText(pushErrorPath, Encoding.UTF8)
                .Replace("        script:string(),", "        script:string(),\r\n        '-s',", StringComparison.Ordinal);
            File.WriteAllText(pushErrorPath, pushErrorText, Encoding.UTF8);
        }
    }

    string? GetFirstExistingDirectory(params string[] candidatePaths)
    {
        foreach (var path in candidatePaths)
        {
            if (Directory.Exists(path))
            {
                return path;
            }
        }

        return null;
    }

    void AssertOriginalYdweCheckerPasses(string scenarioName, byte[] wtgBytes)
    {
        var wtgPath = Path.Combine(tempRoot, $"{scenarioName}.ydwe-check.wtg");
        File.WriteAllBytes(wtgPath, wtgBytes);
        AssertOriginalYdweCheckerPassesFromPath(scenarioName, wtgPath);
    }

    void AssertOriginalYdweDebugWalkPasses(string scenarioName, byte[] wtgBytes)
    {
        var wtgPath = Path.Combine(tempRoot, $"{scenarioName}.ydwe-debug.wtg");
        File.WriteAllBytes(wtgPath, wtgBytes);
        AssertOriginalYdweDebugWalkPassesFromPath(scenarioName, wtgPath);
    }

    void AssertOriginalYdweCheckerPassesFromPath(string scenarioName, string wtgPath)
    {
        var startInfo = CreateYdweCheckerStartInfo(scenarioName, wtgPath);

        using var process = Process.Start(startInfo);
        Assert(process is not null, $"{scenarioName}: failed to start original YDWE checker");

        process!.WaitForExit();
        var stdout = process.StandardOutput.ReadToEnd().Trim();
        var stderr = process.StandardError.ReadToEnd().Trim();

        Assert(process.ExitCode == 0,
            $"{scenarioName}: original YDWE checker failed: {FormatProcessOutput(stdout, stderr)}");
    }

    void AssertOriginalYdweDebugWalkPassesFromPath(string scenarioName, string wtgPath)
    {
        var startInfo = CreateYdweCheckerStartInfo(scenarioName, wtgPath);
        startInfo.ArgumentList.Add("--debug-missing");

        using var process = Process.Start(startInfo);
        Assert(process is not null, $"{scenarioName}: failed to start YDWE debug walk");

        process!.WaitForExit();
        var stdout = process.StandardOutput.ReadToEnd().Trim();
        var stderr = process.StandardError.ReadToEnd().Trim();

        Assert(process.ExitCode == 0,
            $"{scenarioName}: YDWE debug walk failed: {FormatProcessOutput(stdout, stderr)}");
    }

    ProcessStartInfo CreateYdweCheckerStartInfo(string scenarioName, string wtgPath)
    {
        var ydweRoot = Path.Combine(repository.RootPath, ".tools", "YDWE");
        var luaRuntimePath = Path.Combine(ydweRoot, "plugin", "w3x2lni_zhCN_v2.7.3", "bin", "w3x2lni-lua.exe");
        var checkerScriptPath = Path.Combine(repository.RootPath, ".tools", "MapRepair", "scripts", "ydwe_wtg_checker.lua");

        Assert(File.Exists(luaRuntimePath), $"{scenarioName}: missing YDWE checker runtime");
        Assert(File.Exists(checkerScriptPath), $"{scenarioName}: missing YDWE checker bridge script");

        var startInfo = new ProcessStartInfo
        {
            FileName = luaRuntimePath,
            WorkingDirectory = repository.RootPath,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            StandardOutputEncoding = Encoding.UTF8,
            StandardErrorEncoding = Encoding.UTF8,
        };
        startInfo.ArgumentList.Add(checkerScriptPath);
        startInfo.ArgumentList.Add(ydweRoot);
        startInfo.ArgumentList.Add(wtgPath);
        return startInfo;
    }

    static string FormatProcessOutput(string stdout, string stderr)
    {
        if (!string.IsNullOrWhiteSpace(stderr) && !string.IsNullOrWhiteSpace(stdout))
        {
            return $"{stderr} | stdout: {stdout}";
        }

        if (!string.IsNullOrWhiteSpace(stderr))
        {
            return stderr;
        }

        if (!string.IsNullOrWhiteSpace(stdout))
        {
            return stdout;
        }

        return "no process output";
    }

    static void CopyDirectory(string sourceDirectory, string targetDirectory)
    {
        Directory.CreateDirectory(targetDirectory);
        foreach (var file in Directory.GetFiles(sourceDirectory))
        {
            File.Copy(file, Path.Combine(targetDirectory, Path.GetFileName(file)), overwrite: true);
        }

        foreach (var directory in Directory.GetDirectories(sourceDirectory))
        {
            CopyDirectory(directory, Path.Combine(targetDirectory, Path.GetFileName(directory)));
        }
    }

    static byte[] CreateTextMdlWithTextures(params string[] texturePaths)
    {
        var builder = new StringBuilder();
        builder.AppendLine("Textures 1 {");
        foreach (var texturePath in texturePaths)
        {
            builder.AppendLine("    Bitmap {");
            builder.AppendLine($"        Image \"{texturePath}\",");
            builder.AppendLine("    }");
        }

        builder.AppendLine("}");
        return Encoding.UTF8.GetBytes(builder.ToString());
    }

    static byte[] CreateBinaryMdxWithTextures(params string[] texturePaths)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(Encoding.ASCII.GetBytes("MDLX"));

        using var textureChunkStream = new MemoryStream();
        using (var textureChunkWriter = new BinaryWriter(textureChunkStream, Encoding.UTF8, leaveOpen: true))
        {
            foreach (var texturePath in texturePaths)
            {
                textureChunkWriter.Write(0);
                var pathBuffer = new byte[260];
                var encodedPath = Encoding.UTF8.GetBytes(texturePath);
                Array.Copy(encodedPath, pathBuffer, Math.Min(encodedPath.Length, pathBuffer.Length - 1));
                textureChunkWriter.Write(pathBuffer);
                textureChunkWriter.Write(0);
            }
        }

        var textureChunkBytes = textureChunkStream.ToArray();
        writer.Write(Encoding.ASCII.GetBytes("TEXS"));
        writer.Write(textureChunkBytes.Length);
        writer.Write(textureChunkBytes);
        return stream.ToArray();
    }

    static void Assert(bool condition, string message)
    {
        if (!condition)
        {
            throw new InvalidOperationException(message);
        }
    }

    static void AssertHasEditorCustomTextHeader(string scenarioName, string customText)
    {
        Assert(
            customText.StartsWith("//TESH.scrollpos=0", StringComparison.Ordinal),
            $"{scenarioName}: expected custom text to start with a TESH scroll header");
        Assert(
            customText.Contains("//TESH.alwaysfold=0", StringComparison.Ordinal),
            $"{scenarioName}: expected custom text to include a TESH fold header");
    }

    static int GetFunctionDeclarationIndex(string customText, string functionName)
    {
        var match = System.Text.RegularExpressions.Regex.Match(
            customText,
            $@"(?m)^function\s+{System.Text.RegularExpressions.Regex.Escape(functionName)}\b");
        return match.Success ? match.Index : -1;
    }
}
finally
{
    try
    {
        Directory.Delete(tempRoot, recursive: true);
    }
    catch
    {
        // best effort cleanup
    }
}
