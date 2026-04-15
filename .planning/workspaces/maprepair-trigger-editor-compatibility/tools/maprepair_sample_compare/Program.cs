using System.Reflection;
using System.Text;
using System.Text.Json;
using MapRepair.Core;

if (args.Length < 3)
{
    Console.Error.WriteLine("Usage: MapRepair.SampleCompare <repo-root> <sample-script-path> <output-dir> [reference-wtg-path] [reference-wct-path]");
    return 1;
}

var repoRoot = Path.GetFullPath(args[0]);
var scriptPath = Path.GetFullPath(args[1]);
var outputDir = Path.GetFullPath(args[2]);
var referenceWtgPath = args.Length >= 4
    ? Path.GetFullPath(args[3])
    : TryGetSiblingFile(scriptPath, "war3map.wtg");
var referenceWctPath = args.Length >= 5
    ? Path.GetFullPath(args[4])
    : TryGetSiblingFile(scriptPath, "war3map.wct");

Directory.CreateDirectory(outputDir);
Directory.CreateDirectory(Path.Combine(outputDir, "RecoveredGui"));

var assembly = typeof(MapRepairService).Assembly;
var bindingFlags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Instance;

var metadataType = assembly.GetType("MapRepair.Core.Internal.Gui.GuiMetadataCatalog", throwOnError: true)!;
var parserType = assembly.GetType("MapRepair.Core.Internal.Gui.JassGuiReconstructionParser", throwOnError: true)!;
var codecType = assembly.GetType("MapRepair.Core.Internal.Gui.LegacyGuiBinaryCodec", throwOnError: true)!;
var textFileCodecType = assembly.GetType("MapRepair.Core.Internal.TextFileCodec", throwOnError: true)!;
var scriptDocumentType = parserType.GetNestedType("JassScriptDocument", bindingFlags)!;

var metadataLoad = metadataType.GetMethods(bindingFlags)
    .Single(method => method.Name == "Load" && method.GetParameters().Length == 2);
var decodeMethod = textFileCodecType.GetMethod("Decode", bindingFlags)!;
var reconstructMethod = parserType.GetMethod("Reconstruct", bindingFlags)!;
var writeWtgMethod = codecType.GetMethod("WriteWtg", bindingFlags)!;
var writeWctMethod = codecType.GetMethod("WriteWct", bindingFlags)!;
var readWtgAndWctMethod = codecType.GetMethod("ReadWtgAndWct", bindingFlags)!;
var parseScriptMethod = scriptDocumentType.GetMethod("Parse", bindingFlags)!;
var createDisplayNameMethod = parserType.GetMethod("CreateDisplayName", bindingFlags)!;
var normalizeCodeLineMethod = parserType.GetMethod("NormalizeCodeLine", bindingFlags)!;
var splitArgumentsMethod = parserType.GetMethod("SplitArguments", bindingFlags)!;

var emptyArchiveEntries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
var metadata = metadataLoad.Invoke(null, [repoRoot, emptyArchiveEntries])!;
var decoded = decodeMethod.Invoke(null, [File.ReadAllBytes(scriptPath)])!;
var scriptText = (string)(decoded.GetType().GetProperty("Text", bindingFlags)!.GetValue(decoded) ?? string.Empty);
var scriptDocument = parseScriptMethod.Invoke(null, [scriptText])!;
var parser = Activator.CreateInstance(parserType)!;
var result = reconstructMethod.Invoke(parser, [scriptText, metadata])!;

var succeeded = (bool)(result.GetType().GetProperty("Succeeded", bindingFlags)!.GetValue(result) ?? false);
var document = result.GetType().GetProperty("Document", bindingFlags)!.GetValue(result);
var summary = result.GetType().GetProperty("Summary", bindingFlags)!.GetValue(result);
var artifacts = GetList(result, "TriggerArtifacts");
var helperRegistrationSummary = BuildHelperRegistrationSummary(
    scriptDocument,
    createDisplayNameMethod,
    normalizeCodeLineMethod,
    splitArgumentsMethod);
