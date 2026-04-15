namespace MapRepair.Core.Internal;

internal sealed record WarcraftArchivePaths(
    string RootPath,
    IReadOnlyList<string> ArchivePaths);

internal static class WarcraftArchiveLocator
{
    public static WarcraftArchivePaths Locate()
    {
        foreach (var candidate in EnumerateCandidateRoots())
        {
            var archives = new[]
            {
                Path.Combine(candidate, "War3Patch.mpq"),
                Path.Combine(candidate, "War3x.mpq"),
                Path.Combine(candidate, "war3.mpq"),
                Path.Combine(candidate, "War3xLocal.mpq")
            }
            .Where(File.Exists)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();

            if (archives.Length > 0)
            {
                return new WarcraftArchivePaths(candidate, archives);
            }
        }

        throw new DirectoryNotFoundException("无法定位 Warcraft MPQ 数据目录，预期至少存在 `War3Patch.mpq`、`War3x.mpq` 或 `war3.mpq`。");
    }

    private static IEnumerable<string> EnumerateCandidateRoots()
    {
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var directCandidates = new[]
        {
            @"D:\Game\Warcraft.III.v1.20e-v1.27a.CHS.Green.Edition",
            @"D:\Game\Warcraft.III",
            @"D:\Game\魔兽"
        };

        foreach (var candidate in directCandidates)
        {
            if (Directory.Exists(candidate) && seen.Add(Path.GetFullPath(candidate)))
            {
                yield return Path.GetFullPath(candidate);
            }
        }

        foreach (var drive in DriveInfo.GetDrives().Where(drive => drive.DriveType == DriveType.Fixed && drive.IsReady))
        {
            foreach (var firstLevel in EnumerateDirectoriesSafe(drive.RootDirectory.FullName))
            {
                var firstLevelName = Path.GetFileName(firstLevel);
                if (LooksLikeWarcraftRoot(firstLevelName) && seen.Add(firstLevel))
                {
                    yield return firstLevel;
                }

                foreach (var secondLevel in EnumerateDirectoriesSafe(firstLevel))
                {
                    var secondLevelName = Path.GetFileName(secondLevel);
                    if (LooksLikeWarcraftRoot(secondLevelName) && seen.Add(secondLevel))
                    {
                        yield return secondLevel;
                    }
                }
            }
        }
    }

    private static IEnumerable<string> EnumerateDirectoriesSafe(string rootPath)
    {
        try
        {
            return Directory.EnumerateDirectories(rootPath);
        }
        catch
        {
            return Array.Empty<string>();
        }
    }

    private static bool LooksLikeWarcraftRoot(string directoryName) =>
        directoryName.Contains("Warcraft", StringComparison.OrdinalIgnoreCase) ||
        directoryName.Contains("Frozen Throne", StringComparison.OrdinalIgnoreCase) ||
        directoryName.Contains("魔兽", StringComparison.OrdinalIgnoreCase);
}
