namespace MapRepair.Core.Internal;

internal static class DoodadWriter
{
    public static byte[] WriteEmptyDoodads()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(new[] { 'W', '3', 'd', 'o' });
        writer.Write(8);
        writer.Write(11);
        writer.Write(0);
        writer.Write(0);
        writer.Write(0);
        return stream.ToArray();
    }

    public static byte[] WriteEmptyUnits()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(new[] { 'W', '3', 'd', 'o' });
        writer.Write(8);
        writer.Write(11);
        writer.Write(0);
        return stream.ToArray();
    }
}
