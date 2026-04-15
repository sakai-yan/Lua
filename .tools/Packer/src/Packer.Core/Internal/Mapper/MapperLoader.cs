using System.Collections.ObjectModel;
using Packer.Core.Internal.Lua;

namespace Packer.Core.Internal.Mapper;

internal sealed record MapperDefaultBranch(
    IReadOnlyList<OrderedLuaField> OrderedFields,
    string? Parent);

internal sealed record MapperDefaultFamily(
    IReadOnlyList<OrderedLuaField> OrderedFields,
    IReadOnlyList<OrderedLuaField> CommonFields,
    MapperDefaultBranch Remote,
    MapperDefaultBranch Meele);

internal sealed record MapperDefaultRules(
    IReadOnlyList<OrderedLuaField> OrderedFields,
    IReadOnlyList<OrderedLuaField> CommonFields,
    MapperDefaultFamily Hero,
    MapperDefaultFamily Unit);

internal sealed record MapperDefinition(
    IReadOnlyList<KeyValuePair<string, string>> OrderedAttrKeys,
    IReadOnlyDictionary<string, LuaValue> AttrValues,
    MapperDefaultRules DefaultRules);

internal sealed class MapperLoader
{
    private static readonly LuaTableValue EmptyTable = new(Array.Empty<LuaTableField>());

    public MapperDefinition Load(string mapperFilePath)
    {
        var source = TextFileCodec.Read(mapperFilePath).Text;
        var tokens = new LuaTokenizer(source).Tokenize();
        LuaTableValue? slkMapper = null;

        for (var index = 0; index < tokens.Count - 2 && slkMapper is null; index++)
        {
            if (TryParseAssignment(tokens, index, out var assignmentName, out var value, out var nextPosition))
            {
                if (string.Equals(assignmentName, "Slk_Mapper", StringComparison.Ordinal) && value is LuaTableValue directMapper)
                {
                    slkMapper = directMapper;
                    break;
                }

                if (value is LuaTableValue tableValue && TryGetNamedTable(tableValue, "Slk_Mapper", out var nestedMapper))
                {
                    slkMapper = nestedMapper;
                    break;
                }

                index = Math.Max(index, nextPosition - 1);
            }
        }

        if (slkMapper is null)
        {
            throw new InvalidOperationException("`Mapper.lua` 中缺少 `Slk_Mapper` 定义。");
        }

        if (!TryGetNamedTable(slkMapper, "attr_key", out var attrKeyTable))
        {
            throw new InvalidOperationException("`Slk_Mapper.attr_key` 缺失或不是表。");
        }

        if (!TryGetNamedTable(slkMapper, "attr_value", out var attrValueTable))
        {
            throw new InvalidOperationException("`Slk_Mapper.attr_value` 缺失或不是表。");
        }

        var orderedAttrKeys = new List<KeyValuePair<string, string>>();
        var attrValues = new Dictionary<string, LuaValue>(StringComparer.Ordinal);
        var defaultTable = GetOptionalNamedTable(slkMapper, "default", "Slk_Mapper.default");

        foreach (var field in attrKeyTable.Fields)
        {
            var key = GetFieldKey(field.Key);

            if (field.Value is not LuaStringValue stringValue)
            {
                throw new InvalidOperationException($"`Slk_Mapper.attr_key.{key}` 必须是字符串。");
            }

            orderedAttrKeys.Add(new KeyValuePair<string, string>(key, stringValue.Value));
        }

        if (orderedAttrKeys.Count == 0)
        {
            throw new InvalidOperationException("`Slk_Mapper.attr_key` 不能为空。");
        }

        foreach (var field in attrValueTable.Fields)
        {
            attrValues[GetFieldKey(field.Key)] = field.Value;
        }

        return new MapperDefinition(
            orderedAttrKeys,
            new ReadOnlyDictionary<string, LuaValue>(attrValues),
            ParseDefaultRules(defaultTable));
    }

    private static MapperDefaultRules ParseDefaultRules(LuaTableValue defaultTable)
    {
        return new MapperDefaultRules(
            ParseOrderedFields(defaultTable, "common", "hero", "unit"),
            ParseOrderedFields(GetOptionalNamedTable(defaultTable, "common", "Slk_Mapper.default.common")),
            ParseDefaultFamily(
                GetOptionalNamedTable(defaultTable, "hero", "Slk_Mapper.default.hero"),
                "Slk_Mapper.default.hero"),
            ParseDefaultFamily(
                GetOptionalNamedTable(defaultTable, "unit", "Slk_Mapper.default.unit"),
                "Slk_Mapper.default.unit"));
    }

