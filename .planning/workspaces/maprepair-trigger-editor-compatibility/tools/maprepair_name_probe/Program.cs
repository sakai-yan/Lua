using System.Reflection;
using System.Text;

var inputMap = args.Length > 0
    ? Path.GetFullPath(args[0])
    : Path.GetFullPath(@"d:\Software\魔兽地图编辑\[0]新整合编辑器\Lua\.tools\MapRepair\chuzhang V2 mod2.851.w3x");

var mapRepairCorePath = Path.GetFullPath(Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "..", "..", ".tools", "MapRepair", "src", "MapRepair.Core", "bin", "Debug", "net8.0", "MapRepair.Core.dll"));
var assembly = Assembly.LoadFrom(mapRepairCorePath);

var archiveReaderType = assembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
var gameArchiveSourceType = assembly.GetType("MapRepair.Core.Internal.GameArchiveSource", throwOnError: true)!;
var objectMetadataLoaderType = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataLoader", throwOnError: true)!;
var slkTableParserType = assembly.GetType("MapRepair.Core.Internal.Slk.SlkTableParser", throwOnError: true)!;
var warcraftArchiveLocatorType = assembly.GetType("MapRepair.Core.Internal.WarcraftArchiveLocator", throwOnError: true)!;
var archiveProfileTextOverlayType = assembly.GetType("MapRepair.Core.Internal.ArchiveProfileTextOverlay", throwOnError: true)!;

var mpqOpen = archiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
var mpqReadFile = archiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
var mpqDispose = archiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
var locateWarcraftArchives = warcraftArchiveLocatorType.GetMethod("Locate", BindingFlags.Public | BindingFlags.Static)!;
var metadataRawCodeProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("RawCode")!;
var metadataFieldProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("Field")!;
var metadataSlkTableProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("SlkTable")!;
var metadataTypeProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("Type")!;
var metadataUseUnitProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("UseUnit")!;
var metadataUseHeroProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("UseHero")!;
var metadataUseBuildingProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("UseBuilding")!;
var metadataUseItemProp = assembly.GetType("MapRepair.Core.Internal.ObjectMetadataEntry", throwOnError: true)!.GetProperty("UseItem")!;

var readResultType = assembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;
var resultExists = readResultType.GetProperty("Exists")!;
var resultReadable = readResultType.GetProperty("Readable")!;
var resultData = readResultType.GetProperty("Data")!;

var parseSlk = slkTableParserType.GetMethod("Parse", BindingFlags.Public | BindingFlags.Static)!;
var buildProfileOverlay = archiveProfileTextOverlayType.GetMethod("Build", BindingFlags.Public | BindingFlags.Static)!;
var slkRowsProp = assembly.GetType("MapRepair.Core.Internal.Slk.SlkTable", throwOnError: true)!.GetProperty("Rows")!;
var slkRowValuesProp = assembly.GetType("MapRepair.Core.Internal.Slk.SlkRow", throwOnError: true)!.GetProperty("Values")!;

byte[]? ReadMapEntry(string path)
{
    var archive = mpqOpen.Invoke(null, [inputMap]);
    try
    {
        var result = mpqReadFile.Invoke(archive, [path])!;
        var exists = (bool)resultExists.GetValue(result)!;
        var readable = (bool)resultReadable.GetValue(result)!;
        if (!exists || !readable)
        {
            return null;
        }

        return (byte[]?)resultData.GetValue(result);
    }
    finally
    {
        mpqDispose.Invoke(archive, []);
    }
}

Dictionary<string, Dictionary<string, string>> ParseSlkTable(string tableName, byte[] data)
{
    var table = parseSlk.Invoke(null, [tableName, data])!;
    var rowsObj = (System.Collections.IDictionary)slkRowsProp.GetValue(table)!;
    var rows = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);
    foreach (System.Collections.DictionaryEntry rowEntry in rowsObj)
    {
        var rowId = (string)rowEntry.Key;
        var valuesObj = (System.Collections.Generic.IReadOnlyDictionary<string, string>)slkRowValuesProp.GetValue(rowEntry.Value)!;
        rows[rowId] = new Dictionary<string, string>(valuesObj, StringComparer.OrdinalIgnoreCase);
    }

    return rows;
}

string DecodeText(byte[] data)
{
    try
    {
        return new UTF8Encoding(false, true).GetString(data);
    }
    catch
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
        return Encoding.GetEncoding("GB18030").GetString(data);
    }
}

void CompareTable(string mapEntryPath, string tableName, params string[] nameFields)
{
    var mapData = ReadMapEntry(mapEntryPath);
    if (mapData is null)
    {
        Console.WriteLine($"[{tableName}] map entry missing: {mapEntryPath}");
        return;
    }

    var archivePaths = locateWarcraftArchives.Invoke(null, [])!;
    var gameArchiveSource = Activator.CreateInstance(gameArchiveSourceType, [archivePaths])!;
    var tryRead = gameArchiveSourceType.GetMethod("TryRead", BindingFlags.Public | BindingFlags.Instance)!;
    var stockData = (byte[]?)tryRead.Invoke(gameArchiveSource, [mapEntryPath.Replace("units\\", "Units\\", StringComparison.OrdinalIgnoreCase)]);
    if (stockData is null)
    {
        stockData = (byte[]?)tryRead.Invoke(gameArchiveSource, [mapEntryPath]);
    }

    var mapRows = ParseSlkTable(tableName, mapData);
    var stockRows = stockData is null ? new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase) : ParseSlkTable(tableName, stockData);

    var customNameHits = new List<string>();
    var trigstrHits = new List<string>();

    foreach (var (id, values) in mapRows)
    {
        stockRows.TryGetValue(id, out var stockValues);
        foreach (var field in nameFields)
        {
            if (!values.TryGetValue(field, out var mapValue) || string.IsNullOrWhiteSpace(mapValue))
            {
                continue;
            }

            var stockValue = string.Empty;
            stockValues?.TryGetValue(field, out stockValue);
            if (!string.Equals(mapValue, stockValue, StringComparison.Ordinal))
            {
                customNameHits.Add($"{id} {field} = {mapValue}");
                if (mapValue.StartsWith("TRIGSTR_", StringComparison.OrdinalIgnoreCase))
                {
                    trigstrHits.Add($"{id} {field} = {mapValue}");
                }
                break;
            }
        }
    }

    Console.WriteLine($"[{tableName}] rows={mapRows.Count}, custom-name-diffs={customNameHits.Count}, trigstr-name-diffs={trigstrHits.Count}");
    foreach (var line in customNameHits.Take(20))
    {
        Console.WriteLine($"  {line}");
    }
}

