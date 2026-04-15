using System.Text;

namespace MapRepair.Core.Internal.Slk;

internal static class SlkTableParser
{
    public static SlkTable Parse(string tableName, byte[] data)
    {
        var text = Decode(data);
        var cells = new Dictionary<(int X, int Y), string>();
        var currentX = 1;
        var currentY = 1;

        foreach (var rawLine in text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n'))
        {
            if (string.IsNullOrWhiteSpace(rawLine))
            {
                continue;
            }

            var parts = rawLine.Split(';');
            if (parts[0] is not ("F" or "C"))
            {
                continue;
            }

            var x = currentX;
            var y = currentY;
            string? value = null;

            foreach (var part in parts.Skip(1))
            {
                if (part.StartsWith('X'))
                {
                    x = int.Parse(part[1..]);
                }
                else if (part.StartsWith('Y'))
                {
                    y = int.Parse(part[1..]);
                }
                else if (part.StartsWith('K'))
                {
                    value = ParseValue(part[1..]);
                }
            }

            currentX = x;
            currentY = y;

            if (parts[0] == "C" && value is not null)
            {
                cells[(x, y)] = value;
            }
        }

        var headers = cells
            .Where(kv => kv.Key.Y == 1)
            .OrderBy(kv => kv.Key.X)
            .ToDictionary(kv => kv.Key.X, kv => kv.Value);

        if (headers.Count == 0)
        {
            throw new InvalidDataException($"SLK `{tableName}` 缺少表头。");
        }

        var idColumn = headers.OrderBy(kv => kv.Key).First().Value;
        var maxY = cells.Keys.Max(cell => cell.Y);
        var rows = new Dictionary<string, SlkRow>(StringComparer.OrdinalIgnoreCase);

        for (var y = 2; y <= maxY; y++)
        {
            var values = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            foreach (var header in headers)
            {
                if (cells.TryGetValue((header.Key, y), out var value))
                {
                    values[header.Value] = value;
                }
            }

            if (!values.TryGetValue(idColumn, out var id) || string.IsNullOrWhiteSpace(id))
            {
                continue;
            }

            rows[id] = new SlkRow(id, values);
        }

        return new SlkTable(tableName, idColumn, rows);
    }

    private static string Decode(byte[] data)
    {
        try
        {
            return new UTF8Encoding(false, throwOnInvalidBytes: true).GetString(data);
        }
        catch (DecoderFallbackException)
        {
            Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
            return Encoding.GetEncoding("GB18030").GetString(data);
        }
    }

    private static string ParseValue(string rawValue)
    {
        var value = rawValue.Trim();
        if (value.Length >= 2 && value[0] == '"' && value[^1] == '"')
        {
            value = value[1..^1].Replace("\"\"", "\"", StringComparison.Ordinal);
        }

        return value;
    }
}
