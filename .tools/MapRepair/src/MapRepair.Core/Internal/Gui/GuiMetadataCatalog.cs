using System.Text;
using MapRepair.Core.Internal;

namespace MapRepair.Core.Internal.Gui;

internal sealed class GuiMetadataCatalog
{
    private readonly Dictionary<(LegacyGuiFunctionKind Kind, string Name), GuiMetadataEntry> _entriesByName = new();
    private readonly Dictionary<(LegacyGuiFunctionKind Kind, string ScriptName), GuiMetadataEntry> _entriesByScriptName = new();
    private readonly Dictionary<(LegacyGuiFunctionKind Kind, string Name), GuiMetadataEntry> _baseCompatibleEntriesByName = new();
    private readonly Dictionary<(LegacyGuiFunctionKind Kind, string ScriptName), GuiMetadataEntry> _baseCompatibleEntriesByScriptName = new();
    private readonly Dictionary<string, Dictionary<string, string>> _presetNamesByTypeAndScript = new(StringComparer.OrdinalIgnoreCase);

    private GuiMetadataCatalog()
    {
    }

    public IReadOnlyList<string> Sources { get; private set; } = [];

    public IReadOnlyList<GuiPrivateSemanticAlias> PrivateAliases { get; private set; } = [];

    public static GuiMetadataCatalog Load(string repositoryRoot, IReadOnlyDictionary<string, byte[]> archiveEntries)
    {
        var catalog = new GuiMetadataCatalog();
        var sources = new List<string>();

        catalog.LoadBaseTriggerData(repositoryRoot, sources);
        catalog.LoadYdwePackages(repositoryRoot, sources);
        catalog.LoadMapLocalPackages(archiveEntries, sources);

        catalog.Sources = sources.Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
        catalog.PrivateAliases =
        [
            new GuiPrivateSemanticAlias("AbilityId(\"MFEvent_", "MFEvent runtime dispatch"),
            new GuiPrivateSemanticAlias("SkillUEvent_Register", "MF skill event registration"),
            new GuiPrivateSemanticAlias("MFLua['", "MFLua dispatch table"),
            new GuiPrivateSemanticAlias("MyFucLua['", "MyFucLua dispatch table"),
            new GuiPrivateSemanticAlias("MyFucLua[\"", "MyFucLua dispatch table")
        ];
        return catalog;
    }

    public bool TryGetEntry(LegacyGuiFunctionKind kind, string name, out GuiMetadataEntry entry)
    {
        if (_entriesByName.TryGetValue((kind, name), out entry!))
        {
            return true;
        }

        return _entriesByScriptName.TryGetValue((kind, name), out entry!);
    }

    public bool TryGetBaseCompatibleEntry(LegacyGuiFunctionKind kind, string name, out GuiMetadataEntry entry)
    {
        if (_baseCompatibleEntriesByName.TryGetValue((kind, name), out entry!))
        {
            return true;
        }

        return _baseCompatibleEntriesByScriptName.TryGetValue((kind, name), out entry!);
    }

    public bool TryGetStructuredRecoveryEntry(LegacyGuiFunctionKind kind, string name, out GuiMetadataEntry entry)
    {
        return TryGetEntry(kind, name, out entry);
    }

    public IReadOnlyList<string> MatchPrivateSemantics(string text)
    {
        var matches = new List<string>();
        foreach (var alias in PrivateAliases)
        {
            if (text.Contains(alias.Marker, StringComparison.Ordinal))
            {
                matches.Add(alias.Description);
            }
        }

        return matches;
    }

    public bool TryResolvePreset(string? expectedType, string scriptValue, out string presetName)
    {
        presetName = string.Empty;
        if (string.IsNullOrWhiteSpace(expectedType) || string.IsNullOrWhiteSpace(scriptValue))
        {
            return false;
        }

        if (!_presetNamesByTypeAndScript.TryGetValue(expectedType.Trim(), out var byScript))
        {
            return false;
        }

        return byScript.TryGetValue(scriptValue.Trim(), out presetName!);
    }

