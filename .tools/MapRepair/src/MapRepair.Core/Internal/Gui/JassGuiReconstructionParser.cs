using System.Text;
using System.Text.RegularExpressions;
using MapRepair.Core.Internal;

namespace MapRepair.Core.Internal.Gui;

internal sealed class JassGuiReconstructionParser
{
    private const int StringHeavyQuestTimerActionThreshold = 8;
    private const int StringHeavyQuestTimerConstantPayloadThreshold = 1024;
    private const int VeryLargeGuiActionThreshold = 256;
    private const int HighActionPseudoGuiActionThreshold = 96;
    private const int HighActionPseudoGuiCustomScriptThreshold = 24;
    private const int HighActionPseudoGuiControlFlowThreshold = 12;
    private const int DensePseudoGuiActionThreshold = 64;
    private const int DensePseudoGuiCustomScriptThreshold = 48;
    private const int DensePseudoGuiControlFlowThreshold = 24;
    private const int SmallAllCustomPseudoGuiActionThreshold = 20;
    private const int SmallAllCustomPseudoGuiAllowedStructuredActions = 1;
    private const int SmallBranchyPseudoGuiActionThreshold = 20;
    private const int SmallBranchyPseudoGuiCustomScriptThreshold = 18;
    private const int SmallBranchyPseudoGuiControlFlowThreshold = 8;
    private const int MediumBranchyPseudoGuiActionThreshold = 20;
    private const int MediumBranchyPseudoGuiCustomScriptThreshold = 14;
    private const int MediumBranchyPseudoGuiControlFlowThreshold = 7;
    private const int MediumControlPseudoGuiActionThreshold = 20;
    private const int MediumControlPseudoGuiCustomScriptThreshold = 15;
    private const int MediumControlPseudoGuiControlFlowThreshold = 5;
    private const int ScriptHeavyPseudoGuiActionThreshold = 40;
    private const int ScriptHeavyPseudoGuiCustomScriptThreshold = 28;
    private const int CompactScriptHeavyPseudoGuiActionThreshold = 36;
    private const int CompactScriptHeavyPseudoGuiCustomScriptThreshold = 27;
    private const int CompactScriptHeavyPseudoGuiControlFlowThreshold = 18;
    private const int VeryCompactScriptHeavyPseudoGuiActionThreshold = 30;
    private const int VeryCompactScriptHeavyPseudoGuiCustomScriptThreshold = 24;
    private const int VeryCompactScriptHeavyPseudoGuiControlFlowThreshold = 15;
    private const int CompactPseudoGuiActionThreshold = 48;
    private const int CompactPseudoGuiControlFlowThreshold = 20;
    private const int RootConditionGuardActionCount = 3;

    private static readonly Regex FunctionHeaderRegex = new(
        @"^\s*function\s+([A-Za-z0-9_]+)\s+takes\s+(.*?)\s+returns\s+([A-Za-z0-9_]+)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex GlobalVariableRegex = new(
        @"^\s*(?:constant\s+)?([A-Za-z0-9_]+)\s+(array\s+)?(udg_[A-Za-z0-9_]+)(?:\s*=\s*(.+?))?\s*$",
        RegexOptions.Compiled);

    private static readonly Regex InitCallRegex = new(
        @"^\s*call\s+(InitTrig_[A-Za-z0-9_]+)\s*\(\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex VariableAssignmentRegex = new(
        @"^\s*set\s+(udg_[A-Za-z0-9_]+)\s*=\s*(.+?)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ActionSetRegex = new(
        @"^\s*set\s+((?:udg_[A-Za-z0-9_]+)(?:\s*\[\s*.+\s*\])?)\s*=\s*(.+?)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex CreateTriggerRegex = new(
        @"^\s*set\s+([A-Za-z0-9_]+)\s*=\s*CreateTrigger\s*\(\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex DisableTriggerRegex = new(
        @"^\s*call\s+DisableTrigger\s*\(\s*([A-Za-z0-9_]+)\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ExecuteTriggerRegex = new(
        @"^\s*call\s+(?:ConditionalTriggerExecute|TriggerExecute)\s*\(\s*([A-Za-z0-9_]+)\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex DirectHelperCallRegex = new(
        @"^\s*call\s+([A-Za-z0-9_]+)\s*\(\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex TriggerActionRegex = new(
        @"^\s*call\s+TriggerAddAction\s*\(\s*([A-Za-z0-9_]+)\s*,\s*function\s+([A-Za-z0-9_]+)\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex TriggerConditionRegex = new(
        @"^\s*call\s+TriggerAddCondition\s*\(\s*([A-Za-z0-9_]+)\s*,\s*Condition\s*\(\s*function\s+([A-Za-z0-9_]+)\s*\)\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex TriggerEventRegex = new(
        @"^\s*call\s+([A-Za-z0-9_]+)\s*\((.*)\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex TriggerCommentRegex = new(
        @"^\s*//\s*Trigger:\s*(.+?)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex GenericCallRegex = new(
        @"^\s*call\s+([A-Za-z0-9_]+)\s*\((.*)\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex FunctionReferenceRegex = new(
        @"\b(?:Condition|Filter)\s*\(\s*function\s+([A-Za-z0-9_]+)\s*\)|\b(?:TimerStart|TriggerAddAction|TriggerAddCondition)\s*\([^()\r\n]*function\s+([A-Za-z0-9_]+)\s*\)|\bExecuteFunc\s*\(\s*""([A-Za-z0-9_]+)""\s*\)",
        RegexOptions.Compiled);

    private static readonly Regex CallbackFunctionReferenceRegex = new(
        @"\bfunction\s+([A-Za-z0-9_]+)\b",
        RegexOptions.Compiled);

    private static readonly Regex ZeroArgumentFunctionCallRegex = new(
        @"^([A-Za-z0-9_]+)\s*\(\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ForForceCallbackRegex = new(
        @"^\s*call\s+ForForce\s*\(\s*(.+?)\s*,\s*function\s+([A-Za-z0-9_]+)\s*\)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ForLoopStartRegex = new(
        @"^\s*set\s+bj_forLoop([AB])Index\s*=\s*(.+?)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ForLoopEndRegex = new(
        @"^\s*set\s+bj_forLoop([AB])IndexEnd\s*=\s*(.+?)\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ForLoopExitWhenRegex = new(
        @"^\s*exitwhen\s+bj_forLoop([AB])Index\s*>\s*bj_forLoop([AB])IndexEnd\s*$",
        RegexOptions.Compiled);

    private static readonly Regex ForLoopIncrementRegex = new(
        @"^\s*set\s+bj_forLoop([AB])Index\s*=\s*bj_forLoop([AB])Index\s*\+\s*1\s*$",
        RegexOptions.Compiled);

    private static readonly Regex AbilityIdRegex = new(
        @"AbilityId\s*\(\s*""([^""]+)""\s*\)",
        RegexOptions.Compiled);

    private static readonly HashSet<string> IgnoredDirectFunctionCallKeywords = new(StringComparer.Ordinal)
    {
        "and",
        "call",
        "elseif",
        "exitwhen",
        "function",
        "if",
        "local",
        "loop",
        "not",
        "or",
        "return",
        "set"
    };

    private sealed record TriggerRiskAnalysis(
        int EventCount,
        int ConditionCount,
        int ActionCount,
        int CustomScriptCount,
        int ControlFlowCount,
        bool HasRootConditionGuard,
        int BodyCustomScriptCount,
        int BodyControlFlowCount);

    public RecoveredGuiReconstructionResult Reconstruct(string scriptText, GuiMetadataCatalog metadata)
    {
        ArgumentNullException.ThrowIfNull(scriptText);
        ArgumentNullException.ThrowIfNull(metadata);

        var script = JassScriptDocument.Parse(scriptText);
        var normalizer = new GuiArgumentNormalizer(metadata, structuredRecoveryOnly: true);
        var notes = new List<string>();
        if (script.InitTriggerCalls.Count == 0)
        {
            notes.Add("No `InitCustomTriggers()` trigger calls were found in `war3map.j`.");
            return new RecoveredGuiReconstructionResult(
                false,
                null,
                [],
                new RecoveredGuiSummary(
                    Attempted: true,
                    Succeeded: false,
                    TriggerCount: 0,
                    VariableCount: 0,
                    GuiEventNodeCount: 0,
                    CustomTextTriggerCount: 0,
                    FailedTriggerCount: 0,
                    metadata.Sources,
                    notes,
                    []));
        }

        var runOnMapInitGlobals = script.ExtractRunOnMapInitTriggerGlobals();
        var explicitlyExecutedTriggerGlobals = script.ExtractExplicitlyExecutedTriggerGlobals();
        var variables = script.RecoverVariables();
        var triggers = new List<LegacyGuiTrigger>();
        var artifacts = new List<RecoveredTriggerArtifact>();
        var unmatchedPrivate = new HashSet<string>(StringComparer.Ordinal);
        var guiEventNodeCount = 0;
        var customTextTriggerCount = 0;
        var failedTriggerCount = 0;

        for (var index = 0; index < script.InitTriggerCalls.Count; index++)
        {
            var trigger = RecoverTrigger(script, metadata, normalizer, script.InitTriggerCalls[index], runOnMapInitGlobals, explicitlyExecutedTriggerGlobals, index + 1, unmatchedPrivate, out var artifact);
            artifacts.Add(artifact);
            if (trigger is null)
            {
                failedTriggerCount++;
                continue;
            }

            triggers.Add(trigger);
            guiEventNodeCount += trigger.Events.Count;
            if (trigger.IsCustomText)
            {
                customTextTriggerCount++;
            }
        }

        if (triggers.Count == 0)
        {
            notes.Add("`war3map.j` contained trigger init calls, but none could be reconstructed into a legal `war3map.wtg/wct` pair.");
            return new RecoveredGuiReconstructionResult(
                false,
                null,
                artifacts,
                new RecoveredGuiSummary(
                    Attempted: true,
                    Succeeded: false,
                    TriggerCount: 0,
                    VariableCount: variables.Count,
                    GuiEventNodeCount: guiEventNodeCount,
                    CustomTextTriggerCount: customTextTriggerCount,
                    FailedTriggerCount: failedTriggerCount,
                    metadata.Sources,
                    notes,
                    unmatchedPrivate.OrderBy(value => value, StringComparer.Ordinal).ToArray()));
        }

        var document = new LegacyGuiDocument(
            [new LegacyGuiCategory(0, "Recovered GUI")],
            variables,
            triggers,
            "Recovered from war3map.j",
            string.Empty);

        notes.Add($"Recovered {triggers.Count} trigger definitions from `InitCustomTriggers()`.");
        if (customTextTriggerCount > 0)
        {
            notes.Add($"{customTextTriggerCount} trigger(s) were emitted as custom-text triggers.");
        }

        return new RecoveredGuiReconstructionResult(
            true,
            document,
            artifacts,
            new RecoveredGuiSummary(
                Attempted: true,
                Succeeded: true,
                TriggerCount: triggers.Count,
                VariableCount: variables.Count,
                GuiEventNodeCount: guiEventNodeCount,
                CustomTextTriggerCount: customTextTriggerCount,
                FailedTriggerCount: failedTriggerCount,
                metadata.Sources,
                notes,
                unmatchedPrivate.OrderBy(value => value, StringComparer.Ordinal).ToArray()));
    }

