using System.Text;
using System.Text.Json;
using MapRepair.Core.Internal.Gui;

namespace MapRepair.Core.Internal;

internal sealed record RepairReportPayload(
    string InputMapPath,
    string OutputMapPath,
    string RepositoryRoot,
    MapRepairFallbackLevel FallbackLevel,
    IReadOnlyList<string> PreservedFiles,
    IReadOnlyList<string> GeneratedFiles,
    IReadOnlyList<string> OmittedFiles,
    IReadOnlyList<string> Warnings,
    RecoveredGuiSummary? RecoveredGui,
    IReadOnlyList<RecoveredTriggerRiskIndexEntry> RecoveredGuiTriggerIndex);

internal static class RepairReportWriter
{
    public static (string JsonPath, string MarkdownPath) Write(string reportDirectory, RepairReportPayload payload)
    {
        Directory.CreateDirectory(reportDirectory);
        var jsonPath = Path.Combine(reportDirectory, "repair-report.json");
        var markdownPath = Path.Combine(reportDirectory, "repair-report.md");

        File.WriteAllText(
            jsonPath,
            JsonSerializer.Serialize(payload, new JsonSerializerOptions { WriteIndented = true }),
            Encoding.UTF8);

        var markdown = new StringBuilder();
        markdown.AppendLine("# Repair Report");
        markdown.AppendLine();
        markdown.AppendLine($"- Input map: `{payload.InputMapPath}`");
        markdown.AppendLine($"- Output map: `{payload.OutputMapPath}`");
        markdown.AppendLine($"- Repository root: `{payload.RepositoryRoot}`");
        markdown.AppendLine($"- Fallback level: `{payload.FallbackLevel}`");
        markdown.AppendLine();
        AppendList(markdown, "Preserved Files", payload.PreservedFiles);
        AppendList(markdown, "Generated Files", payload.GeneratedFiles);
        AppendList(markdown, "Omitted Files", payload.OmittedFiles);
        AppendList(markdown, "Warnings", payload.Warnings);
        AppendRecoveredGui(markdown, payload.RecoveredGui, payload.RecoveredGuiTriggerIndex);
        File.WriteAllText(markdownPath, markdown.ToString(), Encoding.UTF8);

        return (jsonPath, markdownPath);
    }

    private static void AppendList(StringBuilder builder, string title, IReadOnlyList<string> items)
    {
        builder.AppendLine($"## {title}");
        builder.AppendLine();

        if (items.Count == 0)
        {
            builder.AppendLine("- None");
            builder.AppendLine();
            return;
        }

        foreach (var item in items)
        {
            builder.AppendLine($"- `{item}`");
        }

        builder.AppendLine();
    }

    private static void AppendRecoveredGui(
        StringBuilder builder,
        RecoveredGuiSummary? summary,
        IReadOnlyList<RecoveredTriggerRiskIndexEntry> triggerIndex)
    {
        if (summary is null)
        {
            return;
        }

        builder.AppendLine("## Recovered GUI");
        builder.AppendLine();
        builder.AppendLine($"- Attempted: `{summary.Attempted}`");
        builder.AppendLine($"- Succeeded: `{summary.Succeeded}`");
        builder.AppendLine($"- Trigger count: `{summary.TriggerCount}`");
        builder.AppendLine($"- Variable count: `{summary.VariableCount}`");
        builder.AppendLine($"- GUI event nodes: `{summary.GuiEventNodeCount}`");
        builder.AppendLine($"- Custom-text triggers: `{summary.CustomTextTriggerCount}`");
        builder.AppendLine($"- Failed triggers: `{summary.FailedTriggerCount}`");
        builder.AppendLine($"- Trigger risk entries: `{triggerIndex.Count}` (see `RecoveredGui/index.json`)");
        builder.AppendLine();
        AppendList(builder, "Recovered GUI Notes", summary.Notes);
        AppendList(builder, "Recovered GUI Metadata Sources", summary.MetadataSources);
        AppendList(builder, "Recovered GUI Unmatched Private Semantics", summary.UnmatchedPrivateSemantics);
    }
}
