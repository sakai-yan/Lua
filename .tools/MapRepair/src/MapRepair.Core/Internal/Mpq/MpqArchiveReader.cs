using System.IO.Compression;
using System.Text;

namespace MapRepair.Core.Internal.Mpq;

internal sealed class MpqArchiveReader : IDisposable
{
    private const uint FileFlagImploded = 0x00000100;
    private const uint FileFlagCompressed = 0x00000200;
    private const uint FileFlagEncrypted = 0x00010000;
    private const uint FileFlagSingleUnit = 0x01000000;
    private const uint FileFlagSectorCrc = 0x04000000;
    private const uint FileFlagExists = 0x80000000;

    private readonly FileStream _stream;
    private readonly MpqHeader _header;
    private readonly MpqHashEntry[] _hashEntries;
    private readonly MpqBlockEntry[] _blockEntries;

    private MpqArchiveReader(
        FileStream stream,
        MpqHeader header,
        MpqHashEntry[] hashEntries,
        MpqBlockEntry[] blockEntries)
    {
        _stream = stream;
        _header = header;
        _hashEntries = hashEntries;
        _blockEntries = blockEntries;
    }

    public static MpqArchiveReader Open(string filePath)
    {
        var stream = new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);

        try
        {
            var header = ReadHeader(stream);
            var hashEntries = ReadHashTable(stream, header);
            var blockEntries = ReadBlockTable(stream, header);
            return new MpqArchiveReader(stream, header, hashEntries, blockEntries);
        }
        catch
        {
            stream.Dispose();
            throw;
        }
    }

    public MpqEntryReadResult ReadFile(string fileName)
    {
        var normalizedName = MpqCrypto.NormalizePath(fileName);
        var hashEntry = FindHashEntry(normalizedName);
        if (hashEntry is null)
        {
            return new MpqEntryReadResult(false, false, null, null);
        }

        if (hashEntry.BlockIndex >= _blockEntries.Length)
        {
            return new MpqEntryReadResult(true, false, null, $"`{normalizedName}` 的块索引超出范围。");
        }

        var block = _blockEntries[hashEntry.BlockIndex];
        if ((block.Flags & FileFlagExists) == 0)
        {
            return new MpqEntryReadResult(false, false, null, null);
        }

        if ((block.Flags & FileFlagImploded) != 0)
        {
            return new MpqEntryReadResult(true, false, null, $"`{normalizedName}` 使用了 implode 压缩，v1 不支持。");
        }

        return ReadBlock(normalizedName, block);
    }

    public MpqEntryReadResult ReadRawFile(string fileName)
    {
        var normalizedName = MpqCrypto.NormalizePath(fileName);
        var hashEntry = FindHashEntry(normalizedName);
        if (hashEntry is null)
        {
            return new MpqEntryReadResult(false, false, null, null);
        }

        if (hashEntry.BlockIndex >= _blockEntries.Length)
        {
            return new MpqEntryReadResult(true, false, null, $"`{normalizedName}` 的块索引超出范围。");
        }

        var block = _blockEntries[hashEntry.BlockIndex];
        if ((block.Flags & FileFlagExists) == 0)
        {
            return new MpqEntryReadResult(false, false, null, null);
        }

        var absoluteOffset = _header.ArchiveOffset + block.FileOffset;
        if (absoluteOffset + block.CompressedSize > _stream.Length)
        {
            return new MpqEntryReadResult(true, false, null, $"`{normalizedName}` 的块偏移超出存档边界。");
        }

        _stream.Position = absoluteOffset;
        var rawData = new byte[block.CompressedSize];
        _ = _stream.Read(rawData, 0, rawData.Length);
        return new MpqEntryReadResult(true, true, rawData, null);
    }

    public void Dispose()
    {
        _stream.Dispose();
    }

    private MpqEntryReadResult ReadBlock(string fileName, MpqBlockEntry block)
    {
        var absoluteOffset = _header.ArchiveOffset + block.FileOffset;
        if (absoluteOffset + block.CompressedSize > _stream.Length)
        {
            return new MpqEntryReadResult(true, false, null, $"`{fileName}` 的块偏移超出存档边界。");
        }

        _stream.Position = absoluteOffset;
        var rawData = new byte[block.CompressedSize];
        _ = _stream.Read(rawData, 0, rawData.Length);
        var fileKey = block.IsEncrypted ? MpqCrypto.ComputeFileKey(fileName, block) : 0u;

        if ((block.Flags & FileFlagCompressed) == 0 && (block.Flags & FileFlagSingleUnit) == 0)
        {
            var plainData = block.IsEncrypted
                ? DecryptBySectors(rawData, fileKey, 512 << _header.BlockSize, (int)block.FileSize)
                : rawData.Take((int)block.FileSize).ToArray();
            return new MpqEntryReadResult(true, true, plainData.Take((int)block.FileSize).ToArray(), null);
        }

        try
        {
            if ((block.Flags & FileFlagSingleUnit) != 0)
            {
                var singleUnitData = block.IsEncrypted ? MpqCrypto.Decrypt(rawData, fileKey) : rawData;
                var data = DecompressChunk(singleUnitData, (int)block.FileSize);
                return new MpqEntryReadResult(true, true, data, null);
            }

            var sectorSize = 512 << _header.BlockSize;
            var sectorCount = (int)((block.FileSize + (uint)sectorSize - 1) / (uint)sectorSize);
            var offsetCount = sectorCount + 1;
            if ((block.Flags & FileFlagSectorCrc) != 0)
            {
                offsetCount += sectorCount;
            }

            if (block.IsEncrypted)
            {
                var tableByteLength = offsetCount * 4;
                var encryptedTable = new byte[tableByteLength];
                Buffer.BlockCopy(rawData, 0, encryptedTable, 0, tableByteLength);
                var decryptedTable = MpqCrypto.Decrypt(encryptedTable, fileKey - 1);
                Buffer.BlockCopy(decryptedTable, 0, rawData, 0, tableByteLength);
            }

            using var sectorStream = new MemoryStream(rawData, writable: false);
            using var reader = new BinaryReader(sectorStream);
            var sectorOffsets = new uint[offsetCount];
            for (var index = 0; index < offsetCount; index++)
            {
                sectorOffsets[index] = reader.ReadUInt32();
            }

            using var output = new MemoryStream((int)block.FileSize);
            for (var index = 0; index < sectorCount; index++)
            {
                var start = sectorOffsets[index];
                var end = sectorOffsets[index + 1];
                var expectedSize = Math.Min(sectorSize, (int)block.FileSize - index * sectorSize);
                if (end < start || end > rawData.Length)
                {
                    return new MpqEntryReadResult(true, false, null, $"`{fileName}` 的扇区偏移损坏。");
                }

                var sectorData = new byte[end - start];
                Buffer.BlockCopy(rawData, (int)start, sectorData, 0, sectorData.Length);
                if (block.IsEncrypted)
                {
                    sectorData = MpqCrypto.Decrypt(sectorData, fileKey + (uint)index);
                }

                var decompressed = sectorData.Length == expectedSize
                    ? sectorData
                    : DecompressChunk(sectorData, expectedSize);
                output.Write(decompressed, 0, decompressed.Length);
            }

            return new MpqEntryReadResult(true, true, output.ToArray(), null);
        }
        catch (InvalidDataException exception)
        {
            return new MpqEntryReadResult(true, false, null, $"`{fileName}` 解压失败：{exception.Message}");
        }
    }

    private static byte[] DecryptBySectors(byte[] rawData, uint fileKey, int sectorSize, int fileSize)
    {
        var output = new byte[rawData.Length];
        var sectorCount = (fileSize + sectorSize - 1) / sectorSize;

        for (var index = 0; index < sectorCount; index++)
        {
            var sourceOffset = index * sectorSize;
            if (sourceOffset >= rawData.Length)
            {
                break;
            }

            var length = Math.Min(sectorSize, rawData.Length - sourceOffset);
            var sectorData = new byte[length];
            Buffer.BlockCopy(rawData, sourceOffset, sectorData, 0, length);
            var decrypted = MpqCrypto.Decrypt(sectorData, fileKey + (uint)index);
            Buffer.BlockCopy(decrypted, 0, output, sourceOffset, decrypted.Length);
        }

        return output;
    }

    private static byte[] DecompressChunk(byte[] data, int expectedSize)
    {
        if (data.Length == expectedSize)
        {
            return data;
        }

        if (data.Length == 0)
        {
            return [];
        }

        var compressionMask = data[0];
        if (compressionMask == 0)
        {
            return data[1..];
        }

        if (compressionMask == 0x08)
        {
            return PkwareExploder.Decompress(data[1..], expectedSize);
        }

        if ((compressionMask & 0x02) != 0 && (compressionMask & ~0x02) == 0)
        {
            using var input = new MemoryStream(data, 1, data.Length - 1, writable: false);
            using var zlib = new ZLibStream(input, CompressionMode.Decompress);
            using var output = new MemoryStream(expectedSize);
            zlib.CopyTo(output);
            return output.ToArray();
        }

        if ((compressionMask & 0x08) != 0)
        {
            throw new InvalidDataException($"不支持的压缩掩码 0x{compressionMask:X2}。");
        }

        throw new InvalidDataException($"不支持的压缩掩码 0x{compressionMask:X2}。");
    }

    private MpqHashEntry? FindHashEntry(string fileName)
    {
        var hashStart = (int)(MpqCrypto.HashString(fileName, MpqHashType.TableOffset) % (uint)_hashEntries.Length);
        var hashA = MpqCrypto.HashString(fileName, MpqHashType.HashA);
        var hashB = MpqCrypto.HashString(fileName, MpqHashType.HashB);

        for (var step = 0; step < _hashEntries.Length; step++)
        {
            var index = (hashStart + step) % _hashEntries.Length;
            var entry = _hashEntries[index];
            if (entry.BlockIndex == 0xFFFFFFFF)
            {
                return null;
            }

            if (entry.HashA == hashA && entry.HashB == hashB && entry.BlockIndex != 0xFFFFFFFE)
            {
                return entry;
            }
        }

        return null;
    }

    private static MpqHeader ReadHeader(FileStream stream)
    {
        const string signature = "MPQ\x1A";
        var scanLimit = Math.Min(stream.Length, 1024L * 1024L);
        for (long offset = 0; offset <= scanLimit - 4; offset = offset == 0 ? 512 : offset + 512)
        {
            stream.Position = offset;
            using var reader = new BinaryReader(stream, Encoding.ASCII, leaveOpen: true);
            if (!string.Equals(new string(reader.ReadChars(4)), signature, StringComparison.Ordinal))
            {
                continue;
            }

            var headerSize = reader.ReadInt32();
            var archiveSize = reader.ReadInt32();
            var formatVersion = reader.ReadInt16();
            var blockSize = reader.ReadInt16();
            var hashTableOffset = reader.ReadInt32();
            var blockTableOffset = reader.ReadInt32();
            var hashTableSize = reader.ReadInt32();
            var blockTableSize = reader.ReadInt32();

            if (formatVersion > 1)
            {
                throw new InvalidDataException($"暂不支持 MPQ 格式版本 {formatVersion}。");
            }

            return new MpqHeader(
                offset,
                headerSize,
                archiveSize,
                formatVersion,
                blockSize,
                hashTableOffset,
                blockTableOffset,
                hashTableSize,
                blockTableSize);
        }

        throw new InvalidDataException("未找到 MPQ 头，输入文件不是可读取的 Warcraft 3 地图。");
    }

    private static MpqHashEntry[] ReadHashTable(FileStream stream, MpqHeader header)
    {
        var sizeInBytes = header.HashTableSize * 16;
        stream.Position = header.ArchiveOffset + header.HashTableOffset;
        var encrypted = new byte[sizeInBytes];
        _ = stream.Read(encrypted, 0, encrypted.Length);
        var decrypted = MpqCrypto.Decrypt(encrypted, MpqCrypto.HashString("(hash table)", MpqHashType.FileKey));

        var entries = new MpqHashEntry[header.HashTableSize];
        using var memory = new MemoryStream(decrypted, writable: false);
        using var reader = new BinaryReader(memory);
        for (var index = 0; index < entries.Length; index++)
        {
            entries[index] = new MpqHashEntry(
                reader.ReadUInt32(),
                reader.ReadUInt32(),
                reader.ReadUInt16(),
                reader.ReadUInt16(),
                reader.ReadUInt32());
        }

        return entries;
    }

    private static MpqBlockEntry[] ReadBlockTable(FileStream stream, MpqHeader header)
    {
        var sizeInBytes = header.BlockTableSize * 16;
        stream.Position = header.ArchiveOffset + header.BlockTableOffset;
        var encrypted = new byte[sizeInBytes];
        _ = stream.Read(encrypted, 0, encrypted.Length);
        var decrypted = MpqCrypto.Decrypt(encrypted, MpqCrypto.HashString("(block table)", MpqHashType.FileKey));

        var entries = new MpqBlockEntry[header.BlockTableSize];
        using var memory = new MemoryStream(decrypted, writable: false);
        using var reader = new BinaryReader(memory);
        for (var index = 0; index < entries.Length; index++)
        {
            entries[index] = new MpqBlockEntry(
                reader.ReadUInt32(),
                reader.ReadUInt32(),
                reader.ReadUInt32(),
                reader.ReadUInt32());
        }

        return entries;
    }
}