    private static LegacyGuiTrigger? RecoverTrigger(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        string initTriggerFunctionName,
        ISet<string> runOnMapInitGlobals,
        ISet<string> explicitlyExecutedTriggerGlobals,
        int ordinal,
        ISet<string> unmatchedPrivate,
        out RecoveredTriggerArtifact artifact)
    {
        if (!script.Functions.TryGetValue(initTriggerFunctionName, out var initFunction))
        {
            artifact = new RecoveredTriggerArtifact(
                CreateArtifactStem(ordinal, initTriggerFunctionName),
                initTriggerFunctionName,
                UsedCustomText: true,
                LmlText: null,
                CustomText: null,
                DescriptionText: null,
                [$"Missing init function `{initTriggerFunctionName}` in `war3map.j`."],
                [],
                [],
                new RecoveredTriggerRiskIndexEntry(
                    initTriggerFunctionName,
                    IsCustomText: true,
                    EventCount: 0,
                    ConditionCount: 0,
                    ActionCount: 0,
                    CustomScriptCount: 0,
                    ControlFlowCount: 0,
                    FallbackReason: "Fell back to custom-text because the init function was missing from war3map.j.",
                    MatchedPrivateSemantics: []));
            return null;
        }

        var name = CreateDisplayName(initFunction, ordinal);
        var triggerGlobal = initFunction.TryExtractTriggerGlobal();
        var runOnMapInit = triggerGlobal is not null && runOnMapInitGlobals.Contains(triggerGlobal);
        var eventNodes = new List<LegacyGuiNode>();
        var actionFunctions = new List<string>();
        var conditionFunctions = new List<string>();
        var opaqueInitHelperCalls = new HashSet<string>(StringComparer.Ordinal);
        var notes = new List<string>();

        foreach (var line in initFunction.BodyLines)
        {
            var normalizedLine = NormalizeCodeLine(line);
            if (string.IsNullOrWhiteSpace(normalizedLine))
            {
                continue;
            }

            if (TriggerActionRegex.Match(normalizedLine) is { Success: true } actionMatch)
            {
                actionFunctions.Add(actionMatch.Groups[2].Value);
                continue;
            }

            if (TriggerConditionRegex.Match(normalizedLine) is { Success: true } conditionMatch)
            {
                conditionFunctions.Add(conditionMatch.Groups[2].Value);
                continue;
            }

            if (TriggerEventRegex.Match(normalizedLine) is { Success: true } eventMatch)
            {
                var functionName = eventMatch.Groups[1].Value;
                if (TryBuildEventNode(metadata, normalizer, triggerGlobal, functionName, eventMatch.Groups[2].Value, out var eventNode, out var failure))
                {
                    eventNodes.Add(eventNode);
                }
                else if (!IsIgnorableOpaqueInitCall(functionName))
                {
                    if (metadata.TryGetStructuredRecoveryEntry(LegacyGuiFunctionKind.Event, functionName, out _))
                    {
                        if (failure is not null)
                        {
                            notes.Add(failure);
                        }
                    }
                    else
                    {
                        opaqueInitHelperCalls.Add(functionName);
                    }
                }
            }
        }

        if (runOnMapInit &&
            eventNodes.Count == 0 &&
            TryBuildSyntheticMapInitializationEvent(metadata, out var mapInitializationEventNode))
        {
            eventNodes.Insert(0, mapInitializationEventNode);
            runOnMapInit = false;
        }

        if (eventNodes.Count == 0)
        {
            notes.Add("No standard trigger-registration calls could be mapped back into GUI event nodes.");
        }

        var requiresOpaqueInitFallback = eventNodes.Count == 0 && opaqueInitHelperCalls.Count > 0;
        if (requiresOpaqueInitFallback)
        {
            notes.Add($"Detected opaque init helper call(s) with no recoverable GUI events: {string.Join(", ", opaqueInitHelperCalls.OrderBy(static value => value, StringComparer.Ordinal))}.");
        }

        var referencedFunctions = CollectFunctionClosure(script, initTriggerFunctionName, actionFunctions, conditionFunctions, opaqueInitHelperCalls);
        var customTextFunctions = SelectCustomTextChunkFunctions(script, initTriggerFunctionName, referencedFunctions);
        var customText = BuildCustomTextChunk(script, name, customTextFunctions);
        var combinedText = string.Join("\n\n", referencedFunctions.Select(function => function.FullText));
        var matchedPrivate = metadata.MatchPrivateSemantics(combinedText);
        var unmatchedMarkers = CollectUnmatchedMarkers(combinedText, matchedPrivate);
        foreach (var marker in unmatchedMarkers)
        {
            unmatchedPrivate.Add(marker);
        }

        var trigger = new LegacyGuiTrigger
        {
            Name = name,
            Description = string.Empty,
            Type = 0,
            Enabled = !initFunction.DisablesTrigger(triggerGlobal),
            IsCustomText = false,
            StartsClosed = false,
            RunOnMapInit = runOnMapInit,
            CategoryId = 0,
            CustomText = string.Empty
        };
        foreach (var eventNode in eventNodes)
        {
            trigger.Events.Add(eventNode);
        }

        var conditionGuards = new List<string>();
        var missingCallback = !TryRecoverConditionNodes(script, normalizer, conditionFunctions, trigger.Conditions, conditionGuards, notes);
        if (conditionGuards.Count > 0)
        {
            AppendConditionGuardActions(trigger.Actions, conditionGuards);
            notes.Add($"{conditionGuards.Count} root condition function(s) were preserved as custom-script guard actions.");
        }

        missingCallback |= !AppendRecoveredActionFunctions(script, metadata, normalizer, actionFunctions, trigger.Actions, notes);
        var riskSourceTrigger = trigger;
        var riskAnalysis = AnalyzeTriggerRisk(riskSourceTrigger);
        if (missingCallback)
        {
            if (missingCallback)
            {
                notes.Add("Fell back to custom-text because a referenced trigger callback function was missing.");
            }

            trigger = BuildCustomTextTrigger(
                name,
                !initFunction.DisablesTrigger(triggerGlobal),
                runOnMapInit,
                customText);
        }
        else if (requiresOpaqueInitFallback)
        {
            notes.Add("Fell back to custom-text because the init function used opaque trigger-registration/helper calls and no GUI event nodes could be reconstructed.");
            trigger = BuildCustomTextTrigger(
                name,
                !initFunction.DisablesTrigger(triggerGlobal),
                runOnMapInit,
                customText);
        }
        else if (ShouldFallbackEventlessGuiTrigger(
                     trigger,
                     triggerGlobal is not null && explicitlyExecutedTriggerGlobals.Contains(triggerGlobal),
                     out var eventlessFallbackReason))
        {
            notes.Add(eventlessFallbackReason);
            trigger = BuildCustomTextTrigger(
                name,
                !initFunction.DisablesTrigger(triggerGlobal),
                runOnMapInit,
                customText);
        }
        else if (ShouldFallbackPseudoGuiTrigger(trigger, riskAnalysis, out var pseudoGuiFallbackReason))
        {
            notes.Add(pseudoGuiFallbackReason);
            trigger = BuildCustomTextTrigger(
                name,
                !initFunction.DisablesTrigger(triggerGlobal),
                runOnMapInit,
                customText);
        }

        var fallbackReason = notes.LastOrDefault(static note =>
            note.StartsWith("Fell back to custom-text because", StringComparison.Ordinal));
        artifact = new RecoveredTriggerArtifact(
            CreateArtifactStem(ordinal, name),
            name,
            UsedCustomText: trigger.IsCustomText,
            LmlText: LegacyGuiText.ToDebugLml(trigger),
            CustomText: trigger.CustomText,
            DescriptionText: null,
            notes,
            matchedPrivate,
            unmatchedMarkers,
            BuildTriggerRiskIndex(name, trigger.IsCustomText, riskAnalysis, fallbackReason, matchedPrivate));
        return trigger;
    }

    private static bool TryBuildEventNode(
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        string? triggerGlobal,
        string functionName,
        string rawArguments,
        out LegacyGuiNode node,
        out string? failure) =>
        TryBuildNode(
            LegacyGuiFunctionKind.Event,
            metadata,
            normalizer,
            functionName,
            rawArguments,
            expectTriggerHandle: true,
            triggerGlobal,
            out node,
            out failure);

    private static bool TryBuildActionNode(
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        string functionName,
        string rawArguments,
        out LegacyGuiNode node,
        out string? failure) =>
        TryBuildNode(
            LegacyGuiFunctionKind.Action,
            metadata,
            normalizer,
            functionName,
            rawArguments,
            expectTriggerHandle: false,
            null,
            out node,
            out failure);

    private static bool TryBuildNode(
        LegacyGuiFunctionKind kind,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        string functionName,
        string rawArguments,
        bool expectTriggerHandle,
        string? triggerGlobal,
        out LegacyGuiNode node,
        out string? failure)
    {
        node = new LegacyGuiNode(kind, functionName);
        failure = null;

        if (!metadata.TryGetStructuredRecoveryEntry(kind, functionName, out var entry))
        {
            failure = $"Skipped {kind.ToString().ToLowerInvariant()} `{functionName}` because no GUI metadata entry was available.";
            return false;
        }

        var arguments = SplitArguments(rawArguments);
        if (expectTriggerHandle && arguments.Count == 0)
        {
            failure = $"Skipped {kind.ToString().ToLowerInvariant()} `{functionName}` because it did not include the trigger handle argument.";
            return false;
        }

        if (expectTriggerHandle &&
            !string.IsNullOrWhiteSpace(triggerGlobal) &&
            !string.Equals(arguments[0], triggerGlobal, StringComparison.Ordinal))
        {
            failure = $"Skipped {kind.ToString().ToLowerInvariant()} `{functionName}` because its first argument did not match `{triggerGlobal}`.";
            return false;
        }

        var effectiveArguments = entry.EffectiveArguments;
        var payloadArguments = expectTriggerHandle ? arguments.Skip(1).ToArray() : arguments.ToArray();
        if (payloadArguments.Length != effectiveArguments.Count)
        {
            failure = $"Skipped {kind.ToString().ToLowerInvariant()} `{functionName}` because it exposed {payloadArguments.Length} argument(s), expected {effectiveArguments.Count}.";
            return false;
        }

        node = new LegacyGuiNode(kind, entry.Name);
        for (var index = 0; index < payloadArguments.Length; index++)
        {
            if (!normalizer.TryNormalize(payloadArguments[index], effectiveArguments[index], out var argument))
            {
                failure = $"Skipped {kind.ToString().ToLowerInvariant()} `{functionName}` because argument `{payloadArguments[index]}` could not be encoded back into WTG.";
                return false;
            }

            node.Arguments.Add(argument);
        }

        return true;
    }

