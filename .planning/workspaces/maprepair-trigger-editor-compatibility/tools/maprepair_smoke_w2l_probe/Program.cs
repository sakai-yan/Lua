using System.Diagnostics;
using System.Reflection;
using System.Text;
using MapRepair.Core;

var options = ParseArgs(args);
var repoRoot = options.TryGetValue("repo-root", out var explicitRepoRoot)
    ? Path.GetFullPath(explicitRepoRoot)
    : FindRepoRoot(Directory.GetCurrentDirectory(), AppContext.BaseDirectory);
var outputRoot = options.TryGetValue("output-root", out var explicitOutput)
    ? Path.GetFullPath(explicitOutput)
    : Path.Combine(repoRoot, ".planning", "workspaces", "maprepair-trigger-editor-compatibility", "tmp", "smoke-w2l-probe");
var includeShadow = options.ContainsKey("include-shadow");
var includeTriggerTemplates = options.ContainsKey("include-trigger-templates");

if (Directory.Exists(outputRoot))
{
    Directory.Delete(outputRoot, recursive: true);
}

Directory.CreateDirectory(outputRoot);

var coreAssembly = typeof(MapRepairService).Assembly;
var repoType = coreAssembly.GetType("MapRepair.Core.Internal.RepositoryLocator", throwOnError: true)!;
var templateRepoType = coreAssembly.GetType("MapRepair.Core.Internal.TemplateRepository", throwOnError: true)!;
var w3iLoaderType = coreAssembly.GetType("MapRepair.Core.Internal.W3iIniTemplateLoader", throwOnError: true)!;
var w3eReaderType = coreAssembly.GetType("MapRepair.Core.Internal.W3eReader", throwOnError: true)!;
var w3iWriterType = coreAssembly.GetType("MapRepair.Core.Internal.W3iBinaryWriter", throwOnError: true)!;
var wpmWriterType = coreAssembly.GetType("MapRepair.Core.Internal.WpmWriter", throwOnError: true)!;
var doodadWriterType = coreAssembly.GetType("MapRepair.Core.Internal.DoodadWriter", throwOnError: true)!;
var mpqWriterType = coreAssembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveWriter", throwOnError: true)!;
var archiveReaderType = coreAssembly.GetType("MapRepair.Core.Internal.Mpq.MpqArchiveReader", throwOnError: true)!;
var entryReadResultType = coreAssembly.GetType("MapRepair.Core.Internal.Mpq.MpqEntryReadResult", throwOnError: true)!;

var locateMethod = repoType.GetMethod("Locate", BindingFlags.Public | BindingFlags.Static)!;
var repository = locateMethod.Invoke(null, [])!;
var rootPath = (string)repository.GetType().GetProperty("RootPath")!.GetValue(repository)!;

var templateRepository = Activator.CreateInstance(templateRepoType, repository)!;
var readMapInfoTemplateMethod = templateRepoType.GetMethod("ReadMapInfoTemplate", BindingFlags.Public | BindingFlags.Instance)!;
var readTerrainTemplateMethod = templateRepoType.GetMethod("ReadTerrainTemplate", BindingFlags.Public | BindingFlags.Instance)!;
var readTriggerDataTemplateMethod = templateRepoType.GetMethod("ReadTriggerDataTemplate", BindingFlags.Public | BindingFlags.Instance)!;
var readTriggerStringsTemplateMethod = templateRepoType.GetMethod("ReadTriggerStringsTemplate", BindingFlags.Public | BindingFlags.Instance)!;
var readShadowTemplateMethod = templateRepoType.GetMethod("ReadShadowTemplate", BindingFlags.Public | BindingFlags.Instance)!;

var mapInfoTemplate = readMapInfoTemplateMethod.Invoke(templateRepository, [])!;
var terrainBytes = (byte[])readTerrainTemplateMethod.Invoke(templateRepository, [])!;

var w3iLoader = Activator.CreateInstance(w3iLoaderType)!;
var loadMapInfoMethod = w3iLoaderType.GetMethod("Load", BindingFlags.Public | BindingFlags.Instance)!;
var mapInfo = loadMapInfoMethod.Invoke(w3iLoader, [mapInfoTemplate])!;

var tryReadTerrainInfoMethod = w3eReaderType.GetMethod("TryReadTerrainInfo", BindingFlags.Public | BindingFlags.Static)!;
var terrainArgs = new object?[] { terrainBytes, null };
var terrainReadOk = (bool)tryReadTerrainInfoMethod.Invoke(null, terrainArgs)!;
if (!terrainReadOk)
{
    throw new InvalidOperationException("Failed to parse terrain template.");
}

var terrain = terrainArgs[1]!;

