using System.IO.Compression;
using System.Xml.Linq;

namespace Packer.Core.Internal.Excel;

internal sealed record ExcelSheetRow(int RowNumber, IReadOnlyDictionary<string, string> Values);

internal sealed record ExcelSheetData(
    string SheetName,
    IReadOnlyList<string> Headers,
    IReadOnlyList<ExcelSheetRow> Rows);

internal sealed record WorkbookSheetInfo(string Name, string EntryPath);

internal sealed class ExcelWorkbookReader
{
    private static readonly XNamespace SpreadsheetNamespace = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
    private static readonly XNamespace RelationshipNamespace = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
    private const int WorkbookOpenRetryCount = 3;

    public IReadOnlyList<string> GetSheetNames(string workbookPath)
    {
        using var archive = OpenWorkbookArchive(workbookPath);
        return LoadSheetInfos(archive)
            .Select(info => info.Name)
            .ToArray();
    }

    public ExcelSheetData Read(string workbookPath, string? sheetName)
    {
        using var archive = OpenWorkbookArchive(workbookPath);
        var sheetInfos = LoadSheetInfos(archive);
        var selectedSheet = SelectSheet(sheetInfos, sheetName);
        var sharedStrings = LoadSharedStrings(archive);
        var sheetDocument = LoadXml(archive, selectedSheet.EntryPath);
        var rowElements = sheetDocument.Root?
            .Element(SpreadsheetNamespace + "sheetData")?
            .Elements(SpreadsheetNamespace + "row")
            .ToArray()
            ?? Array.Empty<XElement>();

        if (rowElements.Length == 0)
        {
            throw new InvalidOperationException("Excel 工作表为空，无法读取表头。");
        }

        var headerValues = ReadRow(rowElements[0], sharedStrings);
        var maxHeaderIndex = headerValues.Count == 0 ? 0 : headerValues.Keys.Max();
        var headers = new List<string>(capacity: maxHeaderIndex);

        for (var index = 1; index <= maxHeaderIndex; index++)
        {
            headers.Add(headerValues.TryGetValue(index, out var header) ? header : string.Empty);
        }

        var rows = new List<ExcelSheetRow>();

        foreach (var rowElement in rowElements.Skip(1))
        {
            var cells = ReadRow(rowElement, sharedStrings);
            var values = new Dictionary<string, string>(StringComparer.Ordinal);

            for (var columnIndex = 1; columnIndex <= headers.Count; columnIndex++)
            {
                var header = headers[columnIndex - 1];

                if (string.IsNullOrWhiteSpace(header))
                {
                    continue;
                }

                values[header] = cells.TryGetValue(columnIndex, out var cellValue) ? cellValue : string.Empty;
            }

            var rowNumber = int.TryParse(rowElement.Attribute("r")?.Value, out var parsedRowNumber)
                ? parsedRowNumber
                : rows.Count + 2;

            rows.Add(new ExcelSheetRow(rowNumber, values));
        }

        return new ExcelSheetData(selectedSheet.Name, headers, rows);
    }

    private static ZipArchive OpenWorkbookArchive(string workbookPath) =>
        new(CreateWorkbookSnapshot(workbookPath), ZipArchiveMode.Read, leaveOpen: false);

    // Read the workbook through a shared-read snapshot so Excel/WPS being open
    // for editing does not block the packer in the common case.
    private static MemoryStream CreateWorkbookSnapshot(string workbookPath)
    {
        IOException? lastIOException = null;

        for (var attempt = 1; attempt <= WorkbookOpenRetryCount; attempt++)
        {
            try
            {
                using var sourceStream = new FileStream(
                    workbookPath,
                    FileMode.Open,
                    FileAccess.Read,
                    FileShare.ReadWrite | FileShare.Delete);

                var snapshot = new MemoryStream();
                sourceStream.CopyTo(snapshot);
                snapshot.Position = 0;
                return snapshot;
            }
            catch (IOException exception) when (attempt < WorkbookOpenRetryCount)
            {
                lastIOException = exception;
                Thread.Sleep(120);
            }
            catch (IOException exception)
            {
                lastIOException = exception;
                break;
            }
        }

        throw new IOException(
            $"无法读取 Excel 文件。文件可能正被 Excel、WPS 或其它进程独占；如果文件刚保存过，请稍候再试。原始错误：{lastIOException?.Message}",
            lastIOException);
    }

