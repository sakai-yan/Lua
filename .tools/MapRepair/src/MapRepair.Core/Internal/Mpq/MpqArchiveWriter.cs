namespace MapRepair.Core.Internal.Mpq;

internal static class MpqArchiveWriter
{
    private const uint FileFlagExists = 0x80000000;

    public static void WriteArchive(string outputPath, IReadOnlyDictionary<string, byte[]> files)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(outputPath) ?? ".");

        using var stream = new FileStream(outputPath, FileMode.Create, FileAccess.ReadWrite, FileShare.None);
        using var writer = new BinaryWriter(stream);

        for (var index = 0; index < 32; index++)
        {
            writer.Write((byte)0);
        }

        var orderedEntries = files
            .Select(entry => new KeyValuePair<string, byte[]>(MpqCrypto.NormalizePath(entry.Key), entry.Value))
            .OrderBy(entry => entry.Key, StringComparer.OrdinalIgnoreCase)
            .ToArray();

        var blockEntries = new MpqBlockEntry[orderedEntries.Length];
        for (var index = 0; index < orderedEntries.Length; index++)
        {
            Align(stream, 512);
            var offset = checked((uint)stream.Position);
            var data = orderedEntries[index].Value;
            writer.Write(data);
            blockEntries[index] = new MpqBlockEntry(offset, (uint)data.Length, (uint)data.Length, FileFlagExists);
        }

        Align(stream, 512);
        var hashTableOffset = checked((int)stream.Position);
        var hashTableEntries = BuildHashTable(orderedEntries);
        var encryptedHashTable = MpqCrypto.Encrypt(SerializeHashTable(hashTableEntries), MpqCrypto.HashString("(hash table)", MpqHashType.FileKey));
        writer.Write(encryptedHashTable);

        var blockTableOffset = checked((int)stream.Position);
        var encryptedBlockTable = MpqCrypto.Encrypt(SerializeBlockTable(blockEntries), MpqCrypto.HashString("(block table)", MpqHashType.FileKey));
        writer.Write(encryptedBlockTable);

        var archiveSize = checked((int)stream.Length);
        stream.Position = 0;
        writer.Write(new[] { 'M', 'P', 'Q', '\x1A' });
        writer.Write(32);
        writer.Write(archiveSize);
        writer.Write((short)0);
        writer.Write((short)3);
        writer.Write(hashTableOffset);
        writer.Write(blockTableOffset);
        writer.Write(hashTableEntries.Length);
        writer.Write(blockEntries.Length);
    }

    private static MpqHashEntry[] BuildHashTable(IReadOnlyList<KeyValuePair<string, byte[]>> entries)
    {
        var hashTableSize = 2;
        while (hashTableSize < entries.Count * 2)
        {
            hashTableSize <<= 1;
        }

        var table = Enumerable.Range(0, hashTableSize)
            .Select(_ => new MpqHashEntry(0xFFFFFFFF, 0xFFFFFFFF, 0xFFFF, 0xFFFF, 0xFFFFFFFF))
            .ToArray();

        for (var blockIndex = 0; blockIndex < entries.Count; blockIndex++)
        {
            var name = entries[blockIndex].Key;
            var start = (int)(MpqCrypto.HashString(name, MpqHashType.TableOffset) % (uint)hashTableSize);
            for (var step = 0; step < hashTableSize; step++)
            {
                var index = (start + step) % hashTableSize;
                if (table[index].BlockIndex != 0xFFFFFFFF)
                {
                    continue;
                }

                table[index] = new MpqHashEntry(
                    MpqCrypto.HashString(name, MpqHashType.HashA),
                    MpqCrypto.HashString(name, MpqHashType.HashB),
                    0,
                    0,
                    (uint)blockIndex);
                break;
            }
        }

        return table;
    }

    private static byte[] SerializeHashTable(IEnumerable<MpqHashEntry> entries)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        foreach (var entry in entries)
        {
            writer.Write(entry.HashA);
            writer.Write(entry.HashB);
            writer.Write(entry.Locale);
            writer.Write(entry.Platform);
            writer.Write(entry.BlockIndex);
        }

        return stream.ToArray();
    }

    private static byte[] SerializeBlockTable(IEnumerable<MpqBlockEntry> entries)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        foreach (var entry in entries)
        {
            writer.Write(entry.FileOffset);
            writer.Write(entry.CompressedSize);
            writer.Write(entry.FileSize);
            writer.Write(entry.Flags);
        }

        return stream.ToArray();
    }

    private static void Align(Stream stream, int alignment)
    {
        var remainder = stream.Position % alignment;
        if (remainder == 0)
        {
            return;
        }

        var padding = alignment - remainder;
        for (var index = 0; index < padding; index++)
        {
            stream.WriteByte(0);
        }
    }
}