var referenceSummary = TryBuildReferenceSummary(
    referenceWtgPath,
    referenceWctPath,
    scriptText,
    metadata,
    readWtgAndWctMethod);

File.WriteAllText(
    Path.Combine(outputDir, "summary.json"),
    JsonSerializer.Serialize(new
    {
        succeeded,
        summary = summary is null ? null : ReadObject(summary),
        artifactCount = artifacts.Count,
        helperInitAnalysis = helperRegistrationSummary,
        reference = referenceSummary
    }, new JsonSerializerOptions { WriteIndented = true }),
    Encoding.UTF8);

foreach (var artifact in artifacts)
{
    var stem = GetString(artifact, "PathStem");
    var lmlText = GetNullableString(artifact, "LmlText");
    var customText = GetNullableString(artifact, "CustomText");
    var notes = GetStrings(artifact, "Notes");
    var matchedPrivate = GetStrings(artifact, "MatchedPrivateSemantics");
    var unmatched = GetStrings(artifact, "UnmatchedPrivateSemantics");

    if (!string.IsNullOrWhiteSpace(lmlText))
    {
        File.WriteAllText(Path.Combine(outputDir, "RecoveredGui", $"{stem}.lml"), lmlText, Encoding.UTF8);
    }

    if (!string.IsNullOrWhiteSpace(customText))
    {
        File.WriteAllText(Path.Combine(outputDir, "RecoveredGui", $"{stem}.j"), customText, Encoding.UTF8);
    }

    File.WriteAllText(
        Path.Combine(outputDir, "RecoveredGui", $"{stem}.meta.txt"),
        BuildMeta(stem, notes, matchedPrivate, unmatched),
        Encoding.UTF8);
}

if (succeeded && document is not null)
{
    var wtgBytes = (byte[])writeWtgMethod.Invoke(null, [document])!;
    var wctBytes = (byte[])writeWctMethod.Invoke(null, [document])!;
    File.WriteAllBytes(Path.Combine(outputDir, "sample-reconstructed.wtg"), wtgBytes);
    File.WriteAllBytes(Path.Combine(outputDir, "sample-reconstructed.wct"), wctBytes);
}

return succeeded ? 0 : 2;

static string? TryGetSiblingFile(string filePath, string siblingName)
{
    var directory = Path.GetDirectoryName(filePath);
    if (string.IsNullOrWhiteSpace(directory))
    {
        return null;
    }

    var path = Path.Combine(directory, siblingName);
    return File.Exists(path) ? path : null;
}

static IReadOnlyList<object> GetList(object instance, string propertyName)
{
    var property = instance.GetType().GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
    var enumerable = property?.GetValue(instance) as System.Collections.IEnumerable;
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

static object? GetPropertyValue(object instance, string propertyName) =>
    instance.GetType()
        .GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)?
        .GetValue(instance);

static string GetString(object instance, string propertyName) =>
    (string?)instance.GetType()
        .GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)?
        .GetValue(instance) ?? string.Empty;

static string? GetNullableString(object instance, string propertyName) =>
    (string?)instance.GetType()
        .GetProperty(propertyName, BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance)?
        .GetValue(instance);

static IReadOnlyList<string> GetStrings(object instance, string propertyName) =>
    GetList(instance, propertyName).Select(item => item.ToString() ?? string.Empty).ToArray();

static object ReadObject(object instance)
{
    var result = new Dictionary<string, object?>(StringComparer.Ordinal);
    foreach (var property in instance.GetType().GetProperties(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance))
    {
        result[property.Name] = property.GetValue(instance) switch
        {
            null => null,
            string value => value,
            bool value => value,
            int value => value,
            long value => value,
            _ when property.PropertyType.IsPrimitive => property.GetValue(instance),
            System.Collections.IEnumerable values when property.PropertyType != typeof(string) =>
                values.Cast<object?>().Select(value => value?.ToString()).ToArray(),
            var value => value?.ToString()
        };
    }

    return result;
}

