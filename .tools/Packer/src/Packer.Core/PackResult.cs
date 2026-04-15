namespace Packer.Core;

public sealed record PackSummary(
    int ScannedFileCount,
    int CopiedFileCount,
    int ProjectCopiedFileCount,
    int AssetCopiedFileCount,
    int TransformedFileCount,
    int RecognizedUnitCount,
    int SuccessfulUnitCount,
    int SkippedUnitCount,
    int ReferencedAssetCount,
    int ResolvedAssetCount,
    int ModelTextureDependencyCount,
    int ErrorCount);

public sealed class PackResult
{
    public required PackSummary Summary { get; init; }

    public required string SelectedWorksheet { get; init; }

    public required string ProjectRootPath { get; init; }

    public required string MapOutputPath { get; init; }

    public required string AssetOutputPath { get; init; }

    public required string BackupRootDirectoryPath { get; init; }

    public required string BackupRunDirectoryPath { get; init; }

    public required string ErrorReportPath { get; init; }

    public required string ManifestPath { get; init; }

    public required string IniFilePath { get; init; }

    public required IReadOnlyList<string> BackupFilePaths { get; init; }

    public required IReadOnlyList<string> ProjectCopiedFilePaths { get; init; }

    public required IReadOnlyList<string> AssetCopiedFilePaths { get; init; }

    public required IReadOnlyList<string> CopiedFilePaths { get; init; }

    public required IReadOnlyList<string> TransformedFilePaths { get; init; }

    public required IReadOnlyList<PackageError> Errors { get; init; }

    public required IReadOnlyList<string> Logs { get; init; }

    public bool HasSuccessfulUnits => Summary.SuccessfulUnitCount > 0;
}
