using System.Text;

namespace MapRepair.Core.Internal;

internal static class ObjectDataAssetCollector
{
    private static readonly HashSet<string> EntriesWithLevelAndPointer = new(StringComparer.OrdinalIgnoreCase)
    {
        "war3map.w3a",
        "war3map.w3q"
    };

    public static IReadOnlyList<string> CollectStringValues(string entryName, byte[] data)
    {
        if (!ObjectDataValidator.LooksValid(data))
        {
            return ExtractAsciiStrings(data);
        }

        try
        {
            using var stream = new MemoryStream(data, writable: false);
            using var reader = new BinaryReader(stream, Encoding.UTF8, leaveOpen: false);
            var version = reader.ReadInt32();
            if (version is < 1 or > 3)
            {
                return [];
            }

            var includeLevelAndPointer = EntriesWithLevelAndPointer.Contains(entryName);
            var values = new List<string>();

            ReadBucket(reader, includeLevelAndPointer, values);
            ReadBucket(reader, includeLevelAndPointer, values);

            return values;
        }
        catch (EndOfStreamException)
        {
            return ExtractAsciiStrings(data);
        }
        catch (InvalidDataException)
        {
            return ExtractAsciiStrings(data);
        }
    }

    private static void ReadBucket(BinaryReader reader, bool includeLevelAndPointer, ICollection<string> values)
    {
        var count = reader.ReadInt32();
        if (count < 0 || count > 1_000_000)
        {
            throw new InvalidDataException($"Invalid object-data bucket count: {count}");
        }

        for (var objectIndex = 0; objectIndex < count; objectIndex++)
        {
            _ = ReadRawCode(reader);
            _ = reader.ReadBytes(4);

            var modificationCount = reader.ReadInt32();
            if (modificationCount < 0 || modificationCount > 1_000_000)
            {
                throw new InvalidDataException($"Invalid object-data modification count: {modificationCount}");
            }

            for (var modificationIndex = 0; modificationIndex < modificationCount; modificationIndex++)
            {
                _ = ReadRawCode(reader);
                var kind = reader.ReadInt32();
                if (includeLevelAndPointer)
                {
                    _ = reader.ReadInt32();
                    _ = reader.ReadInt32();
                }

                switch (kind)
                {
                    case (int)ObjectValueKind.Int:
                    case (int)ObjectValueKind.Real:
                    case (int)ObjectValueKind.Unreal:
                        _ = reader.ReadBytes(4);
                        break;

                    case (int)ObjectValueKind.String:
                        values.Add(ReadCString(reader));
                        break;

                    default:
                        throw new InvalidDataException($"Unknown object-data value kind: {kind}");
                }

                _ = reader.ReadBytes(4);
            }
        }
    }

    private static string ReadRawCode(BinaryReader reader)
    {
        var bytes = reader.ReadBytes(4);
        if (bytes.Length < 4)
        {
            throw new EndOfStreamException();
        }

        return Encoding.ASCII.GetString(bytes).TrimEnd('\0');
    }

    private static string ReadCString(BinaryReader reader)
    {
        using var stream = new MemoryStream();
        while (true)
        {
            var value = reader.ReadByte();
            if (value == 0)
            {
                break;
            }

            stream.WriteByte(value);
        }

        return Encoding.UTF8.GetString(stream.ToArray());
    }

    private static IReadOnlyList<string> ExtractAsciiStrings(byte[] data)
    {
        var values = new List<string>();
        var buffer = new List<byte>();

        foreach (var value in data)
        {
            if (value is >= 32 and <= 126)
            {
                buffer.Add(value);
                continue;
            }

            Flush(values, buffer);
        }

        Flush(values, buffer);
        return values;
    }

    private static void Flush(ICollection<string> values, List<byte> buffer)
    {
        if (buffer.Count >= 4)
        {
            values.Add(Encoding.ASCII.GetString(buffer.ToArray()));
        }

        buffer.Clear();
    }
}
