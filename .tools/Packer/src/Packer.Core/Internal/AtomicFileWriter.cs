using System.Text;

namespace Packer.Core.Internal;

internal static class AtomicFileWriter
{
    private static readonly UTF8Encoding Utf8WithoutBom = new(encoderShouldEmitUTF8Identifier: false);

    public static void WriteAllText(string filePath, string content) =>
        WriteAllBytes(filePath, Utf8WithoutBom.GetBytes(content));

    public static void WriteAllBytes(string filePath, byte[] content)
    {
        var directory = Path.GetDirectoryName(filePath);

        if (string.IsNullOrWhiteSpace(directory))
        {
            throw new InvalidOperationException($"无法确定输出目录：`{filePath}`");
        }

        Directory.CreateDirectory(directory);

        var tempFile = Path.Combine(directory, $"{Path.GetFileName(filePath)}.{Guid.NewGuid():N}.tmp");

        try
        {
            File.WriteAllBytes(tempFile, content);
            ReplaceTempFile(tempFile, filePath);
        }
        finally
        {
            if (File.Exists(tempFile))
            {
                File.Delete(tempFile);
            }
        }
    }

    public static void ReplaceWithFile(string sourceFilePath, string targetFilePath)
    {
        var directory = Path.GetDirectoryName(targetFilePath);

        if (string.IsNullOrWhiteSpace(directory))
        {
            throw new InvalidOperationException($"无法确定输出目录：`{targetFilePath}`");
        }

        Directory.CreateDirectory(directory);

        var tempFile = Path.Combine(directory, $"{Path.GetFileName(targetFilePath)}.{Guid.NewGuid():N}.tmp");

        try
        {
            File.Copy(sourceFilePath, tempFile, overwrite: true);
            ReplaceTempFile(tempFile, targetFilePath);
        }
        finally
        {
            if (File.Exists(tempFile))
            {
                File.Delete(tempFile);
            }
        }
    }

    private static void ReplaceTempFile(string tempFilePath, string targetFilePath)
    {
        if (File.Exists(targetFilePath))
        {
            File.Replace(tempFilePath, targetFilePath, destinationBackupFileName: null, ignoreMetadataErrors: true);
            return;
        }

        File.Move(tempFilePath, targetFilePath);
    }
}
