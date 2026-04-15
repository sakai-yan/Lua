using System.Text;
using MapRepair.Core.Internal;
using MapRepair.Core.Internal.Gui;
using MapRepair.Core.Internal.Mpq;

if (args.Length > 0 && string.Equals(args[0], "--trigger-shell", StringComparison.OrdinalIgnoreCase))
{
    return RunTriggerShellVariants(args.Skip(1).ToArray());
}

if (args.Length > 0 && string.Equals(args[0], "--replace-trigger-data", StringComparison.OrdinalIgnoreCase))
{
    return ReplaceTriggerData(args.Skip(1).ToArray());
}

return RunObjectFileVariants(args);

static int RunObjectFileVariants(string[] args)
{
    var inputPath = args.Length > 0
        ? Path.GetFullPath(args[0])
        : Path.GetFullPath(@"D:\Software\榄斿吔鍦板浘缂栬緫\[0]鏂版暣鍚堢紪杈戝櫒\Lua\.tools\MapRepair\chuzhang V2 mod2.851_repaired_v19.w3x");

    if (!File.Exists(inputPath))
    {
        Console.Error.WriteLine($"Input map not found: {inputPath}");
        return 1;
    }

    var outputRoot = args.Length > 1
        ? Path.GetFullPath(args[1])
        : Path.Combine(Path.GetDirectoryName(inputPath) ?? ".", Path.GetFileNameWithoutExtension(inputPath) + "_diag");
    Directory.CreateDirectory(outputRoot);

    var objectFiles = new[]
    {
        "war3map.w3u",
        "war3map.w3t",
        "war3map.w3a",
        "war3map.w3h",
        "war3map.w3q",
        "war3map.w3b",
        "war3map.w3d"
    };

    var variants = new[]
    {
        new Variant("base", []),
        new Variant("w3u_only", ["war3map.w3u"]),
        new Variant("w3t_only", ["war3map.w3t"]),
        new Variant("w3a_only", ["war3map.w3a"]),
        new Variant("w3h_only", ["war3map.w3h"]),
        new Variant("w3q_only", ["war3map.w3q"]),
        new Variant("w3bd_only", ["war3map.w3b", "war3map.w3d"])
    };

    var sourceEntries = ReadAllEntries(inputPath);
    var manifest = new StringBuilder();
    manifest.AppendLine("# Diagnostic Variants");
    manifest.AppendLine();
    manifest.AppendLine($"- Source: `{inputPath}`");
    manifest.AppendLine($"- Output root: `{outputRoot}`");
    manifest.AppendLine();

    foreach (var variant in variants)
    {
        var variantEntries = new Dictionary<string, byte[]>(sourceEntries, StringComparer.OrdinalIgnoreCase);

        foreach (var objectFile in objectFiles)
        {
            if (variant.KeepObjectFiles.Contains(objectFile, StringComparer.OrdinalIgnoreCase))
            {
                continue;
            }

            variantEntries.Remove(objectFile);
        }

        variantEntries["(listfile)"] = BuildListFile(variantEntries.Keys);
        var outputPath = Path.Combine(outputRoot, $"{Path.GetFileNameWithoutExtension(inputPath)}_{variant.Name}.w3x");
        MpqArchiveWriter.WriteArchive(outputPath, variantEntries);

        manifest.AppendLine($"## {variant.Name}");
        manifest.AppendLine();
        manifest.AppendLine($"- Output: `{outputPath}`");
        manifest.AppendLine($"- Keeps: `{string.Join(", ", variant.KeepObjectFiles.DefaultIfEmpty("(none)"))}`");
        manifest.AppendLine();
    }

    var manifestPath = Path.Combine(outputRoot, "diagnostic-variants.md");
    File.WriteAllText(manifestPath, manifest.ToString(), Encoding.UTF8);
    Console.WriteLine($"Generated {variants.Length} diagnostic variants under: {outputRoot}");
    Console.WriteLine($"Manifest: {manifestPath}");
    return 0;
}

