namespace MapRepair.Core.Internal;

internal sealed record War3ImportEntry(byte Flag, string StoredPath)
{
    public const byte StandardPathFlagLegacy = 5;
    public const byte StandardPathFlag = 8;
    public const byte CustomPathFlagLegacy = 10;
    public const byte CustomPathFlag = 13;

    private const string ImportedPrefix = @"war3mapImported\";

    public string NormalizedStoredPath => NormalizeStoredPath(StoredPath);

    public bool UsesCustomPath => IsCustomPathFlag(Flag);

    public string ArchivePath => ResolveArchivePath(Flag, StoredPath);

    public static bool IsCustomPathFlag(byte flag) =>
        flag is CustomPathFlagLegacy or CustomPathFlag;

    public static bool IsStandardPathFlag(byte flag) =>
        flag is StandardPathFlagLegacy or StandardPathFlag;

    public static string ResolveArchivePath(byte flag, string? storedPath)
    {
        var normalized = NormalizeStoredPath(storedPath);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return string.Empty;
        }

        if (IsCustomPathFlag(flag))
        {
            return normalized;
        }

        return normalized.StartsWith(ImportedPrefix, StringComparison.OrdinalIgnoreCase)
            ? normalized
            : ImportedPrefix + normalized;
    }

    public static War3ImportEntry CreateForArchivePath(string archivePath, byte? preferredFlag = null)
    {
        var normalizedArchivePath = NormalizeStoredPath(archivePath);
        var flag = preferredFlag ?? GuessDefaultFlag(normalizedArchivePath);

        if (IsCustomPathFlag(flag))
        {
            return new War3ImportEntry(flag, normalizedArchivePath);
        }

        var storedPath = normalizedArchivePath.StartsWith(ImportedPrefix, StringComparison.OrdinalIgnoreCase)
            ? normalizedArchivePath[ImportedPrefix.Length..]
            : normalizedArchivePath;
        return new War3ImportEntry(flag, storedPath);
    }

    private static byte GuessDefaultFlag(string normalizedArchivePath) =>
        normalizedArchivePath.StartsWith(ImportedPrefix, StringComparison.OrdinalIgnoreCase)
            ? StandardPathFlag
            : CustomPathFlag;

    private static string NormalizeStoredPath(string? storedPath) =>
        (storedPath ?? string.Empty).Replace('/', '\\').TrimStart('\\');
}
