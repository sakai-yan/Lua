using System.Reflection;
using System.Text.Json;
using MapRepair.Core;

if (args.Length < 3)
{
    Console.Error.WriteLine("Usage: MapRepair.WtgInspect <repo-root> <wtg-path> <wct-path>");
    return 1;
}

var repoRoot = Path.GetFullPath(args[0]);
var wtgPath = Path.GetFullPath(args[1]);
var wctPath = Path.GetFullPath(args[2]);

var assembly = typeof(MapRepairService).Assembly;
var bindingFlags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Instance;

var metadataType = assembly.GetType("MapRepair.Core.Internal.Gui.GuiMetadataCatalog", throwOnError: true)!;
var codecType = assembly.GetType("MapRepair.Core.Internal.Gui.LegacyGuiBinaryCodec", throwOnError: true)!;
var functionKindType = assembly.GetType("MapRepair.Core.Internal.Gui.LegacyGuiFunctionKind", throwOnError: true)!;

var metadataLoad = metadataType.GetMethods(bindingFlags)
    .Single(method => method.Name == "Load" && method.GetParameters().Length == 2);
var readMethod = codecType.GetMethod("ReadWtgAndWct", bindingFlags)!;
var tryGetEntryMethod = metadataType.GetMethod("TryGetEntry", bindingFlags)!;
var baseNodeNames = LoadBaseNodeNames(repoRoot);

var emptyArchiveEntries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
var metadata = metadataLoad.Invoke(null, [repoRoot, emptyArchiveEntries])!;
var document = readMethod.Invoke(null, [File.ReadAllBytes(wtgPath), File.ReadAllBytes(wctPath), metadata])!;

var triggers = GetList(document, "Triggers");
var variables = GetList(document, "Variables");
var categories = GetList(document, "Categories");

var topEvents = new Dictionary<string, int>(StringComparer.Ordinal);
var topActions = new Dictionary<string, int>(StringComparer.Ordinal);
var topConditions = new Dictionary<string, int>(StringComparer.Ordinal);
var suspiciousTriggers = new List<object>();
var extensionNodes = new Dictionary<string, int>(StringComparer.Ordinal);
var extensionSources = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
var customTextCount = 0;
var runOnInitCount = 0;
var totalChildBlocks = 0;
var maxActionCount = -1;
var maxActionTrigger = string.Empty;

