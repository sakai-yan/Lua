using System.Text;
using Packer.Core.Internal.Lua;

namespace Packer.Core.Internal.Rendering;

internal sealed record IniField(string SourceKey, string TargetKey, LuaValue Value);

internal sealed class LuaOutputWriter
{
    public string RenderUnitTypeCall(
        string invocationPrefix,
        string unitId,
        IReadOnlyList<OrderedLuaField> fields,
        string indent,
        string lineEnding)
    {
        var builder = new StringBuilder();

        builder.Append(indent)
            .Append(invocationPrefix)
            .Append("(\"")
            .Append(Escape(unitId))
            .Append("\", {")
            .Append(lineEnding);

        foreach (var field in fields)
        {
            builder.Append(indent)
                .Append("    [\"")
                .Append(Escape(field.Key))
                .Append("\"] = ")
                .Append(RenderValue(field.Value, indent + "    ", lineEnding))
                .Append(',')
                .Append(lineEnding);
        }

        builder.Append(indent).Append("})");
        return builder.ToString();
    }

    public string RenderValue(LuaValue value, string indent, string lineEnding)
    {
        return value switch
        {
            LuaStringValue stringValue => $"\"{Escape(stringValue.Value)}\"",
            LuaNumberValue numberValue => numberValue.RawText,
            LuaBooleanValue booleanValue => booleanValue.Value ? "true" : "false",
            LuaNilValue => "nil",
            LuaTableValue tableValue => RenderTable(tableValue, indent, lineEnding),
            _ => throw new InvalidOperationException("不支持的 Lua 值。")
        };
    }

    private string RenderTable(LuaTableValue tableValue, string indent, string lineEnding)
    {
        if (tableValue.Fields.Count == 0)
        {
            return "{}";
        }

        var childIndent = indent + "    ";
        var builder = new StringBuilder();
        builder.Append('{').Append(lineEnding);

        foreach (var field in tableValue.Fields)
        {
            builder.Append(childIndent)
                .Append(RenderKey(field.Key))
                .Append(" = ")
                .Append(RenderValue(field.Value, childIndent, lineEnding))
                .Append(',')
                .Append(lineEnding);
        }

        builder.Append(indent).Append('}');
        return builder.ToString();
    }

    private static string RenderKey(LuaTableKey key)
    {
        return key switch
        {
            LuaNamedKey namedKey => namedKey.Name,
            LuaComputedKey { KeyValue: LuaStringValue stringValue } => $"[\"{Escape(stringValue.Value)}\"]",
            LuaComputedKey { KeyValue: LuaNumberValue numberValue } => $"[{numberValue.RawText}]",
            LuaArrayKey => throw new InvalidOperationException("数组项不需要显式键。"),
            _ => throw new InvalidOperationException("不支持的表键。")
        };
    }

    private static string Escape(string value) =>
        value
            .Replace("\\", "\\\\", StringComparison.Ordinal)
            .Replace("\"", "\\\"", StringComparison.Ordinal)
            .Replace("\r", "\\r", StringComparison.Ordinal)
            .Replace("\n", "\\n", StringComparison.Ordinal)
            .Replace("\t", "\\t", StringComparison.Ordinal);
}
