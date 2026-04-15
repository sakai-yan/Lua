using System.IO;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Media;
using Microsoft.Win32;
using Packer.Core;

namespace Packer.WinForms;

public partial class MainWindow : Window
{
    private sealed class PersistedPathState
    {
        public string? ProjectRootPath { get; init; }
        public string? UnitTypeDirPath { get; init; }
        public string? MapperFilePath { get; init; }
        public string? ExcelFilePath { get; init; }
        public string? BackupRootPath { get; init; }
        public string? AssetSourceRootPath { get; init; }
        public string? VirtualMpqRootPath { get; init; }
        public string? War3RootPath { get; init; }
        public bool FormalPackEnabled { get; init; }
    }

    private readonly PackerService _service = new();
    private readonly FlowDocument _logDoc = new() { PagePadding = new Thickness(0) };
    private bool _isRestoringPersistedPaths;

    [DllImport("dwmapi.dll")]
    private static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int attrValue, int attrSize);

    private const int DwmwaSystemBackdropType = 38;

    public MainWindow()
    {
        InitializeComponent();
        LogBox.Document = _logDoc;
        HookPathPersistence();
        ApplyUiCopyOverrides();
        LoadPersistedPaths();
        AppendLog("[LOG]", Brushes.SteelBlue, "就绪，请填写路径后点击“预检”或“开始打包”。");
    }

    protected override void OnSourceInitialized(EventArgs e)
    {
        base.OnSourceInitialized(e);
        var hwnd = new System.Windows.Interop.WindowInteropHelper(this).Handle;
        var micaValue = 2;
        DwmSetWindowAttribute(hwnd, DwmwaSystemBackdropType, ref micaValue, sizeof(int));
    }

    private void BrowseProjectRoot_Click(object sender, RoutedEventArgs e) => BrowseFolder(ProjectRootBox);

    private void BrowseUnitTypeDir_Click(object sender, RoutedEventArgs e) => BrowseFolder(UnitTypeDirBox);

    private void BrowseMapperFile_Click(object sender, RoutedEventArgs e) =>
        BrowseFile(MapperFileBox, "Lua 文件|*.lua|所有文件|*.*");

    private void BrowseExcelFile_Click(object sender, RoutedEventArgs e) =>
        BrowseFile(ExcelFileBox, "Excel 文件|*.xlsx|所有文件|*.*");

    private void BrowseSourceDir_Click(object sender, RoutedEventArgs e) => BrowseFolder(SourceDirBox);

    private void BrowseAssetSourceRoot_Click(object sender, RoutedEventArgs e) => BrowseFolder(AssetSourceRootBox);

    private void BrowseVirtualMpqRoot_Click(object sender, RoutedEventArgs e) => BrowseFolder(VirtualMpqRootBox);

    private void BrowseWar3Root_Click(object sender, RoutedEventArgs e) => BrowseFolder(War3RootBox);

    private static void BrowseFolder(TextBox target)
    {
        var dialog = new OpenFolderDialog();

        if (!string.IsNullOrWhiteSpace(target.Text) && Directory.Exists(target.Text))
        {
            dialog.InitialDirectory = target.Text;
        }

        if (dialog.ShowDialog() == true)
        {
            target.Text = dialog.FolderName;
        }
    }

    private static void BrowseFile(TextBox target, string filter)
    {
        var dialog = new OpenFileDialog { Filter = filter };

        if (!string.IsNullOrWhiteSpace(target.Text))
        {
            dialog.InitialDirectory = Path.GetDirectoryName(target.Text) ?? string.Empty;
        }

        if (dialog.ShowDialog() == true)
        {
            target.Text = dialog.FileName;
        }
    }

    private void HookPathPersistence()
    {
        foreach (var textBox in GetPersistedPathTextBoxes())
        {
            textBox.TextChanged += PersistedPathTextBox_TextChanged;
        }

        FormalPackCheckBox.Checked += FormalPackCheckBox_Changed;
        FormalPackCheckBox.Unchecked += FormalPackCheckBox_Changed;
        Closing += (_, _) => TrySavePersistedPaths();
    }

    private IEnumerable<TextBox> GetPersistedPathTextBoxes()
    {
        yield return ProjectRootBox;
        yield return UnitTypeDirBox;
        yield return MapperFileBox;
        yield return ExcelFileBox;
        yield return SourceDirBox;
        yield return AssetSourceRootBox;
        yield return VirtualMpqRootBox;
        yield return War3RootBox;
    }

    private void PersistedPathTextBox_TextChanged(object? sender, TextChangedEventArgs e)
    {
        if (_isRestoringPersistedPaths)
        {
            return;
        }

        TrySavePersistedPaths();
        RefreshDerivedPathsHint();
    }

    private void FormalPackCheckBox_Changed(object sender, RoutedEventArgs e)
    {
        if (_isRestoringPersistedPaths)
        {
            return;
        }

        TrySavePersistedPaths();
        RefreshDerivedPathsHint();
    }

    private void LoadPersistedPaths()
    {
        var stateFilePath = GetPersistedStateFilePath();

        if (!File.Exists(stateFilePath))
        {
            RefreshDerivedPathsHint();
            return;
        }

        try
        {
            var json = File.ReadAllText(stateFilePath);
            var state = JsonSerializer.Deserialize<PersistedPathState>(json);

            if (state is null)
            {
                RefreshDerivedPathsHint();
                return;
            }

            _isRestoringPersistedPaths = true;
            ProjectRootBox.Text = state.ProjectRootPath ?? string.Empty;
            UnitTypeDirBox.Text = state.UnitTypeDirPath ?? string.Empty;
            MapperFileBox.Text = state.MapperFilePath ?? string.Empty;
            ExcelFileBox.Text = state.ExcelFilePath ?? string.Empty;
            SourceDirBox.Text = state.BackupRootPath ?? string.Empty;
            AssetSourceRootBox.Text = state.AssetSourceRootPath ?? string.Empty;
            VirtualMpqRootBox.Text = state.VirtualMpqRootPath ?? string.Empty;
            War3RootBox.Text = state.War3RootPath ?? string.Empty;
            FormalPackCheckBox.IsChecked = state.FormalPackEnabled;
        }
        catch
        {
            // Ignore broken local UI state and keep the form usable.
        }
        finally
        {
            _isRestoringPersistedPaths = false;
            RefreshDerivedPathsHint();
        }
    }

    private void TrySavePersistedPaths()
    {
        if (_isRestoringPersistedPaths)
        {
            return;
        }

        try
        {
            var stateFilePath = GetPersistedStateFilePath();
            var directoryPath = Path.GetDirectoryName(stateFilePath);

            if (!string.IsNullOrWhiteSpace(directoryPath))
            {
                Directory.CreateDirectory(directoryPath);
            }

            var state = new PersistedPathState
            {
                ProjectRootPath = ProjectRootBox.Text.Trim(),
                UnitTypeDirPath = UnitTypeDirBox.Text.Trim(),
                MapperFilePath = MapperFileBox.Text.Trim(),
                ExcelFilePath = ExcelFileBox.Text.Trim(),
                BackupRootPath = SourceDirBox.Text.Trim(),
                AssetSourceRootPath = AssetSourceRootBox.Text.Trim(),
                VirtualMpqRootPath = VirtualMpqRootBox.Text.Trim(),
                War3RootPath = War3RootBox.Text.Trim(),
                FormalPackEnabled = FormalPackCheckBox.IsChecked == true
            };

            var json = JsonSerializer.Serialize(state, new JsonSerializerOptions
            {
                WriteIndented = true
            });

            File.WriteAllText(stateFilePath, json);
        }
        catch
        {
            // Best-effort persistence only.
        }
    }

    private static string GetPersistedStateFilePath() =>
        Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "Packer",
            "ui-state.json");

    private void War3RootBox_TextChanged(object sender, TextChangedEventArgs e)
    {
        RefreshDerivedPathsHint();
    }

    private async void InspectButton_Click(object sender, RoutedEventArgs e)
    {
        if (!TryBuildOptions(out var options))
        {
            return;
        }

        SetBusy(true, "预检中");

        try
        {
            var result = await Task.Run(() => _service.Inspect(options));
            ApplyInspectResult(result);
        }
        catch (Exception exception)
        {
            SetStatusChip("预检异常", "#FEE2E2", "#DC2626");
            AppendLog("[ERR]", Brushes.Crimson, exception.Message);
        }
        finally
        {
            SetBusy(false);
        }
    }

    private async void PackButton_Click(object sender, RoutedEventArgs e)
    {
        if (!TryBuildOptions(out var options))
        {
            return;
        }

        SetBusy(true, "打包中");

        try
        {
            var result = await Task.Run(() => _service.Pack(options));
            ApplyPackResult(result);
        }
        catch (Exception exception)
        {
            SetStatusChip("打包异常", "#FEE2E2", "#DC2626");
            AppendLog("[ERR]", Brushes.Crimson, exception.Message);
        }
        finally
        {
            SetBusy(false);
        }
    }

    private bool TryBuildOptions(out PackerOptions options)
    {
        options = default!;
        var missing = new List<string>();

        if (string.IsNullOrWhiteSpace(ProjectRootBox.Text)) missing.Add("项目根目录");
        if (string.IsNullOrWhiteSpace(UnitTypeDirBox.Text)) missing.Add("UnitType 目录");
        if (string.IsNullOrWhiteSpace(MapperFileBox.Text)) missing.Add("Mapper 文件");
        if (string.IsNullOrWhiteSpace(ExcelFileBox.Text)) missing.Add("Excel 文件");
        if (string.IsNullOrWhiteSpace(SourceDirBox.Text)) missing.Add("备份和错误信息目录");
        if (string.IsNullOrWhiteSpace(War3RootBox.Text)) missing.Add("War3 根目录");

        if (missing.Count > 0)
        {
            SetStatusChip("缺少输入", "#FEF9C3", "#CA8A04");
            AppendLog("[ERR]", Brushes.Goldenrod, "请填写：" + string.Join("、", missing));
            return false;
        }

        var assetSourceRootPath = AssetSourceRootBox.Text.Trim();
        var virtualMpqRootPath = VirtualMpqRootBox.Text.Trim();
        var formalPackEnabled = FormalPackCheckBox.IsChecked == true;

        if (!string.IsNullOrWhiteSpace(assetSourceRootPath) &&
            !formalPackEnabled &&
            string.IsNullOrWhiteSpace(virtualMpqRootPath))
        {
            SetStatusChip("缺少输入", "#FEF9C3", "#CA8A04");
            AppendLog("[ERR]", Brushes.Goldenrod, "启用源资源目录但未勾选正式打包时，请填写虚拟 MPQ 目录。");
            return false;
        }

        options = new PackerOptions(
            ProjectRootPath: ProjectRootBox.Text.Trim(),
            War3RootPath: War3RootBox.Text.Trim(),
            UnitTypeFolderPath: UnitTypeDirBox.Text.Trim(),
            MapperFilePath: MapperFileBox.Text.Trim(),
            ExcelFilePath: ExcelFileBox.Text.Trim(),
            BackupRootDirectoryPath: SourceDirBox.Text.Trim(),
            AssetSourceRootPath: assetSourceRootPath,
            VirtualMpqRootPath: virtualMpqRootPath,
            FormalPackEnabled: formalPackEnabled);

        return true;
    }

    private void ApplyInspectResult(InspectResult result)
    {
        if (result.Errors.Count == 0)
        {
            SetStatusChip("预检通过", "#DCFCE7", "#16A34A");
        }
        else
        {
            SetStatusChip($"预检发现 {result.Errors.Count} 个问题", "#FEE2E2", "#DC2626");
        }

        SourceFilesLabel.Text = result.SourceFileCount.ToString();
        UnitTypeLabel.Text = result.UnitTypeLuaFileCount.ToString();
        RecognizedLabel.Text = result.RecognizedUnitCount.ToString();
        SuccessLabel.Text = result.RecognizedUnitCount.ToString();
        ReferencedAssetsLabel.Text = result.ReferencedAssetCount.ToString();
        ResolvedAssetsLabel.Text = result.ResolvedAssetCount.ToString();
        SummaryBox.Text = BuildSummaryText(result.MapOutputPath, result.UnitIniPath, result.AssetOutputPath, result.ModelTextureDependencyCount);

        ReplaceLog(result.Logs, result.Errors, Array.Empty<string>());
    }

    private void ApplyPackResult(PackResult result)
    {
        if (result.Errors.Count == 0)
        {
            SetStatusChip("打包成功", "#DCFCE7", "#16A34A");
        }
        else
        {
            SetStatusChip($"打包完成，含 {result.Errors.Count} 个错误", "#FEE2E2", "#DC2626");
        }

        SourceFilesLabel.Text = result.Summary.ProjectCopiedFileCount.ToString();
        UnitTypeLabel.Text = result.Summary.TransformedFileCount.ToString();
        RecognizedLabel.Text = result.Summary.RecognizedUnitCount.ToString();
        SuccessLabel.Text = result.Summary.SuccessfulUnitCount.ToString();
        ReferencedAssetsLabel.Text = result.Summary.ReferencedAssetCount.ToString();
        ResolvedAssetsLabel.Text = result.Summary.ResolvedAssetCount.ToString();
        SummaryBox.Text = BuildSummaryText(result.MapOutputPath, result.IniFilePath, result.AssetOutputPath, result.Summary.ModelTextureDependencyCount);

        ReplaceLog(result.Logs, result.Errors, result.BackupFilePaths);
    }

    private static string BuildSummaryText(string mapOutputPath, string unitIniPath, string assetOutputPath, int modelTextureDependencyCount)
    {
        var assetLine = string.IsNullOrWhiteSpace(assetOutputPath) ? "(未启用)" : assetOutputPath;
        return $"map: {mapOutputPath}\nunit.ini: {unitIniPath}\nassets: {assetLine}\nmodel textures: {modelTextureDependencyCount}";
    }

    private void ReplaceLog(IReadOnlyList<string> logs, IReadOnlyList<PackageError> errors, IReadOnlyList<string> backups)
    {
        _logDoc.Blocks.Clear();

        if (logs.Count == 0 && errors.Count == 0 && backups.Count == 0)
        {
            AppendLog("", Brushes.Gray, "暂无日志。");
            return;
        }

        foreach (var log in logs)
        {
            AppendLog("[LOG]", new SolidColorBrush(Color.FromRgb(37, 99, 235)), log);
        }

        foreach (var backup in backups)
        {
            AppendLog("[BAK]", new SolidColorBrush(Color.FromRgb(22, 163, 74)), backup);
        }

        foreach (var error in errors)
        {
            AppendLog("[ERR]", new SolidColorBrush(Color.FromRgb(220, 38, 38)), FormatError(error));
        }

        LogBox.ScrollToHome();
    }

    private void AppendLog(string prefix, Brush prefixBrush, string body)
    {
        var paragraph = new Paragraph { Margin = new Thickness(0, 0, 0, 1) };

        if (!string.IsNullOrEmpty(prefix))
        {
            paragraph.Inlines.Add(new Run(prefix + " ")
            {
                Foreground = prefixBrush,
                FontWeight = FontWeights.SemiBold
            });
        }

        paragraph.Inlines.Add(new Run(body));
        _logDoc.Blocks.Add(paragraph);
    }

    private static string FormatError(PackageError error)
    {
        var parts = new List<string>();

        if (!string.IsNullOrEmpty(error.Message)) parts.Add(error.Message);
        if (!string.IsNullOrEmpty(error.FilePath)) parts.Add($"文件：{error.FilePath}");
        if (!string.IsNullOrEmpty(error.UnitId)) parts.Add($"单位：{error.UnitId}");
        if (error.RowNumber.HasValue) parts.Add($"行：{error.RowNumber.Value}");

        return string.Join(" | ", parts);
    }

    private void ApplyUiCopyOverrides()
    {
        RefreshDerivedPathsHint();
    }

    private void RefreshDerivedPathsHint()
    {
        var war3Root = ResolveWar3RootForDisplay(War3RootBox.Text);
        var mapPath = string.IsNullOrWhiteSpace(war3Root) ? "(等待 War3 根目录)" : Path.Combine(war3Root, "map");
        var iniPath = string.IsNullOrWhiteSpace(war3Root) ? "(等待 War3 根目录)" : Path.Combine(war3Root, "table", "unit.ini");
        var assetOutputPath = ResolveAssetOutputForDisplay(mapPath);

        DerivedPathsHint.Text = $"-> map: {mapPath}\n-> unit.ini: {iniPath}\n-> assets: {assetOutputPath}";
    }

    private string ResolveAssetOutputForDisplay(string mapPath)
    {
        if (string.IsNullOrWhiteSpace(AssetSourceRootBox.Text))
        {
            return "(资源同步未启用)";
        }

        if (FormalPackCheckBox.IsChecked == true)
        {
            return mapPath;
        }

        var virtualMpqRoot = NormalizeOptionalPath(VirtualMpqRootBox.Text);
        return string.IsNullOrWhiteSpace(virtualMpqRoot)
            ? "(等待虚拟 MPQ 目录)"
            : virtualMpqRoot;
    }

    private static string ResolveWar3RootForDisplay(string path)
    {
        var normalized = NormalizeOptionalPath(path);

        if (string.IsNullOrWhiteSpace(normalized))
        {
            return string.Empty;
        }

        return Path.GetFileName(normalized).Equals("map", StringComparison.OrdinalIgnoreCase)
            ? (Path.GetDirectoryName(normalized) ?? normalized)
            : normalized;
    }

    private static string NormalizeOptionalPath(string path) =>
        path.Trim().TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

    private void SetBusy(bool busy, string? label = null)
    {
        InspectButton.IsEnabled = !busy;
        PackButton.IsEnabled = !busy;
        MarqueeBar.Visibility = busy ? Visibility.Visible : Visibility.Collapsed;
        Cursor = busy ? System.Windows.Input.Cursors.Wait : null;

        if (busy && label is not null)
        {
            SetStatusChip(label, "#DBEAFE", "#2563EB");
        }
    }

    private void SetStatusChip(string text, string backgroundHex, string foregroundHex)
    {
        StatusLabel.Text = text;
        StatusChip.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(backgroundHex));
        StatusLabel.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString(foregroundHex));
    }
}