var entries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase)
{
    ["war3map.j"] = CreateGuiRecoveryScript(),
    ["war3map.w3i"] = (byte[])w3iWriterType.GetMethod("Write", BindingFlags.Public | BindingFlags.Static)!.Invoke(null, [mapInfo, terrain, "SmokeMap"])!,
    ["war3map.w3e"] = terrainBytes,
    ["war3map.wpm"] = (byte[])wpmWriterType.GetMethod("Write", BindingFlags.Public | BindingFlags.Static)!.Invoke(null, [terrain])!,
    ["war3map.doo"] = (byte[])doodadWriterType.GetMethod("WriteEmptyDoodads", BindingFlags.Public | BindingFlags.Static)!.Invoke(null, [])!,
    ["war3mapUnits.doo"] = (byte[])doodadWriterType.GetMethod("WriteEmptyUnits", BindingFlags.Public | BindingFlags.Static)!.Invoke(null, [])!,
    ["(listfile)"] = Array.Empty<byte>(),
};

if (includeTriggerTemplates)
{
    entries["war3map.wtg"] = (byte[])readTriggerDataTemplateMethod.Invoke(templateRepository, [])!;
    entries["war3map.wct"] = (byte[])readTriggerStringsTemplateMethod.Invoke(templateRepository, [])!;
}

if (includeShadow)
{
    entries["war3map.shd"] = (byte[])readShadowTemplateMethod.Invoke(templateRepository, [])!;
}

var inputMapPath = Path.Combine(outputRoot, "w2l-gui-reconstruction.w3x");
var repairedMapPath = Path.Combine(outputRoot, "w2l-gui-reconstruction_repaired.w3x");
var reportPath = Path.Combine(outputRoot, "w2l-gui-reconstruction_report");
var stagePath = Path.Combine(outputRoot, "w2l-stage");
var lniOutputPath = Path.Combine(outputRoot, "w2l-output");

mpqWriterType.GetMethod("WriteArchive", BindingFlags.Public | BindingFlags.Static)!.Invoke(null, [inputMapPath, entries]);

var service = new MapRepairService();
var repairResult = service.Repair(new RepairOptions(inputMapPath, repairedMapPath, reportPath, OverwriteOutput: true));

PrepareW2lStage(rootPath, stagePath);
Directory.CreateDirectory(lniOutputPath);

var startInfo = new ProcessStartInfo
{
    FileName = Path.Combine(stagePath, "w2l.exe"),
    Arguments = $"lni \"{repairedMapPath}\" \"{lniOutputPath}\"",
    WorkingDirectory = stagePath,
    UseShellExecute = false,
    RedirectStandardOutput = true,
    RedirectStandardError = true,
    StandardOutputEncoding = Encoding.UTF8,
    StandardErrorEncoding = Encoding.UTF8,
};

using var process = Process.Start(startInfo);
if (process is null)
{
    throw new InvalidOperationException("Failed to start staged w2l.exe.");
}

var stdout = process.StandardOutput.ReadToEnd();
var stderr = process.StandardError.ReadToEnd();
process.WaitForExit();

var archiveOpenMethod = archiveReaderType.GetMethod("Open", BindingFlags.Public | BindingFlags.Static)!;
var archiveReadMethod = archiveReaderType.GetMethod("ReadFile", BindingFlags.Public | BindingFlags.Instance)!;
var archiveDisposeMethod = archiveReaderType.GetMethod("Dispose", BindingFlags.Public | BindingFlags.Instance)!;
var existsProperty = entryReadResultType.GetProperty("Exists", BindingFlags.Public | BindingFlags.Instance)!;
var readableProperty = entryReadResultType.GetProperty("Readable", BindingFlags.Public | BindingFlags.Instance)!;
var dataProperty = entryReadResultType.GetProperty("Data", BindingFlags.Public | BindingFlags.Instance)!;

var archive = archiveOpenMethod.Invoke(null, [repairedMapPath]);
var entrySummary = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
try
{
    foreach (var entryPath in new[]
             {
                 "war3map.w3i",
                 "war3map.w3e",
                 "war3map.wpm",
                 "war3map.doo",
                 "war3mapUnits.doo",
                 "war3map.wtg",
                 "war3map.wct",
                 "war3map.j",
                 "war3map.shd",
                 "(listfile)",
             })
    {
        var result = archiveReadMethod.Invoke(archive, [entryPath])!;
        entrySummary[entryPath] = new
        {
            exists = (bool)existsProperty.GetValue(result)!,
            readable = (bool)readableProperty.GetValue(result)!,
            length = ((byte[]?)dataProperty.GetValue(result))?.Length ?? 0,
        };
    }
}
finally
{
    archiveDisposeMethod.Invoke(archive, []);
}

var errorLogDir = Path.Combine(stagePath, "log", "error");
var latestErrorLog = Directory.Exists(errorLogDir)
    ? Directory.GetFiles(errorLogDir).OrderByDescending(File.GetLastWriteTimeUtc).FirstOrDefault()
    : null;

var resultPayload = new
{
    repoRoot = rootPath,
    outputRoot,
    includeShadow,
    includeTriggerTemplates,
    repairWarnings = repairResult.Warnings,
    repairGeneratedFiles = repairResult.GeneratedFiles,
    repairedMapEntries = entrySummary,
    w2l = new
    {
        exitCode = process.ExitCode,
        stdout,
        stderr,
        outputEntries = Directory.Exists(lniOutputPath)
            ? Directory.GetFileSystemEntries(lniOutputPath).Select(Path.GetFileName).OrderBy(name => name).ToArray()
            : Array.Empty<string>(),
        errorLogPath = latestErrorLog,
        errorLog = latestErrorLog is null ? null : File.ReadAllText(latestErrorLog, Encoding.UTF8),
    },
};

