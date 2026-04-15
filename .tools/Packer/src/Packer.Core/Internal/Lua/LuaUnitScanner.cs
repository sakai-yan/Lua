using System.Collections.ObjectModel;
using System.Text;
using Packer.Core.Internal;

namespace Packer.Core.Internal.Lua;

internal sealed record OrderedLuaField(string Key, LuaValue Value);

internal sealed record ScannedLuaUnit(
    string UnitId,
    string SourceFilePath,
    int SourceLine,
    string InvocationPrefix,
    string Indent,
    int CallStartOffset,
    int CallEndOffset,
    IReadOnlyList<OrderedLuaField> OrderedFields,
    IReadOnlyDictionary<string, LuaValue> FieldMap);

internal sealed record ScannedLuaFile(
    string SourceFilePath,
    string SourceText,
    Encoding SourceEncoding,
    string LineEnding,
    IReadOnlyList<ScannedLuaUnit> Units,
    IReadOnlyList<PackageError> Errors,
    bool HasQualifiedUnitTypeReference);

internal sealed record LuaUnitScanResult(
    IReadOnlyList<ScannedLuaFile> Files,
    IReadOnlyList<ScannedLuaUnit> Units,
    IReadOnlyList<PackageError> Errors,
    int ScannedFileCount);

internal sealed class LuaUnitScanner
{
    public LuaUnitScanResult ScanDirectory(string luaFolderPath)
    {
        var files = new List<ScannedLuaFile>();
        var units = new List<ScannedLuaUnit>();
        var errors = new List<PackageError>();

        foreach (var filePath in Directory.EnumerateFiles(luaFolderPath, "*.lua", SearchOption.AllDirectories)
                     .OrderBy(path => path, StringComparer.OrdinalIgnoreCase))
        {
            var scannedFile = ScanFile(filePath);
            files.Add(scannedFile);
            units.AddRange(scannedFile.Units);
            errors.AddRange(scannedFile.Errors);
        }

        return new LuaUnitScanResult(files, units, errors, files.Count);
    }

    public ScannedLuaFile ScanFile(string filePath)
    {
        var decodedFile = TextFileCodec.Read(filePath);
        var source = decodedFile.Text;
        var lineEnding = DetectLineEnding(source);
        var errors = new List<PackageError>();
        var units = new List<ScannedLuaUnit>();
        var hasQualifiedUnitTypeReference = source.Contains("Unit.unitType", StringComparison.Ordinal);
        IReadOnlyList<LuaToken> tokens;

        try
        {
            tokens = new LuaTokenizer(source).Tokenize();
        }
        catch (LuaParseException exception)
        {
            errors.Add(new PackageError(ErrorCategory.LuaParse, exception.Message, filePath));
            return new ScannedLuaFile(filePath, source, decodedFile.Encoding, lineEnding, Array.Empty<ScannedLuaUnit>(), errors, hasQualifiedUnitTypeReference);
        }

        var unitTypeAliases = DiscoverUnitTypeAliases(tokens);
        hasQualifiedUnitTypeReference |= ContainsQualifiedUnitTypeReference(tokens);

        for (var index = 0; index < tokens.Count; index++)
        {
            if (!TryMatchUnitTypeCall(tokens, index, unitTypeAliases, out var argumentStart, out var callToken, out var invocationPrefix))
            {
                continue;
            }

            try
            {
                var parser = new LuaSubsetParser(tokens, argumentStart);
                var idValue = parser.ParseValue();

                if (idValue is not LuaStringValue idString)
                {
                    throw new LuaParseException("unitType 的第一个参数必须是字符串字面量 ID。", callToken);
                }

                parser.Expect(LuaTokenKind.Comma, "unitType 的两个参数之间缺少 `,`。");
                var tableValue = parser.ParseValue();
                parser.Expect(LuaTokenKind.RightParen, "unitType 调用缺少 `)`。");

                if (tableValue is not LuaTableValue configTable)
                {
                    throw new LuaParseException("unitType 的第二个参数必须是字面量表。", callToken);
                }

                var flattenedFields = FlattenConfig(configTable, callToken);
                var endToken = tokens[Math.Max(argumentStart, parser.Position - 1)];
                var callStartOffset = tokens[index].Offset;
                var callEndOffset = endToken.Offset + Math.Max(1, endToken.Text.Length);

                units.Add(new ScannedLuaUnit(
                    idString.Value,
                    filePath,
                    callToken.Line,
                    invocationPrefix,
                    DetectIndent(source, callStartOffset),
                    callStartOffset,
                    callEndOffset,
                    flattenedFields,
                    BuildFieldMap(flattenedFields)));

                index = Math.Max(index, parser.Position - 1);
            }
            catch (LuaParseException exception)
            {
                errors.Add(new PackageError(ErrorCategory.LuaParse, exception.Message, filePath));
            }
        }

        return new ScannedLuaFile(filePath, source, decodedFile.Encoding, lineEnding, units, errors, hasQualifiedUnitTypeReference);
    }

