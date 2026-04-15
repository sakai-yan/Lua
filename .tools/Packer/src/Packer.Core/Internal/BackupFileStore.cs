namespace Packer.Core.Internal;

internal sealed class BackupFileStore
{
    public string CreateRunDirectory(string backupRootDirectoryPath)
    {
        Directory.CreateDirectory(backupRootDirectoryPath);

        var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        var runDirectoryPath = Path.Combine(backupRootDirectoryPath, timestamp);
        var suffix = 1;

        while (Directory.Exists(runDirectoryPath))
        {
            runDirectoryPath = Path.Combine(backupRootDirectoryPath, $"{timestamp}_{suffix}");
            suffix++;
        }

        Directory.CreateDirectory(runDirectoryPath);
        return runDirectoryPath;
    }

    public string? BackupIfExists(string filePath, string relativeTargetPath, string backupRunDirectoryPath)
    {
        if (!File.Exists(filePath))
        {
            return null;
        }

        var backupPath = Path.Combine(backupRunDirectoryPath, "overwritten", relativeTargetPath);
        var directory = Path.GetDirectoryName(backupPath);

        if (!string.IsNullOrWhiteSpace(directory))
        {
            Directory.CreateDirectory(directory);
        }

        var finalBackupPath = EnsureUniquePath(backupPath);
        File.Copy(filePath, finalBackupPath, overwrite: false);
        return finalBackupPath;
    }

    private static string EnsureUniquePath(string path)
    {
        if (!File.Exists(path))
        {
            return path;
        }

        var directory = Path.GetDirectoryName(path) ?? string.Empty;
        var fileNameWithoutExtension = Path.GetFileNameWithoutExtension(path);
        var extension = Path.GetExtension(path);
        var suffix = 1;

        while (true)
        {
            var candidate = Path.Combine(directory, $"{fileNameWithoutExtension}_{suffix}{extension}");

            if (!File.Exists(candidate))
            {
                return candidate;
            }

            suffix++;
        }
    }
}
