namespace MapRepair.Core.Internal;

internal static class WpmWriter
{
    private const byte DefaultCell = 0xCE;

    public static byte[] Write(TerrainInfo terrain)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream);
        writer.Write(new[] { 'M', 'P', '3', 'W' });
        writer.Write(0);
        writer.Write(terrain.PathingWidth);
        writer.Write(terrain.PathingHeight);

        var cellCount = checked(terrain.PathingWidth * terrain.PathingHeight);
        for (var index = 0; index < cellCount; index++)
        {
            writer.Write(DefaultCell);
        }

        return stream.ToArray();
    }
}
