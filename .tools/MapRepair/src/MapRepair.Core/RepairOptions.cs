namespace MapRepair.Core;

public sealed record RepairOptions(
    string InputMapPath,
    string OutputMapPath,
    string ReportDirectory,
    bool OverwriteOutput = false);
