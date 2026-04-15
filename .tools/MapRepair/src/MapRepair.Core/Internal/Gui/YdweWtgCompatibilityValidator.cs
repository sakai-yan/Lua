using System.Text;

namespace MapRepair.Core.Internal.Gui;

internal static class YdweWtgCompatibilityValidator
{
    private static readonly Encoding Utf8 = new UTF8Encoding(false);

    public static bool TryValidate(byte[] wtgBytes, GuiMetadataCatalog metadata, out string? failure)
    {
        ArgumentNullException.ThrowIfNull(wtgBytes);
        ArgumentNullException.ThrowIfNull(metadata);

        try
        {
            using var stream = new MemoryStream(wtgBytes);
            using var reader = new BinaryReader(stream, Utf8, leaveOpen: false);
            Validate(reader, metadata);
            failure = null;
            return true;
        }
        catch (Exception ex) when (ex is EndOfStreamException or InvalidDataException)
        {
            failure = ex.Message;
            return false;
        }
    }

    private static void Validate(BinaryReader reader, GuiMetadataCatalog metadata)
    {
        var signature = Utf8.GetString(reader.ReadBytes(4));
        if (!string.Equals(signature, "WTG!", StringComparison.Ordinal))
        {
            throw new InvalidDataException("WTG compatibility validation failed: invalid signature.");
        }

        var version = reader.ReadInt32();
        if (version != 7)
        {
            throw new InvalidDataException($"WTG compatibility validation failed: unsupported version `{version}`.");
        }

        var categoryCount = reader.ReadInt32();
        for (var index = 0; index < categoryCount; index++)
        {
            _ = reader.ReadInt32();
            _ = ReadCString(reader);
            _ = reader.ReadInt32();
        }

        if (reader.ReadInt32() != 2)
        {
            throw new InvalidDataException("WTG compatibility validation failed: invalid variable header.");
        }

        var variableCount = reader.ReadInt32();
        for (var index = 0; index < variableCount; index++)
        {
            _ = ReadCString(reader);
            _ = ReadCString(reader);
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = ReadCString(reader);
        }

        var triggerCount = reader.ReadInt32();
        for (var triggerIndex = 0; triggerIndex < triggerCount; triggerIndex++)
        {
            _ = ReadCString(reader);
            _ = ReadCString(reader);
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();

            var rootCount = reader.ReadInt32();
            for (var nodeIndex = 0; nodeIndex < rootCount; nodeIndex++)
            {
                ValidateNode(reader, metadata, isChild: false);
            }
        }
    }

    private static void ValidateNode(BinaryReader reader, GuiMetadataCatalog metadata, bool isChild)
    {
        var kind = (LegacyGuiFunctionKind)reader.ReadInt32();
        if (isChild)
        {
            _ = reader.ReadInt32();
        }

        var name = ReadCString(reader);
        _ = reader.ReadInt32();

        if (!metadata.TryGetEntry(kind, name, out var entry))
        {
            throw new InvalidDataException($"WTG compatibility validation failed: missing GUI metadata for `{kind}:{name}`.");
        }

        foreach (var _ in entry.EffectiveArguments)
        {
            ValidateArgument(reader, metadata);
        }

        var childCount = reader.ReadInt32();
        for (var index = 0; index < childCount; index++)
        {
            ValidateNode(reader, metadata, isChild: true);
        }
    }

    private static void ValidateArgument(BinaryReader reader, GuiMetadataCatalog metadata)
    {
        _ = (LegacyGuiArgumentKind)reader.ReadInt32();
        _ = ReadCString(reader);
        var hasCall = reader.ReadInt32() != 0;
        if (hasCall)
        {
            ValidateNode(reader, metadata, isChild: false);
        }

        var hasArrayIndex = reader.ReadInt32() != 0;
        if (hasArrayIndex)
        {
            ValidateArgument(reader, metadata);
        }
    }

    private static string ReadCString(BinaryReader reader)
    {
        using var stream = new MemoryStream();
        while (true)
        {
            var current = reader.ReadByte();
            if (current == 0)
            {
                return Utf8.GetString(stream.ToArray());
            }

            stream.WriteByte(current);
        }
    }
}