    private static MapperDefaultFamily ParseDefaultFamily(LuaTableValue familyTable, string familyPath)
    {
        return new MapperDefaultFamily(
            ParseOrderedFields(familyTable, "common", "remote", "meele"),
            ParseOrderedFields(GetOptionalNamedTable(familyTable, "common", $"{familyPath}.common")),
            ParseDefaultBranch(
                GetOptionalNamedTable(familyTable, "remote", $"{familyPath}.remote"),
                $"{familyPath}.remote"),
            ParseDefaultBranch(
                GetOptionalNamedTable(familyTable, "meele", $"{familyPath}.meele"),
                $"{familyPath}.meele"));
    }

    private static MapperDefaultBranch ParseDefaultBranch(LuaTableValue branchTable, string branchPath)
    {
        return new MapperDefaultBranch(
            ParseOrderedFields(branchTable, "parent"),
            ParseBranchParent(branchTable, branchPath));
    }

    private static IReadOnlyList<OrderedLuaField> ParseOrderedFields(LuaTableValue table, params string[] reservedKeys)
    {
        var reservedKeySet = reservedKeys.Length == 0
            ? null
            : new HashSet<string>(reservedKeys, StringComparer.Ordinal);
        var orderedFields = new List<OrderedLuaField>();
        var fieldIndexes = new Dictionary<string, int>(StringComparer.Ordinal);

        foreach (var field in table.Fields)
        {
            var key = GetFieldKey(field.Key);

            if (reservedKeySet?.Contains(key) == true)
            {
                continue;
            }

            if (fieldIndexes.TryGetValue(key, out var fieldIndex))
            {
                orderedFields[fieldIndex] = new OrderedLuaField(key, field.Value);
                continue;
            }

            fieldIndexes[key] = orderedFields.Count;
            orderedFields.Add(new OrderedLuaField(key, field.Value));
        }

        return orderedFields;
    }

    private static string? ParseBranchParent(LuaTableValue branchTable, string branchPath)
    {
        string? parent = null;

        foreach (var field in branchTable.Fields)
        {
            var key = GetFieldKey(field.Key);

            if (!string.Equals(key, "parent", StringComparison.Ordinal))
            {
                continue;
            }

            if (field.Value is not LuaStringValue stringValue ||
                string.IsNullOrWhiteSpace(stringValue.Value))
            {
                throw new InvalidOperationException($"`{branchPath}.{key}` 必须是非空字符串。");
            }

            parent = stringValue.Value;
        }

        return parent;
    }

    private static bool TryParseAssignment(
        IReadOnlyList<LuaToken> tokens,
        int index,
        out string name,
        out LuaValue value,
        out int nextPosition)
    {
        name = string.Empty;
        value = new LuaNilValue();
        nextPosition = index + 1;
        var current = tokens[index];

        if (current.Kind == LuaTokenKind.Identifier &&
            string.Equals(current.Text, "local", StringComparison.Ordinal))
        {
            if (tokens[index + 1].Kind != LuaTokenKind.Identifier || tokens[index + 2].Kind != LuaTokenKind.Equals)
            {
                return false;
            }

            name = tokens[index + 1].Text;
            var parser = new LuaSubsetParser(tokens, index + 3);
            value = parser.ParseValue();
            nextPosition = parser.Position;
            return true;
        }

        if (current.Kind == LuaTokenKind.Identifier &&
            tokens[index + 1].Kind == LuaTokenKind.Equals)
        {
            name = current.Text;
            var parser = new LuaSubsetParser(tokens, index + 2);
            value = parser.ParseValue();
            nextPosition = parser.Position;
            return true;
        }

        return false;
    }

    private static bool TryGetNamedTable(LuaTableValue table, string fieldName, out LuaTableValue nestedTable)
    {
        foreach (var field in table.Fields)
        {
            if (string.Equals(GetFieldKey(field.Key), fieldName, StringComparison.Ordinal) &&
                field.Value is LuaTableValue tableValue)
            {
                nestedTable = tableValue;
                return true;
            }
        }

        nestedTable = null!;
        return false;
    }

    private static LuaTableValue GetOptionalNamedTable(LuaTableValue table, string fieldName, string displayPath)
    {
        foreach (var field in table.Fields)
        {
            if (!string.Equals(GetFieldKey(field.Key), fieldName, StringComparison.Ordinal))
            {
                continue;
            }

            if (field.Value is not LuaTableValue tableValue)
            {
                throw new InvalidOperationException($"`{displayPath}` 必须是表。");
            }

            return tableValue;
        }

        return EmptyTable;
    }

    private static string GetFieldKey(LuaTableKey key)
    {
        return key switch
        {
            LuaNamedKey namedKey => namedKey.Name,
            LuaComputedKey { KeyValue: LuaStringValue stringValue } => stringValue.Value,
            _ => throw new InvalidOperationException("Mapper 仅支持字符串键。")
        };
    }
}
