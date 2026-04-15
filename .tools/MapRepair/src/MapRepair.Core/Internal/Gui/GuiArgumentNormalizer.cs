using System.Globalization;
using System.Text.RegularExpressions;

namespace MapRepair.Core.Internal.Gui;

internal sealed class GuiArgumentNormalizer
{
    private static readonly HashSet<string> RawcodeLikeTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "integer",
        "abilityid",
        "abilcode",
        "buffcode",
        "destructablecode",
        "heroskillcode",
        "itemcode",
        "ordercode",
        "techcode",
        "unitcode",
    };

    private static readonly string[] ComparisonConditionNames =
    [
        "OperatorCompareInteger",
        "OperatorCompareReal",
        "OperatorCompareString",
        "OperatorComparePlayer",
        "OperatorComparePlayerColor",
        "OperatorComparePlayerControl",
        "OperatorComparePlayerSlotStatus",
        "OperatorCompareUnit",
        "OperatorCompareUnitCode",
        "OperatorCompareItem",
        "OperatorCompareItemType",
        "OperatorCompareItemCode",
        "OperatorCompareAbilityId",
        "OperatorCompareBuffId",
        "OperatorCompareTechCode",
        "OperatorCompareOrderCode",
        "OperatorCompareRace",
        "OperatorCompareGameDifficulty",
        "OperatorCompareGameSpeed",
        "OperatorCompareHeroSkill",
        "OperatorCompareTrigger",
        "OperatorCompareDestructible",
        "OperatorCompareDestructableCode",
        "OperatorCompareTerrainType",
        "OperatorCompareBoolean",
    ];

    private static readonly Regex IntegerRegex = new(@"^-?\d+$", RegexOptions.Compiled);
    private static readonly Regex RealRegex = new(@"^-?(?:\d+(?:\.\d+)?|\.\d+)$", RegexOptions.Compiled);
    private static readonly Regex RawcodeRegex = new(@"^'[A-Za-z0-9_]{4}'$", RegexOptions.Compiled);
    private static readonly Regex BareIdentifierRegex = new(@"^[A-Za-z_][A-Za-z0-9_]*$", RegexOptions.Compiled);
    private static readonly Regex GgGlobalRegex = new(@"^gg_[A-Za-z0-9_]+$", RegexOptions.Compiled);
    private static readonly Regex PlayerIndexRegex = new(@"^Player\s*\(\s*(\d+)\s*\)$", RegexOptions.Compiled);
    private static readonly Regex PlayerNamedRegex = new(@"^Player\s*\(\s*(PLAYER_NEUTRAL_AGGRESSIVE|PLAYER_NEUTRAL_PASSIVE|bj_PLAYER_NEUTRAL_VICTIM|bj_PLAYER_NEUTRAL_EXTRA)\s*\)$", RegexOptions.Compiled);

    private readonly GuiMetadataCatalog _metadata;
    private readonly bool _structuredRecoveryOnly;

    public GuiArgumentNormalizer(GuiMetadataCatalog metadata, bool structuredRecoveryOnly = false)
    {
        _metadata = metadata;
        _structuredRecoveryOnly = structuredRecoveryOnly;
    }

    public bool TryNormalize(string rawValue, GuiMetadataArgumentDefinition expectedArgument, out LegacyGuiArgument argument) =>
        TryNormalize(rawValue, expectedArgument.Type, out argument);

    public bool TryNormalize(string rawValue, string? expectedType, out LegacyGuiArgument argument)
    {
        var value = rawValue.Trim();
        if (string.IsNullOrWhiteSpace(value))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        if (TryParseVariable(value, out argument))
        {
            return true;
        }

        if (TryParseHandleGlobal(value, out argument))
        {
            return true;
        }

        if (_metadata.TryResolvePreset(expectedType, value, out var presetName))
        {
            argument = LegacyGuiArgument.Preset(presetName);
            return true;
        }

        if (TryParseTypedPreset(expectedType, value, out argument))
        {
            return true;
        }

        if (TryParsePlayerPreset(value, out argument))
        {
            return true;
        }

        if (TryParseQuotedString(value, out argument))
        {
            return true;
        }

        if (TryParseNumericConstant(value, out argument))
        {
            return true;
        }

        if (TryParseRawcode(expectedType, value, out argument))
        {
            return true;
        }

        if (TryParsePreset(expectedType, value, out argument))
        {
            return true;
        }

        if (TryParseArithmeticExpression(expectedType, value, out argument))
        {
            return true;
        }

        if (TryParseCallNode(value, DetermineSearchOrder(expectedType), out var callNode))
        {
            argument = LegacyGuiArgument.Call(callNode);
            return true;
        }

        if (ShouldTreatAsBareVariable(expectedType, value))
        {
            argument = LegacyGuiArgument.Variable(value);
            return true;
        }

        argument = LegacyGuiArgument.Disabled();
        return false;
    }

    public bool TryParseConditionExpression(string rawValue, out LegacyGuiNode? node)
    {
        var value = rawValue.Trim();
        if (string.Equals(value, "true", StringComparison.OrdinalIgnoreCase))
        {
            node = null;
            return true;
        }

        if (TryParseCallNode(value, [LegacyGuiFunctionKind.Condition], out var conditionNode))
        {
            node = conditionNode;
            return true;
        }

        if (TryParseComparisonExpression(value, out var comparisonNode))
        {
            node = comparisonNode;
            return true;
        }

        if (TryParseCallNode(value, [LegacyGuiFunctionKind.Call], out var booleanCall))
        {
            node = new LegacyGuiNode(LegacyGuiFunctionKind.Condition, "OperatorCompareBoolean");
            node.Arguments.Add(LegacyGuiArgument.Call(booleanCall));
            node.Arguments.Add(LegacyGuiArgument.Preset("OperatorEqualENE"));
            node.Arguments.Add(LegacyGuiArgument.Preset("true"));
            return true;
        }

        if (string.Equals(value, "false", StringComparison.OrdinalIgnoreCase))
        {
            node = new LegacyGuiNode(LegacyGuiFunctionKind.Condition, "OperatorCompareBoolean");
            node.Arguments.Add(LegacyGuiArgument.Preset("false"));
            node.Arguments.Add(LegacyGuiArgument.Preset("OperatorEqualENE"));
            node.Arguments.Add(LegacyGuiArgument.Preset("true"));
            return true;
        }

        node = null;
        return false;
    }

    private bool TryParseComparisonExpression(string rawValue, out LegacyGuiNode? node)
    {
        node = null;
        if (!TrySplitComparisonExpression(rawValue, out var left, out var comparisonOperator, out var right))
        {
            return false;
        }

        if (TryParseSpecializedComparisonExpression(left, comparisonOperator, right, out node))
        {
            return true;
        }

        foreach (var conditionName in ComparisonConditionNames)
        {
            if (TryBuildComparisonNode(conditionName, left, comparisonOperator, right, out node))
            {
                return true;
            }
        }

        return false;
    }

    private bool TryParseSpecializedComparisonExpression(string left, string comparisonOperator, string right, out LegacyGuiNode? node)
    {
        node = null;

        if (IsBooleanLiteral(left) || IsBooleanLiteral(right))
        {
            return TryBuildComparisonNode("OperatorCompareBoolean", left, comparisonOperator, right, out node);
        }

        if (TryInferRawcodeComparisonConditionName(left, right, out var rawcodeConditionName))
        {
            return TryBuildComparisonNode(rawcodeConditionName, left, comparisonOperator, right, out node);
        }

        if (IsNumericLiteral(left) || IsNumericLiteral(right))
        {
            var numericConditionName = UsesRealLiteral(left) || UsesRealLiteral(right)
                ? "OperatorCompareReal"
                : "OperatorCompareInteger";
            return TryBuildComparisonNode(numericConditionName, left, comparisonOperator, right, out node);
        }

        if (IsQuotedStringLiteral(left) || IsQuotedStringLiteral(right))
        {
            return TryBuildComparisonNode("OperatorCompareString", left, comparisonOperator, right, out node);
        }

        return false;
    }

    private bool TryBuildComparisonNode(string conditionName, string left, string comparisonOperator, string right, out LegacyGuiNode? node)
    {
        node = null;
        if (!TryGetEntry(LegacyGuiFunctionKind.Condition, conditionName, out var entry))
        {
            return false;
        }

        var arguments = entry.EffectiveArguments;
        if (arguments.Count != 3 ||
            !TryGetComparisonOperatorPreset(comparisonOperator, arguments[1].Type, out var operatorPreset) ||
            !TryNormalize(left, arguments[0], out var leftArgument) ||
            !TryNormalize(operatorPreset, arguments[1], out var operatorArgument) ||
            !TryNormalize(right, arguments[2], out var rightArgument))
        {
            return false;
        }

        node = new LegacyGuiNode(LegacyGuiFunctionKind.Condition, entry.Name);
        node.Arguments.Add(leftArgument);
        node.Arguments.Add(operatorArgument);
        node.Arguments.Add(rightArgument);
        return true;
    }

    public bool TryParseCallNode(string rawValue, IReadOnlyList<LegacyGuiFunctionKind> searchOrder, out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Call, rawValue);
        var openParen = rawValue.IndexOf('(');
        var closeParen = rawValue.LastIndexOf(')');
        if (openParen <= 0 || closeParen <= openParen || closeParen != rawValue.Length - 1)
        {
            return false;
        }

        var callName = rawValue[..openParen].Trim();
        var rawArguments = JassGuiReconstructionParser.SplitArguments(rawValue[(openParen + 1)..closeParen]);
        foreach (var kind in searchOrder)
        {
            if (!TryGetEntry(kind, callName, out var entry))
            {
                continue;
            }

            var expectedArguments = entry.EffectiveArguments;
            if (rawArguments.Count != expectedArguments.Count)
            {
                continue;
            }

            var candidate = new LegacyGuiNode(kind, entry.Name);
            var success = true;
            for (var index = 0; index < rawArguments.Count; index++)
            {
                if (!TryNormalize(rawArguments[index], expectedArguments[index], out var argument))
                {
                    success = false;
                    break;
                }

                candidate.Arguments.Add(argument);
            }

            if (!success)
            {
                continue;
            }

            node = candidate;
            return true;
        }

        return false;
    }

    private bool TryGetEntry(LegacyGuiFunctionKind kind, string name, out GuiMetadataEntry entry)
    {
        if (_structuredRecoveryOnly)
        {
            return _metadata.TryGetStructuredRecoveryEntry(kind, name, out entry);
        }

        return _metadata.TryGetEntry(kind, name, out entry);
    }

    private bool TryParseVariable(string value, out LegacyGuiArgument argument)
    {
        if (!value.StartsWith("udg_", StringComparison.Ordinal))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        var arrayIndex = value.IndexOf('[');
        if (arrayIndex > 0 && value.EndsWith("]", StringComparison.Ordinal))
        {
            var indexRaw = value[(arrayIndex + 1)..^1].Trim();
            LegacyGuiArgument indexArgument;
            if (IntegerRegex.IsMatch(indexRaw))
            {
                indexArgument = LegacyGuiArgument.Constant(indexRaw);
            }
            else if (BareIdentifierRegex.IsMatch(indexRaw))
            {
                indexArgument = LegacyGuiArgument.Variable(indexRaw);
            }
            else if (!TryNormalize(indexRaw, "integer", out indexArgument))
            {
                argument = LegacyGuiArgument.Disabled();
                return false;
            }

            argument = LegacyGuiArgument.Array(value[..arrayIndex], indexArgument);
            return true;
        }

        argument = LegacyGuiArgument.Variable(value);
        return true;
    }

    private static bool TryParseHandleGlobal(string value, out LegacyGuiArgument argument)
    {
        if (!GgGlobalRegex.IsMatch(value))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        argument = LegacyGuiArgument.Variable(value);
        return true;
    }

    private static bool TryParsePlayerPreset(string value, out LegacyGuiArgument argument)
    {
        if (PlayerIndexRegex.Match(value) is { Success: true } indexMatch &&
            int.TryParse(indexMatch.Groups[1].Value, NumberStyles.Integer, CultureInfo.InvariantCulture, out var index) &&
            index is >= 0 and <= 11)
        {
            argument = LegacyGuiArgument.Preset($"Player{index:D2}");
            return true;
        }

        if (PlayerNamedRegex.Match(value) is { Success: true } namedMatch)
        {
            argument = namedMatch.Groups[1].Value switch
            {
                "PLAYER_NEUTRAL_AGGRESSIVE" => LegacyGuiArgument.Preset("PlayerNA"),
                "PLAYER_NEUTRAL_PASSIVE" => LegacyGuiArgument.Preset("PlayerNP"),
                "bj_PLAYER_NEUTRAL_VICTIM" => LegacyGuiArgument.Preset("PlayerNV"),
                "bj_PLAYER_NEUTRAL_EXTRA" => LegacyGuiArgument.Preset("PlayerNE"),
                _ => LegacyGuiArgument.Disabled()
            };
            return argument.Kind != LegacyGuiArgumentKind.Disabled;
        }

        argument = LegacyGuiArgument.Disabled();
        return false;
    }

    private static bool TryParseQuotedString(string value, out LegacyGuiArgument argument)
    {
        if (value.Length < 2 || value[0] != '"' || value[^1] != '"')
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        argument = LegacyGuiArgument.Constant(LiteralValueParser.ParseQuotedString(value));
        return true;
    }

    private static bool TryParseNumericConstant(string value, out LegacyGuiArgument argument)
    {
        if (!RealRegex.IsMatch(value))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        argument = LegacyGuiArgument.Constant(NormalizeRealLiteral(value));
        return true;
    }

    private static bool TryParseRawcode(string? expectedType, string value, out LegacyGuiArgument argument)
    {
        if (!RawcodeRegex.IsMatch(value) ||
            !IsRawcodeCompatibleType(expectedType))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        argument = LegacyGuiArgument.Constant(value[1..^1]);
        return true;
    }

    private static bool IsRawcodeCompatibleType(string? expectedType)
    {
        return string.IsNullOrWhiteSpace(expectedType) ||
               RawcodeLikeTypes.Contains(expectedType) ||
               string.Equals(expectedType, "Null", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "AnyGlobal", StringComparison.OrdinalIgnoreCase);
    }

    private static bool TryParsePreset(string? expectedType, string value, out LegacyGuiArgument argument)
    {
        if (((string.Equals(value, "true", StringComparison.OrdinalIgnoreCase) ||
              string.Equals(value, "false", StringComparison.OrdinalIgnoreCase)) &&
             string.Equals(expectedType, "boolean", StringComparison.OrdinalIgnoreCase)) ||
            (string.Equals(value, "null", StringComparison.OrdinalIgnoreCase) &&
             (expectedType is null ||
              string.Equals(expectedType, "Null", StringComparison.OrdinalIgnoreCase))) ||
            Regex.IsMatch(value, @"^[A-Z][A-Z0-9_]*$"))
        {
            argument = LegacyGuiArgument.Preset(value);
            return true;
        }

        argument = LegacyGuiArgument.Disabled();
        return false;
    }

    private bool TryParseArithmeticExpression(string? expectedType, string value, out LegacyGuiArgument argument)
    {
        if (!ShouldParseArithmeticExpression(expectedType, value) ||
            !TrySplitArithmeticExpression(value, out var left, out var arithmeticOperator, out var right))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        var callName = GetArithmeticOperatorCallName(expectedType, left, right, arithmeticOperator);
        if (!TryGetEntry(LegacyGuiFunctionKind.Call, callName, out var entry))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        var arguments = entry.EffectiveArguments;
        if (arguments.Count != 2 ||
            !TryNormalize(left, arguments[0], out var leftArgument) ||
            !TryNormalize(right, arguments[1], out var rightArgument))
        {
            argument = LegacyGuiArgument.Disabled();
            return false;
        }

        var node = new LegacyGuiNode(LegacyGuiFunctionKind.Call, entry.Name);
        node.Arguments.Add(leftArgument);
        node.Arguments.Add(rightArgument);
        argument = LegacyGuiArgument.Call(node);
        return true;
    }

    private static bool ShouldParseArithmeticExpression(string? expectedType, string value)
    {
        if (!string.Equals(expectedType, "integer", StringComparison.OrdinalIgnoreCase) &&
            !string.Equals(expectedType, "real", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        var trimmed = TrimOuterParentheses(value);
        return trimmed.IndexOf('+') >= 0 ||
               trimmed.IndexOf('-') >= 0 ||
               trimmed.IndexOf('*') >= 0 ||
               trimmed.IndexOf('/') >= 0;
    }

    private static bool TryParseTypedPreset(string? expectedType, string value, out LegacyGuiArgument argument)
    {
        if (!string.IsNullOrWhiteSpace(expectedType) &&
            expectedType.EndsWith("Operator", StringComparison.OrdinalIgnoreCase) &&
            BareIdentifierRegex.IsMatch(value))
        {
            argument = LegacyGuiArgument.Preset(value);
            return true;
        }

        argument = LegacyGuiArgument.Disabled();
        return false;
    }

    private static bool TrySplitComparisonExpression(string value, out string left, out string comparisonOperator, out string right)
    {
        left = string.Empty;
        comparisonOperator = string.Empty;
        right = string.Empty;

        var parentheses = 0;
        var quote = false;
        var rawcode = false;
        for (var index = 0; index < value.Length; index++)
        {
            var current = value[index];
            if (current == '"' && !rawcode)
            {
                quote = !quote;
                continue;
            }

            if (current == '\'' && !quote)
            {
                rawcode = !rawcode;
                continue;
            }

            if (quote || rawcode)
            {
                continue;
            }

            switch (current)
            {
                case '(':
                    parentheses++;
                    continue;
                case ')':
                    parentheses--;
                    continue;
            }

            if (parentheses != 0)
            {
                continue;
            }

            string? candidateOperator = null;
            if (index + 1 < value.Length)
            {
                candidateOperator = value.Substring(index, 2) switch
                {
                    "==" => "==",
                    "!=" => "!=",
                    ">=" => ">=",
                    "<=" => "<=",
                    _ => null
                };
            }

            if (candidateOperator is null && (current == '>' || current == '<'))
            {
                candidateOperator = current.ToString();
            }

            if (candidateOperator is null)
            {
                continue;
            }

            left = TrimOuterParentheses(value[..index].Trim());
            right = TrimOuterParentheses(value[(index + candidateOperator.Length)..].Trim());
            comparisonOperator = candidateOperator;
            return left.Length > 0 && right.Length > 0;
        }

        return false;
    }

    private static bool TrySplitArithmeticExpression(string value, out string left, out string arithmeticOperator, out string right)
    {
        left = string.Empty;
        arithmeticOperator = string.Empty;
        right = string.Empty;

        var trimmed = TrimOuterParentheses(value);
        var operatorIndex = FindTopLevelArithmeticOperator(trimmed, '+', '-');
        if (operatorIndex < 0)
        {
            operatorIndex = FindTopLevelArithmeticOperator(trimmed, '*', '/');
        }

        if (operatorIndex < 0)
        {
            return false;
        }

        left = TrimOuterParentheses(trimmed[..operatorIndex].Trim());
        right = TrimOuterParentheses(trimmed[(operatorIndex + 1)..].Trim());
        arithmeticOperator = trimmed[operatorIndex].ToString();
        return left.Length > 0 && right.Length > 0;
    }

    private static int FindTopLevelArithmeticOperator(string value, char firstOperator, char secondOperator)
    {
        var parentheses = 0;
        var quote = false;
        var rawcode = false;
        var lastIndex = -1;
        for (var index = 0; index < value.Length; index++)
        {
            var current = value[index];
            if (current == '"' && !rawcode)
            {
                quote = !quote;
                continue;
            }

            if (current == '\'' && !quote)
            {
                rawcode = !rawcode;
                continue;
            }

            if (quote || rawcode)
            {
                continue;
            }

            switch (current)
            {
                case '(':
                    parentheses++;
                    continue;
                case ')':
                    parentheses--;
                    continue;
            }

            if (parentheses != 0 ||
                (current != firstOperator && current != secondOperator) ||
                IsUnaryArithmeticOperator(value, index))
            {
                continue;
            }

            lastIndex = index;
        }

        return lastIndex;
    }

    private static bool IsUnaryArithmeticOperator(string value, int index)
    {
        if (index == 0)
        {
            return true;
        }

        for (var previousIndex = index - 1; previousIndex >= 0; previousIndex--)
        {
            var previous = value[previousIndex];
            if (char.IsWhiteSpace(previous))
            {
                continue;
            }

            return previous is '(' or '+' or '-' or '*' or '/' or ',' or '<' or '>' or '=';
        }

        return true;
    }

    private static string GetArithmeticOperatorCallName(string? expectedType, string left, string right, string arithmeticOperator)
    {
        var useReal = string.Equals(expectedType, "real", StringComparison.OrdinalIgnoreCase) ||
                      UsesRealLiteral(left) ||
                      UsesRealLiteral(right);
        return (useReal, arithmeticOperator) switch
        {
            (false, "+") => "OperatorIntegerAdd",
            (false, "-") => "OperatorIntegerSubtract",
            (false, "*") => "OperatorIntegerMultiply",
            (false, "/") => "OperatorIntegerDivide",
            (true, "+") => "OperatorRealAdd",
            (true, "-") => "OperatorRealSubtract",
            (true, "*") => "OperatorRealMultiply",
            (true, "/") => "OperatorRealDivide",
            _ => string.Empty
        };
    }

    private static bool TryGetComparisonOperatorPreset(string comparisonOperator, string? expectedOperatorType, out string preset)
    {
        preset = string.Empty;
        if (string.Equals(expectedOperatorType, "EqualNotEqualOperator", StringComparison.OrdinalIgnoreCase))
        {
            preset = comparisonOperator switch
            {
                "==" => "OperatorEqualENE",
                "!=" => "OperatorNotEqualENE",
                _ => string.Empty
            };
            return preset.Length > 0;
        }

        if (string.Equals(expectedOperatorType, "ComparisonOperator", StringComparison.OrdinalIgnoreCase))
        {
            preset = comparisonOperator switch
            {
                "==" => "OperatorEqual",
                "!=" => "OperatorNotEqual",
                ">" => "OperatorGreater",
                ">=" => "OperatorGreaterEq",
                "<" => "OperatorLess",
                "<=" => "OperatorLessEq",
                _ => string.Empty
            };
            return preset.Length > 0;
        }

        return false;
    }

    private static bool TryInferRawcodeComparisonConditionName(string left, string right, out string conditionName)
    {
        conditionName = string.Empty;
        var leftIsRawcode = RawcodeRegex.IsMatch(left);
        var rightIsRawcode = RawcodeRegex.IsMatch(right);
        if (leftIsRawcode == rightIsRawcode)
        {
            return false;
        }

        var otherSide = leftIsRawcode ? right : left;
        if (!TryExtractCallName(otherSide, out var callName))
        {
            return false;
        }

        conditionName = callName switch
        {
            "GetItemTypeId" => "OperatorCompareItemCode",
            "GetUnitTypeId" => "OperatorCompareUnitCode",
            "GetSpellAbilityId" => "OperatorCompareAbilityId",
            "GetLearnedSkillBJ" => "OperatorCompareHeroSkill",
            "GetResearched" => "OperatorCompareTechCode",
            "GetIssuedOrderIdBJ" => "OperatorCompareOrderCode",
            "GetDestructableTypeId" => "OperatorCompareDestructableCode",
            _ => string.Empty
        };

        return conditionName.Length > 0;
    }

    private static bool TryExtractCallName(string value, out string callName)
    {
        callName = string.Empty;
        var trimmed = TrimOuterParentheses(value);
        var openParen = trimmed.IndexOf('(');
        var closeParen = trimmed.LastIndexOf(')');
        if (openParen <= 0 || closeParen != trimmed.Length - 1)
        {
            return false;
        }

        callName = trimmed[..openParen].Trim();
        return BareIdentifierRegex.IsMatch(callName);
    }

    private static bool IsBooleanLiteral(string value) =>
        string.Equals(value.Trim(), "true", StringComparison.OrdinalIgnoreCase) ||
        string.Equals(value.Trim(), "false", StringComparison.OrdinalIgnoreCase);

    private static bool IsNumericLiteral(string value) => RealRegex.IsMatch(value.Trim());

    private static bool UsesRealLiteral(string value)
    {
        var trimmed = value.Trim();
        return RealRegex.IsMatch(trimmed) && trimmed.Contains('.', StringComparison.Ordinal);
    }

    private static bool IsQuotedStringLiteral(string value)
    {
        var trimmed = value.Trim();
        return trimmed.Length >= 2 && trimmed[0] == '"' && trimmed[^1] == '"';
    }

    private static string TrimOuterParentheses(string value)
    {
        var trimmed = value.Trim();
        while (trimmed.Length >= 2 &&
               trimmed[0] == '(' &&
               trimmed[^1] == ')' &&
               WrapsWholeExpression(trimmed))
        {
            trimmed = trimmed[1..^1].Trim();
        }

        return trimmed;
    }

    private static bool WrapsWholeExpression(string value)
    {
        var depth = 0;
        var quote = false;
        var rawcode = false;
        for (var index = 0; index < value.Length; index++)
        {
            var current = value[index];
            if (current == '"' && !rawcode)
            {
                quote = !quote;
                continue;
            }

            if (current == '\'' && !quote)
            {
                rawcode = !rawcode;
                continue;
            }

            if (quote || rawcode)
            {
                continue;
            }

            if (current == '(')
            {
                depth++;
                continue;
            }

            if (current == ')')
            {
                depth--;
                if (depth == 0 && index < value.Length - 1)
                {
                    return false;
                }
            }
        }

        return depth == 0;
    }

    private static IReadOnlyList<LegacyGuiFunctionKind> DetermineSearchOrder(string? expectedType)
    {
        if (string.Equals(expectedType, "boolexpr", StringComparison.OrdinalIgnoreCase))
        {
            return [LegacyGuiFunctionKind.Condition, LegacyGuiFunctionKind.Call];
        }

        if (string.Equals(expectedType, "code", StringComparison.OrdinalIgnoreCase))
        {
            return [LegacyGuiFunctionKind.Action, LegacyGuiFunctionKind.Call];
        }

        return [LegacyGuiFunctionKind.Call];
    }

    private static bool ShouldTreatAsBareVariable(string? expectedType, string value)
    {
        if (!BareIdentifierRegex.IsMatch(value))
        {
            return false;
        }

        if (string.Equals(value, "true", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(value, "false", StringComparison.OrdinalIgnoreCase) ||
            string.Equals(value, "null", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        return string.Equals(expectedType, "AnyGlobal", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "Null", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "unit", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "rect", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "destructable", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "destructible", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "trigger", StringComparison.OrdinalIgnoreCase) ||
               string.Equals(expectedType, "location", StringComparison.OrdinalIgnoreCase);
    }

    private static string NormalizeRealLiteral(string value)
    {
        if (value.StartsWith(".", StringComparison.Ordinal))
        {
            return "0" + value;
        }

        if (value.StartsWith("-.", StringComparison.Ordinal))
        {
            return value.Insert(1, "0");
        }

        return value;
    }
}
