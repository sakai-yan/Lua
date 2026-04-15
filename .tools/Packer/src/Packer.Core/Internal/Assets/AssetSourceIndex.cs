using System.Collections.ObjectModel;

namespace Packer.Core.Internal.Assets;

internal sealed record IndexedAssetFile(
    string SourcePath,
    string SourceRootRelativePath,
    string Extension);

internal sealed class AssetSourceIndex
{
    private readonly IReadOnlyDictionary<string, IndexedAssetFile> _filesByRelativePath;

    private AssetSourceIndex(
        string rootPath,
        IReadOnlyDictionary<string, IndexedAssetFile> filesByRelativePath,
        IReadOnlySet<string> knownExtensions)
    {
        RootPath = rootPath;
        _filesByRelativePath = filesByRelativePath;
        KnownExtensions = knownExtensions;
    }

    public string RootPath { get; }

    public IReadOnlySet<string> KnownExtensions { get; }

    public int FileCount => _filesByRelativePath.Count;

    public static AssetSourceIndex Build(string assetSourceRootPath)
    {
        var normalizedRootPath = NormalizeAbsolutePath(assetSourceRootPath);
        var filesByRelativePath = new Dictionary<string, IndexedAssetFile>(StringComparer.OrdinalIgnoreCase);
        var knownExtensions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var filePath in Directory.EnumerateFiles(normalizedRootPath, "*", SearchOption.AllDirectories)
                     .OrderBy(path => path, StringComparer.OrdinalIgnoreCase))
        {
            var normalizedFilePath = NormalizeAbsolutePath(filePath);
            var relativePath = Path.GetRelativePath(normalizedRootPath, normalizedFilePath);

            if (ShouldSkipRelativePath(relativePath))
            {
                continue;
            }

            var normalizedRelativePath = NormalizeRelativePath(relativePath);
            var extension = Path.GetExtension(normalizedRelativePath);
            filesByRelativePath[ToDictionaryKey(normalizedRelativePath)] =
                new IndexedAssetFile(normalizedFilePath, normalizedRelativePath, extension);

            if (!string.IsNullOrWhiteSpace(extension))
            {
                knownExtensions.Add(extension);
            }
        }

        return new AssetSourceIndex(
            normalizedRootPath,
            new ReadOnlyDictionary<string, IndexedAssetFile>(filesByRelativePath),
            knownExtensions);
    }

    public bool TryResolve(string rawReference, string referenceSourcePath, out IndexedAssetFile assetFile)
    {
        assetFile = default!;
        var cleanedReference = CleanReference(rawReference);

        if (string.IsNullOrWhiteSpace(cleanedReference))
        {
            return false;
        }

        if (Path.IsPathRooted(cleanedReference))
        {
            return TryResolveAbsolute(cleanedReference, out assetFile);
        }

        if (!StartsWithRelativeNavigation(cleanedReference) &&
            TryResolveRootRelative(cleanedReference, out assetFile))
        {
            return true;
        }

        return TryResolveAgainstReferenceDirectory(cleanedReference, referenceSourcePath, out assetFile);
    }

    public static string NormalizeRelativePath(string relativePath)
    {
        var cleaned = (relativePath ?? string.Empty)
            .Trim()
            .Replace(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar)
            .TrimStart(Path.DirectorySeparatorChar);

        if (string.IsNullOrWhiteSpace(cleaned))
        {
            return string.Empty;
        }

        var segments = cleaned.Split(
            [Path.DirectorySeparatorChar],
            StringSplitOptions.RemoveEmptyEntries);

        return string.Join(Path.DirectorySeparatorChar, segments);
    }

    private bool TryResolveAbsolute(string absolutePath, out IndexedAssetFile assetFile)
    {
        assetFile = default!;

        try
        {
            var normalizedAbsolutePath = NormalizeAbsolutePath(absolutePath);

            if (!File.Exists(normalizedAbsolutePath) ||
                !ProjectFileCollector.IsSubPathOf(normalizedAbsolutePath, RootPath))
            {
                return false;
            }

            var relativePath = NormalizeRelativePath(Path.GetRelativePath(RootPath, normalizedAbsolutePath));

            if (_filesByRelativePath.TryGetValue(ToDictionaryKey(relativePath), out var resolvedAssetFile))
            {
                assetFile = resolvedAssetFile;
                return true;
            }

            return false;
        }
        catch
        {
            return false;
        }
    }

    private bool TryResolveRootRelative(string cleanedReference, out IndexedAssetFile assetFile)
    {
        assetFile = default!;
        var normalizedRelativePath = NormalizeRelativePath(cleanedReference);

        if (_filesByRelativePath.TryGetValue(ToDictionaryKey(normalizedRelativePath), out var resolvedAssetFile))
        {
            assetFile = resolvedAssetFile;
            return true;
        }

        return false;
    }

    private bool TryResolveAgainstReferenceDirectory(string cleanedReference, string referenceSourcePath, out IndexedAssetFile assetFile)
    {
        assetFile = default!;

        try
        {
            var referenceDirectory = Path.GetDirectoryName(referenceSourcePath);

            if (string.IsNullOrWhiteSpace(referenceDirectory))
            {
                return false;
            }

            var combinedPath = NormalizeAbsolutePath(Path.Combine(referenceDirectory, cleanedReference));

            if (!File.Exists(combinedPath) ||
                !ProjectFileCollector.IsSubPathOf(combinedPath, RootPath))
            {
                return false;
            }

            var relativePath = NormalizeRelativePath(Path.GetRelativePath(RootPath, combinedPath));

            if (_filesByRelativePath.TryGetValue(ToDictionaryKey(relativePath), out var resolvedAssetFile))
            {
                assetFile = resolvedAssetFile;
                return true;
            }

            return false;
        }
        catch
        {
            return false;
        }
    }

    private static bool ShouldSkipRelativePath(string relativePath)
    {
        var segments = relativePath.Split(
            [Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar],
            StringSplitOptions.RemoveEmptyEntries);

        return segments.Any(segment => segment.StartsWith(".", StringComparison.Ordinal));
    }

    private static string CleanReference(string rawReference)
    {
        return (rawReference ?? string.Empty)
            .Trim()
            .Trim('"', '\'')
            .Replace(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar);
    }

    private static bool StartsWithRelativeNavigation(string reference)
    {
        return reference.StartsWith("." + Path.DirectorySeparatorChar, StringComparison.Ordinal) ||
               reference.StartsWith(".." + Path.DirectorySeparatorChar, StringComparison.Ordinal) ||
               string.Equals(reference, ".", StringComparison.Ordinal) ||
               string.Equals(reference, "..", StringComparison.Ordinal);
    }

    private static string NormalizeAbsolutePath(string path) =>
        Path.GetFullPath(path)
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

    private static string ToDictionaryKey(string relativePath) =>
        relativePath.Replace(Path.AltDirectorySeparatorChar, Path.DirectorySeparatorChar);
}