void DumpTextFile(string entryPath, int maxLines = 40)
{
    var data = ReadMapEntry(entryPath);
    if (data is null)
    {
        Console.WriteLine($"[TXT] missing: {entryPath}");
        return;
    }

    Console.WriteLine($"[TXT] {entryPath}");
    foreach (var line in DecodeText(data).Split(['\r', '\n'], StringSplitOptions.RemoveEmptyEntries).Take(maxLines))
    {
        Console.WriteLine($"  {line}");
    }
}

void DumpOverlaySection(params string[] sectionNames)
{
    var mapEntries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
    foreach (var entryPath in new[]
    {
        @"Units\CampaignAbilityStrings.txt",
        @"Units\CampaignUnitFunc.txt",
        @"Units\ItemFunc.txt",
        @"units\neutralupgradestrings.txt"
    })
    {
        var data = ReadMapEntry(entryPath);
        if (data is not null)
        {
            mapEntries[entryPath] = data;
        }
    }

    var overlay = (System.Collections.IDictionary)buildProfileOverlay.Invoke(null, [mapEntries])!;
    Console.WriteLine("[OVERLAY]");
    foreach (var sectionName in sectionNames)
    {
        if (!overlay.Contains(sectionName))
        {
            Console.WriteLine($"  missing section={sectionName}");
            continue;
        }

        Console.WriteLine($"  section={sectionName}");
        var section = (System.Collections.IEnumerable)overlay[sectionName]!;
        foreach (var entry in section)
        {
            var keyProp = entry.GetType().GetProperty("Key")!;
            var valueProp = entry.GetType().GetProperty("Value")!;
            Console.WriteLine($"    {keyProp.GetValue(entry)}={valueProp.GetValue(entry)}");
        }
    }
}

void DumpMetadata(string loaderMethodName, params string[] fields)
{
    var archivePaths = locateWarcraftArchives.Invoke(null, [])!;
    var gameArchiveSource = Activator.CreateInstance(gameArchiveSourceType, [archivePaths])!;
    var loader = Activator.CreateInstance(objectMetadataLoaderType, [gameArchiveSource])!;
    var method = objectMetadataLoaderType.GetMethod(loaderMethodName, BindingFlags.Public | BindingFlags.Instance)!;
    var entries = (System.Collections.IEnumerable)method.Invoke(loader, [])!;

    Console.WriteLine($"[META] {loaderMethodName}");
    foreach (var entry in entries)
    {
        var field = (string)metadataFieldProp.GetValue(entry)!;
        if (!fields.Contains(field, StringComparer.OrdinalIgnoreCase))
        {
            continue;
        }

        var rawCode = (string)metadataRawCodeProp.GetValue(entry)!;
        var slkTable = (string)metadataSlkTableProp.GetValue(entry)!;
        var type = (string)metadataTypeProp.GetValue(entry)!;
        var useUnit = (bool)metadataUseUnitProp.GetValue(entry)!;
        var useHero = (bool)metadataUseHeroProp.GetValue(entry)!;
        var useBuilding = (bool)metadataUseBuildingProp.GetValue(entry)!;
        var useItem = (bool)metadataUseItemProp.GetValue(entry)!;
        Console.WriteLine($"  field={field} raw={rawCode} table={slkTable} type={type} unit={useUnit} hero={useHero} building={useBuilding} item={useItem}");
    }
}

CompareTable(@"Units\AbilityData.slk", "AbilityData", "Name");
CompareTable(@"units\unitdata.slk", "UnitData", "Name", "name");
CompareTable(@"Units\ItemData.slk", "ItemData", "Name", "name");
CompareTable(@"units\abilitybuffdata.slk", "AbilityBuffData", "Bufftip", "Buffubertip", "EditorName", "Name", "name");

DumpMetadata("LoadAbilityMetadata", "Name", "Tip", "Ubertip", "EditorSuffix", "Art");
DumpMetadata("LoadUnitMetadata", "Name", "Tip", "Ubertip", "EditorSuffix", "Description", "Art");
DumpMetadata("LoadAbilityBuffMetadata", "Bufftip", "Buffubertip", "EditorName");
DumpMetadata("LoadUpgradeMetadata", "Name", "Tip", "Ubertip", "Hotkey", "Art");
DumpOverlaySection("T001", "wnw1", "Rhla", "I000");

DumpTextFile(@"Units\CampaignAbilityStrings.txt");
DumpTextFile(@"Units\CampaignUnitFunc.txt");
DumpTextFile(@"Units\ItemFunc.txt");
DumpTextFile(@"units\neutralupgradestrings.txt");
