namespace MapRepair.Core.Internal;

internal static class EditorPanelWriters
{
    public static byte[] WriteEmptyRegions()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(5);
        writer.Write(0);
        return stream.ToArray();
    }

    public static byte[] WriteEmptyCameras()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(0);
        writer.Write(0);
        return stream.ToArray();
    }

    public static byte[] WriteEmptySounds()
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(1);
        writer.Write(0);
        return stream.ToArray();
    }
}