foreach (var trigger in triggers)
{
    var name = GetString(trigger, "Name");
    var isCustomText = GetBool(trigger, "IsCustomText");
    var runOnMapInit = GetBool(trigger, "RunOnMapInit");
    var events = GetList(trigger, "Events");
    var conditions = GetList(trigger, "Conditions");
    var actions = GetList(trigger, "Actions");

    if (isCustomText)
    {
        customTextCount++;
    }

    if (runOnMapInit)
    {
        runOnInitCount++;
    }

    if (actions.Count > maxActionCount)
    {
        maxActionCount = actions.Count;
        maxActionTrigger = name;
    }

    foreach (var node in events)
    {
        var eventName = GetString(node, "Name");
        Increment(topEvents, eventName);
        TrackMetadataSource(metadata, tryGetEntryMethod, functionKindType, baseNodeNames, "Event", eventName, extensionNodes, extensionSources);
        WalkArgumentCalls(node, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
        totalChildBlocks += GetList(node, "ChildBlocks").Count;
    }

    foreach (var node in conditions)
    {
        var conditionName = GetString(node, "Name");
        Increment(topConditions, conditionName);
        TrackMetadataSource(metadata, tryGetEntryMethod, functionKindType, baseNodeNames, "Condition", conditionName, extensionNodes, extensionSources);
        WalkArgumentCalls(node, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
        totalChildBlocks += GetList(node, "ChildBlocks").Count;
    }

    foreach (var node in actions)
    {
        var nodeName = GetString(node, "Name");
        Increment(topActions, nodeName);
        TrackMetadataSource(metadata, tryGetEntryMethod, functionKindType, baseNodeNames, "Action", nodeName, extensionNodes, extensionSources);
        WalkArgumentCalls(node, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
        var childBlocks = GetList(node, "ChildBlocks");
        totalChildBlocks += childBlocks.Count;

        if (childBlocks.Count > 3 || string.Equals(nodeName, "CustomScriptCode", StringComparison.Ordinal))
        {
            suspiciousTriggers.Add(new
            {
                trigger = name,
                node = nodeName,
                childBlocks = childBlocks.Count
            });
        }
    }
}

var payload = new
{
    wtgPath,
    wctPath,
    triggerCount = triggers.Count,
    variableCount = variables.Count,
    categoryCount = categories.Count,
    customTextCount,
    runOnInitCount,
    totalChildBlocks,
    maxActionTrigger,
    maxActionCount,
    topEvents = topEvents.OrderByDescending(static pair => pair.Value).Take(16).ToArray(),
    topActions = topActions.OrderByDescending(static pair => pair.Value).Take(20).ToArray(),
    topConditions = topConditions.OrderByDescending(static pair => pair.Value).Take(16).ToArray(),
    extensionNodes = extensionNodes.OrderByDescending(static pair => pair.Value).Take(40).ToArray(),
    extensionSources = extensionSources.OrderByDescending(static pair => pair.Value).Take(20).ToArray(),
    firstTriggers = triggers.Take(12).Select(trigger => new
    {
        name = GetString(trigger, "Name"),
        isCustomText = GetBool(trigger, "IsCustomText"),
        runOnMapInit = GetBool(trigger, "RunOnMapInit"),
        eventCount = GetList(trigger, "Events").Count,
        conditionCount = GetList(trigger, "Conditions").Count,
        actionCount = GetList(trigger, "Actions").Count
    }).ToArray(),
    suspiciousTriggers = suspiciousTriggers.Take(40).ToArray()
};

Console.WriteLine(JsonSerializer.Serialize(payload, new JsonSerializerOptions
{
    WriteIndented = true
}));
return 0;

static object? GetPropertyValue(object instance, string propertyName)
{
    return instance.GetType().GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)!.GetValue(instance);
}

static string GetString(object instance, string propertyName)
{
    return (string?)GetPropertyValue(instance, propertyName) ?? string.Empty;
}

static bool GetBool(object instance, string propertyName)
{
    return (bool)(GetPropertyValue(instance, propertyName) ?? false);
}

static IReadOnlyList<object> GetList(object instance, string propertyName)
{
    var enumerable = (System.Collections.IEnumerable?)GetPropertyValue(instance, propertyName);
    if (enumerable is null)
    {
        return [];
    }

    var items = new List<object>();
    foreach (var item in enumerable)
    {
        if (item is not null)
        {
            items.Add(item);
        }
    }

    return items;
}

static void Increment(Dictionary<string, int> map, string key)
{
    map.TryGetValue(key, out var current);
    map[key] = current + 1;
}

static void WalkArgumentCalls(
    object node,
    object metadata,
    MethodInfo tryGetEntryMethod,
    Type functionKindType,
    HashSet<string> baseNodeNames,
    Dictionary<string, int> extensionNodes,
    Dictionary<string, int> extensionSources)
{
    foreach (var argument in GetList(node, "Arguments"))
    {
        WalkArgument(argument, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
    }
}

static void WalkArgument(
    object argument,
    object metadata,
    MethodInfo tryGetEntryMethod,
    Type functionKindType,
    HashSet<string> baseNodeNames,
    Dictionary<string, int> extensionNodes,
    Dictionary<string, int> extensionSources)
{
    var callNode = GetPropertyValue(argument, "CallNode");
    if (callNode is not null)
    {
        var callName = GetString(callNode, "Name");
        TrackMetadataSource(metadata, tryGetEntryMethod, functionKindType, baseNodeNames, "Call", callName, extensionNodes, extensionSources);
        WalkArgumentCalls(callNode, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
    }

    var arrayIndex = GetPropertyValue(argument, "ArrayIndex");
    if (arrayIndex is not null)
    {
        WalkArgument(arrayIndex, metadata, tryGetEntryMethod, functionKindType, baseNodeNames, extensionNodes, extensionSources);
    }
}

static void TrackMetadataSource(
    object metadata,
    MethodInfo tryGetEntryMethod,
    Type functionKindType,
    HashSet<string> baseNodeNames,
    string kindName,
    string nodeName,
    Dictionary<string, int> extensionNodes,
    Dictionary<string, int> extensionSources)
{
    if (baseNodeNames.Contains(nodeName))
    {
        return;
    }

    var kind = Enum.Parse(functionKindType, kindName);
    var parameters = new object?[] { kind, nodeName, null };
    var found = (bool)tryGetEntryMethod.Invoke(metadata, parameters)!;
    if (!found || parameters[2] is null)
    {
        Increment(extensionNodes, $"{kindName}:{nodeName} [missing-metadata]");
        Increment(extensionSources, "missing-metadata");
        return;
    }

    var source = GetString(parameters[2], "Source");
    if (IsBaseMetadataSource(source))
    {
        return;
    }

    Increment(extensionNodes, $"{kindName}:{nodeName}");
    Increment(extensionSources, source);
}

static bool IsBaseMetadataSource(string source)
{
    return source.Contains(@"\.tools\w3x2lni\data\", StringComparison.OrdinalIgnoreCase) &&
           source.EndsWith(@"TriggerData.txt", StringComparison.OrdinalIgnoreCase);
}

static HashSet<string> LoadBaseNodeNames(string repoRoot)
{
    var candidates = new[]
    {
        Path.Combine(repoRoot, ".tools", "w3x2lni", "data", "zhCN-1.24.4", "UI", "TriggerData.txt"),
        Path.Combine(repoRoot, ".tools", "w3x2lni", "data", "zhCN-1.24.4", "ui", "TriggerData.txt"),
        Path.Combine(repoRoot, ".tools", "w3x2lni", "data", "zhCN-1.32.8", "UI", "TriggerData.txt"),
        Path.Combine(repoRoot, ".tools", "w3x2lni", "data", "zhCN-1.32.8", "ui", "TriggerData.txt"),
    };

    var path = candidates.FirstOrDefault(File.Exists);
    if (path is null)
    {
        return new HashSet<string>(StringComparer.Ordinal);
    }

    var result = new HashSet<string>(StringComparer.Ordinal);
    foreach (var rawLine in File.ReadLines(path))
    {
        var line = rawLine.Trim();
        if (line.Length == 0 || line.StartsWith("//", StringComparison.Ordinal) || line.StartsWith("[", StringComparison.Ordinal))
        {
            continue;
        }

        var separator = line.IndexOf('=');
        if (separator <= 0)
        {
            continue;
        }

        var key = line[..separator].Trim();
        if (key.Length == 0 || key.StartsWith("_", StringComparison.Ordinal) || key.StartsWith("TC_", StringComparison.Ordinal))
        {
            continue;
        }

        result.Add(key);
    }

    return result;
}