    private static bool IsIgnorableOpaqueInitCall(string functionName) =>
        string.Equals(functionName, "DisableTrigger", StringComparison.Ordinal) ||
        string.Equals(functionName, "EnableTrigger", StringComparison.Ordinal) ||
        string.Equals(functionName, "TriggerExecute", StringComparison.Ordinal) ||
        string.Equals(functionName, "ConditionalTriggerExecute", StringComparison.Ordinal);

    private static bool TryBuildSyntheticMapInitializationEvent(
        GuiMetadataCatalog metadata,
        out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Event, "MapInitializationEvent");
        if (!metadata.TryGetStructuredRecoveryEntry(LegacyGuiFunctionKind.Event, "MapInitializationEvent", out var entry))
        {
            return false;
        }

        node = new LegacyGuiNode(LegacyGuiFunctionKind.Event, entry.Name);
        return true;
    }

    private static bool ShouldFallbackEventlessGuiTrigger(
        LegacyGuiTrigger trigger,
        bool allowStructuredExecutableTrigger,
        out string reason)
    {
        reason = string.Empty;
        if (trigger.Events.Count > 0 || trigger.Conditions.Count > 0)
        {
            return false;
        }

        if (trigger.Actions.Count == 0)
        {
            return false;
        }

        var customScriptCount = 0;
        foreach (var action in trigger.Actions)
        {
            if (TryGetCustomScriptLine(action, out _))
            {
                customScriptCount++;
            }
        }

        if (customScriptCount > 0)
        {
            reason = $"Fell back to custom-text because the trigger had no recoverable GUI events and still relied on {customScriptCount} custom-script action(s).";
            return true;
        }

        if (trigger.Actions.Any(static action => IsOpaqueEventlessAction(action.Name)))
        {
            reason = "Fell back to custom-text because the trigger had no recoverable GUI events and still relied on opaque dispatch actions.";
            return true;
        }

        if (!allowStructuredExecutableTrigger && trigger.Actions.Count > 1)
        {
            reason = $"Fell back to custom-text because the trigger had no recoverable GUI events and still expanded into {trigger.Actions.Count} GUI actions.";
            return true;
        }

        return false;
    }

    private static bool TryRecoverConditionNodes(
        JassScriptDocument script,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> conditionFunctions,
        ICollection<LegacyGuiNode> guiConditions,
        ICollection<string> guardFunctions,
        ICollection<string> notes)
    {
        var allFunctionsPresent = true;
        foreach (var conditionFunctionName in conditionFunctions)
        {
            if (!script.Functions.TryGetValue(conditionFunctionName, out var function))
            {
                notes.Add($"Missing root condition function `{conditionFunctionName}` in `war3map.j`.");
                allFunctionsPresent = false;
                continue;
            }

            if (TryParseConditionFunctionNodes(function, normalizer, out var guardedConditionNodes))
            {
                foreach (var guardedConditionNode in guardedConditionNodes)
                {
                    guiConditions.Add(guardedConditionNode);
                }

                continue;
            }

            guardFunctions.Add(conditionFunctionName);
        }

        return allFunctionsPresent;
    }

    private static bool TryParseConditionFunction(
        JassFunction function,
        GuiArgumentNormalizer normalizer,
        out LegacyGuiNode? conditionNode)
    {
        if (TryParseConditionFunctionNodes(function, normalizer, out var conditionNodes))
        {
            if (conditionNodes.Count == 0)
            {
                conditionNode = null;
                return true;
            }

            if (conditionNodes.Count == 1)
            {
                conditionNode = conditionNodes[0];
                return true;
            }
        }

        conditionNode = null;
        return false;
    }

    private static bool TryParseConditionFunctionNodes(
        JassFunction function,
        GuiArgumentNormalizer normalizer,
        out IReadOnlyList<LegacyGuiNode> conditionNodes)
    {
        var normalizedLines = function.BodyLines
            .Select(NormalizeCodeLine)
            .Where(line => !string.IsNullOrWhiteSpace(line) && !line.StartsWith("local ", StringComparison.Ordinal))
            .ToArray();

        if (normalizedLines.Length == 1 &&
            TryExtractReturnExpression(normalizedLines[0], out var returnExpression) &&
            normalizer.TryParseConditionExpression(returnExpression, out var directConditionNode))
        {
            conditionNodes = directConditionNode is null
                ? []
                : [directConditionNode];
            return true;
        }

        if (TryParseGuardedBooleanReturnExpression(normalizedLines, out var guardedExpression) &&
            normalizer.TryParseConditionExpression(guardedExpression, out var guardedConditionNode))
        {
            conditionNodes = guardedConditionNode is null
                ? []
                : [guardedConditionNode];
            return true;
        }

        if (TryParseGuardedBooleanConditionSequence(normalizedLines, normalizer, out var guardedConditionNodes))
        {
            conditionNodes = guardedConditionNodes;
            return true;
        }

        conditionNodes = [];
        return false;
    }

    private static bool TryExtractReturnExpression(string line, out string expression)
    {
        expression = string.Empty;
        if (!line.StartsWith("return", StringComparison.Ordinal))
        {
            return false;
        }

        expression = line["return".Length..].Trim();
        while (expression.Length >= 2 &&
               expression[0] == '(' &&
               expression[^1] == ')' &&
               WrapsWholeExpression(expression))
        {
            expression = expression[1..^1].Trim();
        }

        return expression.Length > 0;
    }

    private static bool TryParseGuardedBooleanReturnExpression(IReadOnlyList<string> normalizedLines, out string expression)
    {
        expression = string.Empty;
        if (normalizedLines.Count != 4 ||
            !normalizedLines[0].StartsWith("if", StringComparison.Ordinal) ||
            !string.Equals(normalizedLines[2], "endif", StringComparison.Ordinal))
        {
            return false;
        }

        if (!TryExtractIfConditionExpression(normalizedLines[0], out var conditionExpression) ||
            !TryParseBooleanReturn(normalizedLines[1], out var firstReturn) ||
            !TryParseBooleanReturn(normalizedLines[3], out var finalReturn) ||
            firstReturn == finalReturn)
        {
            return false;
        }

        if (firstReturn && !finalReturn)
        {
            expression = conditionExpression;
            return true;
        }

        return TryInvertConditionExpression(conditionExpression, out expression);
    }

    private static bool TryParseGuardedBooleanConditionSequence(
        IReadOnlyList<string> normalizedLines,
        GuiArgumentNormalizer normalizer,
        out IReadOnlyList<LegacyGuiNode> conditionNodes)
    {
        conditionNodes = [];
        if (normalizedLines.Count < 4 ||
            !TryParseBooleanReturn(normalizedLines[^1], out var finalReturn) ||
            !finalReturn)
        {
            return false;
        }

        var guardLineCount = normalizedLines.Count - 1;
        if (guardLineCount % 3 != 0)
        {
            return false;
        }

        var nodes = new List<LegacyGuiNode>();
        for (var index = 0; index < guardLineCount; index += 3)
        {
            var ifLine = normalizedLines[index];
            var returnLine = normalizedLines[index + 1];
            var endIfLine = normalizedLines[index + 2];
            if (!TryExtractIfConditionExpression(ifLine, out var guardExpression) ||
                !TryParseBooleanReturn(returnLine, out var guardReturn) ||
                !string.Equals(endIfLine, "endif", StringComparison.Ordinal) ||
                guardReturn)
            {
                return false;
            }

            if (!TryInvertConditionExpression(guardExpression, out var requiredExpression) ||
                !normalizer.TryParseConditionExpression(requiredExpression, out var conditionNode) ||
                conditionNode is null)
            {
                return false;
            }

            nodes.Add(conditionNode);
        }

        conditionNodes = nodes;
        return nodes.Count > 0;
    }

    private static bool TryExtractIfConditionExpression(string ifLine, out string expression)
    {
        expression = string.Empty;
        if (!ifLine.StartsWith("if", StringComparison.Ordinal) ||
            !ifLine.EndsWith("then", StringComparison.Ordinal))
        {
            return false;
        }

        expression = ifLine["if".Length..^"then".Length].Trim();
        while (expression.Length >= 2 &&
               expression[0] == '(' &&
               expression[^1] == ')' &&
               WrapsWholeExpression(expression))
        {
            expression = expression[1..^1].Trim();
        }

        return expression.Length > 0;
    }

    private static bool TryParseBooleanReturn(string line, out bool value)
    {
        if (string.Equals(line, "return true", StringComparison.Ordinal))
        {
            value = true;
            return true;
        }

        if (string.Equals(line, "return false", StringComparison.Ordinal))
        {
            value = false;
            return true;
        }

        value = false;
        return false;
    }

    private static bool TryInvertConditionExpression(string expression, out string inverted)
    {
        var trimmed = expression.Trim();
        while (trimmed.Length >= 2 &&
               trimmed[0] == '(' &&
               trimmed[^1] == ')' &&
               WrapsWholeExpression(trimmed))
        {
            trimmed = trimmed[1..^1].Trim();
        }

        if (!trimmed.StartsWith("not", StringComparison.Ordinal))
        {
            inverted = string.Empty;
            return false;
        }

        inverted = trimmed["not".Length..].Trim();
        while (inverted.Length >= 2 &&
               inverted[0] == '(' &&
               inverted[^1] == ')' &&
               WrapsWholeExpression(inverted))
        {
            inverted = inverted[1..^1].Trim();
        }

        return inverted.Length > 0;
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

    private static bool AppendRecoveredActionFunctions(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> actionFunctions,
        ICollection<LegacyGuiNode> actions,
        ICollection<string> notes)
    {
        var allFunctionsPresent = true;
        foreach (var actionFunctionName in actionFunctions)
        {
            if (!script.Functions.TryGetValue(actionFunctionName, out var function))
            {
                notes.Add($"Missing action function `{actionFunctionName}` in `war3map.j`.");
                allFunctionsPresent = false;
                continue;
            }

            if (!CanInlineActionFunction(function))
            {
                actions.Add(BuildCustomScriptAction($"call {actionFunctionName}()"));
                notes.Add($"Preserved action function `{actionFunctionName}` as a custom-script callback because it uses locals or early returns.");
                continue;
            }

            var normalizedLines = function.BodyLines
                .Select(NormalizeCodeLine)
                .Where(line => !string.IsNullOrWhiteSpace(line))
                .ToArray();
            var lineIndex = 0;
            AppendRecoveredActionLines(script, metadata, normalizer, normalizedLines, ref lineIndex, actions, stopAtBlockTerminator: false);
        }

        return allFunctionsPresent;
    }

    private static void AppendRecoveredActionLines(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> normalizedLines,
        ref int lineIndex,
        ICollection<LegacyGuiNode> actions,
        bool stopAtBlockTerminator,
        Func<IReadOnlyList<string>, int, bool>? shouldStop = null)
    {
        while (lineIndex < normalizedLines.Count)
        {
            if (shouldStop is not null && shouldStop(normalizedLines, lineIndex))
            {
                return;
            }

            var normalizedLine = normalizedLines[lineIndex];
            if (stopAtBlockTerminator && IsActionBlockTerminator(normalizedLine))
            {
                return;
            }

            if (TryBuildStructuredForLoopAction(script, metadata, normalizer, normalizedLines, ref lineIndex, out var loopNode))
            {
                actions.Add(loopNode);
                continue;
            }

            if (TryBuildStructuredForForceAction(script, metadata, normalizer, normalizedLines, ref lineIndex, out var forForceNode))
            {
                actions.Add(forForceNode);
                continue;
            }

            if (TryBuildStructuredIfThenElseAction(script, metadata, normalizer, normalizedLines, ref lineIndex, out var controlFlowNode))
            {
                actions.Add(controlFlowNode);
                continue;
            }

            if (TriggerEventRegex.Match(normalizedLine) is { Success: true } actionMatch &&
                TryBuildActionNode(metadata, normalizer, actionMatch.Groups[1].Value, actionMatch.Groups[2].Value, out var actionNode, out _))
            {
                actions.Add(actionNode);
                lineIndex++;
                continue;
            }

            if (ActionSetRegex.Match(normalizedLine) is { Success: true } setMatch &&
                TryBuildSetVariableAction(normalizer, setMatch.Groups[1].Value, setMatch.Groups[2].Value, out var setNode))
            {
                actions.Add(setNode);
                lineIndex++;
                continue;
            }

            actions.Add(BuildCustomScriptAction(normalizedLine));
            lineIndex++;
        }
    }

    private static bool TryBuildStructuredForLoopAction(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> normalizedLines,
        ref int lineIndex,
        out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "ForLoopAMultiple");
        if (lineIndex + 5 >= normalizedLines.Count ||
            ForLoopStartRegex.Match(normalizedLines[lineIndex]) is not { Success: true } startMatch)
        {
            return false;
        }

        var loopKind = startMatch.Groups[1].Value;
        if (ForLoopEndRegex.Match(normalizedLines[lineIndex + 1]) is not { Success: true } endMatch ||
            !string.Equals(endMatch.Groups[1].Value, loopKind, StringComparison.Ordinal) ||
            !string.Equals(normalizedLines[lineIndex + 2], "loop", StringComparison.Ordinal) ||
            ForLoopExitWhenRegex.Match(normalizedLines[lineIndex + 3]) is not { Success: true } exitMatch ||
            !string.Equals(exitMatch.Groups[1].Value, loopKind, StringComparison.Ordinal) ||
            !string.Equals(exitMatch.Groups[2].Value, loopKind, StringComparison.Ordinal))
        {
            return false;
        }

        var nodeName = string.Equals(loopKind, "B", StringComparison.Ordinal)
            ? "ForLoopBMultiple"
            : "ForLoopAMultiple";
        if (!metadata.TryGetEntry(LegacyGuiFunctionKind.Action, nodeName, out var entry))
        {
            return false;
        }

        var arguments = entry.EffectiveArguments;
        if (arguments.Count != 2 ||
            !normalizer.TryNormalize(startMatch.Groups[2].Value, arguments[0], out var startArgument) ||
            !normalizer.TryNormalize(endMatch.Groups[2].Value, arguments[1], out var endArgument))
        {
            return false;
        }

        var originalIndex = lineIndex;
        lineIndex += 4;
        var bodyNodes = new List<LegacyGuiNode>();
        AppendRecoveredActionLines(
            script,
            metadata,
            normalizer,
            normalizedLines,
            ref lineIndex,
            bodyNodes,
            stopAtBlockTerminator: false,
            shouldStop: (lines, index) => IsForLoopTerminator(lines, index, loopKind));

        if (!IsForLoopTerminator(normalizedLines, lineIndex, loopKind))
        {
            lineIndex = originalIndex;
            return false;
        }

        lineIndex += 2;
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, nodeName);
        node.Arguments.Add(startArgument);
        node.Arguments.Add(endArgument);
        var actionBlock = new LegacyGuiNodeBlock("actions");
        actionBlock.Nodes.AddRange(bodyNodes);
        node.ChildBlocks.Add(actionBlock);
        return true;
    }

    private static bool IsForLoopTerminator(IReadOnlyList<string> normalizedLines, int lineIndex, string loopKind)
    {
        if (lineIndex + 1 >= normalizedLines.Count ||
            ForLoopIncrementRegex.Match(normalizedLines[lineIndex]) is not { Success: true } incrementMatch ||
            !string.Equals(incrementMatch.Groups[1].Value, loopKind, StringComparison.Ordinal) ||
            !string.Equals(incrementMatch.Groups[2].Value, loopKind, StringComparison.Ordinal))
        {
            return false;
        }

        return string.Equals(normalizedLines[lineIndex + 1], "endloop", StringComparison.Ordinal);
    }

    private static bool TryBuildStructuredForForceAction(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> normalizedLines,
        ref int lineIndex,
        out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "ForForceMultiple");
        if (ForForceCallbackRegex.Match(normalizedLines[lineIndex]) is not { Success: true } match)
        {
            return false;
        }

        if (!metadata.TryGetEntry(LegacyGuiFunctionKind.Action, "ForForceMultiple", out var entry))
        {
            return false;
        }

        var arguments = entry.EffectiveArguments;
        if (arguments.Count != 1 ||
            !normalizer.TryNormalize(match.Groups[1].Value, arguments[0], out var forceArgument))
        {
            return false;
        }

        var callbackFunctionName = match.Groups[2].Value;
        if (!script.Functions.TryGetValue(callbackFunctionName, out var callbackFunction) ||
            !CanInlineActionFunction(callbackFunction))
        {
            return false;
        }

        var callbackLines = callbackFunction.BodyLines
            .Select(NormalizeCodeLine)
            .Where(line => !string.IsNullOrWhiteSpace(line))
            .ToArray();
        var callbackIndex = 0;
        var callbackActions = new List<LegacyGuiNode>();
        AppendRecoveredActionLines(
            script,
            metadata,
            normalizer,
            callbackLines,
            ref callbackIndex,
            callbackActions,
            stopAtBlockTerminator: false);
        if (callbackIndex != callbackLines.Length)
        {
            return false;
        }

        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "ForForceMultiple");
        node.Arguments.Add(forceArgument);
        var actionBlock = new LegacyGuiNodeBlock("actions");
        actionBlock.Nodes.AddRange(callbackActions);
        node.ChildBlocks.Add(actionBlock);
        lineIndex++;
        return true;
    }

    private static bool TryBuildStructuredIfThenElseAction(
        JassScriptDocument script,
        GuiMetadataCatalog metadata,
        GuiArgumentNormalizer normalizer,
        IReadOnlyList<string> normalizedLines,
        ref int lineIndex,
        out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "IfThenElseMultiple");
        if (lineIndex >= normalizedLines.Count)
        {
            return false;
        }

        var originalIndex = lineIndex;
        var ifLikeLine = normalizedLines[lineIndex];
        if (IsElseIfLine(ifLikeLine))
        {
            return false;
        }

        if (!TryExtractIfConditionExpression(ifLikeLine, out var conditionExpression) ||
            !TryParseActionConditionExpression(script, normalizer, conditionExpression, out var conditionNode) ||
            conditionNode is null)
        {
            lineIndex = originalIndex;
            return false;
        }

        lineIndex++;
        var thenNodes = new List<LegacyGuiNode>();
        AppendRecoveredActionLines(script, metadata, normalizer, normalizedLines, ref lineIndex, thenNodes, stopAtBlockTerminator: true);
        if (ContainsInlineReturn(thenNodes))
        {
            lineIndex = originalIndex;
            return false;
        }

        var elseNodes = new List<LegacyGuiNode>();
        if (lineIndex < normalizedLines.Count &&
                 string.Equals(normalizedLines[lineIndex], "else", StringComparison.Ordinal))
        {
            lineIndex++;
            AppendRecoveredActionLines(script, metadata, normalizer, normalizedLines, ref lineIndex, elseNodes, stopAtBlockTerminator: true);
            if (ContainsInlineReturn(elseNodes))
            {
                lineIndex = originalIndex;
                return false;
            }
        }

        if (lineIndex >= normalizedLines.Count ||
            !string.Equals(normalizedLines[lineIndex], "endif", StringComparison.Ordinal))
        {
            lineIndex = originalIndex;
            return false;
        }

        lineIndex++;
        var conditionBlock = new LegacyGuiNodeBlock("conditions");
        conditionBlock.Nodes.Add(conditionNode);
        var thenBlock = new LegacyGuiNodeBlock("then");
        thenBlock.Nodes.AddRange(thenNodes);
        var elseBlock = new LegacyGuiNodeBlock("else");
        elseBlock.Nodes.AddRange(elseNodes);

        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "IfThenElseMultiple");
        node.ChildBlocks.Add(conditionBlock);
        node.ChildBlocks.Add(thenBlock);
        node.ChildBlocks.Add(elseBlock);
        return true;
    }

    private static bool TryParseActionConditionExpression(
        JassScriptDocument script,
        GuiArgumentNormalizer normalizer,
        string rawExpression,
        out LegacyGuiNode? conditionNode)
    {
        if (normalizer.TryParseConditionExpression(rawExpression, out conditionNode))
        {
            return conditionNode is not null;
        }

        var value = rawExpression.Trim();
        if (ZeroArgumentFunctionCallRegex.Match(value) is not { Success: true } helperMatch ||
            !script.Functions.TryGetValue(helperMatch.Groups[1].Value, out var helperFunction))
        {
            conditionNode = null;
            return false;
        }

        return TryParseConditionFunction(helperFunction, normalizer, out conditionNode) &&
               conditionNode is not null;
    }

    private static bool IsActionBlockTerminator(string normalizedLine) =>
        string.Equals(normalizedLine, "else", StringComparison.Ordinal) ||
        string.Equals(normalizedLine, "endif", StringComparison.Ordinal) ||
        IsElseIfLine(normalizedLine);

    private static bool IsElseIfLine(string normalizedLine) =>
        normalizedLine.StartsWith("elseif ", StringComparison.Ordinal) ||
        normalizedLine.StartsWith("elseif(", StringComparison.Ordinal);

    private static bool ContainsInlineReturn(IReadOnlyList<LegacyGuiNode> actions)
    {
        foreach (var action in actions)
        {
            if (TryGetCustomScriptLine(action, out var line) &&
                string.Equals(line, "return", StringComparison.Ordinal))
            {
                return true;
            }

            foreach (var block in action.ChildBlocks)
            {
                if (ContainsInlineReturn(block.Nodes))
                {
                    return true;
                }
            }
        }

        return false;
    }

    private static bool TryBuildSetVariableAction(
        GuiArgumentNormalizer normalizer,
        string targetRaw,
        string valueRaw,
        out LegacyGuiNode node)
    {
        node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "SetVariable");
        if (!normalizer.TryNormalize(targetRaw, "AnyGlobal", out var variableArgument) ||
            !normalizer.TryNormalize(valueRaw, "Null", out var valueArgument))
        {
            return false;
        }

        node.Arguments.Add(variableArgument);
        node.Arguments.Add(valueArgument);
        return true;
    }

    private static void AppendConditionGuardActions(ICollection<LegacyGuiNode> actions, IReadOnlyList<string> guardFunctions)
    {
        foreach (var conditionFunctionName in guardFunctions)
        {
            actions.Add(BuildCustomScriptAction($"if not {conditionFunctionName}() then"));
            actions.Add(BuildCustomScriptAction("return"));
            actions.Add(BuildCustomScriptAction("endif"));
        }
    }

    private static bool ShouldFallbackPseudoGuiTrigger(
        LegacyGuiTrigger trigger,
        TriggerRiskAnalysis analysis,
        out string reason)
    {
        reason = string.Empty;
        var customScriptCount = analysis.CustomScriptCount;
        var controlFlowCount = analysis.ControlFlowCount;
        var actionCount = analysis.ActionCount;
        var opaqueDispatchCount = trigger.Actions.Count(action => IsOpaqueEventlessAction(action.Name));

        if (actionCount >= VeryLargeGuiActionThreshold &&
            IsLargeStructuredSetVariableTrigger(trigger, analysis))
        {
            return false;
        }

        if (TryGetStringHeavyQuestTimerPayloadLength(trigger, analysis, out var questPayloadLength))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger packed {actionCount} CreateQuestBJ actions with {questPayloadLength} constant characters behind a single timer event.";
            return true;
        }

        if (IsLargeStructuredSingleTimerTrigger(trigger, analysis))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger stayed very large at {actionCount} actions behind a single timer event.";
            return true;
        }

        if (actionCount >= VeryLargeGuiActionThreshold)
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger expanded into {actionCount} flat actions.";
            return true;
        }

        if (actionCount >= HighActionPseudoGuiActionThreshold &&
            (customScriptCount >= HighActionPseudoGuiCustomScriptThreshold ||
             controlFlowCount >= HighActionPseudoGuiControlFlowThreshold))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still expanded into {actionCount} flat actions, including {customScriptCount} custom-script lines and {controlFlowCount} control-flow custom-script markers.";
            return true;
        }

        if (actionCount >= DensePseudoGuiActionThreshold &&
            (customScriptCount >= DensePseudoGuiCustomScriptThreshold ||
             controlFlowCount >= DensePseudoGuiControlFlowThreshold))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger remained a dense pseudo-GUI body with {actionCount} flat actions, {customScriptCount} custom-script lines, and {controlFlowCount} control-flow custom-script markers.";
            return true;
        }

        if (actionCount >= SmallAllCustomPseudoGuiActionThreshold &&
            customScriptCount + SmallAllCustomPseudoGuiAllowedStructuredActions >= actionCount)
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger stayed almost entirely custom-script with {customScriptCount} custom-script lines across {actionCount} actions.";
            return true;
        }

        if (actionCount >= SmallAllCustomPseudoGuiActionThreshold &&
            (opaqueDispatchCount * 4) >= (actionCount * 3))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still expanded into opaque dispatch helpers across {actionCount} actions.";
            return true;
        }

        if (actionCount >= SmallBranchyPseudoGuiActionThreshold &&
            customScriptCount >= SmallBranchyPseudoGuiCustomScriptThreshold &&
            controlFlowCount >= SmallBranchyPseudoGuiControlFlowThreshold)
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still looked like a small branch-heavy pseudo-GUI body with {customScriptCount} custom-script lines and {controlFlowCount} control-flow markers across {actionCount} actions.";
            return true;
        }

        if (actionCount >= ScriptHeavyPseudoGuiActionThreshold &&
            customScriptCount >= ScriptHeavyPseudoGuiCustomScriptThreshold &&
            (customScriptCount * 3) >= (actionCount * 2))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger stayed script-heavy with {customScriptCount} custom-script lines across {actionCount} actions.";
            return true;
        }

        if (actionCount >= ScriptHeavyPseudoGuiActionThreshold &&
            (opaqueDispatchCount * 3) >= (actionCount * 2))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger stayed opaque-dispatch-heavy with {opaqueDispatchCount} dispatch actions across {actionCount} actions.";
            return true;
        }

        if (actionCount >= CompactScriptHeavyPseudoGuiActionThreshold &&
            (controlFlowCount >= CompactScriptHeavyPseudoGuiControlFlowThreshold ||
             (customScriptCount >= CompactScriptHeavyPseudoGuiCustomScriptThreshold &&
              (customScriptCount * 4) >= (actionCount * 3))))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still looked like a compact script-heavy body with {customScriptCount} custom-script lines and {controlFlowCount} control-flow markers across {actionCount} actions.";
            return true;
        }

        if (actionCount >= VeryCompactScriptHeavyPseudoGuiActionThreshold &&
            customScriptCount >= VeryCompactScriptHeavyPseudoGuiCustomScriptThreshold &&
            (controlFlowCount >= VeryCompactScriptHeavyPseudoGuiControlFlowThreshold ||
             (customScriptCount * 5) >= (actionCount * 4)))
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still looked like a very compact script-heavy body with {customScriptCount} custom-script lines and {controlFlowCount} control-flow markers across {actionCount} actions.";
            return true;
        }

        if (actionCount >= CompactPseudoGuiActionThreshold &&
            controlFlowCount >= CompactPseudoGuiControlFlowThreshold)
        {
            reason =
                $"Fell back to custom-text because the reconstructed GUI trigger still flattened control flow into {controlFlowCount} custom-script markers across {actionCount} actions.";
            return true;
        }

        return false;
    }

    private static bool IsOpaqueEventlessAction(string actionName) =>
        string.Equals(actionName, "ExecuteFunc", StringComparison.Ordinal) ||
        string.Equals(actionName, "ConditionalTriggerExecute", StringComparison.Ordinal) ||
        string.Equals(actionName, "TriggerExecute", StringComparison.Ordinal);

    private static bool IsLargeStructuredSetVariableTrigger(
        LegacyGuiTrigger trigger,
        TriggerRiskAnalysis analysis)
    {
        return analysis.CustomScriptCount == 0 &&
               analysis.ControlFlowCount == 0 &&
               trigger.Actions.Count > 0 &&
               trigger.Actions.All(static action => string.Equals(action.Name, "SetVariable", StringComparison.Ordinal));
    }

    private static bool IsLargeStructuredSingleTimerTrigger(
        LegacyGuiTrigger trigger,
        TriggerRiskAnalysis analysis)
    {
        return analysis.ActionCount >= DensePseudoGuiActionThreshold &&
               analysis.CustomScriptCount == 0 &&
               analysis.ControlFlowCount == 0 &&
               trigger.Events.Count == 1 &&
               trigger.Conditions.Count == 0 &&
               string.Equals(trigger.Events[0].Name, "TriggerRegisterTimerEventSingle", StringComparison.Ordinal) &&
               trigger.Actions.Any(static action => action.ChildBlocks.Count > 0);
    }

    private static bool TryGetStringHeavyQuestTimerPayloadLength(
        LegacyGuiTrigger trigger,
        TriggerRiskAnalysis analysis,
        out int constantPayloadLength)
    {
        constantPayloadLength = 0;
        if (analysis.CustomScriptCount != 0 ||
            analysis.ControlFlowCount != 0 ||
            trigger.Events.Count != 1 ||
            trigger.Conditions.Count != 0 ||
            trigger.Actions.Count < StringHeavyQuestTimerActionThreshold ||
            !string.Equals(trigger.Events[0].Name, "TriggerRegisterTimerEventSingle", StringComparison.Ordinal) ||
            !trigger.Actions.All(static action => string.Equals(action.Name, "CreateQuestBJ", StringComparison.Ordinal)))
        {
            return false;
        }

        constantPayloadLength = GetTotalConstantPayloadLength(trigger.Actions);
        return constantPayloadLength >= StringHeavyQuestTimerConstantPayloadThreshold;
    }

    private static TriggerRiskAnalysis AnalyzeTriggerRisk(LegacyGuiTrigger trigger)
    {
        var customScriptCount = 0;
        var controlFlowCount = 0;
        var bodyCustomScriptCount = 0;
        var bodyControlFlowCount = 0;
        var hasRootConditionGuard = HasRootConditionGuard(trigger.Actions);
        var actionCount = CountActionNodes(trigger.Actions);
        AccumulateActionRisk(
            trigger.Actions,
            hasRootConditionGuard ? RootConditionGuardActionCount : 0,
            ref customScriptCount,
            ref controlFlowCount,
            ref bodyCustomScriptCount,
            ref bodyControlFlowCount);

        return new TriggerRiskAnalysis(
            trigger.Events.Count,
            trigger.Conditions.Count,
            actionCount,
            customScriptCount,
            controlFlowCount,
            hasRootConditionGuard,
            bodyCustomScriptCount,
            bodyControlFlowCount);
    }

    private static int CountActionNodes(IReadOnlyList<LegacyGuiNode> nodes)
    {
        var count = 0;
        foreach (var node in nodes)
        {
            if (node.Kind == LegacyGuiFunctionKind.Action)
            {
                count++;
            }

            foreach (var block in node.ChildBlocks)
            {
                count += CountActionNodes(block.Nodes);
            }
        }

        return count;
    }

    private static int GetTotalConstantPayloadLength(IReadOnlyList<LegacyGuiNode> nodes)
    {
        var total = 0;
        foreach (var node in nodes)
        {
            total += GetTotalConstantPayloadLength(node);
        }

        return total;
    }

    private static int GetTotalConstantPayloadLength(LegacyGuiNode node)
    {
        var total = 0;
        foreach (var argument in node.Arguments)
        {
            total += GetTotalConstantPayloadLength(argument);
        }

        foreach (var block in node.ChildBlocks)
        {
            total += GetTotalConstantPayloadLength(block.Nodes);
        }

        return total;
    }

    private static int GetTotalConstantPayloadLength(LegacyGuiArgument argument)
    {
        var total = argument.Kind == LegacyGuiArgumentKind.Constant ? argument.Value.Length : 0;
        if (argument.CallNode is not null)
        {
            total += GetTotalConstantPayloadLength(argument.CallNode);
        }

        if (argument.ArrayIndex is not null)
        {
            total += GetTotalConstantPayloadLength(argument.ArrayIndex);
        }

        return total;
    }

    private static void AccumulateActionRisk(
        IReadOnlyList<LegacyGuiNode> nodes,
        int rootGuardSkipCount,
        ref int customScriptCount,
        ref int controlFlowCount,
        ref int bodyCustomScriptCount,
        ref int bodyControlFlowCount)
    {
        for (var index = 0; index < nodes.Count; index++)
        {
            var node = nodes[index];
            if (node.Kind == LegacyGuiFunctionKind.Action &&
                TryGetCustomScriptLine(node, out var line))
            {
                customScriptCount++;
                var isControlFlow = IsControlFlowCustomScript(line);
                if (isControlFlow)
                {
                    controlFlowCount++;
                }

                if (rootGuardSkipCount == 0 || index >= rootGuardSkipCount)
                {
                    bodyCustomScriptCount++;
                    if (isControlFlow)
                    {
                        bodyControlFlowCount++;
                    }
                }
            }

            foreach (var block in node.ChildBlocks)
            {
                AccumulateActionRisk(
                    block.Nodes,
                    0,
                    ref customScriptCount,
                    ref controlFlowCount,
                    ref bodyCustomScriptCount,
                    ref bodyControlFlowCount);
            }
        }
    }

    private static RecoveredTriggerRiskIndexEntry BuildTriggerRiskIndex(
        string name,
        bool isCustomText,
        TriggerRiskAnalysis analysis,
        string? fallbackReason,
        IReadOnlyList<string> matchedPrivateSemantics)
    {
        return new RecoveredTriggerRiskIndexEntry(
            name,
            isCustomText,
            analysis.EventCount,
            analysis.ConditionCount,
            analysis.ActionCount,
            analysis.CustomScriptCount,
            analysis.ControlFlowCount,
            fallbackReason,
            matchedPrivateSemantics);
    }

    private static bool TryGetCustomScriptLine(LegacyGuiNode action, out string line)
    {
        line = string.Empty;
        if (!string.Equals(action.Name, "CustomScriptCode", StringComparison.Ordinal) ||
            action.Arguments.Count != 1 ||
            action.Arguments[0].Kind != LegacyGuiArgumentKind.Constant)
        {
            return false;
        }

        line = action.Arguments[0].Value.Trim();
        return true;
    }

    private static bool IsControlFlowCustomScript(string line)
    {
        return line.StartsWith("if ", StringComparison.Ordinal) ||
               line.StartsWith("if(", StringComparison.Ordinal) ||
               line.StartsWith("elseif ", StringComparison.Ordinal) ||
               line.StartsWith("elseif(", StringComparison.Ordinal) ||
               string.Equals(line, "else", StringComparison.Ordinal) ||
               string.Equals(line, "endif", StringComparison.Ordinal) ||
               string.Equals(line, "return", StringComparison.Ordinal) ||
               string.Equals(line, "loop", StringComparison.Ordinal) ||
               string.Equals(line, "endloop", StringComparison.Ordinal) ||
               line.StartsWith("exitwhen", StringComparison.Ordinal);
    }

    private static bool HasRootConditionGuard(IReadOnlyList<LegacyGuiNode> actions)
    {
        if (actions.Count < RootConditionGuardActionCount)
        {
            return false;
        }

        return TryGetCustomScriptLine(actions[0], out var firstLine) &&
               TryGetCustomScriptLine(actions[1], out var secondLine) &&
               TryGetCustomScriptLine(actions[2], out var thirdLine) &&
               firstLine.StartsWith("if not ", StringComparison.Ordinal) &&
               firstLine.EndsWith("then", StringComparison.Ordinal) &&
               string.Equals(secondLine, "return", StringComparison.Ordinal) &&
               string.Equals(thirdLine, "endif", StringComparison.Ordinal);
    }

    private static bool CanInlineActionFunction(JassFunction function)
    {
        foreach (var line in function.BodyLines.Select(NormalizeCodeLine))
        {
            if (string.IsNullOrWhiteSpace(line))
            {
                continue;
            }

            if (line.StartsWith("local ", StringComparison.Ordinal) ||
                line.StartsWith("return", StringComparison.Ordinal))
            {
                return false;
            }
        }

        return true;
    }

    private static LegacyGuiNode BuildCustomScriptAction(string codeLine)
    {
        var node = new LegacyGuiNode(LegacyGuiFunctionKind.Action, "CustomScriptCode");
        node.Arguments.Add(LegacyGuiArgument.Constant(codeLine));
        return node;
    }

    private static LegacyGuiTrigger BuildCustomTextTrigger(
        string name,
        bool enabled,
        bool runOnMapInit,
        string customText)
    {
        return new LegacyGuiTrigger
        {
            Name = name,
            Description = string.Empty,
            Type = 0,
            Enabled = enabled,
            IsCustomText = true,
            StartsClosed = false,
            RunOnMapInit = runOnMapInit,
            CategoryId = 0,
            CustomText = customText
        };
    }

    private static IReadOnlyList<JassFunction> SelectCustomTextChunkFunctions(
        JassScriptDocument script,
        string initTriggerFunctionName,
        IReadOnlyList<JassFunction> referencedFunctions)
    {
        if (referencedFunctions.Count == 0)
        {
            return referencedFunctions;
        }

        var triggerLocalPrefix = TryGetTriggerLocalPrefix(initTriggerFunctionName);
        var selectedNames = new HashSet<string>(StringComparer.Ordinal);
        foreach (var function in referencedFunctions)
        {
            if (IsTriggerLocalFunctionName(function.Name, initTriggerFunctionName, triggerLocalPrefix))
            {
                selectedNames.Add(function.Name);
            }
        }

        if (selectedNames.Count == 0)
        {
            selectedNames.Add(initTriggerFunctionName);
        }

        if (script.Functions.TryGetValue(initTriggerFunctionName, out var initFunction))
        {
            foreach (var candidate in EnumerateReferencedFunctionNamesInEncounterOrder(initFunction))
            {
                if (!script.Functions.ContainsKey(candidate) ||
                    IsTriggerLocalFunctionName(candidate, initTriggerFunctionName, triggerLocalPrefix) ||
                    IsCrossTriggerInitOrActionFunction(candidate))
                {
                    continue;
                }

                selectedNames.Add(candidate);
            }
        }

        var selectedFunctions = script.GetFunctionsInSourceOrder(selectedNames);
        return selectedFunctions.Count > 0 ? selectedFunctions : referencedFunctions;
    }

    private static IReadOnlyList<JassFunction> CollectFunctionClosure(
        JassScriptDocument script,
        string initTriggerFunctionName,
        IReadOnlyList<string> actionFunctions,
        IReadOnlyList<string> conditionFunctions,
        IEnumerable<string>? extraReferencedFunctions = null)
    {
        var orderedNames = new List<string>();
        var includedFunctions = new HashSet<string>(StringComparer.Ordinal);
        var queuedFunctions = new HashSet<string>(StringComparer.Ordinal);
        var queue = new Queue<string>();
        var triggerLocalPrefix = TryGetTriggerLocalPrefix(initTriggerFunctionName);

        void EnqueuePreferred(IEnumerable<string> functionNames)
        {
            var localNames = new List<string>();
            var externalNames = new List<string>();

            foreach (var functionName in functionNames)
            {
                if (!script.Functions.ContainsKey(functionName) ||
                    includedFunctions.Contains(functionName) ||
                    !queuedFunctions.Add(functionName))
                {
                    continue;
                }

                if (IsTriggerLocalFunctionName(functionName, initTriggerFunctionName, triggerLocalPrefix))
                {
                    localNames.Add(functionName);
                }
                else
                {
                    externalNames.Add(functionName);
                }
            }

            foreach (var functionName in localNames)
            {
                queue.Enqueue(functionName);
            }

            foreach (var functionName in externalNames)
            {
                queue.Enqueue(functionName);
            }
        }

        void IncludeFunction(string functionName)
        {
            if (!includedFunctions.Add(functionName) ||
                !script.Functions.TryGetValue(functionName, out var function))
            {
                return;
            }

            orderedNames.Add(functionName);
            if (!string.Equals(functionName, initTriggerFunctionName, StringComparison.Ordinal))
            {
                EnqueuePreferred(EnumerateReferencedFunctionNamesInEncounterOrder(function));
            }
        }

        IncludeFunction(initTriggerFunctionName);
        EnqueuePreferred(actionFunctions);
        EnqueuePreferred(conditionFunctions);

        if (extraReferencedFunctions is not null)
        {
            EnqueuePreferred(extraReferencedFunctions);
        }

        while (queue.Count > 0)
        {
            var functionName = queue.Dequeue();
            queuedFunctions.Remove(functionName);
            IncludeFunction(functionName);
        }

        var functions = new List<JassFunction>(orderedNames.Count);
        foreach (var functionName in orderedNames)
        {
            if (script.Functions.TryGetValue(functionName, out var function))
            {
                functions.Add(function);
            }
        }

        return functions;
    }

    private static string BuildCustomTextChunk(
        JassScriptDocument script,
        string triggerName,
        IReadOnlyList<JassFunction> functions)
    {
        if (TryBuildCustomTextChunkFromSource(script, functions, out var sourceChunk))
        {
            return NormalizeCustomTextChunkForEditor(sourceChunk);
        }

        var builder = new StringBuilder();
        builder.AppendLine("//=========================================================================== ");
        builder.AppendLine($"// Trigger: {triggerName}");
        builder.AppendLine("//=========================================================================== ");
        foreach (var function in functions)
        {
            builder.AppendLine(function.FullText.TrimEnd());
            builder.AppendLine();
        }

        return NormalizeCustomTextChunkForEditor(builder.ToString());
    }

    private static bool TryBuildCustomTextChunkFromSource(
        JassScriptDocument script,
        IReadOnlyList<JassFunction> functions,
        out string sourceChunk)
    {
        sourceChunk = string.Empty;
        if (functions.Count == 0 || script.SourceLines.Count == 0)
        {
            return false;
        }

        var functionNames = new HashSet<string>(functions.Select(static function => function.Name), StringComparer.Ordinal);
        var selectedFunctions = script.GetFunctionsInSourceOrder(functionNames);
        if (selectedFunctions.Count == 0)
        {
            return false;
        }

        var ranges = new List<(int Start, int End)>();
        foreach (var function in selectedFunctions)
        {
            var rangeStart = ExpandCustomTextSourceStart(script.SourceLines, function.StartLineIndex);
            var rangeEnd = function.EndLineIndex;
            if (ranges.Count > 0 && CanMergeCustomTextSourceRange(script.SourceLines, ranges[^1], rangeStart))
            {
                var previous = ranges[^1];
                ranges[^1] = (previous.Start, Math.Max(previous.End, rangeEnd));
                continue;
            }

            ranges.Add((rangeStart, rangeEnd));
        }

        if (ranges.Count == 0)
        {
            return false;
        }

        var builder = new StringBuilder();
        for (var rangeIndex = 0; rangeIndex < ranges.Count; rangeIndex++)
        {
            var (start, end) = ranges[rangeIndex];
            if (builder.Length > 0)
            {
                builder.AppendLine();
            }

            for (var lineIndex = start; lineIndex <= end; lineIndex++)
            {
                builder.AppendLine(script.SourceLines[lineIndex]);
            }
        }

        sourceChunk = builder.ToString().Trim();
        return sourceChunk.Length > 0;
    }

    private static string NormalizeCustomTextChunkForEditor(string customText)
    {
        var body = StripLeadingDecorativeCustomTextPreamble(customText);
        if (body.StartsWith("//TESH.scrollpos=", StringComparison.Ordinal))
        {
            return body;
        }

        return string.Join(
            Environment.NewLine,
            new[]
            {
                "//TESH.scrollpos=0",
                "//TESH.alwaysfold=0",
                body,
            }.Where(static line => line.Length > 0)).TrimEnd();
    }

    private static string StripLeadingDecorativeCustomTextPreamble(string customText)
    {
        if (string.IsNullOrWhiteSpace(customText))
        {
            return string.Empty;
        }

        var lines = customText
            .Replace("\r\n", "\n", StringComparison.Ordinal)
            .Replace('\r', '\n')
            .Split('\n');

        var start = 0;
        while (start < lines.Length)
        {
            var trimmed = lines[start].Trim();
            if (trimmed.Length == 0)
            {
                start++;
                continue;
            }

            if (trimmed.StartsWith("//TESH.", StringComparison.Ordinal) ||
                trimmed.StartsWith("// Trigger:", StringComparison.Ordinal) ||
                trimmed.StartsWith("//==", StringComparison.Ordinal) ||
                trimmed.StartsWith("function ", StringComparison.Ordinal) ||
                string.Equals(trimmed, "globals", StringComparison.Ordinal) ||
                trimmed.StartsWith("<?import(", StringComparison.Ordinal))
            {
                break;
            }

            if (!IsDecorativeCustomTextCommentLine(trimmed))
            {
                break;
            }

            start++;
        }

        return string.Join(Environment.NewLine, lines.Skip(start)).TrimEnd();
    }

    private static bool IsDecorativeCustomTextCommentLine(string trimmedLine)
    {
        if (!trimmedLine.StartsWith("//", StringComparison.Ordinal) ||
            trimmedLine.Length <= 2)
        {
            return false;
        }

        for (var index = 2; index < trimmedLine.Length; index++)
        {
            var ch = trimmedLine[index];
            if (!(ch == '/' || ch == '*' || ch == '=' || ch == '-' || ch == '_' || ch == '#'))
            {
                return false;
            }
        }

        return true;
    }

    private static int ExpandCustomTextSourceStart(IReadOnlyList<string> sourceLines, int startLineIndex)
    {
        var expandedStart = startLineIndex;
        var cursor = startLineIndex - 1;

        while (cursor >= 0 && IsCommentOrWhitespaceLine(sourceLines[cursor]))
        {
            expandedStart = cursor;
            cursor--;
        }

        if (cursor >= 0 &&
            IsEndGlobalsLine(sourceLines[cursor]) &&
            TryFindGlobalsBlockStart(sourceLines, cursor, out var globalsStart))
        {
            var headerStart = globalsStart;
            var headerCursor = globalsStart - 1;
            while (headerCursor >= 0 && IsCommentOrWhitespaceLine(sourceLines[headerCursor]))
            {
                headerStart = headerCursor;
                headerCursor--;
            }

            if (ContainsTriggerHeader(sourceLines, headerStart, globalsStart - 1))
            {
                expandedStart = headerStart;
            }
        }

        return expandedStart;
    }

    private static bool CanMergeCustomTextSourceRange(
        IReadOnlyList<string> sourceLines,
        (int Start, int End) existingRange,
        int nextRangeStart)
    {
        if (nextRangeStart <= existingRange.End + 1)
        {
            return true;
        }

        for (var lineIndex = existingRange.End + 1; lineIndex < nextRangeStart; lineIndex++)
        {
            if (!IsCommentOrWhitespaceLine(sourceLines[lineIndex]))
            {
                return false;
            }
        }

        return true;
    }

    private static bool TryFindGlobalsBlockStart(
        IReadOnlyList<string> sourceLines,
        int endGlobalsLineIndex,
        out int globalsStartLineIndex)
    {
        for (var lineIndex = endGlobalsLineIndex - 1; lineIndex >= 0; lineIndex--)
        {
            var trimmed = sourceLines[lineIndex].Trim();
            if (string.Equals(trimmed, "globals", StringComparison.Ordinal))
            {
                globalsStartLineIndex = lineIndex;
                return true;
            }

            if (trimmed.StartsWith("function ", StringComparison.Ordinal) ||
                string.Equals(trimmed, "endfunction", StringComparison.Ordinal))
            {
                break;
            }
        }

        globalsStartLineIndex = -1;
        return false;
    }

    private static bool ContainsTriggerHeader(
        IReadOnlyList<string> sourceLines,
        int startLineIndex,
        int endLineIndex)
    {
        for (var lineIndex = startLineIndex; lineIndex <= endLineIndex; lineIndex++)
        {
            var trimmed = sourceLines[lineIndex].Trim();
            if (trimmed.StartsWith("// Trigger:", StringComparison.Ordinal) ||
                trimmed.StartsWith("//TESH.", StringComparison.Ordinal) ||
                string.Equals(trimmed, "//===========", StringComparison.Ordinal))
            {
                return true;
            }

            if (trimmed.StartsWith("//", StringComparison.Ordinal) &&
                trimmed.Contains("Trigger:", StringComparison.Ordinal))
            {
                return true;
            }
        }

        return false;
    }

    private static bool IsCommentOrWhitespaceLine(string line)
    {
        var trimmed = line.Trim();
        return trimmed.Length == 0 || trimmed.StartsWith("//", StringComparison.Ordinal);
    }

    private static bool IsEndGlobalsLine(string line)
    {
        return string.Equals(line.Trim(), "endglobals", StringComparison.Ordinal);
    }

    private static string? TryGetTriggerLocalPrefix(string initTriggerFunctionName)
    {
        return initTriggerFunctionName.StartsWith("InitTrig_", StringComparison.Ordinal)
            ? "Trig_" + initTriggerFunctionName["InitTrig_".Length..]
            : null;
    }

    private static bool IsTriggerLocalFunctionName(string functionName, string initTriggerFunctionName, string? triggerLocalPrefix)
    {
        return string.Equals(functionName, initTriggerFunctionName, StringComparison.Ordinal) ||
            (triggerLocalPrefix is not null && functionName.StartsWith(triggerLocalPrefix, StringComparison.Ordinal));
    }

    private static bool IsCrossTriggerInitOrActionFunction(string functionName)
    {
        return functionName.StartsWith("Trig_", StringComparison.Ordinal) ||
            functionName.StartsWith("InitTrig_", StringComparison.Ordinal);
    }

    private static IReadOnlyList<string> EnumerateReferencedFunctionNamesInEncounterOrder(JassFunction function)
    {
        var candidates = new List<string>();
        var seenCandidates = new HashSet<string>(StringComparer.Ordinal);

        void AddCandidate(string candidate)
        {
            if (!string.IsNullOrWhiteSpace(candidate) && seenCandidates.Add(candidate))
            {
                candidates.Add(candidate);
            }
        }

        foreach (var line in function.BodyLines)
        {
            var normalizedLine = NormalizeCodeLine(line);
            foreach (Match match in FunctionReferenceRegex.Matches(normalizedLine))
            {
                for (var groupIndex = 1; groupIndex < match.Groups.Count; groupIndex++)
                {
                    var candidate = match.Groups[groupIndex].Value;
                    AddCandidate(candidate);
                }
            }

            foreach (Match match in CallbackFunctionReferenceRegex.Matches(normalizedLine))
            {
                AddCandidate(match.Groups[1].Value);
            }

            foreach (var candidate in EnumerateDirectFunctionCallCandidates(normalizedLine))
            {
                AddCandidate(candidate);
            }

            foreach (var candidate in EnumerateInlineFunctionReferenceCandidates(normalizedLine))
            {
                AddCandidate(candidate);
            }
        }

        return candidates;
    }

    private static IEnumerable<string> EnumerateDirectFunctionCallCandidates(string line)
    {
        var quote = false;
        var rawcode = false;
        for (var index = 0; index < line.Length; index++)
        {
            var current = line[index];
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

            if (quote || rawcode || !(char.IsLetter(current) || current == '_'))
            {
                continue;
            }

            var start = index;
            while (index + 1 < line.Length &&
                (char.IsLetterOrDigit(line[index + 1]) || line[index + 1] == '_'))
            {
                index++;
            }

            var candidate = line[start..(index + 1)];
            if (IgnoredDirectFunctionCallKeywords.Contains(candidate))
            {
                continue;
            }

            var lookahead = index + 1;
            while (lookahead < line.Length && char.IsWhiteSpace(line[lookahead]))
            {
                lookahead++;
            }

            if (lookahead < line.Length && line[lookahead] == '(')
            {
                yield return candidate;
            }
        }
    }

    private static IEnumerable<string> EnumerateInlineFunctionReferenceCandidates(string line)
    {
        var quote = false;
        var rawcode = false;
        for (var index = 0; index < line.Length; index++)
        {
            var current = line[index];
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

            if (quote || rawcode || !(char.IsLetter(current) || current == '_'))
            {
                continue;
            }

            var start = index;
            while (index + 1 < line.Length &&
                (char.IsLetterOrDigit(line[index + 1]) || line[index + 1] == '_'))
            {
                index++;
            }

            var token = line[start..(index + 1)];
            if (!string.Equals(token, "function", StringComparison.Ordinal))
            {
                continue;
            }

            var lookahead = index + 1;
            while (lookahead < line.Length && char.IsWhiteSpace(line[lookahead]))
            {
                lookahead++;
            }

            if (lookahead >= line.Length || !(char.IsLetter(line[lookahead]) || line[lookahead] == '_'))
            {
                continue;
            }

            var nameStart = lookahead;
            while (lookahead + 1 < line.Length &&
                (char.IsLetterOrDigit(line[lookahead + 1]) || line[lookahead + 1] == '_'))
            {
                lookahead++;
            }

            yield return line[nameStart..(lookahead + 1)];
            index = lookahead;
        }
    }

    private static IReadOnlyList<string> CollectUnmatchedMarkers(string text, IReadOnlyList<string> matchedPrivate)
    {
        var unmatched = new HashSet<string>(StringComparer.Ordinal);
        foreach (Match match in AbilityIdRegex.Matches(text))
        {
            var marker = match.Groups[1].Value;
            if (marker.StartsWith("MFEvent_", StringComparison.Ordinal))
            {
                continue;
            }

            unmatched.Add($"AbilityId({marker})");
        }

        if (text.Contains("MFLua[", StringComparison.Ordinal) && !matchedPrivate.Contains("MFLua dispatch table", StringComparer.Ordinal))
        {
            unmatched.Add("MFLua dispatch table");
        }

        if (text.Contains("MyFucLua[", StringComparison.Ordinal) && !matchedPrivate.Contains("MyFucLua dispatch table", StringComparer.Ordinal))
        {
            unmatched.Add("MyFucLua dispatch table");
        }

        return unmatched.OrderBy(value => value, StringComparer.Ordinal).ToArray();
    }

    private static string NormalizeCodeLine(string line)
    {
        var builder = new StringBuilder(line.Length);
        var quote = false;
        for (var index = 0; index < line.Length; index++)
        {
            var current = line[index];
            if (current == '"')
            {
                quote = !quote;
                builder.Append(current);
                continue;
            }

            if (!quote && current == '/' && index + 1 < line.Length && line[index + 1] == '/')
            {
                break;
            }

            builder.Append(current);
        }

        return builder.ToString().Trim();
    }

    internal static List<string> SplitArguments(string rawArguments)
    {
        var result = new List<string>();
        var builder = new StringBuilder();
        var parentheses = 0;
        var quote = false;
        var rawcode = false;

        for (var index = 0; index < rawArguments.Length; index++)
        {
            var current = rawArguments[index];
            if (current == '"' && !rawcode)
            {
                quote = !quote;
                builder.Append(current);
                continue;
            }

            if (current == '\'' && !quote)
            {
                rawcode = !rawcode;
                builder.Append(current);
                continue;
            }

            if (!quote && !rawcode)
            {
                switch (current)
                {
                    case '(':
                        parentheses++;
                        break;
                    case ')':
                        parentheses--;
                        break;
                    case ',' when parentheses == 0:
                        result.Add(builder.ToString().Trim());
                        builder.Clear();
                        continue;
                }
            }

            builder.Append(current);
        }

        if (builder.Length > 0)
        {
            result.Add(builder.ToString().Trim());
        }

        return result;
    }

    private static string CreateDisplayName(JassFunction initFunction, int ordinal)
    {
        foreach (var comment in initFunction.HeaderComments)
        {
            var match = TriggerCommentRegex.Match(comment);
            if (match.Success)
            {
                var fromComment = match.Groups[1].Value.Trim();
                if (!string.IsNullOrWhiteSpace(fromComment))
                {
                    return fromComment;
                }
            }
        }

        if (initFunction.Name.StartsWith("InitTrig_", StringComparison.Ordinal))
        {
            var suffix = initFunction.Name["InitTrig_".Length..];
            var fromSuffix = Regex.Replace(suffix.Replace('_', ' '), @"\s+", " ").Trim();
            if (!string.IsNullOrWhiteSpace(fromSuffix))
            {
                return fromSuffix;
            }
        }

        return $"Recovered Trigger {ordinal:D3}";
    }

    private static string CreateArtifactStem(int ordinal, string name)
    {
        var sanitized = Regex.Replace(name, @"[\\/:*?""<>|]+", "_").Trim();
        if (string.IsNullOrWhiteSpace(sanitized))
        {
            sanitized = $"Recovered-Trigger-{ordinal:D3}";
        }

        return $"{ordinal:D3}-{sanitized}";
    }

    private sealed record JassFunction(
        string Name,
        IReadOnlyList<string> HeaderComments,
        IReadOnlyList<string> BodyLines,
        string FullText,
        int StartLineIndex,
        int EndLineIndex)
    {
        public string? TryExtractTriggerGlobal()
        {
            foreach (var line in BodyLines)
            {
                var match = CreateTriggerRegex.Match(NormalizeCodeLine(line));
                if (match.Success)
                {
                    return match.Groups[1].Value;
                }
            }

            return null;
        }

        public bool DisablesTrigger(string? triggerGlobal)
        {
            if (string.IsNullOrWhiteSpace(triggerGlobal))
            {
                return false;
            }

            foreach (var line in BodyLines)
            {
                var match = DisableTriggerRegex.Match(NormalizeCodeLine(line));
                if (match.Success && string.Equals(match.Groups[1].Value, triggerGlobal, StringComparison.Ordinal))
                {
                    return true;
                }
            }

            return false;
        }
    }

    private sealed record JassGlobalVariable(
        string Name,
        string Type,
        bool IsArray,
        string? InlineInitializer);

    private sealed class JassScriptDocument
    {
        public IReadOnlyDictionary<string, JassFunction> Functions { get; private init; } = new Dictionary<string, JassFunction>(StringComparer.Ordinal);

        public IReadOnlyList<JassFunction> FunctionOrder { get; private init; } = [];

        public IReadOnlyList<string> SourceLines { get; private init; } = [];

        public IReadOnlyList<string> InitTriggerCalls { get; private init; } = [];

        public IReadOnlyList<JassGlobalVariable> GlobalVariables { get; private init; } = [];

        public IReadOnlyDictionary<string, string> InitGlobalAssignments { get; private init; } = new Dictionary<string, string>(StringComparer.Ordinal);

        public static JassScriptDocument Parse(string scriptText)
        {
            var normalized = scriptText.Replace("\r\n", "\n", StringComparison.Ordinal);
            var lines = normalized.Split('\n');
            var functions = new Dictionary<string, JassFunction>(StringComparer.Ordinal);
            var functionOrder = new List<JassFunction>();
            var globals = new List<JassGlobalVariable>();
            var pendingComments = new List<string>();
            int? pendingCommentStartIndex = null;

            var inGlobals = false;
            for (var index = 0; index < lines.Length; index++)
            {
                var line = lines[index];
                var trimmed = line.Trim();

                if (trimmed.StartsWith("//", StringComparison.Ordinal))
                {
                    pendingCommentStartIndex ??= index;
                    pendingComments.Add(trimmed);
                }
                else if (!string.IsNullOrWhiteSpace(trimmed))
                {
                    pendingComments.Clear();
                    pendingCommentStartIndex = null;
                }

                if (string.Equals(trimmed, "globals", StringComparison.Ordinal))
                {
                    inGlobals = true;
                    continue;
                }

                if (inGlobals)
                {
                    if (string.Equals(trimmed, "endglobals", StringComparison.Ordinal))
                    {
                        inGlobals = false;
                        continue;
                    }

                    var globalMatch = GlobalVariableRegex.Match(trimmed);
                    if (globalMatch.Success)
                    {
                        globals.Add(new JassGlobalVariable(
                            globalMatch.Groups[3].Value,
                            globalMatch.Groups[1].Value,
                            !string.IsNullOrEmpty(globalMatch.Groups[2].Value),
                            NormalizeDefaultValue(globalMatch.Groups[4].Value)));
                    }

                    continue;
                }

                var functionMatch = FunctionHeaderRegex.Match(NormalizeCodeLine(line));
                if (!functionMatch.Success)
                {
                    continue;
                }

                var functionName = functionMatch.Groups[1].Value;
                var headerComments = pendingComments.ToArray();
                var startLineIndex = pendingCommentStartIndex ?? index;
                pendingComments.Clear();
                pendingCommentStartIndex = null;
                var functionLines = new List<string> { line };
                var bodyLines = new List<string>();
                while (++index < lines.Length)
                {
                    functionLines.Add(lines[index]);
                    if (string.Equals(lines[index].Trim(), "endfunction", StringComparison.Ordinal))
                    {
                        break;
                    }

                    bodyLines.Add(lines[index]);
                }

                var function = new JassFunction(
                    functionName,
                    headerComments,
                    bodyLines,
                    string.Join('\n', functionLines),
                    startLineIndex,
                    index);
                functions[functionName] = function;
                functionOrder.Add(function);
            }

            var initTriggerCalls = new List<string>();
            if (functions.TryGetValue("InitCustomTriggers", out var initCustomTriggers))
            {
                foreach (var line in initCustomTriggers.BodyLines)
                {
                    var match = InitCallRegex.Match(NormalizeCodeLine(line));
                    if (match.Success)
                    {
                        initTriggerCalls.Add(match.Groups[1].Value);
                    }
                }
            }

            var initGlobalAssignments = new Dictionary<string, string>(StringComparer.Ordinal);
            if (functions.TryGetValue("InitGlobals", out var initGlobals))
            {
                foreach (var line in initGlobals.BodyLines)
                {
                    var match = VariableAssignmentRegex.Match(NormalizeCodeLine(line));
                    if (match.Success && NormalizeDefaultValue(match.Groups[2].Value) is { } value)
                    {
                        initGlobalAssignments[match.Groups[1].Value] = value;
                    }
                }
            }

            return new JassScriptDocument
            {
                Functions = functions,
                FunctionOrder = functionOrder,
                SourceLines = lines,
                InitTriggerCalls = initTriggerCalls,
                GlobalVariables = globals,
                InitGlobalAssignments = initGlobalAssignments
            };
        }

        public IReadOnlyList<JassFunction> GetFunctionsInSourceOrder(IReadOnlySet<string> functionNames)
        {
            if (functionNames.Count == 0)
            {
                return [];
            }

            return FunctionOrder
                .Where(function => functionNames.Contains(function.Name))
                .ToArray();
        }

        public IReadOnlyList<LegacyGuiVariable> RecoverVariables()
        {
            var variables = new List<LegacyGuiVariable>();
            foreach (var global in GlobalVariables)
            {
                InitGlobalAssignments.TryGetValue(global.Name, out var assignedValue);
                variables.Add(new LegacyGuiVariable(
                    global.Name,
                    global.Type,
                    global.IsArray,
                    global.IsArray ? null : assignedValue ?? global.InlineInitializer));
            }

            return variables;
        }

        public ISet<string> ExtractRunOnMapInitTriggerGlobals()
        {
            var globals = new HashSet<string>(StringComparer.Ordinal);
            if (!Functions.ContainsKey("main"))
            {
                return globals;
            }

            var visitedFunctions = new HashSet<string>(StringComparer.Ordinal);
            var pendingFunctions = new Queue<string>();
            pendingFunctions.Enqueue("main");

            while (pendingFunctions.Count > 0)
            {
                var functionName = pendingFunctions.Dequeue();
                if (!visitedFunctions.Add(functionName) ||
                    !Functions.TryGetValue(functionName, out var function))
                {
                    continue;
                }

                foreach (var line in function.BodyLines)
                {
                    var normalizedLine = NormalizeCodeLine(line);
                    if (string.IsNullOrWhiteSpace(normalizedLine))
                    {
                        continue;
                    }

                    var executeMatch = ExecuteTriggerRegex.Match(normalizedLine);
                    if (executeMatch.Success)
                    {
                        globals.Add(executeMatch.Groups[1].Value);
                        continue;
                    }

                    var helperCallMatch = DirectHelperCallRegex.Match(normalizedLine);
                    if (!helperCallMatch.Success)
                    {
                        continue;
                    }

                    var helperName = helperCallMatch.Groups[1].Value;
                    if (helperName.StartsWith("InitTrig_", StringComparison.Ordinal) ||
                        !Functions.ContainsKey(helperName) ||
                        visitedFunctions.Contains(helperName))
                    {
                        continue;
                    }

                    pendingFunctions.Enqueue(helperName);
                }
            }

            return globals;
        }

        public ISet<string> ExtractExplicitlyExecutedTriggerGlobals()
        {
            var globals = new HashSet<string>(StringComparer.Ordinal);
            foreach (var function in FunctionOrder)
            {
                foreach (var line in function.BodyLines)
                {
                    var match = ExecuteTriggerRegex.Match(NormalizeCodeLine(line));
                    if (match.Success)
                    {
                        globals.Add(match.Groups[1].Value);
                    }
                }
            }

            return globals;
        }

        private static string? NormalizeDefaultValue(string? rawValue)
        {
            if (string.IsNullOrWhiteSpace(rawValue))
            {
                return null;
            }

            var value = rawValue.Trim();
            if (string.Equals(value, "null", StringComparison.OrdinalIgnoreCase))
            {
                return null;
            }

            if (value.Length >= 2 && value[0] == '"' && value[^1] == '"')
            {
                return LiteralValueParser.ParseQuotedString(value);
            }

            if (Regex.IsMatch(value, @"^-?\d+(\.\d+)?$") ||
                Regex.IsMatch(value, @"^'[A-Za-z0-9_]{4}'$") ||
                string.Equals(value, "true", StringComparison.OrdinalIgnoreCase) ||
                string.Equals(value, "false", StringComparison.OrdinalIgnoreCase))
            {
                return value;
            }

            return null;
        }
    }
}