static object BuildHelperRegistrationSummary(
    object scriptDocument,
    MethodInfo createDisplayNameMethod,
    MethodInfo normalizeCodeLineMethod,
    MethodInfo splitArgumentsMethod)
{
    var standardRegisterCounts = new Dictionary<string, int>(StringComparer.Ordinal);
    var helperRegisterCounts = new Dictionary<string, int>(StringComparer.Ordinal);
    var helperEventLabelCounts = new Dictionary<string, int>(StringComparer.Ordinal);
    var helperOnlyTriggers = new List<object>();
    var noRecognizedRegistrationTriggers = new List<string>();
    var initTriggerCalls = GetList(scriptDocument, "InitTriggerCalls")
        .Select(item => item.ToString() ?? string.Empty)
        .Where(static value => !string.IsNullOrWhiteSpace(value))
        .ToArray();

    var functions = GetPropertyValue(scriptDocument, "Functions");
    for (var index = 0; index < initTriggerCalls.Length; index++)
    {
        var initTriggerName = initTriggerCalls[index];
        var function = TryGetDictionaryValue(functions, initTriggerName);
        if (function is null)
        {
            continue;
        }

        var displayName = (string?)createDisplayNameMethod.Invoke(null, [function, index + 1]) ?? initTriggerName;
        var standardCount = 0;
        var helperCount = 0;
        var helperCalls = new List<object>();

        foreach (var rawLine in GetList(function, "BodyLines"))
        {
            var line = rawLine.ToString() ?? string.Empty;
            var normalizedLine = (string?)normalizeCodeLineMethod.Invoke(null, [line]) ?? string.Empty;
            if (string.IsNullOrWhiteSpace(normalizedLine))
            {
                continue;
            }

            var match = System.Text.RegularExpressions.Regex.Match(
                normalizedLine,
                @"^\s*call\s+([A-Za-z0-9_]+)\s*\((.*)\)\s*$");
            if (!match.Success)
            {
                continue;
            }

            var functionName = match.Groups[1].Value;
            if (functionName.StartsWith("TriggerRegister", StringComparison.Ordinal))
            {
                standardCount++;
                Increment(standardRegisterCounts, functionName);
                continue;
            }

            if (string.Equals(functionName, "TriggerAddAction", StringComparison.Ordinal) ||
                string.Equals(functionName, "TriggerAddCondition", StringComparison.Ordinal) ||
                IsIgnorableOpaqueInitCallName(functionName))
            {
                continue;
            }

            helperCount++;
            Increment(helperRegisterCounts, functionName);
            var rawArguments = match.Groups[2].Value;
            var arguments = ((System.Collections.IEnumerable?)splitArgumentsMethod.Invoke(null, [rawArguments]))
                ?.Cast<object?>()
                .Select(static value => value?.ToString() ?? string.Empty)
                .ToArray() ?? [];

            var helperLabel = arguments
                .Where(static value => IsQuotedStringLiteral(value))
                .Select(UnquoteStringLiteral)
                .LastOrDefault(static value => !string.IsNullOrWhiteSpace(value));
            if (!string.IsNullOrWhiteSpace(helperLabel))
            {
                Increment(helperEventLabelCounts, helperLabel);
            }

            helperCalls.Add(new
            {
                function = functionName,
                label = helperLabel,
                arguments
            });
        }

        if (helperCount > 0 && standardCount == 0)
        {
            helperOnlyTriggers.Add(new
            {
                initTrigger = initTriggerName,
                displayName,
                helperCount,
                helpers = helperCalls.Take(12).ToArray()
            });
        }
        else if (helperCount == 0 && standardCount == 0)
        {
            noRecognizedRegistrationTriggers.Add(displayName);
        }
    }

    return new
    {
        initTriggerCount = initTriggerCalls.Length,
        standardRegisterCount = standardRegisterCounts.Values.Sum(),
        helperRegisterCount = helperRegisterCounts.Values.Sum(),
        standardRegisterFunctions = standardRegisterCounts.OrderByDescending(static pair => pair.Value).ToArray(),
        helperRegisterFunctions = helperRegisterCounts.OrderByDescending(static pair => pair.Value).ToArray(),
        helperEventLabels = helperEventLabelCounts.OrderByDescending(static pair => pair.Value).ToArray(),
        helperOnlyTriggerCount = helperOnlyTriggers.Count,
        helperOnlyTriggers = helperOnlyTriggers.Take(24).ToArray(),
        noRecognizedRegistrationCount = noRecognizedRegistrationTriggers.Count,
        noRecognizedRegistrationTriggers = noRecognizedRegistrationTriggers.Take(24).ToArray()
    };
}

