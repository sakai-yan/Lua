using System.Text;

namespace MapRepair.Core.Internal;

internal static class War3ImportFileReader
{
    public static IReadOnlyList<War3ImportEntry> ReadEntries(byte[] data)
    {
        var entries = new List<War3ImportEntry>();
        if (data.Length < 8)
        {
            return entries;
        }

        using var stream = new MemoryStream(data, writable: false);
        using var reader = new BinaryReader(stream);
        _ = reader.ReadInt32();
        var count = reader.ReadInt32();

        for (var index = 0; index < count && stream.Position < stream.Length; index++)
        {
            var flag = reader.ReadByte();
            var storedPath = ReadCString(reader);
            var entry = new War3ImportEntry(flag, storedPath);
            if (string.IsNullOrWhiteSpace(entry.ArchivePath))
            {
                continue;
            }

            entries.Add(entry);
        }

        return entries;
    }

    public static IReadOnlyList<string> ReadImportedPaths(byte[] data)
    {
        return ReadEntries(data)
            .Select(entry => entry.ArchivePath)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static string ReadCString(BinaryReader reader)
    {
        var buffer = new List<byte>();
        while (reader.BaseStream.Position < reader.BaseStream.Length)
        {
            var value = reader.ReadByte();
            if (value == 0)
            {
                break;
            }

            buffer.Add(value);
        }

        return Encoding.UTF8.GetString(buffer.ToArray());
    }
}