var json = System.Text.Json.JsonSerializer.Serialize(resultPayload, new System.Text.Json.JsonSerializerOptions
{
    WriteIndented = true
});

File.WriteAllText(Path.Combine(outputRoot, "result.json"), json, Encoding.UTF8);
Console.WriteLine(json);

static string FindRepoRoot(params string[] startDirectories)
{
    foreach (var startDirectory in startDirectories)
    {
        var current = Path.GetFullPath(startDirectory);
        while (!string.IsNullOrWhiteSpace(current))
        {
            if (File.Exists(Path.Combine(current, "War3", "map", "war3map.w3i")) &&
                Directory.Exists(Path.Combine(current, ".tools", "MapRepair")))
            {
                return current;
            }

            var parent = Path.GetDirectoryName(current);
            if (string.IsNullOrWhiteSpace(parent) || string.Equals(parent, current, StringComparison.OrdinalIgnoreCase))
            {
                break;
            }

            current = parent;
        }
    }

    throw new DirectoryNotFoundException("Failed to locate repository root.");
}

static Dictionary<string, string> ParseArgs(string[] args)
{
    var result = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
    foreach (var arg in args)
    {
        if (!arg.StartsWith("--", StringComparison.Ordinal))
        {
            continue;
        }

        var split = arg.IndexOf('=', 2);
        if (split < 0)
        {
            result[arg[2..]] = "1";
            continue;
        }

        result[arg[2..split]] = arg[(split + 1)..];
    }

    return result;
}

static byte[] CreateGuiRecoveryScript()
{
    return Encoding.UTF8.GetBytes("""
globals
    trigger gg_trg_Recovered = null
    integer udg_Count = 0
    string udg_Name = ""
    integer array udg_Array
endglobals

function InitGlobals takes nothing returns nothing
    set udg_Count = 7
    set udg_Name = "Recovered"
endfunction

function Trig_RecoveredActions takes nothing returns nothing
    call BJDebugMsg("Recovered trigger fired")
endfunction

function InitTrig_Recovered takes nothing returns nothing
    set gg_trg_Recovered = CreateTrigger()
    call TriggerRegisterTimerEventPeriodic(gg_trg_Recovered, 0.25)
    call TriggerAddAction(gg_trg_Recovered, function Trig_RecoveredActions)
endfunction

function InitCustomTriggers takes nothing returns nothing
    call InitTrig_Recovered()
endfunction

function main takes nothing returns nothing
    call InitGlobals()
    call InitCustomTriggers()
    call ConditionalTriggerExecute(gg_trg_Recovered)
endfunction
""");
}

static void PrepareW2lStage(string repoRoot, string stageRoot)
{
    if (Directory.Exists(stageRoot))
    {
        Directory.Delete(stageRoot, recursive: true);
    }

    Directory.CreateDirectory(stageRoot);
    var sourceRoot = Path.Combine(repoRoot, ".canon", "w3x2lni");
    File.Copy(Path.Combine(sourceRoot, "w2l.exe"), Path.Combine(stageRoot, "w2l.exe"), overwrite: true);
    CopyDirectory(Path.Combine(sourceRoot, "bin"), Path.Combine(stageRoot, "bin"));
    CopyDirectory(Path.Combine(sourceRoot, "script"), Path.Combine(stageRoot, "script"));
    CopyDirectory(Path.Combine(sourceRoot, "data"), Path.Combine(stageRoot, "data"));

    var configText = File.ReadAllText(Path.Combine(sourceRoot, "config.ini"), Encoding.UTF8)
        .Replace("data_ui = ${YDWE}", "data_ui = ${DATA}", StringComparison.Ordinal);
    File.WriteAllText(Path.Combine(stageRoot, "config.ini"), configText, Encoding.UTF8);

    var pushErrorPath = Path.Combine(stageRoot, "script", "gui", "push_error.lua");
    var pushErrorText = File.ReadAllText(pushErrorPath, Encoding.UTF8)
        .Replace("        script:string(),", "        script:string(),\r\n        '-s',", StringComparison.Ordinal);
    File.WriteAllText(pushErrorPath, pushErrorText, Encoding.UTF8);
}

static void CopyDirectory(string sourceDirectory, string targetDirectory)
{
    Directory.CreateDirectory(targetDirectory);
    foreach (var filePath in Directory.GetFiles(sourceDirectory))
    {
        File.Copy(filePath, Path.Combine(targetDirectory, Path.GetFileName(filePath)), overwrite: true);
    }

    foreach (var sourceSubdirectory in Directory.GetDirectories(sourceDirectory))
    {
        CopyDirectory(sourceSubdirectory, Path.Combine(targetDirectory, Path.GetFileName(sourceSubdirectory)));
    }
}
