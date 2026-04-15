using MapRepair.Core.Internal.Slk;

namespace MapRepair.Core.Internal;

internal sealed class ObjectMetadataLoader
{
    private readonly GameArchiveSource _archiveSource;

    public ObjectMetadataLoader(GameArchiveSource archiveSource)
    {
        _archiveSource = archiveSource;
    }

    public IReadOnlyList<ObjectMetadataEntry> LoadUnitMetadata() =>
        LoadFromArchive("Units\\UnitMetaData.slk");

    public IReadOnlyList<ObjectMetadataEntry> LoadAbilityBuffMetadata() =>
        LoadFromArchive("Units\\AbilityBuffMetaData.slk");

    public IReadOnlyList<ObjectMetadataEntry> LoadUpgradeMetadata() =>
        LoadFromArchive("Units\\UpgradeMetaData.slk");

    public IReadOnlyList<ObjectMetadataEntry> LoadAbilityMetadata() =>
        LoadFromArchive("Units\\AbilityMetaData.slk");

    private IReadOnlyList<ObjectMetadataEntry> LoadFromArchive(string archivePath)
    {
        var data = _archiveSource.TryRead(archivePath)
            ?? throw new FileNotFoundException($"无法从 Warcraft 数据包中读取 `{archivePath}`。");
        var table = SlkTableParser.Parse(Path.GetFileName(archivePath), data);

        return table.Rows.Values
            .Select(row => BuildEntry(row.Values))
            .Where(entry => !string.IsNullOrWhiteSpace(entry.RawCode))
            .ToArray();
    }

    private static ObjectMetadataEntry BuildEntry(IReadOnlyDictionary<string, string> row)
    {
        var rawCode = Get(row, "ID");
        var field = Get(row, "field");
        var slkTable = NormalizeSlkTableName(Get(row, "slk"));
        var index = ParseInt(Get(row, "index"), defaultValue: -1);
        var type = Get(row, "type");
        var specificTargets = row.TryGetValue("useSpecific", out var specific) ? specific : null;

        return new ObjectMetadataEntry(
            rawCode,
            field,
            slkTable,
            index,
            ParseInt(Get(row, "data"), defaultValue: 0),
            ParseInt(Get(row, "repeat"), defaultValue: 0),
            type,
            Get(row, "section"),
            ParseBool(Get(row, "useUnit")),
            ParseBool(Get(row, "useHero")),
            ParseBool(Get(row, "useBuilding")),
            ParseBool(Get(row, "useItem")),
            !string.IsNullOrWhiteSpace(specificTargets),
            specificTargets);
    }

    public static string NormalizeSlkTableName(string value) =>
        value.Replace(".slk", string.Empty, StringComparison.OrdinalIgnoreCase).Trim();

    private static string Get(IReadOnlyDictionary<string, string> row, string key) =>
        row.TryGetValue(key, out var value) ? value : string.Empty;

    private static int ParseInt(string rawValue, int defaultValue)
    {
        return int.TryParse(rawValue, out var value) ? value : defaultValue;
    }

    private static bool ParseBool(string rawValue)
    {
        if (string.IsNullOrWhiteSpace(rawValue))
        {
            return false;
        }

        return rawValue.Equals("1", StringComparison.OrdinalIgnoreCase) ||
               rawValue.Equals("TRUE", StringComparison.OrdinalIgnoreCase);
    }
}
