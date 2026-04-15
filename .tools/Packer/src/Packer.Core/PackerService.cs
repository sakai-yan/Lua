using System.Collections.ObjectModel;
using Packer.Core.Internal;
using Packer.Core.Internal.Assets;
using Packer.Core.Internal.Excel;
using Packer.Core.Internal.Lua;
using Packer.Core.Internal.Mapper;
using Packer.Core.Internal.Rendering;

namespace Packer.Core;

public sealed class PackerService
{
    private static readonly StringComparer PathComparer = StringComparer.OrdinalIgnoreCase;
    private static readonly string[] MeleeOnlyIgnoredIniKeys = ["Missilearc", "Missileart", "Missilespeed"];
    private const string QualifiedUnitTypeInvocation = "Unit.unitType";
    private const string GeneratedUnitTypeFileName = "UnitTypeInit.lua";

    private readonly ExcelWorkbookReader _excelReader = new();
    private readonly LuaUnitScanner _luaUnitScanner = new();
    private readonly MapperLoader _mapperLoader = new();
    private readonly LuaOutputWriter _luaOutputWriter = new();
    private readonly IniOutputWriter _iniOutputWriter = new();
    private readonly ErrorReportWriter _errorReportWriter = new();
    private readonly ManifestWriter _manifestWriter = new();
    private readonly BackupFileStore _backupFileStore = new();
    private readonly ProjectFileCollector _projectFileCollector = new();
    private readonly ProjectAssetReferenceScanner _projectAssetReferenceScanner = new();
    private readonly ModelTextureReferenceReader _modelTextureReferenceReader = new();

    public IReadOnlyList<string> GetSheetNames(string excelFilePath)
    {
        if (!File.Exists(excelFilePath))
        {
            return Array.Empty<string>();
        }

        return _excelReader.GetSheetNames(excelFilePath);
    }

    public InspectResult Inspect(PackerOptions options)
    {
        var logs = new List<string>();
        var errors = new List<PackageError>();
        var unitIniPath = options.UnitIniPath;
        var assetOutputPath = options.AssetOutputPath;
        var selectedWorksheet = string.Empty;
        var sourceFileCount = 0;
        var unitTypeLuaFileCount = 0;
        var recognizedUnitCount = 0;
        var referencedAssetCount = 0;
        var resolvedAssetCount = 0;
        var modelTextureDependencyCount = 0;
        var projectFiles = Array.Empty<ProjectSourceFile>();
        var scanResult = new LuaUnitScanResult(Array.Empty<ScannedLuaFile>(), Array.Empty<ScannedLuaUnit>(), Array.Empty<PackageError>(), 0);
        MapperDefinition? mapperDefinition = null;
        ExcelSheetData? sheetData = null;

        ValidateInputs(options, errors);

        if (errors.Count == 0)
        {
            try
            {
                projectFiles = _projectFileCollector.Collect(
                    options.ProjectRootPath,
                    options.UnitTypeFolderPath,
                    options.War3RootPath,
                    options.MapOutputPath,
                    options.BackupRootDirectoryPath,
                    BuildProjectCollectionExclusions(options)).ToArray();

                sourceFileCount = projectFiles.Length;
                logs.Add($"待复制项目文件：{sourceFileCount} 个。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法收集项目文件：{exception.Message}", options.ProjectRootPath));
            }

            try
            {
                mapperDefinition = _mapperLoader.Load(options.MapperFilePath);
                logs.Add("已加载 Mapper.lua。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.MapperMissing, exception.Message, options.MapperFilePath));
            }

            try
            {
                sheetData = _excelReader.Read(options.ExcelFilePath, sheetName: null);
                selectedWorksheet = sheetData.SheetName;
                logs.Add($"Excel 工作表：{selectedWorksheet}。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法读取 Excel：{exception.Message}", options.ExcelFilePath));
            }

            try
            {
                scanResult = _luaUnitScanner.ScanDirectory(options.UnitTypeFolderPath);
                unitTypeLuaFileCount = CountPackableUnitTypeFiles(scanResult.Files);
                recognizedUnitCount = CountPackableUnits(scanResult.Files);
                errors.AddRange(scanResult.Errors);
                logs.Add($"识别到包含 `Unit.unitType` 的 UnitType Lua：{unitTypeLuaFileCount} 个。");
                logs.Add($"识别到可打包单位定义：{recognizedUnitCount} 个。");
                logs.Add($"将生成 `{GetGeneratedUnitTypeRelativePath(options)}` 以 require 参与打包的 UnitType 源文件。");

                if (recognizedUnitCount == 0)
                {
                    errors.Add(new PackageError(ErrorCategory.Validation, "未识别到任何可打包的单位定义。", options.UnitTypeFolderPath));
                }
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法扫描 UnitType Lua：{exception.Message}", options.UnitTypeFolderPath));
            }
        }

        if (errors.Count == 0 &&
            options.AssetSyncEnabled &&
            mapperDefinition is not null &&
            sheetData is not null)
        {
            var excelIndex = BuildExcelIndex(sheetData, options.ExcelFilePath, errors);
            var packagedUnits = BuildPackagedUnitsForAssetScan(scanResult.Files, mapperDefinition, sheetData, excelIndex, errors, logs);
            var assetPlan = PlanAssetPreparedFiles(
                options,
                projectFiles,
                packagedUnits,
                BuildReservedTargetSources(projectFiles, options),
                errors,
                logs);

            referencedAssetCount = assetPlan.ReferencedAssetCount;
            resolvedAssetCount = assetPlan.ResolvedAssetCount;
            modelTextureDependencyCount = assetPlan.ModelTextureDependencyCount;
        }