    private static IReadOnlyDictionary<string, LuaValue> BuildFieldMap(IReadOnlyList<OrderedLuaField> orderedFields)
    {
        var dictionary = new Dictionary<string, LuaValue>(StringComparer.Ordinal);

        foreach (var field in orderedFields)
        {
            dictionary[field.Key] = field.Value;
        }

        return new ReadOnlyDictionary<string, LuaValue>(dictionary);
    }

    private static IReadOnlyList<OrderedLuaField> FlattenConfig(LuaTableValue configTable, LuaToken token)
    {
        var orderedFields = new List<OrderedLuaField>();
        var dictionary = new Dictionary<string, LuaValue>(StringComparer.Ordinal);

        foreach (var field in configTable.Fields)
        {
            var key = GetStringKey(field.Key, token);

            if (string.Equals(key, "__slk__", StringComparison.Ordinal))
            {
                if (field.Value is not LuaTableValue nestedTable)
                {
                    throw new LuaParseException("`__slk__` 必须是表。", token);
                }

                foreach (var nestedField in nestedTable.Fields)
                {
                    var nestedKey = GetStringKey(nestedField.Key, token);
                    MergeField(nestedKey, nestedField.Value, dictionary, orderedFields, token);
                }

                continue;
            }

            MergeField(key, field.Value, dictionary, orderedFields, token);
        }

        return orderedFields;
    }

    private static void MergeField(
        string key,
        LuaValue value,
        IDictionary<string, LuaValue> dictionary,
        ICollection<OrderedLuaField> orderedFields,
        LuaToken token)
    {
        if (dictionary.TryGetValue(key, out var existingValue))
        {
            if (!LuaValueComparer.AreEquivalent(existingValue, value))
            {
                throw new LuaParseException($"字段 `{key}` 在顶层和 `__slk__` 中存在冲突。", token);
            }

            return;
        }

        dictionary[key] = value;
        orderedFields.Add(new OrderedLuaField(key, value));
    }

    private static string GetStringKey(LuaTableKey key, LuaToken token)
    {
        return key switch
        {
            LuaNamedKey namedKey => namedKey.Name,
            LuaComputedKey { KeyValue: LuaStringValue stringValue } => stringValue.Value,
            _ => throw new LuaParseException("顶层配置仅支持字符串键。", token)
        };
    }

    private static bool TryMatchUnitTypeCall(
        IReadOnlyList<LuaToken> tokens,
        int index,
        ISet<string> unitTypeAliases,
        out int argumentStart,
        out LuaToken callToken,
        out string invocationPrefix)
    {
        argumentStart = -1;
        callToken = default;
        invocationPrefix = string.Empty;

        if (index >= tokens.Count)
        {
            return false;
        }

        var token = tokens[index];

        if (token.Kind == LuaTokenKind.Identifier &&
            string.Equals(token.Text, "Unit", StringComparison.Ordinal) &&
            Peek(tokens, index + 1).Kind == LuaTokenKind.Dot &&
            Peek(tokens, index + 2).Kind == LuaTokenKind.Identifier &&
            string.Equals(Peek(tokens, index + 2).Text, "unitType", StringComparison.Ordinal) &&
            Peek(tokens, index + 3).Kind == LuaTokenKind.LeftParen)
        {
            argumentStart = index + 4;
            callToken = Peek(tokens, index + 2);
            invocationPrefix = "Unit.unitType";
            return true;
        }

        if (token.Kind == LuaTokenKind.Identifier &&
            unitTypeAliases.Contains(token.Text) &&
            Peek(tokens, index + 1).Kind == LuaTokenKind.LeftParen)
        {
            var previous = index > 0 ? tokens[index - 1] : default;

            if (previous.Kind is LuaTokenKind.Dot or LuaTokenKind.Colon ||
                (previous.Kind == LuaTokenKind.Identifier && string.Equals(previous.Text, "function", StringComparison.Ordinal)))
            {
                return false;
            }

            argumentStart = index + 2;
            callToken = token;
            invocationPrefix = token.Text;
            return true;
        }

        return false;
    }

