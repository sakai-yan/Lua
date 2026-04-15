namespace Packer.Core;

public sealed record PackageError(
    ErrorCategory Category,
    string Message,
    string? FilePath = null,
    string? UnitId = null,
    int? RowNumber = null)
{
    public string ToMarkdownBullet()
    {
        var parts = new List<string>();

        if (!string.IsNullOrWhiteSpace(FilePath))
        {
            parts.Add($"文件：`{FilePath}`");
        }

        if (!string.IsNullOrWhiteSpace(UnitId))
        {
            parts.Add($"单位：`{UnitId}`");
        }

        if (RowNumber.HasValue)
        {
            parts.Add($"行：`{RowNumber.Value}`");
        }

        parts.Add(Message);
        return $"- {string.Join("，", parts)}";
    }
}
