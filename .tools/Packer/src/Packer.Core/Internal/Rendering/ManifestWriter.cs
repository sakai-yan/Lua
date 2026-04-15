using System.Text;

namespace Packer.Core.Internal.Rendering;

internal sealed class ManifestWriter
{
    public string Write(PackResult result)
    {
        var builder = new StringBuilder();
        builder.AppendLine("# Packer Manifest");
        builder.AppendLine();
        builder.AppendLine($"- 工作表：`{result.SelectedWorksheet}`");
        builder.AppendLine($"- 项目根目录：`{result.ProjectRootPath}`");
        builder.AppendLine($"- 地图输出目录：`{result.MapOutputPath}`");
        builder.AppendLine($"- 资源输出目录：`{(string.IsNullOrWhiteSpace(result.AssetOutputPath) ? "(未启用)" : result.AssetOutputPath)}`");
        builder.AppendLine($"- unit.ini：`{result.IniFilePath}`");
        builder.AppendLine($"- 备份目录：`{result.BackupRunDirectoryPath}`");
        builder.AppendLine();
        builder.AppendLine("## 摘要");
        builder.AppendLine();
        builder.AppendLine($"- 扫描文件：`{result.Summary.ScannedFileCount}`");
        builder.AppendLine($"- 复制文件：`{result.Summary.CopiedFileCount}`");
        builder.AppendLine($"- 项目复制文件：`{result.Summary.ProjectCopiedFileCount}`");
        builder.AppendLine($"- 资源复制文件：`{result.Summary.AssetCopiedFileCount}`");
        builder.AppendLine($"- 改写文件：`{result.Summary.TransformedFileCount}`");
        builder.AppendLine($"- 识别单位：`{result.Summary.RecognizedUnitCount}`");
        builder.AppendLine($"- 成功单位：`{result.Summary.SuccessfulUnitCount}`");
        builder.AppendLine($"- 跳过单位：`{result.Summary.SkippedUnitCount}`");
        builder.AppendLine($"- 命中源资源引用：`{result.Summary.ReferencedAssetCount}`");
        builder.AppendLine($"- 实际输出资源：`{result.Summary.ResolvedAssetCount}`");
        builder.AppendLine($"- 模型贴图依赖：`{result.Summary.ModelTextureDependencyCount}`");
        builder.AppendLine($"- 错误数：`{result.Summary.ErrorCount}`");
        builder.AppendLine();

        AppendSection(builder, "复制到地图的项目文件", result.ProjectCopiedFilePaths);
        AppendSection(builder, "复制到资源输出目录的资源文件", result.AssetCopiedFilePaths);
        AppendSection(builder, "改写后的 UnitType 文件", result.TransformedFilePaths);
        AppendSection(builder, "备份文件", result.BackupFilePaths);

        return builder.ToString();
    }

    private static void AppendSection(StringBuilder builder, string title, IReadOnlyList<string> items)
    {
        builder.Append("## ")
            .AppendLine(title);
        builder.AppendLine();

        if (items.Count == 0)
        {
            builder.AppendLine("- 无");
            builder.AppendLine();
            return;
        }

        foreach (var item in items)
        {
            builder.AppendLine($"- `{item}`");
        }

        builder.AppendLine();
    }
}
