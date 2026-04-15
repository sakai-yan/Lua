namespace Packer.Core;

public sealed class InspectResult
{
    public required string ProjectRootPath { get; init; }

    public required string MapOutputPath { get; init; }

    public required string AssetOutputPath { get; init; }

    public required string UnitIniPath { get; init; }

    public required string SelectedWorksheet { get; init; }

    public required int SourceFileCount { get; init; }

    public required int UnitTypeLuaFileCount { get; init; }

    public required int RecognizedUnitCount { get; init; }

    public required int ReferencedAssetCount { get; init; }

    public required int ResolvedAssetCount { get; init; }

    public required int ModelTextureDependencyCount { get; init; }

    public required IReadOnlyList<PackageError> Errors { get; init; }

    public required IReadOnlyList<string> Logs { get; init; }

    public bool IsValid => Errors.Count == 0;
}
