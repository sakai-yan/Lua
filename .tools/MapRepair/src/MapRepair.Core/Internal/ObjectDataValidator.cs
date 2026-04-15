namespace MapRepair.Core.Internal;

internal static class ObjectDataValidator
{
    public static bool LooksValid(byte[] data)
    {
        if (data.Length < 4)
        {
            return false;
        }

        using var stream = new MemoryStream(data, writable: false);
        using var reader = new BinaryReader(stream);

        var version = reader.ReadInt32();
        return version is >= 1 and <= 3;
    }
}
