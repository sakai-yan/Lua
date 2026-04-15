namespace MapRepair.Core.Internal;

internal static class ObjectDataWriter
{
    public static byte[] WriteEmpty()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(2);
        writer.Write(0);
        writer.Write(0);
        return stream.ToArray();
    }
}
