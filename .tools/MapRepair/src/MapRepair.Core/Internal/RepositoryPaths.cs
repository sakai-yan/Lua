namespace MapRepair.Core.Internal;

internal sealed record RepositoryPaths(
    string RootPath,
    string W3iIniPath,
    string TemplateTerrainPath,
    string TemplatePathingPath,
    string TemplateDoodadsPath,
    string TemplateUnitsPath,
    string TemplateTriggerDataPath,
    string TemplateTriggerStringsPath,
    string TemplateShadowPath);

internal static class RepositoryLocator
{
    public static RepositoryPaths Locate()
    {
        foreach (var root in EnumerateCandidateRoots())
        {
            var w3iIniPath = Path.Combine(root, "War3", "table", "w3i.ini");
            var terrainPath = Path.Combine(root, "War3", "map", "war3map.w3e");
            var pathingPath = Path.Combine(root, "War3", "map", "war3map.wpm");
            var doodadsPath = Path.Combine(root, "War3", "map", "war3map.doo");
            var unitsPath = Path.Combine(root, "War3", "map", "war3mapUnits.doo");
            var triggerDataPath = Path.Combine(root, "War3", "map", "war3map.wtg");
            var triggerStringsPath = Path.Combine(root, "War3", "map", "war3map.wct");
            var shadowPath = Path.Combine(root, "War3", "map", "war3map.shd");

            if (File.Exists(w3iIniPath) &&
                File.Exists(terrainPath) &&
                File.Exists(pathingPath) &&
                File.Exists(doodadsPath) &&
                File.Exists(unitsPath) &&
                File.Exists(triggerDataPath) &&
                File.Exists(triggerStringsPath) &&
                File.Exists(shadowPath))
            {
                return new RepositoryPaths(
                    root,
                    w3iIniPath,
                    terrainPath,
                    pathingPath,
                    doodadsPath,
                    unitsPath,
                    triggerDataPath,
                    triggerStringsPath,
                    shadowPath);
            }
        }

        throw new DirectoryNotFoundException("无法定位仓库模板目录，预期存在 War3/table/w3i.ini 与 War3/map/war3map.* 模板文件。");
    }

    private static IEnumerable<string> EnumerateCandidateRoots()
    {
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var seed in new[]
                 {
                     Directory.GetCurrentDirectory(),
                     AppContext.BaseDirectory
                 })
        {
            var current = Path.GetFullPath(seed);
            while (!string.IsNullOrWhiteSpace(current))
            {
                if (seen.Add(current))
                {
                    yield return current;
                }

                var parent = Path.GetDirectoryName(current);
                if (string.IsNullOrWhiteSpace(parent) || string.Equals(parent, current, StringComparison.OrdinalIgnoreCase))
                {
                    break;
                }

                current = parent;
            }
        }
    }
}
