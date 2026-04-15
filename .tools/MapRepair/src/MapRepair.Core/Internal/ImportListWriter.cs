using System.Text;

namespace MapRepair.Core.Internal;

internal static class ImportListWriter
{
    private const int FileVersion = 1;

    public static byte[] Write(IEnumerable<War3ImportEntry> importedEntries)
    {
        var orderedEntries = importedEntries
            .Where(entry => !string.IsNullOrWhiteSpace(entry.ArchivePath))
            .GroupBy(entry => entry.ArchivePath, StringComparer.OrdinalIgnoreCase)
            .Select(group => group.First())
            .ToArray();

        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(FileVersion);
        writer.Write(orderedEntries.Length);

        foreach (var entry in orderedEntries)
        {
            writer.Write(entry.Flag);
            writer.Write(Encoding.UTF8.GetBytes(entry.NormalizedStoredPath));
            writer.Write((byte)0);
        }

        return stream.ToArray();
    }

    public static byte[] Write(IEnumerable<string> importedPaths)
    {
        return Write(importedPaths.Select(path => War3ImportEntry.CreateForArchivePath(path)));
    }

    public static IReadOnlyList<War3ImportEntry> CollectImportEntries(
        IEnumerable<string> archiveEntries,
        IReadOnlyList<War3ImportEntry>? preferredEntries = null)
    {
        var normalizedArchivePaths = archiveEntries
            .Select(path => path.Replace('/', '\\'))
            .Where(IsImportablePath)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        var normalizedArchivePathSet = new HashSet<string>(normalizedArchivePaths, StringComparer.OrdinalIgnoreCase);
        var seenArchivePaths = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var orderedEntries = new List<War3ImportEntry>();

        if (preferredEntries is not null)
        {
            foreach (var preferredEntry in preferredEntries)
            {
                var archivePath = preferredEntry.ArchivePath;
                if (string.IsNullOrWhiteSpace(archivePath) ||
                    !normalizedArchivePathSet.Contains(archivePath) ||
                    !seenArchivePaths.Add(archivePath))
                {
                    continue;
                }

                orderedEntries.Add(preferredEntry);
            }
        }

        foreach (var archivePath in normalizedArchivePaths)
        {
            if (!seenArchivePaths.Add(archivePath))
            {
                continue;
            }

            orderedEntries.Add(War3ImportEntry.CreateForArchivePath(archivePath));
        }

        return orderedEntries;
    }

    public static IReadOnlyList<string> CollectImportablePaths(IEnumerable<string> archiveEntries)
    {
        return CollectImportEntries(archiveEntries)
            .Select(entry => entry.ArchivePath)
            .ToArray();
    }

    private static bool IsImportablePath(string path)
    {
        var normalized = path.Replace('/', '\\');
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return false;
        }

        if (normalized.StartsWith("(", StringComparison.Ordinal) ||
            normalized.StartsWith("war3map.", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        return true;
    }
}
