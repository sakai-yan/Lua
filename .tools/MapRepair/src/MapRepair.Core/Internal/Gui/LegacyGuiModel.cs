using System.Globalization;
using System.Text;
using System.Text.Json.Serialization;

namespace MapRepair.Core.Internal.Gui;

internal enum LegacyGuiFunctionKind
{
    Event = 0,
    Condition = 1,
    Action = 2,
    Call = 3
}

internal enum LegacyGuiArgumentKind
{
    Disabled = -1,
    Preset = 0,
    Variable = 1,
    Call = 2,
    Constant = 3
}

internal sealed record LegacyGuiCategory(int Id, string Name, bool Comment = false);

internal sealed record LegacyGuiVariable(
    string Name,
    string Type,
    bool IsArray,
    string? DefaultValue);

internal sealed class LegacyGuiArgument
{
    private LegacyGuiArgument(
        LegacyGuiArgumentKind kind,
        string value,
        LegacyGuiNode? callNode,
        LegacyGuiArgument? arrayIndex)
    {
        Kind = kind;
        Value = value;
        CallNode = callNode;
        ArrayIndex = arrayIndex;
    }

    public LegacyGuiArgumentKind Kind { get; }

    public string Value { get; }

    public LegacyGuiNode? CallNode { get; }

    public LegacyGuiArgument? ArrayIndex { get; }

    public static LegacyGuiArgument Preset(string value) => new(LegacyGuiArgumentKind.Preset, value, null, null);

    public static LegacyGuiArgument Variable(string value) => new(LegacyGuiArgumentKind.Variable, value, null, null);

    public static LegacyGuiArgument Constant(string value) => new(LegacyGuiArgumentKind.Constant, value, null, null);

    public static LegacyGuiArgument Disabled(string value = "") => new(LegacyGuiArgumentKind.Disabled, value, null, null);

    public static LegacyGuiArgument Call(LegacyGuiNode callNode) => new(LegacyGuiArgumentKind.Call, string.Empty, callNode, null);

    public static LegacyGuiArgument Array(string variableName, LegacyGuiArgument arrayIndex) =>
        new(LegacyGuiArgumentKind.Variable, variableName, null, arrayIndex);
}

internal sealed class LegacyGuiNode
{
    public LegacyGuiNode(LegacyGuiFunctionKind kind, string name)
    {
        Kind = kind;
        Name = name;
    }

    public LegacyGuiFunctionKind Kind { get; }

    public string Name { get; }

    public bool Enabled { get; init; } = true;

    public List<LegacyGuiArgument> Arguments { get; } = [];

    public List<LegacyGuiNodeBlock> ChildBlocks { get; } = [];
}

internal sealed class LegacyGuiNodeBlock
{
    public LegacyGuiNodeBlock(string label)
    {
        Label = label;
    }

    public string Label { get; }

    public List<LegacyGuiNode> Nodes { get; } = [];
}

internal sealed class LegacyGuiTrigger
{
    public required string Name { get; init; }

    public string Description { get; init; } = string.Empty;

    public int Type { get; init; }

    public bool Enabled { get; init; } = true;

    public bool IsCustomText { get; init; }

    public bool StartsClosed { get; init; }

    public bool RunOnMapInit { get; init; }

    public int CategoryId { get; init; }

    public string CustomText { get; init; } = string.Empty;

    public List<LegacyGuiNode> Events { get; } = [];

    public List<LegacyGuiNode> Conditions { get; } = [];

    public List<LegacyGuiNode> Actions { get; } = [];
}

internal sealed record LegacyGuiDocument(
    IReadOnlyList<LegacyGuiCategory> Categories,
    IReadOnlyList<LegacyGuiVariable> Variables,
    IReadOnlyList<LegacyGuiTrigger> Triggers,
    string GlobalCustomComment,
    string GlobalCustomCode);

internal sealed record GuiMetadataArgumentDefinition(
    string Type,
    string? DefaultValue = null)
{
    public bool IsNothing =>
        string.Equals(Type, "nothing", StringComparison.OrdinalIgnoreCase);
}

internal sealed record GuiMetadataEntry(
    LegacyGuiFunctionKind Kind,
    string Name,
    string? ScriptName,
    string? Title,
    string? Description,
    string? Category,
    IReadOnlyList<GuiMetadataArgumentDefinition> Arguments,
    string Source)
{
    public IReadOnlyList<GuiMetadataArgumentDefinition> EffectiveArguments =>
        Arguments.Where(argument => !argument.IsNothing).ToArray();
}

internal sealed record GuiPrivateSemanticAlias(
    string Marker,
    string Description);

internal sealed record RecoveredTriggerArtifact(
    string PathStem,
    string TriggerName,
    bool UsedCustomText,
    string? LmlText,
    string? CustomText,
    string? DescriptionText,
    IReadOnlyList<string> Notes,
    IReadOnlyList<string> MatchedPrivateSemantics,
    IReadOnlyList<string> UnmatchedPrivateSemantics,
    RecoveredTriggerRiskIndexEntry Risk);

