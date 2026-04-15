using System.Text;
using MapRepair.Core.Internal.Slk;

namespace MapRepair.Core.Internal;

internal static class ReferencedAssetCollector
{
    private const int ObjectDataPriority = 0;
    private const int ScriptPriority = 1;
    private const int ProfileTextPriority = 2;
    private const int SlkPriority = 3;
    private const int ModelTexturePriority = 4;

    private static readonly string[] ReferenceSourceEntryNames =
    [
        @"Units\CampaignAbilityStrings.txt",
        @"Units\CampaignUnitFunc.txt",
        @"Units\ItemFunc.txt",
        @"units\neutralupgradestrings.txt",
        @"units\abilitybuffdata.slk",
        @"Units\AbilityData.slk",
        @"Units\ItemData.slk",
        @"Units\UnitAbilities.slk",
        @"Units\UnitBalance.slk",
        @"units\unitdata.slk",
        @"Units\unitUI.slk",
        @"units\unitweapons.slk",
        @"units\upgradedata.slk"
    ];

    private static readonly string[] ProfileTextEntryNames =
    [
        @"Units\CampaignAbilityStrings.txt",
        @"Units\CampaignUnitFunc.txt",
        @"Units\ItemFunc.txt",
        @"units\neutralupgradestrings.txt"
    ];

    private static readonly string[] SlkEntryNames =
    [
        @"units\abilitybuffdata.slk",
        @"Units\AbilityData.slk",
        @"Units\ItemData.slk",
        @"Units\UnitAbilities.slk",
        @"Units\UnitBalance.slk",
        @"units\unitdata.slk",
        @"Units\unitUI.slk",
        @"units\unitweapons.slk",
        @"units\upgradedata.slk"
    ];

    private static readonly string[] ScriptEntryNames =
    [
        "war3map.j",
        "war3map.lua"
    ];

    private static readonly string[] ObjectDataEntryNames =
    [
        "war3map.w3u",
        "war3map.w3t",
        "war3map.w3a",
        "war3map.w3b",
        "war3map.w3d",
        "war3map.w3h",
        "war3map.w3q"
    ];

    public static IReadOnlyList<string> GetReferenceSourceEntryNames() =>
        ReferenceSourceEntryNames;

    public static IReadOnlyList<string> GetSlkEntryNames() =>
        SlkEntryNames;

    public static IReadOnlyList<string> Collect(IReadOnlyDictionary<string, byte[]> mapEntries)
    {
        var referencedAssets = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

        CollectObjectDataAssets(mapEntries, referencedAssets);
        CollectScriptAssets(mapEntries, referencedAssets);
        CollectProfileTextAssets(mapEntries, referencedAssets);
        CollectSlkAssets(mapEntries, referencedAssets);
        CollectModelTextureAssets(mapEntries, referencedAssets);

        return referencedAssets
            .OrderBy(entry => entry.Value)
            .ThenBy(entry => entry.Key, StringComparer.OrdinalIgnoreCase)
            .Select(entry => entry.Key)
            .ToArray();
    }

    private static void CollectProfileTextAssets(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IDictionary<string, int> referencedAssets)
    {
        var profileEntries = mapEntries
            .Where(entry => ProfileTextEntryNames.Contains(entry.Key, StringComparer.OrdinalIgnoreCase))
            .ToDictionary(entry => entry.Key, entry => entry.Value, StringComparer.OrdinalIgnoreCase);
        if (profileEntries.Count == 0)
        {
            return;
        }

        var overlay = ArchiveProfileTextOverlay.BuildRaw(profileEntries);
        foreach (var section in overlay.Values)
        {
            foreach (var value in section.Values)
            {
                AddAssetCandidates(value, referencedAssets, ProfileTextPriority);
            }
        }
    }

