namespace MapRepair.Core.Internal.Slk;

internal sealed record SlkTable(
    string Name,
    string IdColumn,
    IReadOnlyDictionary<string, SlkRow> Rows);