static int RunTriggerShellVariants(string[] args)
{
    if (args.Length < 3)
    {
        Console.Error.WriteLine("Usage: MapRepair.Diag --trigger-shell <map-path> <output-root> <ordinal-spec> [ordinal-spec] [...]");
        Console.Error.WriteLine("Example: MapRepair.Diag --trigger-shell repaired.w3x out 016 018 019 016-022");
        return 1;
    }

    var inputPath = Path.GetFullPath(args[0]);
    if (!File.Exists(inputPath))
    {
        Console.Error.WriteLine($"Input map not found: {inputPath}");
        return 1;
    }

    var outputRoot = Path.GetFullPath(args[1]);
    Directory.CreateDirectory(outputRoot);

    var sourceEntries = ReadAllEntries(inputPath);
    if (!sourceEntries.TryGetValue("war3map.wtg", out var wtgBytes) ||
        !sourceEntries.TryGetValue("war3map.wct", out var wctBytes))
    {
        Console.Error.WriteLine("Source map is missing readable war3map.wtg/wct entries.");
        return 1;
    }

    var repositoryRoot = RepositoryLocator.Locate().RootPath;
    var metadata = GuiMetadataCatalog.Load(repositoryRoot, sourceEntries);
    var document = LegacyGuiBinaryCodec.ReadWtgAndWct(wtgBytes, wctBytes, metadata);

    var specs = args
        .Skip(2)
        .Select(spec => ParseTriggerShellSpec(spec, document.Triggers.Count))
        .ToArray();

    var manifest = new StringBuilder();
    manifest.AppendLine("# Trigger Shell Variants");
    manifest.AppendLine();
    manifest.AppendLine($"- Source: `{inputPath}`");
    manifest.AppendLine($"- Output root: `{outputRoot}`");
    manifest.AppendLine($"- Trigger count: `{document.Triggers.Count}`");
    manifest.AppendLine();

    foreach (var spec in specs)
    {
        var variantTriggers = new List<LegacyGuiTrigger>(document.Triggers.Count);
        foreach (var (trigger, index) in document.Triggers.Select((trigger, index) => (trigger, index)))
        {
            var ordinal = index + 1;
            variantTriggers.Add(spec.Ordinals.Contains(ordinal)
                ? CreateTriggerShell(trigger)
                : trigger);
        }

        var variantDocument = new LegacyGuiDocument(
            document.Categories,
            document.Variables,
            variantTriggers,
            document.GlobalCustomComment,
            document.GlobalCustomCode);

        var variantEntries = new Dictionary<string, byte[]>(sourceEntries, StringComparer.OrdinalIgnoreCase)
        {
            ["war3map.wtg"] = LegacyGuiBinaryCodec.WriteWtg(variantDocument),
            ["war3map.wct"] = LegacyGuiBinaryCodec.WriteWct(variantDocument)
        };

        variantEntries["(listfile)"] = BuildListFile(variantEntries.Keys);

        var outputPath = Path.Combine(outputRoot, $"{Path.GetFileNameWithoutExtension(inputPath)}_trigger_shell_{spec.VariantName}.w3x");
        MpqArchiveWriter.WriteArchive(outputPath, variantEntries);

        var replacedNames = spec.Ordinals
            .Select(ordinal => $"{ordinal:D3}-{document.Triggers[ordinal - 1].Name}")
            .ToArray();

        manifest.AppendLine($"## {spec.RawSpec}");
        manifest.AppendLine();
        manifest.AppendLine($"- Output: `{outputPath}`");
        manifest.AppendLine($"- Replaced ordinals: `{string.Join(", ", spec.Ordinals.Select(ordinal => ordinal.ToString("D3")))}`");
        manifest.AppendLine($"- Replaced triggers: `{string.Join(", ", replacedNames)}`");
        manifest.AppendLine();
    }

    var manifestPath = Path.Combine(outputRoot, "trigger-shell-variants.md");
    File.WriteAllText(manifestPath, manifest.ToString(), Encoding.UTF8);
    Console.WriteLine($"Generated {specs.Length} trigger-shell variants under: {outputRoot}");
    Console.WriteLine($"Manifest: {manifestPath}");
    return 0;
}

