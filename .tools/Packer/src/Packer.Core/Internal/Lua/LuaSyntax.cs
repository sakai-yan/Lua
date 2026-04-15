using System.Globalization;
using System.Text;

namespace Packer.Core.Internal.Lua;

internal enum LuaTokenKind
{
    Identifier,
    String,
    Number,
    True,
    False,
    Nil,
    LeftBrace,
    RightBrace,
    LeftBracket,
    RightBracket,
    LeftParen,
    RightParen,
    Comma,
    Dot,
    Equals,
    Minus,
    Semicolon,
    Colon,
    EndOfFile
}

internal readonly record struct LuaToken(
    LuaTokenKind Kind,
    string Text,
    int Line,
    int Column,
    int Offset);

internal abstract record LuaValue;

internal sealed record LuaStringValue(string Value) : LuaValue;

internal sealed record LuaNumberValue(string RawText, decimal NumericValue) : LuaValue;

internal sealed record LuaBooleanValue(bool Value) : LuaValue;

internal sealed record LuaNilValue() : LuaValue;

internal sealed record LuaTableValue(IReadOnlyList<LuaTableField> Fields) : LuaValue;

internal abstract record LuaTableKey;

internal sealed record LuaNamedKey(string Name) : LuaTableKey;

internal sealed record LuaComputedKey(LuaValue KeyValue) : LuaTableKey;

internal sealed record LuaArrayKey(int Index) : LuaTableKey;

internal sealed record LuaTableField(LuaTableKey Key, LuaValue Value);

internal static class LuaValueFactory
{
    public static LuaValue FromExcelCell(string cellText)
    {
        if (string.Equals(cellText, "nil", StringComparison.Ordinal))
        {
            return new LuaNilValue();
        }

        if (string.Equals(cellText, "true", StringComparison.OrdinalIgnoreCase))
        {
            return new LuaBooleanValue(true);
        }

        if (string.Equals(cellText, "false", StringComparison.OrdinalIgnoreCase))
        {
            return new LuaBooleanValue(false);
        }

        if (decimal.TryParse(
                cellText,
                NumberStyles.AllowLeadingSign | NumberStyles.AllowDecimalPoint,
                CultureInfo.InvariantCulture,
                out var numericValue))
        {
            return new LuaNumberValue(cellText, numericValue);
        }

        return new LuaStringValue(cellText);
    }
}

internal static class LuaValueComparer
{
    public static bool AreEquivalent(LuaValue left, LuaValue right)
    {
        if (ReferenceEquals(left, right))
        {
            return true;
        }

        return (left, right) switch
        {
            (LuaStringValue l, LuaStringValue r) => string.Equals(l.Value, r.Value, StringComparison.Ordinal),
            (LuaNumberValue l, LuaNumberValue r) => l.NumericValue == r.NumericValue,
            (LuaBooleanValue l, LuaBooleanValue r) => l.Value == r.Value,
            (LuaNilValue, LuaNilValue) => true,
            (LuaTableValue l, LuaTableValue r) => AreEquivalent(l.Fields, r.Fields),
            (LuaNumberValue l, LuaStringValue r) => string.Equals(l.RawText, r.Value, StringComparison.Ordinal),
            (LuaStringValue l, LuaNumberValue r) => string.Equals(l.Value, r.RawText, StringComparison.Ordinal),
            _ => false
        };
    }

    public static string ToDisplayString(LuaValue value)
    {
        return value switch
        {
            LuaStringValue stringValue => $"\"{Escape(stringValue.Value)}\"",
            LuaNumberValue numberValue => numberValue.RawText,
            LuaBooleanValue booleanValue => booleanValue.Value ? "true" : "false",
            LuaNilValue => "nil",
            LuaTableValue => "{...}",
            _ => value.ToString() ?? string.Empty
        };
    }

    private static bool AreEquivalent(IReadOnlyList<LuaTableField> left, IReadOnlyList<LuaTableField> right)
    {
        if (left.Count != right.Count)
        {
            return false;
        }

        for (var index = 0; index < left.Count; index++)
        {
            if (!AreEquivalent(left[index].Key, right[index].Key) ||
                !AreEquivalent(left[index].Value, right[index].Value))
            {
                return false;
            }
        }

        return true;
    }

    private static bool AreEquivalent(LuaTableKey left, LuaTableKey right)
    {
        return (left, right) switch
        {
            (LuaNamedKey l, LuaNamedKey r) => string.Equals(l.Name, r.Name, StringComparison.Ordinal),
            (LuaArrayKey l, LuaArrayKey r) => l.Index == r.Index,
            (LuaComputedKey l, LuaComputedKey r) => AreEquivalent(l.KeyValue, r.KeyValue),
            _ => false
        };
    }

    private static string Escape(string value)
    {
        var builder = new StringBuilder(value.Length);

        foreach (var character in value)
        {
            _ = character switch
            {
                '\\' => builder.Append(@"\\"),
                '"' => builder.Append("\\\""),
                '\r' => builder.Append(@"\r"),
                '\n' => builder.Append(@"\n"),
                '\t' => builder.Append(@"\t"),
                _ => builder.Append(character)
            };
        }

        return builder.ToString();
    }
}
