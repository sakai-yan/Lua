using System.IO;
using System.Text;
using System.Windows;
using Microsoft.Win32;
using MapRepair.Core;

namespace MapRepair.Wpf;

public partial class MainWindow : Window
{
    private readonly MapRepairService _service = new();
    private bool _isBusy;

    public MainWindow()
    {
        InitializeComponent();
        ResultBox.Text = "选择一个 .w3x 地图后，先 Inspect 再 Repair。";
    }

    private void InputMapBox_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
    {
        if (string.IsNullOrWhiteSpace(InputMapBox.Text))
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(OutputMapBox.Text))
        {
            OutputMapBox.Text = BuildDefaultOutputPath(InputMapBox.Text.Trim());
        }

        if (string.IsNullOrWhiteSpace(ReportDirBox.Text))
        {
            ReportDirBox.Text = BuildDefaultReportDir(InputMapBox.Text.Trim());
        }
    }

    private void BrowseInput_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new OpenFileDialog
        {
            Filter = "War3 地图|*.w3x|所有文件|*.*"
        };

        if (dialog.ShowDialog() == true)
        {
            InputMapBox.Text = dialog.FileName;
        }
    }

    private void BrowseOutput_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new SaveFileDialog
        {
            Filter = "War3 地图|*.w3x|所有文件|*.*",
            FileName = string.IsNullOrWhiteSpace(OutputMapBox.Text)
                ? "repaired.w3x"
                : Path.GetFileName(OutputMapBox.Text)
        };

        if (dialog.ShowDialog() == true)
        {
            OutputMapBox.Text = dialog.FileName;
        }
    }

    private void BrowseReport_Click(object sender, RoutedEventArgs e)
    {
        var dialog = new OpenFolderDialog();
        if (dialog.ShowDialog() == true)
        {
            ReportDirBox.Text = dialog.FolderName;
        }
    }

    private async void Inspect_Click(object sender, RoutedEventArgs e)
    {
        var input = InputMapBox.Text.Trim();
        if (!ValidateInputPath(input))
        {
            return;
        }

        await RunBusyAsync(async () =>
        {
            var result = await Task.Run(() => _service.Inspect(input));
            ResultBox.Text = RenderInspectResult(result);
            StatusText.Text = $"Inspect 完成：{result.PreservedFiles.Count} readable / {result.UnreadableFiles.Count} unreadable";
        });
    }

    private async void Repair_Click(object sender, RoutedEventArgs e)
    {
        var input = InputMapBox.Text.Trim();
        var output = OutputMapBox.Text.Trim();
        var reportDir = ReportDirBox.Text.Trim();

        if (!ValidateInputPath(input))
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(output))
        {
            MessageBox.Show(this, "请填写输出地图路径。", "MapRepair", MessageBoxButton.OK, MessageBoxImage.Warning);
            return;
        }

        await RunBusyAsync(async () =>
        {
            var result = await Task.Run(() => _service.Repair(new RepairOptions(input, output, reportDir)));
            ResultBox.Text = RenderRepairResult(result);
            StatusText.Text = $"Repair 完成：fallback={result.FallbackLevel}";
        });
    }

    private async Task RunBusyAsync(Func<Task> action)
    {
        if (_isBusy)
        {
            return;
        }

        try
        {
            _isBusy = true;
            SetControlsEnabled(false);
            StatusText.Text = "处理中...";
            await action();
        }
        catch (Exception exception)
        {
            StatusText.Text = "失败";
            ResultBox.Text = exception.ToString();
            MessageBox.Show(this, exception.Message, "MapRepair", MessageBoxButton.OK, MessageBoxImage.Error);
        }
        finally
        {
            _isBusy = false;
            SetControlsEnabled(true);
        }
    }

    private void SetControlsEnabled(bool enabled)
    {
        BrowseInputButton.IsEnabled = enabled;
        BrowseOutputButton.IsEnabled = enabled;
        BrowseReportButton.IsEnabled = enabled;
        InspectButton.IsEnabled = enabled;
        RepairButton.IsEnabled = enabled;
    }

    private bool ValidateInputPath(string inputPath)
    {
        if (string.IsNullOrWhiteSpace(inputPath) || !File.Exists(inputPath))
        {
            MessageBox.Show(this, "请选择存在的 .w3x 地图。", "MapRepair", MessageBoxButton.OK, MessageBoxImage.Warning);
            return false;
        }

        return true;
    }

    private static string BuildDefaultOutputPath(string inputPath)
    {
        var directory = Path.GetDirectoryName(inputPath) ?? ".";
        var fileName = Path.GetFileNameWithoutExtension(inputPath);
        return Path.Combine(directory, $"{fileName}_repaired.w3x");
    }

    private static string BuildDefaultReportDir(string inputPath)
    {
        var directory = Path.GetDirectoryName(inputPath) ?? ".";
        var fileName = Path.GetFileNameWithoutExtension(inputPath);
        return Path.Combine(directory, $"{fileName}_repair_report");
    }

    private static string RenderInspectResult(InspectResult result)
    {
        var builder = new StringBuilder();
        builder.AppendLine("== Inspect ==");
        builder.AppendLine($"Input: {result.InputMapPath}");
        builder.AppendLine($"Readable archive: {result.ArchiveReadable}");
        builder.AppendLine();
        AppendSection(builder, "Preserved", result.PreservedFiles);
        AppendSection(builder, "Missing", result.MissingFiles);
        AppendSection(builder, "Unreadable", result.UnreadableFiles);
        AppendSection(builder, "Recoverable", result.RecoverableFiles);
        AppendSection(builder, "Warnings", result.Warnings);
        return builder.ToString();
    }

    private static string RenderRepairResult(RepairResult result)
    {
        var builder = new StringBuilder();
        builder.AppendLine("== Repair ==");
        builder.AppendLine($"Output: {result.OutputMapPath}");
        builder.AppendLine($"Fallback: {result.FallbackLevel}");
        builder.AppendLine($"Report JSON: {result.JsonReportPath}");
        builder.AppendLine($"Report MD: {result.MarkdownReportPath}");
        builder.AppendLine();
        AppendSection(builder, "Preserved", result.PreservedFiles);
        AppendSection(builder, "Generated", result.GeneratedFiles);
        AppendSection(builder, "Omitted", result.OmittedFiles);
        AppendSection(builder, "Warnings", result.Warnings);
        return builder.ToString();
    }

    private static void AppendSection(StringBuilder builder, string title, IReadOnlyList<string> items)
    {
        builder.AppendLine($"[{title}]");
        if (items.Count == 0)
        {
            builder.AppendLine("  (none)");
            builder.AppendLine();
            return;
        }

        foreach (var item in items)
        {
            builder.AppendLine($"  - {item}");
        }

        builder.AppendLine();
    }
}