static int ReplaceTriggerData(string[] args)
{
    if (args.Length != 4)
    {
        Console.Error.WriteLine("Usage: MapRepair.Diag --replace-trigger-data <input-map> <output-map> <wtg-path> <wct-path>");
        return 1;
    }

    var inputMapPath = Path.GetFullPath(args[0]);
    var outputMapPath = Path.GetFullPath(args[1]);
    var replacementWtgPath = Path.GetFullPath(args[2]);
    var replacementWctPath = Path.GetFullPath(args[3]);

    if (!File.Exists(inputMapPath))
    {
        Console.Error.WriteLine($"Input map not found: {inputMapPath}");
        return 1;
    }

    if (!File.Exists(replacementWtgPath) || !File.Exists(replacementWctPath))
    {
        Console.Error.WriteLine("Replacement war3map.wtg/wct file not found.");
        return 1;
    }

    var entries = ReadAllEntries(inputMapPath);
    entries["war3map.wtg"] = File.ReadAllBytes(replacementWtgPath);
    entries["war3map.wct"] = File.ReadAllBytes(replacementWctPath);
    entries["(listfile)"] = BuildListFile(entries.Keys);

    Directory.CreateDirectory(Path.GetDirectoryName(outputMapPath)!);
    MpqArchiveWriter.WriteArchive(outputMapPath, entries);
    Console.WriteLine(outputMapPath);
    return 0;
}

static LegacyGuiTrigger CreateTriggerShell(LegacyGuiTrigger original)
{
    return new LegacyGuiTrigger
    {
        Name = original.Name,
        Description = original.Description,
        Type = original.Type,
        Enabled = false,
        IsCustomText = false,
        StartsClosed = original.StartsClosed,
        RunOnMapInit = false,
        CategoryId = original.CategoryId,
        CustomText = string.Empty
    };
}

static TriggerShellSpec ParseTriggerShellSpec(string rawSpec, int triggerCount)
{
    if (string.IsNullOrWhiteSpace(rawSpec))
    {
        throw new InvalidOperationException("Trigger-shell spec cannot be empty.");
    }

    var ordinals = new SortedSet<int>();
    foreach (var segment in rawSpec.Split([',', '+'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
    {
        var rangeParts = segment.Split('-', StringSplitOptions.TrimEntries);
        if (rangeParts.Length == 1)
        {
            ordinals.Add(ParseOrdinal(rangeParts[0], triggerCount));
            continue;
        }

        if (rangeParts.Length != 2)
        {
            throw new InvalidOperationException($"Invalid trigger-shell spec segment: `{segment}`.");
        }

        var start = ParseOrdinal(rangeParts[0], triggerCount);
        var end = ParseOrdinal(rangeParts[1], triggerCount);
        if (end < start)
        {
            (start, end) = (end, start);
        }

        for (var ordinal = start; ordinal <= end; ordinal++)
        {
            ordinals.Add(ordinal);
        }
    }

    if (ordinals.Count == 0)
    {
        throw new InvalidOperationException($"Trigger-shell spec `{rawSpec}` resolved to no trigger ordinals.");
    }

    return new TriggerShellSpec(
        rawSpec,
        string.Concat(rawSpec.Select(ch => char.IsLetterOrDigit(ch) ? ch : '_')),
        ordinals.ToArray());
}

static int ParseOrdinal(string rawValue, int triggerCount)
{
    if (!int.TryParse(rawValue, out var ordinal) || ordinal <= 0 || ordinal > triggerCount)
    {
        throw new InvalidOperationException($"Trigger ordinal `{rawValue}` is outside the valid range 1..{triggerCount}.");
    }

    return ordinal;
}

static Dictionary<string, byte[]> ReadAllEntries(string inputPath)
{
    using var archive = MpqArchiveReader.Open(inputPath);
    var listFile = archive.ReadFile("(listfile)");
    if (!listFile.Exists || !listFile.Readable || listFile.Data is null)
    {
        throw new InvalidOperationException("Source map is missing a readable (listfile); cannot build diagnostic variants.");
    }

    var entries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
    var names = Encoding.UTF8.GetString(listFile.Data)
        .Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
        .Distinct(StringComparer.OrdinalIgnoreCase)
        .ToArray();

    foreach (var name in names)
    {
        var result = archive.ReadFile(name);
        if (!result.Exists || !result.Readable || result.Data is null)
        {
            continue;
        }

        entries[name] = result.Data;
    }

    entries["(listfile)"] = listFile.Data;
    return entries;
}

static byte[] BuildListFile(IEnumerable<string> entries)
{
    var lines = entries
        .Where(name => !string.Equals(name, "(listfile)", StringComparison.OrdinalIgnoreCase))
        .OrderBy(name => name, StringComparer.OrdinalIgnoreCase);
    return Encoding.UTF8.GetBytes(string.Join("\r\n", lines) + "\r\n");
}

sealed record Variant(string Name, IReadOnlyList<string> KeepObjectFiles);

sealed record TriggerShellSpec(string RawSpec, string VariantName, IReadOnlyList<int> Ordinals);