internal sealed record RecoveredTriggerRiskIndexEntry(
    [property: JsonPropertyName("name")] string Name,
    [property: JsonPropertyName("isCustomText")] bool IsCustomText,
    [property: JsonPropertyName("eventCount")] int EventCount,
    [property: JsonPropertyName("conditionCount")] int ConditionCount,
    [property: JsonPropertyName("actionCount")] int ActionCount,
    [property: JsonPropertyName("customScriptCount")] int CustomScriptCount,
    [property: JsonPropertyName("controlFlowCount")] int ControlFlowCount,
    [property: JsonPropertyName("fallbackReason")] string? FallbackReason,
    [property: JsonPropertyName("matchedPrivateSemantics")] IReadOnlyList<string> MatchedPrivateSemantics);

internal sealed record RecoveredGuiSummary(
    bool Attempted,
    bool Succeeded,
    int TriggerCount,
    int VariableCount,
    int GuiEventNodeCount,
    int CustomTextTriggerCount,
    int FailedTriggerCount,
    IReadOnlyList<string> MetadataSources,
    IReadOnlyList<string> Notes,
    IReadOnlyList<string> UnmatchedPrivateSemantics);

internal sealed record RecoveredGuiReconstructionResult(
    bool Succeeded,
    LegacyGuiDocument? Document,
    IReadOnlyList<RecoveredTriggerArtifact> TriggerArtifacts,
    RecoveredGuiSummary Summary);

internal static class LegacyGuiText
{
    public static string ToDebugLml(LegacyGuiTrigger trigger)
    {
        var builder = new StringBuilder();
        builder.AppendLine($"name: {trigger.Name}");
        builder.AppendLine($"type: {(trigger.IsCustomText ? "custom-text" : "gui")}");
        builder.AppendLine($"category: {trigger.CategoryId.ToString(CultureInfo.InvariantCulture)}");
        builder.AppendLine($"enabled: {trigger.Enabled.ToString().ToLowerInvariant()}");
        builder.AppendLine($"runOnMapInit: {trigger.RunOnMapInit.ToString().ToLowerInvariant()}");
        AppendNodes(builder, "events", trigger.Events, 0);
        AppendNodes(builder, "conditions", trigger.Conditions, 0);
        AppendNodes(builder, "actions", trigger.Actions, 0);
        return builder.ToString();
    }

    public static string ToDebugLml(IReadOnlyList<LegacyGuiVariable> variables)
    {
        var builder = new StringBuilder();
        foreach (var variable in variables)
        {
            builder.Append(variable.Name);
            builder.Append(": ");
            builder.Append(variable.Type);
            if (variable.IsArray)
            {
                builder.Append(" array");
            }

            if (variable.DefaultValue is not null)
            {
                builder.Append(" = ");
                builder.Append(variable.DefaultValue);
            }

            builder.AppendLine();
        }

        return builder.ToString();
    }

    public static string ToDebugCatalog(IReadOnlyList<LegacyGuiCategory> categories, IReadOnlyList<LegacyGuiTrigger> triggers)
    {
        var builder = new StringBuilder();
        foreach (var category in categories)
        {
            builder.AppendLine(category.Name);
            var index = 1;
            foreach (var trigger in triggers.Where(trigger => trigger.CategoryId == category.Id))
            {
                builder.Append("    ");
                builder.Append(index.ToString("D3", CultureInfo.InvariantCulture));
                builder.Append('-');
                builder.AppendLine(trigger.Name);
                index++;
            }
        }

        return builder.ToString();
    }

    private static void AppendNodes(StringBuilder builder, string title, IReadOnlyList<LegacyGuiNode> nodes, int indent)
    {
        builder.Append(' ', indent);
        builder.AppendLine($"{title}:");
        if (nodes.Count == 0)
        {
            builder.Append(' ', indent + 2);
            builder.AppendLine("-");
            return;
        }

        foreach (var node in nodes)
        {
            builder.Append(' ', indent + 2);
            builder.Append("- ");
            builder.Append(node.Name);
            if (node.Arguments.Count > 0)
            {
                builder.Append(" (");
                builder.Append(string.Join(", ", node.Arguments.Select(DescribeArgument)));
                builder.Append(')');
            }

            builder.AppendLine();
            foreach (var childBlock in node.ChildBlocks)
            {
                AppendNodes(builder, childBlock.Label, childBlock.Nodes, indent + 4);
            }
        }
    }

    private static string DescribeArgument(LegacyGuiArgument argument)
    {
        return argument.Kind switch
        {
            LegacyGuiArgumentKind.Preset => $"preset:{argument.Value}",
            LegacyGuiArgumentKind.Variable when argument.ArrayIndex is not null => $"var:{argument.Value}[{DescribeArgument(argument.ArrayIndex)}]",
            LegacyGuiArgumentKind.Variable => $"var:{argument.Value}",
            LegacyGuiArgumentKind.Constant => $"const:{argument.Value}",
            LegacyGuiArgumentKind.Call when argument.CallNode is not null => $"call:{argument.CallNode.Name}",
            LegacyGuiArgumentKind.Disabled => "disabled",
            _ => argument.Value
        };
    }
}
