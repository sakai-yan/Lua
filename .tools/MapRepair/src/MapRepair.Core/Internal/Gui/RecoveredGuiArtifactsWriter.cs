using System.Text;
using System.Text.Json;

namespace MapRepair.Core.Internal.Gui;

internal static class RecoveredGuiArtifactsWriter
{
    public static string Write(
        string reportDirectory,
        RecoveredGuiReconstructionResult result,
        LegacyGuiDocument document)
    {
        var root = Path.Combine(reportDirectory, "RecoveredGui");
        Directory.CreateDirectory(root);

        File.WriteAllText(Path.Combine(root, "catalog.lml"), LegacyGuiText.ToDebugCatalog(document.Categories, document.Triggers), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, "variable.lml"), LegacyGuiText.ToDebugLml(document.Variables), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, "metadata-sources.txt"), string.Join(Environment.NewLine, result.Summary.MetadataSources), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, "notes.txt"), string.Join(Environment.NewLine, result.Summary.Notes), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, "unmatched-private-semantics.txt"), string.Join(Environment.NewLine, result.Summary.UnmatchedPrivateSemantics), Encoding.UTF8);
        File.WriteAllText(
            Path.Combine(root, "summary.json"),
            JsonSerializer.Serialize(result.Summary, new JsonSerializerOptions { WriteIndented = true }),
            Encoding.UTF8);
        File.WriteAllText(
            Path.Combine(root, "index.json"),
            JsonSerializer.Serialize(
                result.TriggerArtifacts.Select(static artifact => artifact.Risk).ToArray(),
                new JsonSerializerOptions { WriteIndented = true }),
            Encoding.UTF8);

        foreach (var artifact in result.TriggerArtifacts)
        {
            var basePath = Path.Combine(root, artifact.PathStem);
            if (!string.IsNullOrEmpty(artifact.LmlText))
            {
                File.WriteAllText(basePath + ".lml", artifact.LmlText, Encoding.UTF8);
            }

            if (!string.IsNullOrEmpty(artifact.CustomText))
            {
                File.WriteAllText(basePath + ".j", artifact.CustomText, Encoding.UTF8);
            }

            if (!string.IsNullOrEmpty(artifact.DescriptionText))
            {
                File.WriteAllText(basePath + ".txt", artifact.DescriptionText, Encoding.UTF8);
            }

            if (artifact.Notes.Count == 0 &&
                artifact.MatchedPrivateSemantics.Count == 0 &&
                artifact.UnmatchedPrivateSemantics.Count == 0)
            {
                continue;
            }

            var builder = new StringBuilder();
            builder.AppendLine($"Trigger: {artifact.TriggerName}");
            builder.AppendLine($"Mode: {(artifact.UsedCustomText ? "custom-text" : "gui")}");
            builder.AppendLine($"Action Count: {artifact.Risk.ActionCount}");
            builder.AppendLine($"Custom Script Count: {artifact.Risk.CustomScriptCount}");
            builder.AppendLine($"Control Flow Count: {artifact.Risk.ControlFlowCount}");
            if (!string.IsNullOrWhiteSpace(artifact.Risk.FallbackReason))
            {
                builder.AppendLine($"Fallback Reason: {artifact.Risk.FallbackReason}");
            }
            if (artifact.Notes.Count > 0)
            {
                builder.AppendLine();
                builder.AppendLine("Notes:");
                foreach (var note in artifact.Notes)
                {
                    builder.AppendLine($"- {note}");
                }
            }

            if (artifact.MatchedPrivateSemantics.Count > 0)
            {
                builder.AppendLine();
                builder.AppendLine("Matched Private Semantics:");
                foreach (var marker in artifact.MatchedPrivateSemantics)
                {
                    builder.AppendLine($"- {marker}");
                }
            }

            if (artifact.UnmatchedPrivateSemantics.Count > 0)
            {
                builder.AppendLine();
                builder.AppendLine("Unmatched Private Semantics:");
                foreach (var marker in artifact.UnmatchedPrivateSemantics)
                {
                    builder.AppendLine($"- {marker}");
                }
            }

            File.WriteAllText(basePath + ".meta.txt", builder.ToString(), Encoding.UTF8);
        }

        return root;
    }
}