    private void LoadBaseTriggerData(string repositoryRoot, ICollection<string> sources)
    {
        var dataRoot = FindFirstExistingDirectory(
            Path.Combine(repositoryRoot, ".canon", "w3x2lni", "data"),
            Path.Combine(repositoryRoot, ".tools", "w3x2lni", "data"));
        if (dataRoot is null)
        {
            return;
        }

        foreach (var directoryName in new[] { "zhCN-1.24.4", "zhCN-1.32.8", "enUS-1.27.1" })
        {
            var directoryPath = Path.Combine(dataRoot, directoryName);
            if (!Directory.Exists(directoryPath))
            {
                continue;
            }

            var triggerDataPath = FindFirstExisting(
                Path.Combine(directoryPath, "UI", "TriggerData.txt"),
                Path.Combine(directoryPath, "ui", "TriggerData.txt"));
            var triggerStringsPath = FindFirstExisting(
                Path.Combine(directoryPath, "UI", "TriggerStrings.txt"),
                Path.Combine(directoryPath, "ui", "TriggerStrings.txt"));

            if (triggerDataPath is null || triggerStringsPath is null)
            {
                continue;
            }

            LoadLegacyTriggerData(File.ReadAllBytes(triggerDataPath), File.ReadAllBytes(triggerStringsPath), triggerDataPath, sources);
            break;
        }
    }

