namespace MapRepair.Core;

public sealed record InspectResult(
    string InputMapPath,
    bool ArchiveReadable,
    IReadOnlyList<string> PreservedFiles,
    IReadOnlyList<string> MissingFiles,
    IReadOnlyList<string> UnreadableFiles,
    IReadOnlyList<string> RecoverableFiles,
    IReadOnlyList<string> Warnings);
