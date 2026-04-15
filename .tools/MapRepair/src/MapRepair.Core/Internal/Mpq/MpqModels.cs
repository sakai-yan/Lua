namespace MapRepair.Core.Internal.Mpq;

internal enum MpqHashType
{
    TableOffset = 0,
    HashA = 1,
    HashB = 2,
    FileKey = 3
}

internal sealed record MpqHeader(
    long ArchiveOffset,
    int HeaderSize,
    int ArchiveSize,
    short FormatVersion,
    short BlockSize,
    int HashTableOffset,
    int BlockTableOffset,
    int HashTableSize,
    int BlockTableSize);

internal sealed record MpqHashEntry(
    uint HashA,
    uint HashB,
    ushort Locale,
    ushort Platform,
    uint BlockIndex);

internal sealed record MpqBlockEntry(
    uint FileOffset,
    uint CompressedSize,
    uint FileSize,
    uint Flags)
{
    public bool IsEncrypted => (Flags & 0x00010000) != 0;

    public bool UsesAdjustedKey => (Flags & 0x00020000) != 0;
}

internal sealed record MpqEntryReadResult(
    bool Exists,
    bool Readable,
    byte[]? Data,
    string? Warning);
