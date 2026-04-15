using System.Reflection;
using System.Text;
using MapRepair.Core;

if (args.Length < 2)
{
    Console.Error.WriteLine("Usage: MapRepair.EntryStrings <map-path> <entry-name> [pattern]");
    return 1;
}

var mapPath = Path.GetFullPath(args[0]);
var entryName = args[1];
var pattern = args.Length > 2 ? args[2] : string.Empty;

var archiveReaderType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
var readResultType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;
var open = archiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
var readFile = archiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
var dispose = archiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
var existsProp = readResultType.GetProperty("Exists", BindingFlags.Public | BindingFlags.Instance)!;
var readableProp = readResultType.GetProperty("Readable", BindingFlags.Public | BindingFlags.Instance)!;
var dataProp = readResultType.GetProperty("Data", BindingFlags.Public | BindingFlags.Instance)!;

var archive = open.Invoke(null, [mapPath]);
try
{
    var result = readFile.Invoke(archive, [entryName])!;
    var exists = (bool)existsProp.GetValue(result)!;
    var readable = (bool)readableProp.GetValue(result)!;
    if (!exists || !readable)
    {
        Console.Error.WriteLine($"Entry not readable: {entryName}");
        return 2;
    }

    var data = (byte[]?)dataProp.GetValue(result);
    if (data is null)
    {
        Console.Error.WriteLine($"Entry has no data: {entryName}");
        return 3;
    }

    foreach (var value in ExtractAsciiStrings(data))
    {
        if (!string.IsNullOrWhiteSpace(pattern) &&
            value.IndexOf(pattern, StringComparison.OrdinalIgnoreCase) < 0)
        {
            continue;
        }

        Console.WriteLine(value);
    }
}
finally
{
    dispose.Invoke(archive, []);
}

return 0;

static IEnumerable<string> ExtractAsciiStrings(byte[] data)
{
    var buffer = new List<byte>();
    foreach (var value in data)
    {
        if (value is >= 32 and <= 126)
        {
            buffer.Add(value);
            continue;
        }

        if (buffer.Count >= 4)
        {
            yield return Encoding.ASCII.GetString(buffer.ToArray());
        }

        buffer.Clear();
    }

    if (buffer.Count >= 4)
    {
        yield return Encoding.ASCII.GetString(buffer.ToArray());
    }
}
