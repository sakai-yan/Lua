namespace Packer.Core.Internal;

internal sealed record ProjectSourceFile(
    string SourcePath,
    string RelativeTargetPath,
    bool IsUnitTypeLuaFile);

internal sealed class ProjectFileCollector
{
    public IReadOnlyList<ProjectSourceFile> Collect(
        string projectRootPath,
        string unitTypeFolderPath,
        string war3RootPath,
        string mapOutputPath,
        string backupRootPath,
        IEnumerable<string?>? additionalExcludedRoots = null)
    {
        var projectRoot = Normalize(projectRootPath);
        var unitTypeRoot = Normalize(unitTypeFolderPath);
        var selectedWar3Root = string.IsNullOrWhiteSpace(war3RootPath) ? null : Normalize(war3RootPath);
        var mapOutputRoot = Normalize(mapOutputPath);
        var backupRoot = Normalize(backupRootPath);
        var excludedRoots = (additionalExcludedRoots ?? Array.Empty<string?>())
            .Where(path => !string.IsNullOrWhiteSpace(path))
            .Select(path => Normalize(path!))
            .ToArray();
        var war3Root = selectedWar3Root is not null && IsSubPathOf(selectedWar3Root, projectRoot)
            ? selectedWar3Root
            : null;
        var war3MapRoot = war3Root is null ? null : Normalize(Path.Combine(war3Root, "map"));
        var files = new List<ProjectSourceFile>();

        foreach (var filePath in Directory.EnumerateFiles(projectRoot, "*", SearchOption.AllDirectories)
                     .OrderBy(path => path, StringComparer.OrdinalIgnoreCase))
        {
            var fullPath = Normalize(filePath);

            if (ShouldSkipPath(fullPath, projectRoot, mapOutputRoot, backupRoot, war3MapRoot, excludedRoots))
            {
                continue;
            }

            var relativeTargetPath = BuildRelativeTargetPath(fullPath, projectRoot, war3Root);

            if (string.Equals(relativeTargetPath, Path.Combine("Config", "UnitTypeInit.lua"), StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            var isUnitTypeLuaFile =
                IsSubPathOf(fullPath, unitTypeRoot) &&
                string.Equals(Path.GetExtension(fullPath), ".lua", StringComparison.OrdinalIgnoreCase);

            files.Add(new ProjectSourceFile(fullPath, relativeTargetPath, isUnitTypeLuaFile));
        }

        return files;
    }

    public static bool IsSubPathOf(string path, string rootPath)
    {
        var normalizedPath = Normalize(path);
        var normalizedRoot = Normalize(rootPath).TrimEnd(Path.DirectorySeparatorChar) + Path.DirectorySeparatorChar;

        return normalizedPath.StartsWith(normalizedRoot, StringComparison.OrdinalIgnoreCase) ||
               string.Equals(
                   normalizedPath.TrimEnd(Path.DirectorySeparatorChar),
                   normalizedRoot.TrimEnd(Path.DirectorySeparatorChar),
                   StringComparison.OrdinalIgnoreCase);
    }

    private static string BuildRelativeTargetPath(string fullPath, string projectRoot, string? war3Root)
    {
        if (!string.IsNullOrWhiteSpace(war3Root) && IsSubPathOf(fullPath, war3Root))
        {
            var relativeToWar3 = Path.GetRelativePath(war3Root, fullPath);

            if (!relativeToWar3.StartsWith("map", StringComparison.OrdinalIgnoreCase))
            {
                return relativeToWar3;
            }
        }

        return Path.GetRelativePath(projectRoot, fullPath);
    }

    private static bool ShouldSkipPath(
        string fullPath,
        string projectRoot,
        string mapOutputRoot,
        string backupRoot,
        string? war3MapRoot,
        IReadOnlyList<string> excludedRoots)
    {
        if (IsSubPathOf(fullPath, mapOutputRoot) || IsSubPathOf(fullPath, backupRoot))
        {
            return true;
        }

        if (!string.IsNullOrWhiteSpace(war3MapRoot) && IsSubPathOf(fullPath, war3MapRoot))
        {
            return true;
        }

        foreach (var excludedRoot in excludedRoots)
        {
            if (IsSubPathOf(fullPath, excludedRoot))
            {
                return true;
            }
        }

        var relativePath = Path.GetRelativePath(projectRoot, fullPath);
        var segments = relativePath.Split(
            [Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar],
            StringSplitOptions.RemoveEmptyEntries);

        return segments.Any(segment => segment.StartsWith(".", StringComparison.Ordinal));
    }

    private static string Normalize(string path) =>
        Path.GetFullPath(path)
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
}
