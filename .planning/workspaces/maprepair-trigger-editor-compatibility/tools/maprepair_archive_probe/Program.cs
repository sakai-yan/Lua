using System.Reflection;
using MapRepair.Core;

if (args.Length >= 1 && string.Equals(args[0], "--extract", StringComparison.OrdinalIgnoreCase))
{
    if (args.Length != 4)
    {
        Console.Error.WriteLine("Usage: MapRepair.ArchiveProbe --extract <map-path> <entry-path> <output-path>");
        return 1;
    }

    var extractMapPath = Path.GetFullPath(args[1]);
    var extractEntryPath = args[2];
    var extractOutputPath = Path.GetFullPath(args[3]);

    var extractArchiveReaderType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
    var extractReadResultType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;
    var extractOpen = extractArchiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
    var extractReadFile = extractArchiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
    var extractDispose = extractArchiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
    var extractExistsProp = extractReadResultType.GetProperty("Exists", BindingFlags.Public | BindingFlags.Instance)!;
    var extractReadableProp = extractReadResultType.GetProperty("Readable", BindingFlags.Public | BindingFlags.Instance)!;
    var extractDataProp = extractReadResultType.GetProperty("Data", BindingFlags.Public | BindingFlags.Instance)!;
    var extractWarningProp = extractReadResultType.GetProperty("Warning", BindingFlags.Public | BindingFlags.Instance)!;

    var extractArchive = extractOpen.Invoke(null, [extractMapPath]);
    try
    {
        var extractResult = extractReadFile.Invoke(extractArchive, [extractEntryPath])!;
        var extractExists = (bool)extractExistsProp.GetValue(extractResult)!;
        var extractReadable = (bool)extractReadableProp.GetValue(extractResult)!;
        var extractData = (byte[]?)extractDataProp.GetValue(extractResult);
        var extractWarning = (string?)extractWarningProp.GetValue(extractResult);

        if (!extractExists || !extractReadable || extractData is null)
        {
            Console.Error.WriteLine($"Failed to extract `{extractEntryPath}` from `{extractMapPath}`. warning={extractWarning}");
            return 1;
        }

        Directory.CreateDirectory(Path.GetDirectoryName(extractOutputPath)!);
        File.WriteAllBytes(extractOutputPath, extractData);
        Console.WriteLine(extractOutputPath);
        return 0;
    }
    finally
    {
        extractDispose.Invoke(extractArchive, []);
    }
}

if (args.Length < 2)
{
    Console.Error.WriteLine("Usage: MapRepair.ArchiveProbe <map-path> <path1> [path2] [...]");
    Console.Error.WriteLine("       MapRepair.ArchiveProbe --extract <map-path> <entry-path> <output-path>");
    return 1;
}

var mapPath = Path.GetFullPath(args[0]);
var probePaths = args.Skip(1).ToArray();

var archiveReaderType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
var readResultType = typeof(MapRepairService).Assembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;
var open = archiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
var readFile = archiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
var dispose = archiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
var existsProp = readResultType.GetProperty("Exists", BindingFlags.Public | BindingFlags.Instance)!;
var readableProp = readResultType.GetProperty("Readable", BindingFlags.Public | BindingFlags.Instance)!;
var dataProp = readResultType.GetProperty("Data", BindingFlags.Public | BindingFlags.Instance)!;
var warningProp = readResultType.GetProperty("Warning", BindingFlags.Public | BindingFlags.Instance)!;

var archive = open.Invoke(null, [mapPath]);
try
{
    foreach (var path in probePaths)
    {
        var result = readFile.Invoke(archive, [path])!;
        var exists = (bool)existsProp.GetValue(result)!;
        var readable = (bool)readableProp.GetValue(result)!;
        var data = (byte[]?)dataProp.GetValue(result);
        var warning = (string?)warningProp.GetValue(result);
        var headHex = string.Empty;
        var headAscii = string.Empty;
        if (data is { Length: > 0 })
        {
            var count = Math.Min(8, data.Length);
            headHex = string.Join(" ", data.Take(count).Select(value => value.ToString("X2")));
            headAscii = string.Concat(data.Take(count).Select(value =>
                value is >= 32 and <= 126 ? (char)value : '.'));
        }

        Console.WriteLine($"{path}\texists={exists}\treadable={readable}\tlength={(data?.Length ?? 0)}\theadHex={headHex}\theadAscii={headAscii}\twarning={warning}");
    }
}
finally
{
    dispose.Invoke(archive, []);
}

return 0;
