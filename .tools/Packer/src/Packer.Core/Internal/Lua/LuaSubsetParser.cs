namespace Packer.Core.Internal.Lua;

internal sealed class LuaSubsetParser
{
    private readonly IReadOnlyList<LuaToken> _tokens;
    private int _position;

    public LuaSubsetParser(IReadOnlyList<LuaToken> tokens, int startPosition = 0)
    {
        _tokens = tokens;
        _position = startPosition;
    }

    public int Position => _position;

    public LuaValue ParseValue()
    {
        var token = Current();

        return token.Kind switch
        {
            LuaTokenKind.String => ConsumeString(),
            LuaTokenKind.Number => ConsumeNumber(false),
            LuaTokenKind.Minus => ConsumeNegativeNumber(),
            LuaTokenKind.True => ConsumeBoolean(true),
            LuaTokenKind.False => ConsumeBoolean(false),
            LuaTokenKind.Nil => ConsumeNil(),
            LuaTokenKind.LeftBrace => ParseTable(),
            _ => throw new LuaParseException($"不支持的字面量 `{token.Text}`", token)
        };
    }

    public void Expect(LuaTokenKind kind, string message)
    {
        if (Current().Kind != kind)
        {
            throw new LuaParseException(message, Current());
        }

        _position++;
    }

    private LuaValue ConsumeString()
    {
        var token = Current();
        _position++;
        return new LuaStringValue(token.Text);
    }

    private LuaValue ConsumeNumber(bool negative)
    {
        var token = Current();
        _position++;
        var rawText = negative ? "-" + token.Text : token.Text;
        return new LuaNumberValue(rawText, decimal.Parse(rawText, System.Globalization.CultureInfo.InvariantCulture));
    }

    private LuaValue ConsumeNegativeNumber()
    {
        var minusToken = Current();
        _position++;

        if (Current().Kind != LuaTokenKind.Number)
        {
            throw new LuaParseException("仅支持负数字面量", minusToken);
        }

        return ConsumeNumber(true);
    }

    private LuaValue ConsumeBoolean(bool value)
    {
        _position++;
        return new LuaBooleanValue(value);
    }

    private LuaValue ConsumeNil()
    {
        _position++;
        return new LuaNilValue();
    }

    private LuaValue ParseTable()
    {
        Expect(LuaTokenKind.LeftBrace, "表必须以 `{` 开始");
        var fields = new List<LuaTableField>();
        var arrayIndex = 1;

        while (Current().Kind != LuaTokenKind.RightBrace)
        {
            if (Current().Kind == LuaTokenKind.EndOfFile)
            {
                throw new LuaParseException("表未闭合", Current());
            }

            LuaTableField field;

            if (Current().Kind == LuaTokenKind.LeftBracket)
            {
                _position++;
                var keyValue = ParseValue();
                Expect(LuaTokenKind.RightBracket, "缺少 `]`");
                Expect(LuaTokenKind.Equals, "缺少 `=`");
                var value = ParseValue();
                field = new LuaTableField(new LuaComputedKey(keyValue), value);
            }
            else if (Current().Kind == LuaTokenKind.Identifier && Peek().Kind == LuaTokenKind.Equals)
            {
                var keyName = Current().Text;
                _position += 2;
                var value = ParseValue();
                field = new LuaTableField(new LuaNamedKey(keyName), value);
            }
            else
            {
                var value = ParseValue();
                field = new LuaTableField(new LuaArrayKey(arrayIndex++), value);
            }

            fields.Add(field);

            if (Current().Kind is LuaTokenKind.Comma or LuaTokenKind.Semicolon)
            {
                _position++;
            }
        }

        Expect(LuaTokenKind.RightBrace, "缺少 `}`");
        return new LuaTableValue(fields);
    }

    private LuaToken Current() => _tokens[Math.Min(_position, _tokens.Count - 1)];

    private LuaToken Peek(int lookahead = 1) =>
        _tokens[Math.Min(_position + lookahead, _tokens.Count - 1)];
}
