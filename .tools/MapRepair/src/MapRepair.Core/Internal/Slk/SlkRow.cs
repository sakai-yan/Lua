namespace MapRepair.Core.Internal.Slk;

internal sealed record SlkRow(
    string Id,
    IReadOnlyDictionary<string, string> Values);
