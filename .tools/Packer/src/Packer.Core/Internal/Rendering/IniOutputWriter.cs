using System.Text;
using Packer.Core.Internal.Lua;

namespace Packer.Core.Internal.Rendering;

internal sealed record UnitIniSection(
    string UnitId,
    string ParentBaseId,
    IReadOnlyList<IniField> Fields);

internal sealed class IniOutputWriter
{
    public string Write(IReadOnlyList<UnitIniSection> sections)
    {
        var builder = new StringBuilder();

        foreach (var section in sections)
        {
            builder.Append('[')
                .Append(section.UnitId)
                .AppendLine("]");
            builder.Append("_parent = \"")
                .Append(Escape(section.ParentBaseId))
                .AppendLine("\"");
            builder.AppendLine("W2LObject = \"static\"");

            foreach (var field in section.Fields)
            {
                builder.Append(field.TargetKey)
                    .Append(" = ")
                    .Append(RenderValue(field.Value))
                    .AppendLine();
            }

            builder.AppendLine();
        }

        return builder.ToString();
    }

    private static string RenderValue(LuaValue value)
    {
        return value switch
        {
            LuaStringValue stringValue => $"\"{Escape(stringValue.Value)}\"",
            LuaNumberValue numberValue => numberValue.RawText,
            LuaBooleanValue booleanValue => booleanValue.Value ? "1" : "0",
            LuaNilValue => "\"\"",
            _ => throw new InvalidOperationException("unit.ini 仅支持字符串、数字和布尔值。")
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
