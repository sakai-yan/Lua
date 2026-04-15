using System.Text;

namespace Packer.Core.Internal.Lua;

internal sealed class LuaTokenizer
{
    private readonly string _source;
    private int _offset;
    private int _line = 1;
    private int _column = 1;

    public LuaTokenizer(string source)
    {
        _source = source ?? string.Empty;
    }

    public IReadOnlyList<LuaToken> Tokenize()
    {
        var tokens = new List<LuaToken>();

        while (!IsEnd())
        {
            SkipWhitespaceAndComments();

            if (IsEnd())
            {
                break;
            }

            var line = _line;
            var column = _column;
            var offset = _offset;
            var character = Peek();

            if (IsIdentifierStart(character))
            {
                var text = ReadIdentifier();
                var identifierKind = text switch
                {
                    "true" => LuaTokenKind.True,
                    "false" => LuaTokenKind.False,
                    "nil" => LuaTokenKind.Nil,
                    _ => LuaTokenKind.Identifier
                };

                tokens.Add(new LuaToken(identifierKind, text, line, column, offset));
                continue;
            }

            if (char.IsDigit(character))
            {
                tokens.Add(new LuaToken(LuaTokenKind.Number, ReadNumber(), line, column, offset));
                continue;
            }

            if (character is '"' or '\'')
            {
                tokens.Add(new LuaToken(LuaTokenKind.String, ReadQuotedString(character), line, column, offset));
                continue;
            }

            if (character == '[' && TryReadLongBracket(out var longString))
            {
                tokens.Add(new LuaToken(LuaTokenKind.String, longString, line, column, offset));
                continue;
            }

            Advance();

            var kind = character switch
            {
                '{' => LuaTokenKind.LeftBrace,
                '}' => LuaTokenKind.RightBrace,
                '[' => LuaTokenKind.LeftBracket,
                ']' => LuaTokenKind.RightBracket,
                '(' => LuaTokenKind.LeftParen,
                ')' => LuaTokenKind.RightParen,
                ',' => LuaTokenKind.Comma,
                '.' => LuaTokenKind.Dot,
                '=' => LuaTokenKind.Equals,
                '-' => LuaTokenKind.Minus,
                ';' => LuaTokenKind.Semicolon,
                ':' => LuaTokenKind.Colon,
                _ => throw new LuaParseException($"不支持的字符 `{character}`", new LuaToken(LuaTokenKind.Identifier, character.ToString(), line, column, offset))
            };

            tokens.Add(new LuaToken(kind, character.ToString(), line, column, offset));
        }

        tokens.Add(new LuaToken(LuaTokenKind.EndOfFile, string.Empty, _line, _column, _offset));
        return tokens;
    }

    private void SkipWhitespaceAndComments()
    {
        while (!IsEnd())
        {
            if (char.IsWhiteSpace(Peek()))
            {
                Advance();
                continue;
            }

            if (Peek() == '-' && Peek(1) == '-')
            {
                Advance();
                Advance();

                if (Peek() == '[' && TryReadLongBracket(out _))
                {
                    continue;
                }

                while (!IsEnd() && Peek() is not '\r' and not '\n')
                {
                    Advance();
                }

                continue;
            }

            break;
        }
    }

    private string ReadIdentifier()
    {
        var start = _offset;

        while (!IsEnd() && IsIdentifierPart(Peek()))
        {
            Advance();
        }

        return _source[start.._offset];
    }

    private string ReadNumber()
    {
        var start = _offset;

        while (!IsEnd() && char.IsDigit(Peek()))
        {
            Advance();
        }

        if (!IsEnd() && Peek() == '.')
        {
            Advance();

            while (!IsEnd() && char.IsDigit(Peek()))
            {
                Advance();
            }
        }

        return _source[start.._offset];
    }

    private string ReadQuotedString(char quote)
    {
        Advance();
        var builder = new StringBuilder();

        while (!IsEnd())
        {
            var character = Peek();

            if (character == quote)
            {
                Advance();
                return builder.ToString();
            }

            if (character == '\\')
            {
                Advance();

                if (IsEnd())
                {
                    break;
                }

                var escaped = Peek();
                Advance();

                _ = escaped switch
                {
                    'n' => builder.Append('\n'),
                    'r' => builder.Append('\r'),
                    't' => builder.Append('\t'),
                    '\\' => builder.Append('\\'),
                    '"' => builder.Append('"'),
                    '\'' => builder.Append('\''),
                    _ => builder.Append(escaped)
                };

                continue;
            }

            builder.Append(character);
            Advance();
        }

        throw new LuaParseException("字符串未闭合", new LuaToken(LuaTokenKind.String, string.Empty, _line, _column, _offset));
    }

    private bool TryReadLongBracket(out string content)
    {
        content = string.Empty;
        var savedOffset = _offset;
        var savedLine = _line;
        var savedColumn = _column;

        if (Peek() != '[')
        {
            return false;
        }

        Advance();
        var equalsCount = 0;

        while (!IsEnd() && Peek() == '=')
        {
            equalsCount++;
            Advance();
        }

        if (IsEnd() || Peek() != '[')
        {
            _offset = savedOffset;
            _line = savedLine;
            _column = savedColumn;
            return false;
        }

        Advance();
        var builder = new StringBuilder();

        while (!IsEnd())
        {
            if (Peek() == ']')
            {
                var endOffset = _offset;
                Advance();
                var matched = 0;

                while (!IsEnd() && Peek() == '=' && matched < equalsCount)
                {
                    matched++;
                    Advance();
                }

                if (matched == equalsCount && !IsEnd() && Peek() == ']')
                {
                    Advance();
                    content = builder.ToString();
                    return true;
                }

                builder.Append(_source[endOffset.._offset]);
                continue;
            }

            builder.Append(Peek());
            Advance();
        }

        throw new LuaParseException("长字符串/注释未闭合", new LuaToken(LuaTokenKind.String, string.Empty, savedLine, savedColumn, savedOffset));
    }

    private static bool IsIdentifierStart(char character) =>
        character == '_' || char.IsLetter(character);

    private static bool IsIdentifierPart(char character) =>
        character == '_' || char.IsLetterOrDigit(character);

    private char Peek(int lookahead = 0) =>
        _offset + lookahead < _source.Length ? _source[_offset + lookahead] : '\0';

    private void Advance()
    {
        if (IsEnd())
        {
            return;
        }

        if (_source[_offset] == '\n')
        {
            _line++;
            _column = 1;
        }
        else
        {
            _column++;
        }

        _offset++;
    }

    private bool IsEnd() => _offset >= _source.Length;
}
