namespace MapRepair.Core;

public sealed record RepairResult(
    string OutputMapPath,
    MapRepairFallbackLevel FallbackLevel,
    IReadOnlyList<string> PreservedFiles,
    IReadOnlyList<string> GeneratedFiles,
    IReadOnlyList<string> OmittedFiles,
    IReadOnlyList<string> Warnings,
    string JsonReportPath,
    string MarkdownReportPath);