    private void LoadYdwePackages(string repositoryRoot, ICollection<string> sources)
    {
        var mpqRoot = FindFirstExistingDirectory(
            Path.Combine(repositoryRoot, ".canon", "YDWE", "share", "mpq"),
            Path.Combine(repositoryRoot, ".tools", "YDWE", "share", "mpq"));
        if (!Directory.Exists(mpqRoot))
        {
            return;
        }

        var configPath = Path.Combine(mpqRoot, "config");
        if (!File.Exists(configPath))
        {
            return;
        }

        foreach (var rawLine in TextFileCodec.Read(configPath).Text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n'))
        {
            var packageName = rawLine.Trim();
            if (string.IsNullOrWhiteSpace(packageName))
            {
                continue;
            }

            var packagePath = Path.Combine(mpqRoot, packageName);
            if (Directory.Exists(packagePath))
            {
                LoadExtensionPackage(packagePath, sources);
            }
        }
    }

    private void LoadMapLocalPackages(IReadOnlyDictionary<string, byte[]> archiveEntries, ICollection<string> sources)
    {
        if (archiveEntries.TryGetValue(@"ui\TriggerData.txt", out var triggerDataBytes) &&
            archiveEntries.TryGetValue(@"ui\TriggerStrings.txt", out var triggerStringsBytes))
        {
            LoadLegacyTriggerData(triggerDataBytes, triggerStringsBytes, "map:ui\\TriggerData.txt", sources);
        }

        if (!archiveEntries.TryGetValue(@"ui\config", out var configBytes))
        {
            return;
        }

        foreach (var rawLine in TextFileCodec.Decode(configBytes).Text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n'))
        {
            var packageName = rawLine.Trim();
            if (string.IsNullOrWhiteSpace(packageName))
            {
                continue;
            }

            LoadMapLocalExtensionPackage("ui\\" + packageName + "\\", archiveEntries, sources);
        }
    }

    private void LoadMapLocalExtensionPackage(
        string prefix,
        IReadOnlyDictionary<string, byte[]> archiveEntries,
        ICollection<string> sources)
    {
        var triggerDataKey = prefix + @"ui\TriggerData.txt";
        var triggerStringsKey = prefix + @"ui\TriggerStrings.txt";
        if (archiveEntries.TryGetValue(triggerDataKey, out var triggerDataBytes) &&
            archiveEntries.TryGetValue(triggerStringsKey, out var triggerStringsBytes))
        {
            LoadLegacyTriggerData(triggerDataBytes, triggerStringsBytes, $"map:{triggerDataKey}", sources);
        }

        foreach (var (kind, key) in new[]
                 {
                     (LegacyGuiFunctionKind.Action, prefix + "action.txt"),
                     (LegacyGuiFunctionKind.Call, prefix + "call.txt"),
                     (LegacyGuiFunctionKind.Condition, prefix + "condition.txt"),
                     (LegacyGuiFunctionKind.Event, prefix + "event.txt")
                 })
        {
            if (archiveEntries.TryGetValue(key, out var bytes))
            {
                LoadExtensionEntries(TextFileCodec.Decode(bytes).Text, kind, $"map:{key}", sources);
            }
        }
    }

    private void LoadExtensionPackage(string packagePath, ICollection<string> sources)
    {
        var triggerDataPath = FindFirstExisting(
            Path.Combine(packagePath, "ui", "TriggerData.txt"),
            Path.Combine(packagePath, "UI", "TriggerData.txt"));
        var triggerStringsPath = FindFirstExisting(
            Path.Combine(packagePath, "ui", "TriggerStrings.txt"),
            Path.Combine(packagePath, "UI", "TriggerStrings.txt"));

        if (triggerDataPath is not null && triggerStringsPath is not null)
        {
            LoadLegacyTriggerData(File.ReadAllBytes(triggerDataPath), File.ReadAllBytes(triggerStringsPath), triggerDataPath, sources);
        }

        foreach (var (kind, fileName) in new[]
                 {
                     (LegacyGuiFunctionKind.Action, "action.txt"),
                     (LegacyGuiFunctionKind.Call, "call.txt"),
                     (LegacyGuiFunctionKind.Condition, "condition.txt"),
                     (LegacyGuiFunctionKind.Event, "event.txt")
                 })
        {
            var filePath = Path.Combine(packagePath, fileName);
            if (File.Exists(filePath))
            {
                LoadExtensionEntries(TextFileCodec.Read(filePath).Text, kind, filePath, sources);
            }
        }
    }

    private void LoadLegacyTriggerData(byte[] triggerDataBytes, byte[] triggerStringBytes, string source, ICollection<string> sources)
    {
        var triggerData = SimpleIniDocument.Parse(TextFileCodec.Decode(triggerDataBytes).Text);
        var triggerStrings = SimpleIniDocument.Parse(TextFileCodec.Decode(triggerStringBytes).Text);

        LoadLegacyPresets(triggerData);
        LoadLegacySection(triggerData, triggerStrings, "TriggerEvents", "TriggerEventStrings", LegacyGuiFunctionKind.Event, source);
        LoadLegacySection(triggerData, triggerStrings, "TriggerConditions", "TriggerConditionStrings", LegacyGuiFunctionKind.Condition, source);
        LoadLegacySection(triggerData, triggerStrings, "TriggerActions", "TriggerActionStrings", LegacyGuiFunctionKind.Action, source);
        LoadLegacySection(triggerData, triggerStrings, "TriggerCalls", "TriggerCallStrings", LegacyGuiFunctionKind.Call, source);
        sources.Add(source);
    }

    private void LoadLegacyPresets(SimpleIniDocument triggerData)
    {
        var section = triggerData.GetSection("TriggerParams");
        if (section is null)
        {
            return;
        }

        foreach (var entry in section)
        {
            if (entry.Key.StartsWith('_'))
            {
                continue;
            }

            var parts = SplitCsv(entry.Value);
            if (parts.Count < 3)
            {
                continue;
            }

            var type = NormalizeOptionalValue(parts[1]);
            var scriptValue = NormalizeOptionalValue(parts[2]);
            if (string.IsNullOrWhiteSpace(type) || string.IsNullOrWhiteSpace(scriptValue))
            {
                continue;
            }

            if (!_presetNamesByTypeAndScript.TryGetValue(type, out var byScript))
            {
                byScript = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                _presetNamesByTypeAndScript[type] = byScript;
            }

            byScript[scriptValue] = entry.Key;
        }
    }

    private void LoadLegacySection(
        SimpleIniDocument triggerData,
        SimpleIniDocument triggerStrings,
        string dataSectionName,
        string stringSectionName,
        LegacyGuiFunctionKind kind,
        string source)
    {
        var dataSection = triggerData.GetSection(dataSectionName);
        if (dataSection is null)
        {
            return;
        }

        var stringSection = triggerStrings.GetSection(stringSectionName);
        var defaults = dataSection
            .Where(entry => entry.Key.StartsWith('_') && entry.Key.EndsWith("_Defaults", StringComparison.OrdinalIgnoreCase))
            .ToDictionary(entry => entry.Key[1..^"_Defaults".Length], entry => SplitCsv(entry.Value), StringComparer.OrdinalIgnoreCase);
        var categories = dataSection
            .Where(entry => entry.Key.StartsWith('_') && entry.Key.EndsWith("_Category", StringComparison.OrdinalIgnoreCase))
            .ToDictionary(entry => entry.Key[1..^"_Category".Length], entry => entry.Value.Trim(), StringComparer.OrdinalIgnoreCase);
        var scriptNames = dataSection
            .Where(entry => entry.Key.StartsWith('_') && entry.Key.EndsWith("_ScriptName", StringComparison.OrdinalIgnoreCase))
            .ToDictionary(entry => entry.Key[1..^"_ScriptName".Length], entry => entry.Value.Trim(), StringComparer.OrdinalIgnoreCase);

        foreach (var entry in dataSection)
        {
            if (entry.Key.StartsWith('_'))
            {
                continue;
            }

            var parts = SplitCsv(entry.Value);
            var argStart = kind == LegacyGuiFunctionKind.Call ? 3 : 1;
            var arguments = new List<GuiMetadataArgumentDefinition>();
            var defaultValues = defaults.TryGetValue(entry.Key, out var defaultsForEntry) ? defaultsForEntry : [];
            for (var index = argStart; index < parts.Count; index++)
            {
                var defaultValue = index - argStart < defaultValues.Count ? defaultValues[index - argStart] : null;
                arguments.Add(new GuiMetadataArgumentDefinition(parts[index], NormalizeOptionalValue(defaultValue)));
            }

            string? title = null;
            string? description = null;
            if (stringSection is not null && stringSection.TryGetValue(entry.Key, out var titleValue))
            {
                title = ExtractLegacyStringTitle(titleValue);
                description = ExtractLegacyStringDescription(titleValue);
            }

            AddEntry(new GuiMetadataEntry(
                kind,
                entry.Key,
                scriptNames.TryGetValue(entry.Key, out var scriptName) ? NormalizeOptionalValue(scriptName) : null,
                title,
                description,
                categories.TryGetValue(entry.Key, out var category) ? NormalizeOptionalValue(category) : null,
                arguments,
                source));
        }
    }

    private void LoadExtensionEntries(string text, LegacyGuiFunctionKind kind, string source, ICollection<string> sources)
    {
        var currentEntryName = string.Empty;
        Dictionary<string, string>? currentValues = null;
        List<Dictionary<string, string>>? currentArguments = null;
        Dictionary<string, string>? currentArgument = null;

        void Flush()
        {
            if (string.IsNullOrWhiteSpace(currentEntryName) || currentValues is null)
            {
                return;
            }

            var arguments = new List<GuiMetadataArgumentDefinition>();
            if (currentArguments is not null)
            {
                foreach (var arg in currentArguments)
                {
                    if (!arg.TryGetValue("type", out var type))
                    {
                        continue;
                    }

                    arguments.Add(new GuiMetadataArgumentDefinition(
                        NormalizeOptionalValue(type) ?? "nothing",
                        arg.TryGetValue("default", out var defaultValue) ? NormalizeOptionalValue(defaultValue) : null));
                }
            }

            AddEntry(new GuiMetadataEntry(
                kind,
                currentEntryName,
                currentValues.TryGetValue("script_name", out var scriptName) ? NormalizeOptionalValue(scriptName) : null,
                currentValues.TryGetValue("title", out var title) ? NormalizeOptionalValue(title) : null,
                currentValues.TryGetValue("description", out var description) ? NormalizeOptionalValue(description) : null,
                currentValues.TryGetValue("category", out var category) ? NormalizeOptionalValue(category) : null,
                arguments,
                source));
        }

        foreach (var rawLine in text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n'))
        {
            var line = rawLine.Trim();
            if (string.IsNullOrWhiteSpace(line) || line.StartsWith("//", StringComparison.Ordinal))
            {
                continue;
            }

            if (line.StartsWith("[[.args]]", StringComparison.Ordinal))
            {
                currentArguments ??= [];
                currentArgument = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                currentArguments.Add(currentArgument);
                continue;
            }

            if (line.StartsWith('[') && line.EndsWith(']'))
            {
                Flush();
                currentEntryName = NormalizeExtensionEntryName(line[1..^1]);
                currentValues = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                currentArguments = [];
                currentArgument = null;
                continue;
            }

            var separatorIndex = line.IndexOf('=');
            if (separatorIndex <= 0)
            {
                continue;
            }

            var key = line[..separatorIndex].Trim();
            var value = line[(separatorIndex + 1)..].Trim();
            if (currentArgument is not null)
            {
                currentArgument[key] = value;
            }
            else
            {
                currentValues ??= new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                currentValues[key] = value;
            }
        }

        Flush();
        sources.Add(source);
    }

    private static string NormalizeExtensionEntryName(string rawValue)
    {
        var normalized = NormalizeOptionalValue(rawValue);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return rawValue.Trim();
        }

        return normalized;
    }

    private void AddEntry(GuiMetadataEntry entry)
    {
        _entriesByName[(entry.Kind, entry.Name)] = entry;
        AddNormalizedNameAlias(_entriesByName, entry);
        if (!string.IsNullOrWhiteSpace(entry.ScriptName))
        {
            _entriesByScriptName[(entry.Kind, entry.ScriptName!)] = entry;
            AddNormalizedScriptAlias(_entriesByScriptName, entry);
        }

        if (IsBaseCompatibleSource(entry.Source))
        {
            _baseCompatibleEntriesByName[(entry.Kind, entry.Name)] = entry;
            AddNormalizedNameAlias(_baseCompatibleEntriesByName, entry);
            if (!string.IsNullOrWhiteSpace(entry.ScriptName))
            {
                _baseCompatibleEntriesByScriptName[(entry.Kind, entry.ScriptName!)] = entry;
                AddNormalizedScriptAlias(_baseCompatibleEntriesByScriptName, entry);
            }
        }
    }

    private static void AddNormalizedNameAlias(
        IDictionary<(LegacyGuiFunctionKind Kind, string Name), GuiMetadataEntry> entries,
        GuiMetadataEntry entry)
    {
        var normalizedName = NormalizeLookupName(entry.Name);
        if (string.IsNullOrWhiteSpace(normalizedName) ||
            string.Equals(normalizedName, entry.Name, StringComparison.Ordinal))
        {
            return;
        }

        entries[(entry.Kind, normalizedName)] = entry;
    }

    private static void AddNormalizedScriptAlias(
        IDictionary<(LegacyGuiFunctionKind Kind, string Name), GuiMetadataEntry> entries,
        GuiMetadataEntry entry)
    {
        if (string.IsNullOrWhiteSpace(entry.ScriptName))
        {
            return;
        }

        var normalizedScriptName = NormalizeLookupName(entry.ScriptName);
        if (string.IsNullOrWhiteSpace(normalizedScriptName) ||
            string.Equals(normalizedScriptName, entry.ScriptName, StringComparison.Ordinal))
        {
            return;
        }

        entries[(entry.Kind, normalizedScriptName)] = entry;
    }

    private static string NormalizeLookupName(string? rawValue)
    {
        if (string.IsNullOrWhiteSpace(rawValue))
        {
            return string.Empty;
        }

        return rawValue.Trim();
    }

    private static bool IsBaseCompatibleSource(string source)
    {
        return (source.Contains(@"\.canon\w3x2lni\data\", StringComparison.OrdinalIgnoreCase) ||
                source.Contains(@"\.tools\w3x2lni\data\", StringComparison.OrdinalIgnoreCase)) &&
               source.EndsWith(@"TriggerData.txt", StringComparison.OrdinalIgnoreCase);
    }

    private static bool IsMapLocalSource(string source)
    {
        return source.StartsWith("map:", StringComparison.OrdinalIgnoreCase);
    }

    private static string? FindFirstExisting(params string[] candidatePaths)
    {
        foreach (var path in candidatePaths)
        {
            if (File.Exists(path))
            {
                return path;
            }
        }

        return null;
    }

    private static string? FindFirstExistingDirectory(params string[] candidatePaths)
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

    private static List<string> SplitCsv(string rawValue)
    {
        var result = new List<string>();
        var builder = new StringBuilder();
        var quote = false;

        for (var index = 0; index < rawValue.Length; index++)
        {
            var current = rawValue[index];
            if (current == '"')
            {
                quote = !quote;
                builder.Append(current);
                continue;
            }

            if (current == ',' && !quote)
            {
                result.Add(builder.ToString().Trim());
                builder.Clear();
                continue;
            }

            builder.Append(current);
        }

        result.Add(builder.ToString().Trim());
        return result;
    }

    private static string? NormalizeOptionalValue(string? rawValue)
    {
        if (string.IsNullOrWhiteSpace(rawValue))
        {
            return null;
        }

        var value = rawValue.Trim();
        if (value == "_" || string.Equals(value, "none", StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        if (value.Length >= 2 && value[0] == '"' && value[^1] == '"')
        {
            return LiteralValueParser.ParseQuotedString(value);
        }

        return value;
    }

    private static string? ExtractLegacyStringTitle(string rawValue)
    {
        var parts = SplitCsv(rawValue);
        return parts.Count == 0 ? null : NormalizeOptionalValue(parts[0]);
    }

    private static string? ExtractLegacyStringDescription(string rawValue)
    {
        var parts = SplitCsv(rawValue);
        if (parts.Count == 0)
        {
            return null;
        }

        var fragments = new List<string>(parts.Count);
        foreach (var part in parts)
        {
            var trimmed = part.Trim();
            if (trimmed.StartsWith('~'))
            {
                fragments.Add("${" + trimmed[1..] + "}");
            }
            else if (NormalizeOptionalValue(trimmed) is { } text)
            {
                fragments.Add(text);
            }
        }

        return fragments.Count == 0 ? null : string.Concat(fragments);
    }
}
