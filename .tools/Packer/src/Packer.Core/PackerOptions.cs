using System.IO;

namespace Packer.Core;

public sealed record PackerOptions(
    string ProjectRootPath,
    string War3RootPath,
    string UnitTypeFolderPath,
    string MapperFilePath,
    string ExcelFilePath,
    string BackupRootDirectoryPath,
    string AssetSourceRootPath = "",
    string VirtualMpqRootPath = "",
    bool FormalPackEnabled = false)
{
    public string MapOutputPath => ResolveMapOutputPath(War3RootPath);

    public string UnitIniPath => Path.Combine(ResolveWar3RootPath(War3RootPath), "table", "unit.ini");

    public string NormalizedAssetSourceRootPath => ResolveOptionalRootPath(AssetSourceRootPath);

    public string NormalizedVirtualMpqRootPath => ResolveOptionalRootPath(VirtualMpqRootPath);

    public bool AssetSyncEnabled => !string.IsNullOrWhiteSpace(NormalizedAssetSourceRootPath);

    public string AssetOutputPath => FormalPackEnabled ? MapOutputPath : NormalizedVirtualMpqRootPath;

    private static string ResolveMapOutputPath(string war3RootPath)
    {
        var normalized = ResolveWar3RootPath(war3RootPath);

        if (string.IsNullOrWhiteSpace(normalized))
        {
            return string.Empty;
        }

        return Path.GetFileName(normalized).Equals("map", StringComparison.OrdinalIgnoreCase)
            ? normalized
            : Path.Combine(normalized, "map");
    }

    private static string ResolveWar3RootPath(string war3RootPath)
    {
        var normalized = ResolveOptionalRootPath(war3RootPath);

        return Path.GetFileName(normalized).Equals("map", StringComparison.OrdinalIgnoreCase)
            ? (Path.GetDirectoryName(normalized) ?? normalized)
            : normalized;
    }

    private static string ResolveOptionalRootPath(string? path)
    {
        var normalized = (path ?? string.Empty)
            .Trim()
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

        return string.IsNullOrWhiteSpace(normalized)
            ? string.Empty
            : normalized;
    }
}
