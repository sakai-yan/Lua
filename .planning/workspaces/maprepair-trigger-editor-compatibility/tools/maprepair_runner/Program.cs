using MapRepair.Core;

if (args.Length < 3)
{
    Console.Error.WriteLine("Usage: MapRepair.Run <input-map> <output-map> <report-dir>");
    return 1;
}

var inputPath = Path.GetFullPath(args[0]);
var outputPath = Path.GetFullPath(args[1]);
var reportDir = Path.GetFullPath(args[2]);

var service = new MapRepairService();
var result = service.Repair(new RepairOptions(inputPath, outputPath, reportDir, OverwriteOutput: true));

Console.WriteLine($"Output={result.OutputMapPath}");
Console.WriteLine($"Fallback={result.FallbackLevel}");
Console.WriteLine($"Generated={result.GeneratedFiles.Count}");
Console.WriteLine($"Warnings={result.Warnings.Count}");
Console.WriteLine($"ReportJson={result.JsonReportPath}");
Console.WriteLine($"ReportMd={result.MarkdownReportPath}");
return 0;