static object? TryBuildReferenceSummary(
    string? referenceWtgPath,
    string? referenceWctPath,
    string scriptText,
    object metadata,
    MethodInfo readWtgAndWctMethod)
{
    if (string.IsNullOrWhiteSpace(referenceWtgPath) ||
        string.IsNullOrWhiteSpace(referenceWctPath) ||
        !File.Exists(referenceWtgPath) ||
        !File.Exists(referenceWctPath))
    {
        return null;
    }

    string? decodeFailure = null;
    string? decodeFailureSymbol = null;
    bool? decodeFailureSymbolPresentInScript = null;
    object? decoded = null;
    try
    {
        var document = readWtgAndWctMethod.Invoke(null, [File.ReadAllBytes(referenceWtgPath), File.ReadAllBytes(referenceWctPath), metadata])!;
        decoded = new
        {
            categoryCount = GetList(document, "Categories").Count,
            variableCount = GetList(document, "Variables").Count,
            triggerCount = GetList(document, "Triggers").Count
        };
    }
    catch (TargetInvocationException exception)
    {
        decodeFailure = exception.InnerException?.Message ?? exception.Message;
        decodeFailureSymbol = ExtractMissingGuiSymbol(decodeFailure);
        if (!string.IsNullOrWhiteSpace(decodeFailureSymbol))
        {
            decodeFailureSymbolPresentInScript = scriptText.Contains(decodeFailureSymbol, StringComparison.Ordinal);
        }
    }

    return new
    {
        wtgPath = referenceWtgPath,
        wctPath = referenceWctPath,
        raw = ReadReferenceHeaderSummary(referenceWtgPath, referenceWctPath),
        decoded,
        decodeFailure,
        decodeFailureSymbol,
        decodeFailureSymbolPresentInScript
    };
}

static object ReadReferenceHeaderSummary(string wtgPath, string wctPath)
{
    var categoryNames = new List<string>();
    var variableNames = new List<string>();
    int categoryCount;
    int variableCount;
    int triggerCount;

    using (var stream = new MemoryStream(File.ReadAllBytes(wtgPath)))
    using (var reader = new BinaryReader(stream, new UTF8Encoding(false), leaveOpen: false))
    {
        var signature = Encoding.UTF8.GetString(reader.ReadBytes(4));
        if (!string.Equals(signature, "WTG!", StringComparison.Ordinal))
        {
            throw new InvalidDataException($"Invalid WTG signature in `{wtgPath}`.");
        }

        var version = reader.ReadInt32();
        if (version != 7)
        {
            throw new InvalidDataException($"Unsupported WTG version `{version}` in `{wtgPath}`.");
        }

        categoryCount = reader.ReadInt32();
        for (var index = 0; index < categoryCount; index++)
        {
            _ = reader.ReadInt32();
            categoryNames.Add(ReadCString(reader));
            _ = reader.ReadInt32();
        }

        _ = reader.ReadInt32();
        variableCount = reader.ReadInt32();
        for (var index = 0; index < variableCount; index++)
        {
            variableNames.Add(ReadCString(reader));
            _ = ReadCString(reader);
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = reader.ReadInt32();
            _ = ReadCString(reader);
        }

        triggerCount = reader.ReadInt32();
    }