    private static WorkbookSheetInfo SelectSheet(IReadOnlyList<WorkbookSheetInfo> sheetInfos, string? requestedSheetName)
    {
        if (sheetInfos.Count == 0)
        {
            throw new InvalidOperationException("Excel 工作簿中没有可用工作表。");
        }

        if (!string.IsNullOrWhiteSpace(requestedSheetName))
        {
            var matched = sheetInfos.FirstOrDefault(sheet => string.Equals(sheet.Name, requestedSheetName, StringComparison.Ordinal));
            return matched ?? throw new InvalidOperationException($"Excel 工作表 `{requestedSheetName}` 不存在。");
        }

        return sheetInfos.FirstOrDefault(sheet => string.Equals(sheet.Name, "UnitData", StringComparison.Ordinal))
               ?? sheetInfos[0];
    }

    private static IReadOnlyList<WorkbookSheetInfo> LoadSheetInfos(ZipArchive archive)
    {
        var workbook = LoadXml(archive, "xl/workbook.xml");
        var relationships = LoadXml(archive, "xl/_rels/workbook.xml.rels");
        var relationshipLookup = relationships.Root?
            .Elements()
            .ToDictionary(
                element => element.Attribute("Id")?.Value ?? string.Empty,
                element => element.Attribute("Target")?.Value ?? string.Empty,
                StringComparer.Ordinal)
            ?? new Dictionary<string, string>(StringComparer.Ordinal);

        var sheets = new List<WorkbookSheetInfo>();

        foreach (var sheetElement in workbook.Root?
                     .Element(SpreadsheetNamespace + "sheets")?
                     .Elements(SpreadsheetNamespace + "sheet")
                     ?? Enumerable.Empty<XElement>())
        {
            var sheetName = sheetElement.Attribute("name")?.Value ?? string.Empty;
            var relationshipId = sheetElement.Attribute(RelationshipNamespace + "id")?.Value ?? string.Empty;

            if (string.IsNullOrWhiteSpace(sheetName) || !relationshipLookup.TryGetValue(relationshipId, out var target))
            {
                continue;
            }

            var normalizedTarget = target.StartsWith("xl/", StringComparison.OrdinalIgnoreCase)
                ? target
                : $"xl/{target.TrimStart('/')}";

            sheets.Add(new WorkbookSheetInfo(sheetName, normalizedTarget));
        }

        return sheets;
    }

    private static Dictionary<int, string> ReadRow(XElement rowElement, IReadOnlyList<string> sharedStrings)
    {
        var result = new Dictionary<int, string>();

        foreach (var cell in rowElement.Elements(SpreadsheetNamespace + "c"))
        {
            var reference = cell.Attribute("r")?.Value ?? string.Empty;
            var columnIndex = ColumnIndexFromReference(reference);

            if (columnIndex <= 0)
            {
                continue;
            }

            result[columnIndex] = ReadCellValue(cell, sharedStrings);
        }

        return result;
    }

    private static string ReadCellValue(XElement cellElement, IReadOnlyList<string> sharedStrings)
    {
        var type = cellElement.Attribute("t")?.Value;

        if (string.Equals(type, "inlineStr", StringComparison.Ordinal))
        {
            return string.Concat(cellElement
                .Descendants(SpreadsheetNamespace + "t")
                .Select(element => element.Value));
        }

        var value = cellElement.Element(SpreadsheetNamespace + "v")?.Value ?? string.Empty;

        if (string.Equals(type, "s", StringComparison.Ordinal) &&
            int.TryParse(value, out var sharedStringIndex) &&
            sharedStringIndex >= 0 &&
            sharedStringIndex < sharedStrings.Count)
        {
            return sharedStrings[sharedStringIndex];
        }

        if (string.Equals(type, "b", StringComparison.Ordinal))
        {
            return value == "1" ? "true" : "false";
        }

        return value;
    }

    private static IReadOnlyList<string> LoadSharedStrings(ZipArchive archive)
    {
        var entry = archive.GetEntry("xl/sharedStrings.xml");

        if (entry is null)
        {
            return Array.Empty<string>();
        }

        using var stream = entry.Open();
        var document = XDocument.Load(stream);
        return document.Root?
            .Elements(SpreadsheetNamespace + "si")
            .Select(item => string.Concat(item.Descendants(SpreadsheetNamespace + "t").Select(text => text.Value)))
            .ToArray()
            ?? Array.Empty<string>();
    }

    private static XDocument LoadXml(ZipArchive archive, string entryPath)
    {
        var entry = archive.GetEntry(entryPath)
                    ?? throw new InvalidOperationException($"Excel 缺少必要文件 `{entryPath}`。");

        using var stream = entry.Open();
        return XDocument.Load(stream);
    }

    private static int ColumnIndexFromReference(string cellReference)
    {
        var column = 0;

        foreach (var character in cellReference)
        {
            if (!char.IsLetter(character))
            {
                break;
            }

            column = (column * 26) + (char.ToUpperInvariant(character) - 'A' + 1);
        }

        return column;
    }
}
