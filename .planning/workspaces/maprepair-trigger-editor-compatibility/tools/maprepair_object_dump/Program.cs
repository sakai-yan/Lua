using System.Reflection;
using System.Text;
using MapRepair.Core;

if (args.Length < 2)
{
    Console.Error.WriteLine("Usage: MapRepair.ObjectDump <map-path> <entry-name> [id1,id2,...] [raw1,raw2,...] [includeLevelAndPointer]");
    return 1;
}

var mapPath = Path.GetFullPath(args[0]);
var entryName = args[1];
var ids = args.Length > 2 && !string.IsNullOrWhiteSpace(args[2])
    ? args[2].Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
    : Array.Empty<string>();
var rawCodes = args.Length > 3 && !string.IsNullOrWhiteSpace(args[3])
    ? args[3].Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
    : Array.Empty<string>();
var includeLevelAndPointer = args.Length > 4 && bool.TryParse(args[4], out var parsedInclude) && parsedInclude;

var archiveReaderType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
var readResultType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;
var open = archiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
var readFile = archiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
var dispose = archiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
var existsProp = readResultType.GetProperty("Exists", BindingFlags.Public | BindingFlags.Instance)!;
var readableProp = readResultType.GetProperty("Readable", BindingFlags.Public | BindingFlags.Instance)!;
var dataProp = readResultType.GetProperty("Data", BindingFlags.Public | BindingFlags.Instance)!;

var data = ReadMapEntry(mapPath, entryName);
if (data is null)
{
    Console.Error.WriteLine($"Entry not readable: {entryName}");
    return 2;
}

DumpObjectData(data, entryName, ids, rawCodes, includeLevelAndPointer);
return 0;

byte[]? ReadMapEntry(string currentMapPath, string currentEntryName)
{
    var archive = open.Invoke(null, [currentMapPath]);
    try
    {
        var result = readFile.Invoke(archive, [currentEntryName])!;
        var exists = (bool)existsProp.GetValue(result)!;
        var readable = (bool)readableProp.GetValue(result)!;
        if (!exists || !readable)
        {
            return null;
        }

        return (byte[]?)dataProp.GetValue(result);
    }
    finally
    {
        dispose.Invoke(archive, []);
    }
}

void DumpObjectData(byte[] bytes, string label, IReadOnlyCollection<string> selectedIds, IReadOnlyCollection<string> selectedRawCodes, bool writeLevelAndPointer)
{
    using var stream = new MemoryStream(bytes);
    using var reader = new BinaryReader(stream, Encoding.UTF8, leaveOpen: false);

    Console.WriteLine($"FILE {label}");
    Console.WriteLine($"version={reader.ReadInt32()}");

    for (var bucket = 0; bucket < 2; bucket++)
    {
        var count = reader.ReadInt32();
        Console.WriteLine($"bucket[{bucket}]={count}");

        for (var index = 0; index < count; index++)
        {
            var baseId = ReadRawCode(reader);
            var newId = ReadRawCode(reader);
            var objectId = string.IsNullOrEmpty(newId) ? baseId : newId;
            var modificationCount = reader.ReadInt32();
            var shouldDumpObject = selectedIds.Count == 0 || selectedIds.Contains(objectId, StringComparer.OrdinalIgnoreCase);

            if (shouldDumpObject)
            {
                Console.WriteLine($"OBJ {objectId} base={baseId} new={newId} mods={modificationCount}");
            }

            for (var modificationIndex = 0; modificationIndex < modificationCount; modificationIndex++)
            {
                var rawCode = ReadRawCode(reader);
                var kind = reader.ReadInt32();
                var level = 0;
                var pointer = 0;
                if (writeLevelAndPointer)
                {
                    level = reader.ReadInt32();
                    pointer = reader.ReadInt32();
                }

                var value = kind switch
                {
                    0 => reader.ReadInt32().ToString(),
                    1 or 2 => reader.ReadSingle().ToString(System.Globalization.CultureInfo.InvariantCulture),
                    3 => ReadCString(reader),
                    _ => throw new InvalidDataException($"Unknown value kind {kind} at {objectId}/{rawCode}.")
                };
                var terminator = ReadRawCode(reader);

                var shouldDumpModification =
                    shouldDumpObject ||
                    (selectedRawCodes.Count > 0 && selectedRawCodes.Contains(rawCode, StringComparer.OrdinalIgnoreCase));
                if (!shouldDumpModification)
                {
                    continue;
                }

                Console.WriteLine($"  raw={rawCode} kind={kind} level={level} ptr={pointer} term={terminator} value={value}");
            }
        }
    }
}

static string ReadRawCode(BinaryReader reader)
{
    return Encoding.ASCII.GetString(reader.ReadBytes(4)).TrimEnd('\0');
}

static string ReadCString(BinaryReader reader)
{
    using var stream = new MemoryStream();
    while (true)
    {
        var current = reader.ReadByte();
        if (current == 0)
        {
            break;
        }

        stream.WriteByte(current);
    }

    return Encoding.UTF8.GetString(stream.ToArray());
}