    int wctTriggerCount;
    int nonEmptyTriggerTextCount = 0;
    int globalCustomCodeLength = 0;
    using (var stream = new MemoryStream(File.ReadAllBytes(wctPath)))
    using (var reader = new BinaryReader(stream, new UTF8Encoding(false), leaveOpen: false))
    {
        var version = reader.ReadInt32();
        if (version != 1)
        {
            throw new InvalidDataException($"Unsupported WCT version `{version}` in `{wctPath}`.");
        }

        _ = ReadCString(reader);
        globalCustomCodeLength = reader.ReadInt32();
        if (globalCustomCodeLength > 0)
        {
            _ = ReadCString(reader);
        }

        wctTriggerCount = reader.ReadInt32();
        for (var index = 0; index < wctTriggerCount; index++)
        {
            var textLength = reader.ReadInt32();
            if (textLength > 0)
            {
                nonEmptyTriggerTextCount++;
                _ = ReadCString(reader);
            }
        }
    }

    return new
    {
        categoryCount,
        categoryNames = categoryNames.Take(20).ToArray(),
        variableCount,
        variableNames = variableNames.Take(20).ToArray(),
        triggerCount,
        wctTriggerCount,
        nonEmptyTriggerTextCount,
        globalCustomCodeLength
    };
}

static string ReadCString(BinaryReader reader)
{
    using var stream = new MemoryStream();
    while (true)
    {
        var current = reader.ReadByte();
        if (current == 0)
        {
            return Encoding.UTF8.GetString(stream.ToArray());
        }

        stream.WriteByte(current);
    }
}

static object? TryGetDictionaryValue(object? dictionary, string key)
{
    if (dictionary is null)
    {
        return null;
    }

    var tryGetValue = dictionary.GetType().GetMethod("TryGetValue");
    if (tryGetValue is null)
    {
        return null;
    }

    var parameters = new object?[] { key, null };
    var found = (bool)(tryGetValue.Invoke(dictionary, parameters) ?? false);
    return found ? parameters[1] : null;
}

static string UnquoteStringLiteral(string value)
{
    if (value.Length >= 2 && value[0] == '"' && value[^1] == '"')
    {
        return value[1..^1].Replace("\"\"", "\"", StringComparison.Ordinal);
    }

    return value;
}

static bool IsQuotedStringLiteral(string value)
{
    var trimmed = value.Trim();
    return trimmed.Length >= 2 && trimmed[0] == '"' && trimmed[^1] == '"';
}

static string? ExtractMissingGuiSymbol(string? decodeFailure)
{
    if (string.IsNullOrWhiteSpace(decodeFailure))
    {
        return null;
    }

    var match = System.Text.RegularExpressions.Regex.Match(
        decodeFailure,
        @"`(?:Event|Condition|Action|Call):([^`]+)`");
    return match.Success ? match.Groups[1].Value : null;
}

static void Increment(Dictionary<string, int> map, string key)
{
    map.TryGetValue(key, out var current);
    map[key] = current + 1;
}

static bool IsIgnorableOpaqueInitCallName(string functionName) =>
    string.Equals(functionName, "DisableTrigger", StringComparison.Ordinal) ||
    string.Equals(functionName, "EnableTrigger", StringComparison.Ordinal) ||
    string.Equals(functionName, "TriggerExecute", StringComparison.Ordinal) ||
    string.Equals(functionName, "ConditionalTriggerExecute", StringComparison.Ordinal);

static string BuildMeta(
    string stem,
    IReadOnlyList<string> notes,
    IReadOnlyList<string> matchedPrivate,
    IReadOnlyList<string> unmatched)
{
    var builder = new StringBuilder();
    builder.AppendLine($"stem: {stem}");

    builder.AppendLine("notes:");
    if (notes.Count == 0)
    {
        builder.AppendLine("  -");
    }
    else
    {
        foreach (var note in notes)
        {
            builder.AppendLine($"  - {note}");
        }
    }

    builder.AppendLine("matchedPrivate:");
    if (matchedPrivate.Count == 0)
    {
        builder.AppendLine("  -");
    }
    else
    {
        foreach (var item in matchedPrivate)
        {
            builder.AppendLine($"  - {item}");
        }
    }

    builder.AppendLine("unmatchedPrivate:");
    if (unmatched.Count == 0)
    {
        builder.AppendLine("  -");
    }
    else
    {
        foreach (var item in unmatched)
        {
            builder.AppendLine($"  - {item}");
        }
    }

    return builder.ToString();
}