    private static bool ContainsQualifiedUnitTypeReference(IReadOnlyList<LuaToken> tokens)
    {
        for (var index = 0; index < tokens.Count - 2; index++)
        {
            if (tokens[index].Kind == LuaTokenKind.Identifier &&
                string.Equals(tokens[index].Text, "Unit", StringComparison.Ordinal) &&
                Peek(tokens, index + 1).Kind == LuaTokenKind.Dot &&
                Peek(tokens, index + 2).Kind == LuaTokenKind.Identifier &&
                string.Equals(Peek(tokens, index + 2).Text, "unitType", StringComparison.Ordinal))
            {
                return true;
            }
        }

        return false;
    }

    private static HashSet<string> DiscoverUnitTypeAliases(IReadOnlyList<LuaToken> tokens)
    {
        var aliases = new HashSet<string>(StringComparer.Ordinal);

        for (var index = 0; index < tokens.Count - 5; index++)
        {
            if (tokens[index].Kind == LuaTokenKind.Identifier &&
                string.Equals(tokens[index].Text, "local", StringComparison.Ordinal) &&
                Peek(tokens, index + 1).Kind == LuaTokenKind.Identifier &&
                Peek(tokens, index + 2).Kind == LuaTokenKind.Equals &&
                Peek(tokens, index + 3).Kind == LuaTokenKind.Identifier &&
                string.Equals(Peek(tokens, index + 3).Text, "Unit", StringComparison.Ordinal) &&
                Peek(tokens, index + 4).Kind == LuaTokenKind.Dot &&
                Peek(tokens, index + 5).Kind == LuaTokenKind.Identifier &&
                string.Equals(Peek(tokens, index + 5).Text, "unitType", StringComparison.Ordinal))
            {
                aliases.Add(Peek(tokens, index + 1).Text);
                continue;
            }

            if (tokens[index].Kind == LuaTokenKind.Identifier &&
                Peek(tokens, index + 1).Kind == LuaTokenKind.Equals &&
                Peek(tokens, index + 2).Kind == LuaTokenKind.Identifier &&
                string.Equals(Peek(tokens, index + 2).Text, "Unit", StringComparison.Ordinal) &&
                Peek(tokens, index + 3).Kind == LuaTokenKind.Dot &&
                Peek(tokens, index + 4).Kind == LuaTokenKind.Identifier &&
                string.Equals(Peek(tokens, index + 4).Text, "unitType", StringComparison.Ordinal))
            {
                aliases.Add(tokens[index].Text);
            }
        }

        return aliases;
    }

    private static string DetectIndent(string source, int startOffset)
    {
        var lineStart = source.LastIndexOf('\n', Math.Max(0, startOffset - 1));
        lineStart = lineStart < 0 ? 0 : lineStart + 1;
        var length = Math.Max(0, startOffset - lineStart);

        if (length == 0)
        {
            return string.Empty;
        }

        var slice = source.AsSpan(lineStart, length);
        var builder = new StringBuilder();

        foreach (var character in slice)
        {
            if (character is ' ' or '\t')
            {
                builder.Append(character);
                continue;
            }

            break;
        }

        return builder.ToString();
    }

    private static string DetectLineEnding(string source)
    {
        var index = source.IndexOf('\n');

        if (index < 0)
        {
            return Environment.NewLine;
        }

        return index > 0 && source[index - 1] == '\r'
            ? "\r\n"
            : "\n";
    }

    private static LuaToken Peek(IReadOnlyList<LuaToken> tokens, int index) =>
        index >= 0 && index < tokens.Count ? tokens[index] : tokens[^1];
}
