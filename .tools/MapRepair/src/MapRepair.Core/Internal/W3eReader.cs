namespace MapRepair.Core.Internal;

internal static class W3eReader
{
    public static bool TryReadTerrainInfo(byte[] data, out TerrainInfo info)
    {
        info = new TerrainInfo(0, 0, 0, 0, 0, 0, 0, 0);

        if (data.Length < 44)
        {
            return false;
        }

        using var stream = new MemoryStream(data, writable: false);
        using var reader = new BinaryReader(stream);
        var signature = new string(reader.ReadChars(4));

        if (!string.Equals(signature, "W3E!", StringComparison.Ordinal))
        {
            return false;
        }

        _ = reader.ReadInt32();
        _ = reader.ReadByte();
        _ = reader.ReadInt32();

        var tilesetCount = reader.ReadInt32();
        stream.Position += tilesetCount * 4L;
        var cliffCount = reader.ReadInt32();
        stream.Position += cliffCount * 4L;

        if (stream.Position + 16 > stream.Length)
        {
            return false;
        }

        var cornerWidth = reader.ReadInt32();
        var cornerHeight = reader.ReadInt32();
        var centerX = reader.ReadSingle();
        var centerY = reader.ReadSingle();

        if (cornerWidth < 2 || cornerHeight < 2)
        {
            return false;
        }

        info = new TerrainInfo(
            cornerWidth,
            cornerHeight,
            Math.Max(1, cornerWidth - 13),
            Math.Max(1, cornerHeight - 13),
            Math.Max(4, (cornerWidth - 1) * 4),
            Math.Max(4, (cornerHeight - 1) * 4),
            centerX,
            centerY);
        return true;
    }
}