    private static void CollectSlkAssets(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IDictionary<string, int> referencedAssets)
    {
        foreach (var entryName in SlkEntryNames)
        {
            if (!mapEntries.TryGetValue(entryName, out var data))
            {
                continue;
            }

            var table = SlkTableParser.Parse(Path.GetFileName(entryName), data);
            foreach (var row in table.Rows.Values)
            {
                foreach (var value in row.Values.Values)
                {
                    AddAssetCandidates(value, referencedAssets, SlkPriority);
                }
            }
        }
    }

    private static void CollectScriptAssets(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IDictionary<string, int> referencedAssets)
    {
        foreach (var entryName in ScriptEntryNames)
        {
            if (!mapEntries.TryGetValue(entryName, out var data))
            {
                continue;
            }

            var scriptText = Encoding.UTF8.GetString(data);
            foreach (var literal in ExtractQuotedStrings(scriptText))
            {
                AddAssetCandidates(literal, referencedAssets, ScriptPriority);
            }
        }
    }

    private static void CollectObjectDataAssets(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IDictionary<string, int> referencedAssets)
    {
        foreach (var entryName in ObjectDataEntryNames)
        {
            if (!mapEntries.TryGetValue(entryName, out var data))
            {
                continue;
            }

            foreach (var value in ObjectDataAssetCollector.CollectStringValues(entryName, data))
            {
                AddAssetCandidates(value, referencedAssets, ObjectDataPriority);
            }
        }
    }

    private static void CollectModelTextureAssets(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        IDictionary<string, int> referencedAssets)
    {
        foreach (var entry in mapEntries)
        {
            if (!ModelTextureDependencyCollector.LooksLikeModelFile(entry.Key))
            {
                continue;
            }

            foreach (var value in ModelTextureDependencyCollector.CollectTexturePaths(entry.Key, entry.Value))
            {
                AddAssetCandidates(value, referencedAssets, ModelTexturePriority);
            }
        }
    }

    private static void AddAssetCandidates(string rawValue, IDictionary<string, int> referencedAssets, int priority)
    {
        foreach (var candidate in SplitAssetCandidates(rawValue))
        {
            if (!LooksLikeReferencedPath(candidate))
            {
                continue;
            }

            if (!referencedAssets.TryGetValue(candidate, out var currentPriority) ||
                priority < currentPriority)
            {
                referencedAssets[candidate] = priority;
            }
        }
    }

    private static IEnumerable<string> ExtractQuotedStrings(string text)
    {
        if (string.IsNullOrEmpty(text))
        {
            yield break;
        }

        var buffer = new StringBuilder();
        var inString = false;

        foreach (var ch in text)
        {
            if (!inString)
            {
                if (ch == '"')
                {
                    inString = true;
                    buffer.Clear();
                }

                continue;
            }

            if (ch == '"')
            {
                if (buffer.Length > 0)
                {
                    yield return buffer.ToString();
                }

                buffer.Clear();
                inString = false;
                continue;
            }

            buffer.Append(ch);
        }
    }

    private static IEnumerable<string> SplitAssetCandidates(string rawValue)
    {
        var normalized = NormalizeValue(rawValue);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return [];
        }

        return normalized
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Select(NormalizeValue)
            .Where(value => !string.IsNullOrWhiteSpace(value));
    }

    private static bool LooksLikeReferencedPath(string value)
    {
        if (string.IsNullOrWhiteSpace(value) ||
            value.StartsWith("TRIGSTR_", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        var extension = Path.GetExtension(value);
        if (string.IsNullOrWhiteSpace(extension) ||
            extension.Length < 3 ||
            extension.Length > 9)
        {
            return false;
        }

        return extension[1..].All(char.IsLetterOrDigit);
    }

    private static string NormalizeValue(string rawValue)
    {
        var trimmed = (rawValue ?? string.Empty)
            .Trim()
            .Trim('"')
            .Replace('/', '\\')
            .TrimStart('\\');

        if (trimmed.Length >= 2 &&
            trimmed[0] == '"' &&
            trimmed[^1] == '"')
        {
            trimmed = trimmed[1..^1];
        }

        return trimmed.Trim();
    }
}
