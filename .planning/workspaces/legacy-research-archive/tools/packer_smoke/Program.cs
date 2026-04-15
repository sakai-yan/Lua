using Packer.Core;

if (args.Length is < 6 or > 9)
{
    Console.Error.WriteLine("Usage: PackerSmoke <projectRoot> <war3Root> <unitTypeFolder> <mapperFile> <excelFile> <backupRoot> [assetSourceRoot] [virtualMpqRoot] [formalPack]");
    return 2;
}

var options = new PackerOptions(
    args[0],
    args[1],
    args[2],
    args[3],
    args[4],
    args[5],
    args.Length >= 7 ? args[6] : string.Empty,
    args.Length >= 8 ? args[7] : string.Empty,
    args.Length >= 9 && bool.TryParse(args[8], out var formalPackEnabled) && formalPackEnabled);

var service = new PackerService();
var result = service.Pack(options);

Console.WriteLine($"selectedWorksheet={result.SelectedWorksheet}");
Console.WriteLine($"mapOutput={result.MapOutputPath}");
Console.WriteLine($"assetOutput={result.AssetOutputPath}");
Console.WriteLine($"unitIni={result.IniFilePath}");
Console.WriteLine($"successfulUnits={result.Summary.SuccessfulUnitCount}");
Console.WriteLine($"recognizedUnits={result.Summary.RecognizedUnitCount}");
Console.WriteLine($"skippedUnits={result.Summary.SkippedUnitCount}");
Console.WriteLine($"errors={result.Summary.ErrorCount}");
Console.WriteLine($"copiedFiles={result.Summary.CopiedFileCount}");
Console.WriteLine($"projectCopiedFiles={result.Summary.ProjectCopiedFileCount}");
Console.WriteLine($"assetCopiedFiles={result.Summary.AssetCopiedFileCount}");
Console.WriteLine($"transformedFiles={result.Summary.TransformedFileCount}");
Console.WriteLine($"referencedAssets={result.Summary.ReferencedAssetCount}");
Console.WriteLine($"resolvedAssets={result.Summary.ResolvedAssetCount}");
Console.WriteLine($"modelTextureDependencies={result.Summary.ModelTextureDependencyCount}");
Console.WriteLine("logs:");

foreach (var log in result.Logs)
{
    Console.WriteLine($"  LOG {log}");
}

if (result.Errors.Count > 0)
{
    Console.WriteLine("errorsDetail:");

    foreach (var error in result.Errors)
    {
        Console.WriteLine($"  ERR {error.Category} | {error.Message} | file={error.FilePath} | unit={error.UnitId} | row={error.RowNumber}");
    }
}

return result.HasSuccessfulUnits ? 0 : 1;
