using System.Text;

namespace Packer.Core.Internal.Rendering;

internal sealed class ErrorReportWriter
{
    private static readonly IReadOnlyList<(ErrorCategory Category, string Title)> SectionOrder =
    [
        (ErrorCategory.Validation, "校验失败"),
        (ErrorCategory.MapperMissing, "Mapper 缺失"),
        (ErrorCategory.LuaParse, "Lua 解析失败"),
        (ErrorCategory.MatchKeyEmpty, "匹配键缺失"),
        (ErrorCategory.MatchMismatch, "Excel 未匹配"),
        (ErrorCategory.ExcelDuplicateRow, "Excel 重复或冲突"),
        (ErrorCategory.FieldConflict, "字段冲突"),
        (ErrorCategory.DuplicateUnitId, "重复单位 ID"),
        (ErrorCategory.AssetReferenceMissing, "资源依赖缺失"),
        (ErrorCategory.AssetTargetConflict, "资源目标路径冲突"),
        (ErrorCategory.ModelReferenceParse, "模型依赖解析失败"),
        (ErrorCategory.FileCopy, "文件复制失败"),
        (ErrorCategory.TransformWrite, "Lua 改写失败"),
        (ErrorCategory.UnitIniWrite, "unit.ini 写出失败"),
        (ErrorCategory.OutputWrite, "输出失败")
    ];

    public string Write(PackResult result)
    {
        var builder = new StringBuilder();
        builder.AppendLine("# Packer 错误报告");
        builder.AppendLine();
        builder.AppendLine($"- 工作表：`{result.SelectedWorksheet}`");
        builder.AppendLine($"- 项目根目录：`{result.ProjectRootPath}`");
        builder.AppendLine($"- 地图输出目录：`{result.MapOutputPath}`");
        builder.AppendLine($"- 资源输出目录：`{(string.IsNullOrWhiteSpace(result.AssetOutputPath) ? "(未启用)" : result.AssetOutputPath)}`");
        builder.AppendLine($"- unit.ini：`{result.IniFilePath}`");
        builder.AppendLine($"- 备份根目录：`{result.BackupRootDirectoryPath}`");
        builder.AppendLine($"- 本次备份目录：`{result.BackupRunDirectoryPath}`");
        builder.AppendLine($"- manifest：`{result.ManifestPath}`");
        builder.AppendLine($"- error.md：`{result.ErrorReportPath}`");
        builder.AppendLine($"- 扫描文件数：`{result.Summary.ScannedFileCount}`");
        builder.AppendLine($"- 项目复制文件数：`{result.Summary.ProjectCopiedFileCount}`");
        builder.AppendLine($"- 资源复制文件数：`{result.Summary.AssetCopiedFileCount}`");
        builder.AppendLine($"- 改写文件数：`{result.Summary.TransformedFileCount}`");
        builder.AppendLine($"- 识别单位数：`{result.Summary.RecognizedUnitCount}`");
        builder.AppendLine($"- 成功单位数：`{result.Summary.SuccessfulUnitCount}`");
        builder.AppendLine($"- 跳过单位数：`{result.Summary.SkippedUnitCount}`");
        builder.AppendLine($"- 命中源资源引用：`{result.Summary.ReferencedAssetCount}`");
        builder.AppendLine($"- 实际输出资源：`{result.Summary.ResolvedAssetCount}`");
        builder.AppendLine($"- 模型贴图依赖：`{result.Summary.ModelTextureDependencyCount}`");
        builder.AppendLine($"- 错误数：`{result.Summary.ErrorCount}`");
        builder.AppendLine();

        if (result.BackupFilePaths.Count > 0)
        {
            builder.AppendLine("## 已备份文件");
            builder.AppendLine();

            foreach (var backupFilePath in result.BackupFilePaths)
            {
                builder.AppendLine($"- `{backupFilePath}`");
            }

            builder.AppendLine();
        }

        foreach (var (category, title) in SectionOrder)
        {
            var sectionErrors = result.Errors.Where(error => error.Category == category).ToArray();

            if (sectionErrors.Length == 0)
            {
                continue;
            }

            builder.Append("## ")
                .AppendLine(title);
            builder.AppendLine();

            foreach (var error in sectionErrors)
            {
                builder.AppendLine(error.ToMarkdownBullet());
            }

            builder.AppendLine();
        }

        if (result.Errors.Count == 0)
        {
            builder.AppendLine("## 无错误");
            builder.AppendLine();
            builder.AppendLine("- 本次打包未发现错误。");
        }

        return builder.ToString();
    }
}