        return new InspectResult
        {
            ProjectRootPath = options.ProjectRootPath,
            MapOutputPath = options.MapOutputPath,
            AssetOutputPath = assetOutputPath,
            UnitIniPath = unitIniPath,
            SelectedWorksheet = selectedWorksheet,
            SourceFileCount = sourceFileCount,
            UnitTypeLuaFileCount = unitTypeLuaFileCount,
            RecognizedUnitCount = recognizedUnitCount,
            ReferencedAssetCount = referencedAssetCount,
            ResolvedAssetCount = resolvedAssetCount,
            ModelTextureDependencyCount = modelTextureDependencyCount,
            Errors = errors,
            Logs = logs
        };
    }

    public PackResult Pack(PackerOptions options)
    {
        var logs = new List<string>();
        var errors = new List<PackageError>();
        var backupFilePaths = new List<string>();
        var projectCopiedFilePaths = new List<string>();
        var assetCopiedFilePaths = new List<string>();
        var transformedFilePaths = new List<string>();
        var unitIniPath = options.UnitIniPath;
        var assetOutputPath = options.AssetOutputPath;
        var selectedWorksheet = string.Empty;
        var backupRunDirectoryPath = string.Empty;
        var errorReportPath = string.Empty;
        var manifestPath = string.Empty;
        var scannedFileCount = 0;
        var recognizedUnitCount = 0;
        var successfulUnitCount = 0;
        var referencedAssetCount = 0;
        var resolvedAssetCount = 0;
        var modelTextureDependencyCount = 0;

        ValidateInputs(options, errors);

        if (!TryCreateBackupRunDirectory(options, logs, errors, out backupRunDirectoryPath, out errorReportPath, out manifestPath))
        {
            return BuildResult(
                options,
                unitIniPath,
                assetOutputPath,
                selectedWorksheet,
                backupRunDirectoryPath,
                errorReportPath,
                manifestPath,
                scannedFileCount,
                projectCopiedFilePaths,
                assetCopiedFilePaths,
                transformedFilePaths,
                recognizedUnitCount,
                successfulUnitCount,
                Math.Max(0, recognizedUnitCount - successfulUnitCount),
                referencedAssetCount,
                resolvedAssetCount,
                modelTextureDependencyCount,
                backupFilePaths,
                errors,
                logs);
        }

        var projectFiles = Array.Empty<ProjectSourceFile>();
        var scanResult = new LuaUnitScanResult(Array.Empty<ScannedLuaFile>(), Array.Empty<ScannedLuaUnit>(), Array.Empty<PackageError>(), 0);
        MapperDefinition? mapperDefinition = null;
        ExcelSheetData? sheetData = null;
        var generatedUnitTypeRelativePath = GetGeneratedUnitTypeRelativePath(options);
        var generatedUnitTypeTargetPath = Path.Combine(options.MapOutputPath, generatedUnitTypeRelativePath);

        if (errors.Count == 0)
        {
            try
            {
                projectFiles = _projectFileCollector.Collect(
                    options.ProjectRootPath,
                    options.UnitTypeFolderPath,
                    options.War3RootPath,
                    options.MapOutputPath,
                    options.BackupRootDirectoryPath,
                    BuildProjectCollectionExclusions(options)).ToArray();
                scannedFileCount = projectFiles.Length;
                logs.Add($"待复制项目文件：{projectFiles.Length} 个。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法收集项目文件：{exception.Message}", options.ProjectRootPath));
            }

            try
            {
                mapperDefinition = _mapperLoader.Load(options.MapperFilePath);
                logs.Add("已加载 Mapper.lua。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.MapperMissing, exception.Message, options.MapperFilePath));
            }

            try
            {
                sheetData = _excelReader.Read(options.ExcelFilePath, sheetName: null);
                selectedWorksheet = sheetData.SheetName;
                logs.Add($"Excel 工作表：{selectedWorksheet}。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法读取 Excel：{exception.Message}", options.ExcelFilePath));
            }

            try
            {
                scanResult = _luaUnitScanner.ScanDirectory(options.UnitTypeFolderPath);
                var packableUnitTypeFileCount = CountPackableUnitTypeFiles(scanResult.Files);
                recognizedUnitCount = CountPackableUnits(scanResult.Files);
                errors.AddRange(scanResult.Errors);
                logs.Add($"识别到包含 `Unit.unitType` 的 UnitType Lua：{packableUnitTypeFileCount} 个。");
                logs.Add($"识别到可打包单位定义：{recognizedUnitCount} 个。");
                logs.Add($"将生成 `{generatedUnitTypeRelativePath}` 以 require 参与打包的 UnitType 源文件。");
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, $"无法扫描 UnitType Lua：{exception.Message}", options.UnitTypeFolderPath));
            }

            if (recognizedUnitCount == 0)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, "未识别到任何可打包的单位定义。", options.UnitTypeFolderPath));
            }
        }

        var preparedFiles = new Dictionary<string, PreparedFile>(PathComparer);

        if (errors.Count == 0 && mapperDefinition is not null && sheetData is not null)
        {
            var excelIndex = BuildExcelIndex(sheetData, options.ExcelFilePath, errors);
            var scannedFilesByPath = scanResult.Files.ToDictionary(file => file.SourceFilePath, PathComparer);
            var packagedUnits = new List<PackagedUnit>();
            var participatingModules = new SortedSet<string>(StringComparer.Ordinal);

            foreach (var projectFile in projectFiles)
            {
                var targetPath = Path.Combine(options.MapOutputPath, projectFile.RelativeTargetPath);
                var operationRelativePath = Path.Combine("map", projectFile.RelativeTargetPath);

                if (!projectFile.IsUnitTypeLuaFile)
                {
                    preparedFiles[targetPath] = PreparedFile.FromProjectSource(
                        targetPath,
                        projectFile.RelativeTargetPath,
                        operationRelativePath,
                        projectFile.SourcePath);
                    continue;
                }

                if (!scannedFilesByPath.TryGetValue(projectFile.SourcePath, out var scannedFile))
                {
                    preparedFiles[targetPath] = PreparedFile.FromProjectSource(
                        targetPath,
                        projectFile.RelativeTargetPath,
                        operationRelativePath,
                        projectFile.SourcePath);
                    continue;
                }

                if (!IsPackableUnitTypeFile(scannedFile))
                {
                    preparedFiles[targetPath] = PreparedFile.FromProjectSource(
                        targetPath,
                        projectFile.RelativeTargetPath,
                        operationRelativePath,
                        projectFile.SourcePath);
                    continue;
                }

                participatingModules.Add(BuildRequireModuleName(projectFile.RelativeTargetPath));

                try
                {
                    var transformedFile = TransformUnitTypeFile(scannedFile, mapperDefinition, sheetData, excelIndex, errors, logs);
                    packagedUnits.AddRange(transformedFile.PackagedUnits);

                    if (!transformedFile.Changed)
                    {
                        preparedFiles[targetPath] = PreparedFile.FromProjectSource(
                            targetPath,
                            projectFile.RelativeTargetPath,
                            operationRelativePath,
                            projectFile.SourcePath);
                        continue;
                    }

                    var contentBytes = TextFileCodec.Encode(transformedFile.OutputText, transformedFile.OutputEncoding);
                    preparedFiles[targetPath] = PreparedFile.FromProjectBytes(
                        targetPath,
                        projectFile.RelativeTargetPath,
                        operationRelativePath,
                        contentBytes,
                        countsAsTransformed: true);
                }
                catch (Exception exception)
                {
                    errors.Add(new PackageError(ErrorCategory.TransformWrite, $"改写 UnitType 文件失败：{exception.Message}", projectFile.SourcePath));
                    preparedFiles[targetPath] = PreparedFile.FromProjectSource(
                        targetPath,
                        projectFile.RelativeTargetPath,
                        operationRelativePath,
                        projectFile.SourcePath);
                }
            }

            var unitSections = BuildUnitIniSections(packagedUnits, mapperDefinition, errors);
            successfulUnitCount = unitSections.Count;

            if (successfulUnitCount == 0)
            {
                errors.Add(new PackageError(ErrorCategory.Validation, "没有任何单位成功生成 unit.ini，已取消覆盖地图输出。"));
            }
            else
            {
                try
                {
                    var unitTypeInitContent = BuildUnitTypeInitFile(participatingModules, scanResult.Files);
                    preparedFiles[generatedUnitTypeTargetPath] = PreparedFile.Generated(
                        generatedUnitTypeTargetPath,
                        generatedUnitTypeRelativePath,
                        Path.Combine("map", generatedUnitTypeRelativePath),
                        unitTypeInitContent,
                        countsAsTransformed: true);

                    var unitIniContent = _iniOutputWriter.Write(unitSections);
                    preparedFiles[unitIniPath] = PreparedFile.Generated(
                        unitIniPath,
                        Path.Combine("table", "unit.ini"),
                        Path.Combine("table", "unit.ini"),
                        unitIniContent,
                        countsAsTransformed: false);
                    logs.Add($"已生成 `{generatedUnitTypeRelativePath}`，包含 {participatingModules.Count} 个 require 项。");
                    logs.Add($"已生成 `{Path.Combine("table", "unit.ini")}`，包含 {unitSections.Count} 个单位节。");

                    if (options.AssetSyncEnabled)
                    {
                        var assetPlan = PlanAssetPreparedFiles(
                            options,
                            projectFiles,
                            packagedUnits,
                            BuildReservedTargetSources(preparedFiles.Values),
                            errors,
                            logs);

                        referencedAssetCount = assetPlan.ReferencedAssetCount;
                        resolvedAssetCount = assetPlan.ResolvedAssetCount;
                        modelTextureDependencyCount = assetPlan.ModelTextureDependencyCount;

                        foreach (var assetPreparedFile in assetPlan.PreparedFiles)
                        {
                            preparedFiles[assetPreparedFile.TargetPath] = assetPreparedFile;
                        }
                    }
                }
                catch (Exception exception)
                {
                    errors.Add(new PackageError(ErrorCategory.UnitIniWrite, $"生成 unit.ini 内容失败：{exception.Message}", unitIniPath));
                }
            }
        }

        if (successfulUnitCount > 0)
        {
            ApplyPreparedFiles(
                preparedFiles.Values.OrderBy(file => file.OperationRelativePath, StringComparer.OrdinalIgnoreCase).ToArray(),
                backupRunDirectoryPath,
                backupFilePaths,
                projectCopiedFilePaths,
                assetCopiedFilePaths,
                transformedFilePaths,
                errors);
        }
        else
        {
            logs.Add("由于没有成功单位，本次不会覆盖输出源文件、UnitTypeInit.lua 或 unit.ini，仅输出 manifest 和 error.md。");
        }

        var result = BuildResult(
            options,
            unitIniPath,
            assetOutputPath,
            selectedWorksheet,
            backupRunDirectoryPath,
            errorReportPath,
            manifestPath,
            scannedFileCount,
            projectCopiedFilePaths,
            assetCopiedFilePaths,
            transformedFilePaths,
            recognizedUnitCount,
            successfulUnitCount,
            Math.Max(0, recognizedUnitCount - successfulUnitCount),
            referencedAssetCount,
            resolvedAssetCount,
            modelTextureDependencyCount,
            backupFilePaths,
            errors,
            logs);

        TryWriteManifest(result, errors, logs);
        result = BuildResult(
            options,
            unitIniPath,
            assetOutputPath,
            selectedWorksheet,
            backupRunDirectoryPath,
            errorReportPath,
            manifestPath,
            scannedFileCount,
            projectCopiedFilePaths,
            assetCopiedFilePaths,
            transformedFilePaths,
            recognizedUnitCount,
            successfulUnitCount,
            Math.Max(0, recognizedUnitCount - successfulUnitCount),
            referencedAssetCount,
            resolvedAssetCount,
            modelTextureDependencyCount,
            backupFilePaths,
            errors,
            logs);

        TryWriteErrorReport(result, errors, logs);

        return BuildResult(
            options,
            unitIniPath,
            assetOutputPath,
            selectedWorksheet,
            backupRunDirectoryPath,
            errorReportPath,
            manifestPath,
            scannedFileCount,
            projectCopiedFilePaths,
            assetCopiedFilePaths,
            transformedFilePaths,
            recognizedUnitCount,
            successfulUnitCount,
            Math.Max(0, recognizedUnitCount - successfulUnitCount),
            referencedAssetCount,
            resolvedAssetCount,
            modelTextureDependencyCount,
            backupFilePaths,
            errors,
            logs);
    }

    private static void ValidateInputs(PackerOptions options, ICollection<PackageError> errors)
    {
        ValidatePathValue(options.ProjectRootPath, "项目根目录", errors);
        ValidatePathValue(options.War3RootPath, "War3 目录", errors);
        ValidatePathValue(options.UnitTypeFolderPath, "UnitType 数据目录", errors);
        ValidatePathValue(options.MapperFilePath, "映射规则文件", errors);
        ValidatePathValue(options.ExcelFilePath, "UnitType 数据 Excel", errors);
        ValidatePathValue(options.BackupRootDirectoryPath, "备份目录", errors);

        if (options.AssetSyncEnabled && !options.FormalPackEnabled)
        {
            ValidatePathValue(options.VirtualMpqRootPath, "虚拟 MPQ 目录", errors);
        }

        if (errors.Count > 0)
        {
            return;
        }

        if (!Directory.Exists(options.ProjectRootPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "项目根目录不存在。", options.ProjectRootPath));
        }

        if (!Directory.Exists(options.War3RootPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "War3 目录不存在。", options.War3RootPath));
        }

        if (!Directory.Exists(options.UnitTypeFolderPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "UnitType 数据目录不存在。", options.UnitTypeFolderPath));
        }

        if (!File.Exists(options.MapperFilePath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "映射规则文件不存在。", options.MapperFilePath));
        }

        if (!File.Exists(options.ExcelFilePath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "UnitType 数据 Excel 不存在。", options.ExcelFilePath));
        }

        if (!ProjectFileCollector.IsSubPathOf(options.UnitTypeFolderPath, options.ProjectRootPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "UnitType 数据目录必须位于项目根目录内。", options.UnitTypeFolderPath));
        }

        if (options.AssetSyncEnabled && !Directory.Exists(options.NormalizedAssetSourceRootPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "源资源目录不存在。", options.NormalizedAssetSourceRootPath));
        }

        if (ProjectFileCollector.IsSubPathOf(options.MapOutputPath, options.BackupRootDirectoryPath) ||
            ProjectFileCollector.IsSubPathOf(options.BackupRootDirectoryPath, options.MapOutputPath))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "输出目录和备份目录不能互相嵌套。"));
        }

        if (options.AssetSyncEnabled &&
            !string.IsNullOrWhiteSpace(options.AssetOutputPath) &&
            (ProjectFileCollector.IsSubPathOf(options.AssetOutputPath, options.BackupRootDirectoryPath) ||
             ProjectFileCollector.IsSubPathOf(options.BackupRootDirectoryPath, options.AssetOutputPath)))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "资源输出目录和备份目录不能互相嵌套。", options.AssetOutputPath));
        }

        if (options.AssetSyncEnabled &&
            !string.IsNullOrWhiteSpace(options.AssetOutputPath) &&
            (ProjectFileCollector.IsSubPathOf(options.AssetOutputPath, options.NormalizedAssetSourceRootPath) ||
             ProjectFileCollector.IsSubPathOf(options.NormalizedAssetSourceRootPath, options.AssetOutputPath)))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, "源资源目录和资源输出目录不能互相嵌套。", options.AssetOutputPath));
        }
    }

    private static void ValidatePathValue(string path, string displayName, ICollection<PackageError> errors)
    {
        if (string.IsNullOrWhiteSpace(path))
        {
            errors.Add(new PackageError(ErrorCategory.Validation, $"{displayName}不能为空。"));
        }
    }

    private bool TryCreateBackupRunDirectory(
        PackerOptions options,
        ICollection<string> logs,
        ICollection<PackageError> errors,
        out string backupRunDirectoryPath,
        out string errorReportPath,
        out string manifestPath)
    {
        backupRunDirectoryPath = string.Empty;
        errorReportPath = string.Empty;
        manifestPath = string.Empty;

        if (string.IsNullOrWhiteSpace(options.BackupRootDirectoryPath))
        {
            return false;
        }

        try
        {
            backupRunDirectoryPath = _backupFileStore.CreateRunDirectory(options.BackupRootDirectoryPath);
            errorReportPath = Path.Combine(backupRunDirectoryPath, "error.md");
            manifestPath = Path.Combine(backupRunDirectoryPath, "manifest.md");
            logs.Add($"本次备份目录：{backupRunDirectoryPath}。");
            return true;
        }
        catch (Exception exception)
        {
            errors.Add(new PackageError(ErrorCategory.OutputWrite, $"无法创建备份目录：{exception.Message}", options.BackupRootDirectoryPath));
            return false;
        }
    }

    private ExcelIndex BuildExcelIndex(ExcelSheetData sheetData, string excelFilePath, ICollection<PackageError> errors)
    {
        var rowsByTriple = new Dictionary<TripleKey, List<ExcelSheetRow>>();

        foreach (var row in sheetData.Rows)
        {
            var id = GetCell(row, "ID");
            var name = GetCell(row, "名字");
            var title = GetCell(row, "称谓");

            if (!string.IsNullOrWhiteSpace(id) &&
                !string.IsNullOrWhiteSpace(name) &&
                !string.IsNullOrWhiteSpace(title))
            {
                var tripleKey = new TripleKey(id, name, title);

                if (!rowsByTriple.TryGetValue(tripleKey, out var tripleRows))
                {
                    tripleRows = [];
                    rowsByTriple[tripleKey] = tripleRows;
                }

                tripleRows.Add(row);
            }
        }

        foreach (var entry in rowsByTriple.Where(entry => entry.Value.Count > 1))
        {
            var rowNumbers = string.Join(", ", entry.Value.Select(row => row.RowNumber));
            errors.Add(new PackageError(
                ErrorCategory.ExcelDuplicateRow,
                $"Excel 中存在重复的 ID/名字/称谓 组合：`{entry.Key.Id}` / `{entry.Key.Name}` / `{entry.Key.Title}`，行号：{rowNumbers}。",
                excelFilePath,
                entry.Key.Id,
                entry.Value[0].RowNumber));
        }

        return new ExcelIndex(
            new ReadOnlyDictionary<TripleKey, IReadOnlyList<ExcelSheetRow>>(rowsByTriple.ToDictionary(entry => entry.Key, entry => (IReadOnlyList<ExcelSheetRow>)entry.Value, EqualityComparer<TripleKey>.Default)));
    }

    private TransformedLuaFile TransformUnitTypeFile(
        ScannedLuaFile scannedFile,
        MapperDefinition mapperDefinition,
        ExcelSheetData sheetData,
        ExcelIndex excelIndex,
        ICollection<PackageError> errors,
        ICollection<string> logs)
    {
        if (scannedFile.Units.Count == 0)
        {
            return new TransformedLuaFile(scannedFile.SourceText, scannedFile.SourceEncoding, false, Array.Empty<PackagedUnit>());
        }

        var replacements = new List<TextReplacement>();
        var packagedUnits = new List<PackagedUnit>();

        foreach (var unit in scannedFile.Units)
        {
            var packagedUnit = MergeUnit(unit, mapperDefinition, sheetData, excelIndex, errors, logs);
            packagedUnits.Add(packagedUnit);

            if (!packagedUnit.ShouldRewriteCall)
            {
                continue;
            }

            var replacementText = _luaOutputWriter.RenderUnitTypeCall(
                unit.InvocationPrefix,
                packagedUnit.FinalUnitId,
                packagedUnit.OrderedFields,
                unit.Indent,
                scannedFile.LineEnding);

            replacements.Add(new TextReplacement(unit.CallStartOffset, unit.CallEndOffset, replacementText));
        }

        if (replacements.Count == 0)
        {
            return new TransformedLuaFile(scannedFile.SourceText, scannedFile.SourceEncoding, false, packagedUnits);
        }

        var outputText = ApplyReplacements(scannedFile.SourceText, replacements);
        return new TransformedLuaFile(outputText, scannedFile.SourceEncoding, !string.Equals(outputText, scannedFile.SourceText, StringComparison.Ordinal), packagedUnits);
    }

    private PackagedUnit MergeUnit(
        ScannedLuaUnit unit,
        MapperDefinition mapperDefinition,
        ExcelSheetData sheetData,
        ExcelIndex excelIndex,
        ICollection<PackageError> errors,
        ICollection<string> logs)
    {
        var orderedFields = unit.OrderedFields.ToList();
        var fieldMap = new Dictionary<string, LuaValue>(unit.FieldMap, StringComparer.Ordinal);
        var fieldIndexes = orderedFields
            .Select((field, index) => new KeyValuePair<string, int>(field.Key, index))
            .ToDictionary(pair => pair.Key, pair => pair.Value, StringComparer.Ordinal);
        var finalUnitId = unit.UnitId;
        var matchedRow = FindMatchingExcelRow(unit, excelIndex, errors, logs);
        var shouldRewriteCall = false;

        if (matchedRow is null)
        {
            return new PackagedUnit(
                unit.UnitId,
                finalUnitId,
                unit.SourceFilePath,
                unit.SourceLine,
                orderedFields,
                new ReadOnlyDictionary<string, LuaValue>(fieldMap),
                shouldRewriteCall,
                ShouldPackage: false);
        }

        foreach (var header in sheetData.Headers)
        {
            if (string.IsNullOrWhiteSpace(header) || string.Equals(header, "ID", StringComparison.Ordinal))
            {
                continue;
            }

            var cellValue = GetCell(matchedRow, header);

            if (string.IsNullOrWhiteSpace(cellValue))
            {
                continue;
            }

            var excelValue = LuaValueFactory.FromExcelCell(cellValue);

            if (fieldMap.TryGetValue(header, out var existingValue))
            {
                if (IsEmptyValue(existingValue))
                {
                    var fieldIndex = fieldIndexes[header];
                    orderedFields[fieldIndex] = new OrderedLuaField(header, excelValue);
                    fieldMap[header] = excelValue;
                    shouldRewriteCall = true;
                    continue;
                }

                if (!LuaValueComparer.AreEquivalent(existingValue, excelValue))
                {
                    errors.Add(new PackageError(
                        ErrorCategory.FieldConflict,
                        $"字段 `{header}` 在 Lua 与 Excel 中值不同，已保留 Lua 值 `{LuaValueComparer.ToDisplayString(existingValue)}`。",
                        unit.SourceFilePath,
                        unit.UnitId,
                        matchedRow.RowNumber));
                }

                continue;
            }

            fieldIndexes[header] = orderedFields.Count;
            orderedFields.Add(new OrderedLuaField(header, excelValue));
            fieldMap[header] = excelValue;
            shouldRewriteCall = true;
        }

        var mergedDefaultFields = BuildMergedDefaultFields(finalUnitId, fieldMap, mapperDefinition.DefaultRules);

        if (mergedDefaultFields.Count > 0 &&
            ApplyFieldsIfMissing(orderedFields, fieldMap, fieldIndexes, mergedDefaultFields))
        {
            shouldRewriteCall = true;
        }

        return new PackagedUnit(
            unit.UnitId,
            finalUnitId,
            unit.SourceFilePath,
            unit.SourceLine,
            orderedFields,
            new ReadOnlyDictionary<string, LuaValue>(fieldMap),
            shouldRewriteCall,
            ShouldPackage: true);
    }

    private ExcelSheetRow? FindMatchingExcelRow(
        ScannedLuaUnit unit,
        ExcelIndex excelIndex,
        ICollection<PackageError> errors,
        ICollection<string> logs)
    {
        if (!TryGetNonEmptyStringField(unit.FieldMap, "名字", out var unitName) ||
            !TryGetNonEmptyStringField(unit.FieldMap, "称谓", out var unitTitle))
        {
            errors.Add(new PackageError(
                ErrorCategory.MatchKeyEmpty,
                "缺少匹配所需的 `名字` 或 `称谓` 字段，已跳过该单位。",
                unit.SourceFilePath,
                unit.UnitId));
            return null;
        }

        var tripleKey = new TripleKey(unit.UnitId, unitName, unitTitle);

        if (excelIndex.RowsByTriple.TryGetValue(tripleKey, out var exactRows))
        {
            if (exactRows.Count == 1)
            {
                logs.Add($"单位 `{unit.UnitId}` 使用 ID/名字/称谓 精确匹配 Excel 第 {exactRows[0].RowNumber} 行。");
                return exactRows[0];
            }

            errors.Add(new PackageError(
                ErrorCategory.ExcelDuplicateRow,
                "Excel 中存在重复的 `ID + 名字 + 称谓` 精确匹配行，已跳过该单位。",
                unit.SourceFilePath,
                unit.UnitId,
                exactRows[0].RowNumber));
            return null;
        }

        errors.Add(new PackageError(
            ErrorCategory.MatchMismatch,
            $"未找到同时匹配 `ID + 名字 + 称谓` 的 Excel 行（ID=`{unit.UnitId}`，名字=`{unitName}`，称谓=`{unitTitle}`），已跳过该单位。",
            unit.SourceFilePath,
            unit.UnitId));
        return null;
    }

    private List<UnitIniSection> BuildUnitIniSections(
        IReadOnlyList<PackagedUnit> packagedUnits,
        MapperDefinition mapperDefinition,
        ICollection<PackageError> errors)
    {
        var sections = new List<UnitIniSection>();
        var seenUnitIds = new HashSet<string>(StringComparer.Ordinal);

        foreach (var packagedUnit in packagedUnits)
        {
            if (!packagedUnit.ShouldPackage)
            {
                continue;
            }

            if (!seenUnitIds.Add(packagedUnit.FinalUnitId))
            {
                errors.Add(new PackageError(
                    ErrorCategory.DuplicateUnitId,
                    "生成 unit.ini 时出现重复单位 ID，已跳过后续重复项。",
                    packagedUnit.SourceFilePath,
                    packagedUnit.FinalUnitId));
                continue;
            }

            if (!TryResolveParentBaseId(packagedUnit.FinalUnitId, packagedUnit.FieldMap, mapperDefinition.DefaultRules, out var parentBaseId, out var isRemote, out var parentError))
            {
                errors.Add(new PackageError(
                    ErrorCategory.MatchKeyEmpty,
                    parentError!,
                    packagedUnit.SourceFilePath,
                    packagedUnit.FinalUnitId));
                continue;
            }

            if (!TryBuildIniFields(mapperDefinition, packagedUnit.FieldMap, isRemote, out var iniFields, out var iniFieldError))
            {
                errors.Add(new PackageError(
                    ErrorCategory.UnitIniWrite,
                    iniFieldError!,
                    packagedUnit.SourceFilePath,
                    packagedUnit.FinalUnitId));
                continue;
            }

            sections.Add(new UnitIniSection(packagedUnit.FinalUnitId, parentBaseId!, iniFields));
        }

        return sections;
    }

    private void ApplyPreparedFiles(
        IReadOnlyList<PreparedFile> preparedFiles,
        string backupRunDirectoryPath,
        ICollection<string> backupFilePaths,
        ICollection<string> projectCopiedFilePaths,
        ICollection<string> assetCopiedFilePaths,
        ICollection<string> transformedFilePaths,
        ICollection<PackageError> errors)
    {
        var stagingRootPath = Path.Combine(backupRunDirectoryPath, "staging");

        try
        {
            Directory.CreateDirectory(stagingRootPath);
        }
        catch (Exception exception)
        {
            errors.Add(new PackageError(ErrorCategory.OutputWrite, $"无法创建临时输出目录：{exception.Message}", stagingRootPath));
            return;
        }

        foreach (var preparedFile in preparedFiles)
        {
            var stagingPath = Path.Combine(stagingRootPath, preparedFile.OperationRelativePath);

            try
            {
                var stagingDirectory = Path.GetDirectoryName(stagingPath);

                if (!string.IsNullOrWhiteSpace(stagingDirectory))
                {
                    Directory.CreateDirectory(stagingDirectory);
                }

                if (preparedFile.SourcePath is not null)
                {
                    File.Copy(preparedFile.SourcePath, stagingPath, overwrite: true);
                }
                else
                {
                    File.WriteAllBytes(stagingPath, preparedFile.ContentBytes!);
                }
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(
                    preparedFile.CountsAsTransformedFile ? ErrorCategory.TransformWrite : ErrorCategory.FileCopy,
                    $"无法准备输出文件：{exception.Message}",
                    preparedFile.SourcePath ?? preparedFile.TargetPath));
                return;
            }
        }

        foreach (var preparedFile in preparedFiles)
        {
            try
            {
                var backupPath = _backupFileStore.BackupIfExists(
                    preparedFile.TargetPath,
                    preparedFile.OperationRelativePath,
                    backupRunDirectoryPath);

                if (!string.IsNullOrWhiteSpace(backupPath))
                {
                    backupFilePaths.Add(backupPath);
                }

                var stagingPath = Path.Combine(stagingRootPath, preparedFile.OperationRelativePath);
                AtomicFileWriter.ReplaceWithFile(stagingPath, preparedFile.TargetPath);

                if (preparedFile.IsProjectCopiedFile)
                {
                    projectCopiedFilePaths.Add(preparedFile.TargetPath);
                }

                if (preparedFile.IsAssetFile)
                {
                    assetCopiedFilePaths.Add(preparedFile.TargetPath);
                }

                if (preparedFile.CountsAsTransformedFile)
                {
                    transformedFilePaths.Add(preparedFile.TargetPath);
                }
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(
                    preparedFile.CountsAsTransformedFile ? ErrorCategory.TransformWrite : ErrorCategory.FileCopy,
                    $"写入目标文件失败：{exception.Message}",
                    preparedFile.TargetPath));
                return;
            }
        }
    }

    private void TryWriteManifest(PackResult result, ICollection<PackageError> errors, ICollection<string> logs)
    {
        if (string.IsNullOrWhiteSpace(result.ManifestPath))
        {
            return;
        }

        try
        {
            AtomicFileWriter.WriteAllText(result.ManifestPath, _manifestWriter.Write(result));
            logs.Add($"已写出 manifest：{result.ManifestPath}。");
        }
        catch (Exception exception)
        {
            errors.Add(new PackageError(ErrorCategory.OutputWrite, $"写入 manifest 失败：{exception.Message}", result.ManifestPath));
        }
    }

    private void TryWriteErrorReport(PackResult result, ICollection<PackageError> errors, ICollection<string> logs)
    {
        if (string.IsNullOrWhiteSpace(result.ErrorReportPath))
        {
            return;
        }

        try
        {
            AtomicFileWriter.WriteAllText(result.ErrorReportPath, _errorReportWriter.Write(result));
            logs.Add($"已写出错误报告：{result.ErrorReportPath}。");
        }
        catch (Exception exception)
        {
            errors.Add(new PackageError(ErrorCategory.OutputWrite, $"写入 error.md 失败：{exception.Message}", result.ErrorReportPath));
        }
    }

    private static string ApplyReplacements(string source, IReadOnlyList<TextReplacement> replacements)
    {
        if (replacements.Count == 0)
        {
            return source;
        }

        var orderedReplacements = replacements.OrderBy(replacement => replacement.StartOffset).ToArray();
        var builder = new System.Text.StringBuilder(source.Length);
        var currentOffset = 0;

        foreach (var replacement in orderedReplacements)
        {
            builder.Append(source, currentOffset, replacement.StartOffset - currentOffset);
            builder.Append(replacement.Content);
            currentOffset = replacement.EndOffset;
        }

        builder.Append(source, currentOffset, source.Length - currentOffset);
        return builder.ToString();
    }

    private static string BuildUnitTypeInitFile(
        IReadOnlyCollection<string> moduleNames,
        IReadOnlyList<ScannedLuaFile> scannedFiles)
    {
        var lineEnding = scannedFiles
            .Select(file => file.LineEnding)
            .FirstOrDefault(candidate => !string.IsNullOrEmpty(candidate))
            ?? Environment.NewLine;
        var builder = new System.Text.StringBuilder();
        builder.Append("-- Generated by Packer")
            .Append(lineEnding)
            .Append(lineEnding);

        foreach (var moduleName in moduleNames)
        {
            builder.Append("require \"")
                .Append(moduleName)
                .Append('"')
                .Append(lineEnding);
        }

        return builder.ToString();
    }

    private static IReadOnlyList<string> BuildProjectCollectionExclusions(PackerOptions options)
    {
        var exclusions = new List<string>();

        if (options.AssetSyncEnabled)
        {
            exclusions.Add(options.NormalizedAssetSourceRootPath);
        }

        if (!options.FormalPackEnabled && !string.IsNullOrWhiteSpace(options.NormalizedVirtualMpqRootPath))
        {
            exclusions.Add(options.NormalizedVirtualMpqRootPath);
        }

        return exclusions;
    }

    private static Dictionary<string, string> BuildReservedTargetSources(
        IEnumerable<ProjectSourceFile> projectFiles,
        PackerOptions options)
    {
        var reservedTargetSources = new Dictionary<string, string>(PathComparer);

        foreach (var projectFile in projectFiles)
        {
            var targetPath = Path.Combine(options.MapOutputPath, projectFile.RelativeTargetPath);
            reservedTargetSources[targetPath] = projectFile.SourcePath;
        }

        return reservedTargetSources;
    }

    private static Dictionary<string, string> BuildReservedTargetSources(
        IEnumerable<PreparedFile> preparedFiles)
    {
        var reservedTargetSources = new Dictionary<string, string>(PathComparer);

        foreach (var preparedFile in preparedFiles)
        {
            reservedTargetSources[preparedFile.TargetPath] = preparedFile.SourcePath ?? preparedFile.TargetPath;
        }

        return reservedTargetSources;
    }

    private IReadOnlyList<PackagedUnit> BuildPackagedUnitsForAssetScan(
        IReadOnlyList<ScannedLuaFile> scannedFiles,
        MapperDefinition mapperDefinition,
        ExcelSheetData sheetData,
        ExcelIndex excelIndex,
        ICollection<PackageError> errors,
        ICollection<string> logs)
    {
        var packagedUnits = new List<PackagedUnit>();

        foreach (var scannedFile in scannedFiles)
        {
            if (!IsPackableUnitTypeFile(scannedFile))
            {
                continue;
            }

            foreach (var unit in scannedFile.Units)
            {
                packagedUnits.Add(MergeUnit(unit, mapperDefinition, sheetData, excelIndex, errors, logs));
            }
        }

        return packagedUnits;
    }

    private AssetPlanResult PlanAssetPreparedFiles(
        PackerOptions options,
        IReadOnlyList<ProjectSourceFile> projectFiles,
        IReadOnlyList<PackagedUnit> packagedUnits,
        IReadOnlyDictionary<string, string> reservedTargetSources,
        ICollection<PackageError> errors,
        ICollection<string> logs)
    {
        if (!options.AssetSyncEnabled)
        {
            return new AssetPlanResult(
                options.AssetOutputPath,
                Array.Empty<PreparedFile>(),
                ReferencedAssetCount: 0,
                ResolvedAssetCount: 0,
                ModelTextureDependencyCount: 0);
        }

        var assetSourceIndex = AssetSourceIndex.Build(options.NormalizedAssetSourceRootPath);
        var preparedFiles = new Dictionary<string, PreparedFile>(PathComparer);
        var referencedAssetCount = 0;
        var modelTextureDependencyCount = 0;
        var missingModelTextureKeys = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var projectCandidates = _projectAssetReferenceScanner.ScanFiles(projectFiles);
        var unitTypeCandidates = CollectAssetReferenceCandidatesFromPackagedUnits(packagedUnits);

        logs.Add($"已索引源资源目录：{assetSourceIndex.FileCount} 个文件。");

        foreach (var candidate in projectCandidates.Concat(unitTypeCandidates))
        {
            if (!ShouldConsiderAssetReference(candidate.RawValue, assetSourceIndex))
            {
                continue;
            }

            if (!assetSourceIndex.TryResolve(candidate.RawValue, candidate.SourcePath, out var assetFile))
            {
                continue;
            }

            referencedAssetCount++;

            TryAddAssetPreparedFile(
                options,
                assetFile,
                assetFile.SourceRootRelativePath,
                reservedTargetSources,
                preparedFiles,
                errors);

            if (!IsModelFile(assetFile.Extension))
            {
                continue;
            }

            try
            {
                var textureReferences = _modelTextureReferenceReader.ReadTextureReferences(assetFile.SourcePath)
                    .Distinct(StringComparer.OrdinalIgnoreCase)
                    .ToArray();

                foreach (var textureReference in textureReferences)
                {
                    if (!ShouldConsiderAssetReference(textureReference, assetSourceIndex))
                    {
                        continue;
                    }

                    if (!assetSourceIndex.TryResolve(textureReference, assetFile.SourcePath, out var textureFile))
                    {
                        var missingKey = $"{assetFile.SourcePath}|{textureReference}";

                        if (missingModelTextureKeys.Add(missingKey))
                        {
                            errors.Add(new PackageError(
                                ErrorCategory.AssetReferenceMissing,
                                $"模型贴图依赖未在源资源目录中找到：`{textureReference}`。",
                                assetFile.SourcePath));
                        }

                        continue;
                    }

                    var outputRelativePath = BuildModelTextureOutputRelativePath(
                        textureReference,
                        assetFile.SourceRootRelativePath,
                        textureFile.SourceRootRelativePath);

                    if (string.IsNullOrWhiteSpace(outputRelativePath))
                    {
                        errors.Add(new PackageError(
                            ErrorCategory.AssetTargetConflict,
                            $"模型贴图路径超出了允许的输出范围：`{textureReference}`。",
                            assetFile.SourcePath));
                        continue;
                    }

                    if (TryAddAssetPreparedFile(
                            options,
                            textureFile,
                            outputRelativePath,
                            reservedTargetSources,
                            preparedFiles,
                            errors))
                    {
                        modelTextureDependencyCount++;
                    }
                }
            }
            catch (Exception exception)
            {
                errors.Add(new PackageError(
                    ErrorCategory.ModelReferenceParse,
                    $"解析模型贴图依赖失败：{exception.Message}",
                    assetFile.SourcePath));
            }
        }

        if (referencedAssetCount > 0)
        {
            logs.Add($"已识别源资源引用：{referencedAssetCount} 个。");
            logs.Add($"资源输出目标：{options.AssetOutputPath}。");
            logs.Add($"将复制资源文件：{preparedFiles.Count} 个，其中模型贴图依赖：{modelTextureDependencyCount} 个。");
        }

        return new AssetPlanResult(
            options.AssetOutputPath,
            preparedFiles.Values
                .OrderBy(file => file.OperationRelativePath, StringComparer.OrdinalIgnoreCase)
                .ToArray(),
            referencedAssetCount,
            preparedFiles.Count,
            modelTextureDependencyCount);
    }

    private static IReadOnlyList<AssetReferenceCandidate> CollectAssetReferenceCandidatesFromPackagedUnits(
        IReadOnlyList<PackagedUnit> packagedUnits)
    {
        var candidates = new List<AssetReferenceCandidate>();
        var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var packagedUnit in packagedUnits)
        {
            foreach (var value in packagedUnit.FieldMap.Values)
            {
                AppendAssetReferenceCandidates(
                    packagedUnit.SourceFilePath,
                    value,
                    candidates,
                    seen);
            }
        }

        return candidates;
    }

    private static void AppendAssetReferenceCandidates(
        string sourcePath,
        LuaValue value,
        ICollection<AssetReferenceCandidate> candidates,
        ISet<string> seen)
    {
        switch (value)
        {
            case LuaStringValue stringValue:
            {
                var key = sourcePath + "|" + stringValue.Value;

                if (seen.Add(key))
                {
                    candidates.Add(new AssetReferenceCandidate(stringValue.Value, sourcePath, AssetReferenceSourceKind.UnitTypeField));
                }

                break;
            }
            case LuaTableValue tableValue:
                foreach (var field in tableValue.Fields)
                {
                    AppendAssetReferenceCandidates(sourcePath, field.Value, candidates, seen);
                }

                break;
        }
    }

    private static bool ShouldConsiderAssetReference(string rawReference, AssetSourceIndex assetSourceIndex)
    {
        var cleanedReference = (rawReference ?? string.Empty).Trim().Trim('"', '\'');

        if (string.IsNullOrWhiteSpace(cleanedReference))
        {
            return false;
        }

        if (Path.IsPathRooted(cleanedReference) ||
            cleanedReference.Contains(Path.DirectorySeparatorChar) ||
            cleanedReference.Contains(Path.AltDirectorySeparatorChar))
        {
            return true;
        }

        var extension = Path.GetExtension(cleanedReference);
        return !string.IsNullOrWhiteSpace(extension) && assetSourceIndex.KnownExtensions.Contains(extension);
    }

    private static bool TryAddAssetPreparedFile(
        PackerOptions options,
        IndexedAssetFile assetFile,
        string outputRelativePath,
        IReadOnlyDictionary<string, string> reservedTargetSources,
        IDictionary<string, PreparedFile> preparedFiles,
        ICollection<PackageError> errors)
    {
        var normalizedOutputRelativePath = AssetSourceIndex.NormalizeRelativePath(outputRelativePath);

        if (string.IsNullOrWhiteSpace(normalizedOutputRelativePath))
        {
            return false;
        }

        var targetPath = Path.Combine(options.AssetOutputPath, normalizedOutputRelativePath);

        if (reservedTargetSources.TryGetValue(targetPath, out var reservedSource) &&
            !PathComparer.Equals(reservedSource, assetFile.SourcePath))
        {
            errors.Add(new PackageError(
                ErrorCategory.AssetTargetConflict,
                $"资源目标路径冲突：`{normalizedOutputRelativePath}` 同时指向多个来源文件。",
                targetPath));
            return false;
        }

        if (preparedFiles.TryGetValue(targetPath, out var existingPreparedFile))
        {
            if (PathComparer.Equals(existingPreparedFile.SourcePath, assetFile.SourcePath))
            {
                return false;
            }

            errors.Add(new PackageError(
                ErrorCategory.AssetTargetConflict,
                $"资源目标路径冲突：`{normalizedOutputRelativePath}` 同时指向多个来源文件。",
                targetPath));
            return false;
        }

        preparedFiles[targetPath] = PreparedFile.FromAssetSource(
            targetPath,
            normalizedOutputRelativePath,
            Path.Combine(GetAssetOperationRootName(options), normalizedOutputRelativePath),
            assetFile.SourcePath);
        return true;
    }

    private static string BuildModelTextureOutputRelativePath(
        string rawTextureReference,
        string modelOutputRelativePath,
        string fallbackRelativePath)
    {
        var cleanedReference = AssetSourceIndex.NormalizeRelativePath(rawTextureReference.Trim());

        if (Path.IsPathRooted(cleanedReference))
        {
            return fallbackRelativePath;
        }

        if (!cleanedReference.StartsWith(".", StringComparison.Ordinal))
        {
            return cleanedReference;
        }

        var modelDirectory = Path.GetDirectoryName(modelOutputRelativePath) ?? string.Empty;
        var fakeRoot = Path.Combine(Path.GetTempPath(), "packer-model-path-root");
        var combinedAbsolutePath = Path.GetFullPath(Path.Combine(fakeRoot, modelDirectory, cleanedReference));

        return ProjectFileCollector.IsSubPathOf(combinedAbsolutePath, fakeRoot)
            ? AssetSourceIndex.NormalizeRelativePath(Path.GetRelativePath(fakeRoot, combinedAbsolutePath))
            : string.Empty;
    }

    private static bool IsModelFile(string extension) =>
        string.Equals(extension, ".mdl", StringComparison.OrdinalIgnoreCase) ||
        string.Equals(extension, ".mdx", StringComparison.OrdinalIgnoreCase);

    private static string GetAssetOperationRootName(PackerOptions options) =>
        options.FormalPackEnabled ? "map" : "virtual-mpq";

    private static int CountPackableUnits(IReadOnlyList<ScannedLuaFile> scannedFiles) =>
        scannedFiles
            .Where(IsPackableUnitTypeFile)
            .Sum(file => file.Units.Count);

    private static int CountPackableUnitTypeFiles(IReadOnlyList<ScannedLuaFile> scannedFiles) =>
        scannedFiles.Count(IsPackableUnitTypeFile);

    private static bool IsPackableUnitTypeFile(ScannedLuaFile scannedFile) =>
        scannedFile.HasQualifiedUnitTypeReference;

    private static string GetGeneratedUnitTypeRelativePath(PackerOptions options)
    {
        var relativeUnitTypeFolderPath = Path.GetRelativePath(options.ProjectRootPath, options.UnitTypeFolderPath);
        var relativeParentPath = Path.GetDirectoryName(relativeUnitTypeFolderPath);

        return string.IsNullOrWhiteSpace(relativeParentPath)
            ? GeneratedUnitTypeFileName
            : Path.Combine(relativeParentPath, GeneratedUnitTypeFileName);
    }

    private static string BuildRequireModuleName(string relativeTargetPath)
    {
        var modulePath = Path.ChangeExtension(relativeTargetPath, extension: null) ?? relativeTargetPath;
        return modulePath
            .Replace(Path.DirectorySeparatorChar, '.')
            .Replace(Path.AltDirectorySeparatorChar, '.');
    }

    private static IReadOnlyList<OrderedLuaField> BuildMergedDefaultFields(
        string unitId,
        IReadOnlyDictionary<string, LuaValue> fieldMap,
        MapperDefaultRules defaultRules)
    {
        if (!TryResolveDefaultBranch(
                unitId,
                fieldMap,
                defaultRules,
                out var family,
                out var branch,
                out _,
                out _,
                out _))
        {
            return Array.Empty<OrderedLuaField>();
        }

        return MergeDefaultLayers(
            defaultRules.OrderedFields,
            defaultRules.CommonFields,
            family.OrderedFields,
            family.CommonFields,
            branch.OrderedFields);
    }

    private static bool ApplyFieldsIfMissing(
        IList<OrderedLuaField> orderedFields,
        IDictionary<string, LuaValue> fieldMap,
        IDictionary<string, int> fieldIndexes,
        IReadOnlyList<OrderedLuaField> defaultFields)
    {
        var changed = false;

        foreach (var defaultField in defaultFields)
        {
            if (fieldMap.TryGetValue(defaultField.Key, out var existingValue))
            {
                if (!IsEmptyValue(existingValue))
                {
                    continue;
                }

                var fieldIndex = fieldIndexes[defaultField.Key];
                orderedFields[fieldIndex] = defaultField;
            }
            else
            {
                fieldIndexes[defaultField.Key] = orderedFields.Count;
                orderedFields.Add(defaultField);
            }

            fieldMap[defaultField.Key] = defaultField.Value;
            changed = true;
        }

        return changed;
    }

    private static IReadOnlyList<OrderedLuaField> MergeDefaultLayers(params IReadOnlyList<OrderedLuaField>[] layers)
    {
        var orderedFields = new List<OrderedLuaField>();
        var fieldIndexes = new Dictionary<string, int>(StringComparer.Ordinal);

        foreach (var layer in layers)
        {
            MergeDefaultLayer(layer, orderedFields, fieldIndexes);
        }

        return orderedFields;
    }

    private static void MergeDefaultLayer(
        IReadOnlyList<OrderedLuaField> sourceFields,
        IList<OrderedLuaField> targetFields,
        IDictionary<string, int> fieldIndexes)
    {
        foreach (var sourceField in sourceFields)
        {
            if (fieldIndexes.TryGetValue(sourceField.Key, out var existingIndex))
            {
                targetFields[existingIndex] = sourceField;
                continue;
            }

            fieldIndexes[sourceField.Key] = targetFields.Count;
            targetFields.Add(sourceField);
        }
    }

    private static bool TryResolveParentBaseId(
        string unitId,
        IReadOnlyDictionary<string, LuaValue> fieldMap,
        MapperDefaultRules defaultRules,
        out string? parentBaseId,
        out bool isRemote,
        out string? error)
    {
        if (!TryResolveDefaultBranch(
                unitId,
                fieldMap,
                defaultRules,
                out _,
                out var branch,
                out isRemote,
                out var branchPath,
                out error))
        {
            parentBaseId = null;
            return false;
        }

        if (string.IsNullOrWhiteSpace(branch.Parent))
        {
            parentBaseId = null;
            error = $"`{branchPath}.parent` 缺失，无法生成 `_parent`。";
            return false;
        }

        parentBaseId = branch.Parent;
        error = null;
        return true;
    }

    private static bool TryResolveDefaultBranch(
        string unitId,
        IReadOnlyDictionary<string, LuaValue> fieldMap,
        MapperDefaultRules defaultRules,
        out MapperDefaultFamily family,
        out MapperDefaultBranch branch,
        out bool isRemote,
        out string branchPath,
        out string? error)
    {
        family = defaultRules.Unit;
        branch = defaultRules.Unit.Meele;
        branchPath = GetDefaultBranchPath(isHero: false, isRemote: false);

        if (!fieldMap.TryGetValue("远程", out var remoteValue))
        {
            isRemote = false;
            error = "缺少 `远程` 字段，无法判定 default 分支并生成 `_parent`。";
            return false;
        }

        if (!TryInterpretTruthy(remoteValue, out isRemote))
        {
            error = $"`远程` 字段值无法识别：{LuaValueComparer.ToDisplayString(remoteValue)}。";
            return false;
        }

        var isHero = unitId.Length > 0 && char.IsAsciiLetterUpper(unitId[0]);
        family = isHero ? defaultRules.Hero : defaultRules.Unit;
        branch = isRemote ? family.Remote : family.Meele;
        branchPath = GetDefaultBranchPath(isHero, isRemote);
        error = null;
        return true;
    }

    private static string GetDefaultBranchPath(bool isHero, bool isRemote)
    {
        return (isHero, isRemote) switch
        {
            (true, true) => "Slk_Mapper.default.hero.remote",
            (true, false) => "Slk_Mapper.default.hero.meele",
            (false, true) => "Slk_Mapper.default.unit.remote",
            _ => "Slk_Mapper.default.unit.meele"
        };
    }


    private static bool TryInterpretTruthy(LuaValue value, out bool result)
    {
        switch (value)
        {
            case LuaBooleanValue booleanValue:
                result = booleanValue.Value;
                return true;
            case LuaNumberValue numberValue:
                result = numberValue.NumericValue != 0;
                return true;
            case LuaStringValue stringValue:
                var trimmed = stringValue.Value.Trim();

                if (string.IsNullOrEmpty(trimmed))
                {
                    result = false;
                    return false;
                }

                if (string.Equals(trimmed, "0", StringComparison.Ordinal) ||
                    string.Equals(trimmed, "false", StringComparison.OrdinalIgnoreCase) ||
                    string.Equals(trimmed, "否", StringComparison.Ordinal) ||
                    string.Equals(trimmed, "近战", StringComparison.Ordinal))
                {
                    result = false;
                    return true;
                }

                if (string.Equals(trimmed, "1", StringComparison.Ordinal) ||
                    string.Equals(trimmed, "true", StringComparison.OrdinalIgnoreCase) ||
                    string.Equals(trimmed, "是", StringComparison.Ordinal) ||
                    string.Equals(trimmed, "远程", StringComparison.Ordinal))
                {
                    result = true;
                    return true;
                }

                result = true;
                return true;
            default:
                result = false;
                return false;
        }
    }

    private static bool TryBuildIniFields(
        MapperDefinition mapperDefinition,
        IReadOnlyDictionary<string, LuaValue> fieldMap,
        bool isRemote,
        out IReadOnlyList<IniField> iniFields,
        out string? error)
    {
        var orderedFields = new List<IniField>();

        foreach (var mapping in mapperDefinition.OrderedAttrKeys)
        {
            if (!isRemote && MeleeOnlyIgnoredIniKeys.Contains(mapping.Value, StringComparer.Ordinal))
            {
                continue;
            }

            if (!fieldMap.TryGetValue(mapping.Key, out var sourceValue) || IsEmptyValue(sourceValue))
            {
                continue;
            }

            var mappedValue = sourceValue;

            if (sourceValue is LuaStringValue stringValue &&
                mapperDefinition.AttrValues.TryGetValue(stringValue.Value, out var mappedLiteral))
            {
                mappedValue = mappedLiteral;
            }

            if (mappedValue is LuaTableValue)
            {
                iniFields = Array.Empty<IniField>();
                error = $"字段 `{mapping.Key}` 的值是表，无法写入 unit.ini。";
                return false;
            }

            orderedFields.Add(new IniField(mapping.Key, mapping.Value, mappedValue));
        }

        iniFields = orderedFields;
        error = null;
        return true;
    }

    private static bool TryGetNonEmptyStringField(IReadOnlyDictionary<string, LuaValue> fieldMap, string fieldName, out string value)
    {
        value = string.Empty;

        if (!fieldMap.TryGetValue(fieldName, out var fieldValue))
        {
            return false;
        }

        if (fieldValue is not LuaStringValue stringValue || string.IsNullOrWhiteSpace(stringValue.Value))
        {
            return false;
        }

        value = stringValue.Value;
        return true;
    }

    private static bool IsEmptyValue(LuaValue value) =>
        value is LuaNilValue or LuaStringValue { Value.Length: 0 };

    private static string GetCell(ExcelSheetRow row, string header) =>
        row.Values.TryGetValue(header, out var value) ? value.Trim() : string.Empty;

    private PackResult BuildResult(
        PackerOptions options,
        string unitIniPath,
        string assetOutputPath,
        string selectedWorksheet,
        string backupRunDirectoryPath,
        string errorReportPath,
        string manifestPath,
        int scannedFileCount,
        IReadOnlyList<string> projectCopiedFilePaths,
        IReadOnlyList<string> assetCopiedFilePaths,
        IReadOnlyList<string> transformedFilePaths,
        int recognizedUnitCount,
        int successfulUnitCount,
        int skippedUnitCount,
        int referencedAssetCount,
        int resolvedAssetCount,
        int modelTextureDependencyCount,
        IReadOnlyList<string> backupFilePaths,
        IReadOnlyList<PackageError> errors,
        IReadOnlyList<string> logs)
    {
        var copiedFilePaths = projectCopiedFilePaths.Concat(assetCopiedFilePaths).ToArray();

        return new PackResult
        {
            Summary = new PackSummary(
                scannedFileCount,
                copiedFilePaths.Length,
                projectCopiedFilePaths.Count,
                assetCopiedFilePaths.Count,
                transformedFilePaths.Count,
                recognizedUnitCount,
                successfulUnitCount,
                skippedUnitCount,
                referencedAssetCount,
                resolvedAssetCount,
                modelTextureDependencyCount,
                errors.Count),
            SelectedWorksheet = selectedWorksheet,
            ProjectRootPath = options.ProjectRootPath,
            MapOutputPath = options.MapOutputPath,
            AssetOutputPath = assetOutputPath,
            BackupRootDirectoryPath = options.BackupRootDirectoryPath,
            BackupRunDirectoryPath = backupRunDirectoryPath,
            ErrorReportPath = errorReportPath,
            ManifestPath = manifestPath,
            IniFilePath = unitIniPath,
            BackupFilePaths = backupFilePaths.ToArray(),
            ProjectCopiedFilePaths = projectCopiedFilePaths.ToArray(),
            AssetCopiedFilePaths = assetCopiedFilePaths.ToArray(),
            CopiedFilePaths = copiedFilePaths.ToArray(),
            TransformedFilePaths = transformedFilePaths.ToArray(),
            Errors = errors.ToArray(),
            Logs = logs.ToArray()
        };
    }

    private sealed record TripleKey(string Id, string Name, string Title);

    private sealed record ExcelIndex(
        IReadOnlyDictionary<TripleKey, IReadOnlyList<ExcelSheetRow>> RowsByTriple);

    private sealed record PackagedUnit(
        string OriginalUnitId,
        string FinalUnitId,
        string SourceFilePath,
        int SourceLine,
        IReadOnlyList<OrderedLuaField> OrderedFields,
        IReadOnlyDictionary<string, LuaValue> FieldMap,
        bool ShouldRewriteCall,
        bool ShouldPackage);

    private sealed record AssetPlanResult(
        string AssetOutputPath,
        IReadOnlyList<PreparedFile> PreparedFiles,
        int ReferencedAssetCount,
        int ResolvedAssetCount,
        int ModelTextureDependencyCount);

    private enum PreparedFileBucket
    {
        Project,
        Asset,
        Generated
    }

    private sealed record PreparedFile(
        string TargetPath,
        string RelativeTargetPath,
        string OperationRelativePath,
        string? SourcePath,
        byte[]? ContentBytes,
        PreparedFileBucket Bucket,
        bool CountsAsTransformedFile)
    {
        public bool CountsAsCopiedFile => Bucket is PreparedFileBucket.Project or PreparedFileBucket.Asset;

        public bool IsProjectCopiedFile => Bucket == PreparedFileBucket.Project;

        public bool IsAssetFile => Bucket == PreparedFileBucket.Asset;

        public static PreparedFile FromProjectSource(
            string targetPath,
            string relativeTargetPath,
            string operationRelativePath,
            string sourcePath) =>
            new(
                targetPath,
                relativeTargetPath,
                operationRelativePath,
                sourcePath,
                null,
                PreparedFileBucket.Project,
                CountsAsTransformedFile: false);

        public static PreparedFile FromProjectBytes(
            string targetPath,
            string relativeTargetPath,
            string operationRelativePath,
            byte[] contentBytes,
            bool countsAsTransformed) =>
            new(
                targetPath,
                relativeTargetPath,
                operationRelativePath,
                null,
                contentBytes,
                PreparedFileBucket.Project,
                countsAsTransformed);

        public static PreparedFile FromAssetSource(
            string targetPath,
            string relativeTargetPath,
            string operationRelativePath,
            string sourcePath) =>
            new(
                targetPath,
                relativeTargetPath,
                operationRelativePath,
                sourcePath,
                null,
                PreparedFileBucket.Asset,
                CountsAsTransformedFile: false);

        public static PreparedFile Generated(
            string targetPath,
            string relativeTargetPath,
            string operationRelativePath,
            string textContent,
            bool countsAsTransformed) =>
            new(
                targetPath,
                relativeTargetPath,
                operationRelativePath,
                null,
                System.Text.Encoding.UTF8.GetBytes(textContent),
                PreparedFileBucket.Generated,
                countsAsTransformed);
    }

    private sealed record TextReplacement(int StartOffset, int EndOffset, string Content);

    private sealed record TransformedLuaFile(
        string OutputText,
        System.Text.Encoding OutputEncoding,
        bool Changed,
        IReadOnlyList<PackagedUnit> PackagedUnits);
}
