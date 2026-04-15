namespace MapRepair.Core.Internal.Mpq;

internal static class MpqCrypto
{
    private static readonly uint[] CryptTable = BuildCryptTable();

    public static uint HashString(string value, MpqHashType hashType)
    {
        var normalized = NormalizePath(value);
        uint seed1 = 0x7FED7FED;
        uint seed2 = 0xEEEEEEEE;

        foreach (var ch in normalized)
        {
            var upper = char.ToUpperInvariant(ch);
            var index = ((int)hashType << 8) + (byte)upper;
            seed1 = CryptTable[index] ^ (seed1 + seed2);
            seed2 = (uint)((byte)upper + seed1 + seed2 + (seed2 << 5) + 3);
        }

        return seed1;
    }

    public static byte[] Decrypt(byte[] data, uint key)
    {
        var result = (byte[])data.Clone();
        var seed1 = key;
        uint seed2 = 0xEEEEEEEE;

        var fullLength = result.Length - (result.Length % 4);
        for (var offset = 0; offset < fullLength; offset += 4)
        {
            seed2 += CryptTable[0x400 + (seed1 & 0xFF)];
            var value = BitConverter.ToUInt32(result, offset);
            var decrypted = value ^ (seed1 + seed2);
            seed1 = ((~seed1 << 21) + 0x11111111) | (seed1 >> 11);
            seed2 = decrypted + seed2 + (seed2 << 5) + 3;
            BitConverter.GetBytes(decrypted).CopyTo(result, offset);
        }

        return result;
    }

    public static byte[] Encrypt(byte[] data, uint key)
    {
        var result = (byte[])data.Clone();
        var seed1 = key;
        uint seed2 = 0xEEEEEEEE;

        var fullLength = result.Length - (result.Length % 4);
        for (var offset = 0; offset < fullLength; offset += 4)
        {
            seed2 += CryptTable[0x400 + (seed1 & 0xFF)];
            var value = BitConverter.ToUInt32(result, offset);
            var encrypted = value ^ (seed1 + seed2);
            seed1 = ((~seed1 << 21) + 0x11111111) | (seed1 >> 11);
            seed2 = value + seed2 + (seed2 << 5) + 3;
            BitConverter.GetBytes(encrypted).CopyTo(result, offset);
        }

        return result;
    }

    public static string NormalizePath(string value) =>
        value.Replace('/', '\\').Trim();

    public static uint ComputeFileKey(string fileName, MpqBlockEntry block)
    {
        var normalized = NormalizePath(fileName);
        var baseNameIndex = normalized.LastIndexOf('\\');
        var baseName = baseNameIndex >= 0 ? normalized[(baseNameIndex + 1)..] : normalized;
        var key = HashString(baseName, MpqHashType.FileKey);

        if (block.UsesAdjustedKey)
        {
            key = (key + block.FileOffset) ^ block.FileSize;
        }

        return key;
    }

    private static uint[] BuildCryptTable()
    {
        var cryptTable = new uint[0x500];
        uint seed = 0x00100001;

        for (var index1 = 0; index1 < 0x100; index1++)
        {
            var index2 = index1;
            for (var i = 0; i < 5; i++, index2 += 0x100)
            {
                seed = (seed * 125 + 3) % 0x2AAAAB;
                var temp1 = (seed & 0xFFFF) << 16;

                seed = (seed * 125 + 3) % 0x2AAAAB;
                var temp2 = seed & 0xFFFF;

                cryptTable[index2] = temp1 | temp2;
            }
        }

        return cryptTable;
    }
}
