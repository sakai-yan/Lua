using System.Text;

namespace MapRepair.Core.Internal;

internal static class ArchiveProfileTextOverlay
{
    public static IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> Build(IReadOnlyDictionary<string, byte[]> mapEntries)
    {
        return BuildCore(mapEntries, normalizeScalarQuotes: true);
    }

    public static IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> BuildRaw(IReadOnlyDictionary<string, byte[]> mapEntries)
    {
        return BuildCore(mapEntries, normalizeScalarQuotes: false);
    }

    private static IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> BuildCore(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        bool normalizeScalarQuotes)
    {
        var merged = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);

        foreach (var entry in mapEntries)
        {
            if (!IsProfileTextFile(entry.Key))
            {
                continue;
            }

            var text = Decode(entry.Value);
            var document = SimpleIniDocument.Parse(text);
            foreach (var sectionName in document.SectionNames)
            {
                var normalizedSectionName = sectionName.Trim().Trim('\uFEFF');
                if (string.IsNullOrWhiteSpace(normalizedSectionName))
                {
                    continue;
                }

                var section = document.GetSection(sectionName);
                if (section is null)
                {
                    continue;
                }

                if (!merged.TryGetValue(normalizedSectionName, out var targetSection))
                {
                    targetSection = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                    merged[normalizedSectionName] = targetSection;
                }

                foreach (var valueEntry in section)
                {
                    targetSection[valueEntry.Key] = normalizeScalarQuotes
                        ? NormalizeValue(valueEntry.Value)
                        : valueEntry.Value.Trim();
                }
            }
        }

        return merged.ToDictionary(
            pair => pair.Key,
            pair => (IReadOnlyDictionary<string, string>)pair.Value,
            StringComparer.OrdinalIgnoreCase);
    }

    public static IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> BuildDifferences(
        IReadOnlyDictionary<string, byte[]> mapEntries,
        GameArchiveSource gameArchiveSource)
    {
        var mapOverlay = Build(mapEntries);
        if (mapOverlay.Count == 0)
        {
            return mapOverlay;
        }

        var stockEntries = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
        foreach (var entry in mapEntries)
        {
            if (!IsProfileTextFile(entry.Key))
            {
                continue;
            }

            var stockData = TryReadStockProfileFile(gameArchiveSource, entry.Key);
            if (stockData is null)
            {
                continue;
            }

            stockEntries[entry.Key] = stockData;
        }

        if (stockEntries.Count == 0)
        {
            return mapOverlay;
        }

        var stockOverlay = Build(stockEntries);
        var differences = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);

        foreach (var sectionEntry in mapOverlay)
        {
            if (!stockOverlay.TryGetValue(sectionEntry.Key, out var stockSection))
            {
                differences[sectionEntry.Key] = new Dictionary<string, string>(sectionEntry.Value, StringComparer.OrdinalIgnoreCase);
                continue;
            }

            Dictionary<string, string>? differingValues = null;
            foreach (var valueEntry in sectionEntry.Value)
            {
                if (stockSection.TryGetValue(valueEntry.Key, out var stockValue) &&
                    string.Equals(valueEntry.Value, stockValue, StringComparison.Ordinal))
                {
                    continue;
                }

                differingValues ??= new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                differingValues[valueEntry.Key] = valueEntry.Value;
            }

            if (differingValues is not null && differingValues.Count > 0)
            {
                differences[sectionEntry.Key] = differingValues;
            }
        }

        return differences.ToDictionary(
            pair => pair.Key,
            pair => (IReadOnlyDictionary<string, string>)pair.Value,
            StringComparer.OrdinalIgnoreCase);
    }

    private static bool IsProfileTextFile(string path)
    {
        var normalized = path.Replace('/', '\\');
        if (!normalized.EndsWith(".txt", StringComparison.OrdinalIgnoreCase))
        {
            return false;
        }

        return normalized.StartsWith(@"Units\", StringComparison.OrdinalIgnoreCase) ||
               normalized.StartsWith(@"units\", StringComparison.OrdinalIgnoreCase);
    }

    private static string NormalizeValue(string value)
    {
        var trimmed = value.Trim();
        if (trimmed.Length >= 2 &&
            trimmed[0] == '"' &&
            trimmed[^1] == '"' &&
            !trimmed.Contains("\",\"", StringComparison.Ordinal))
        {
            return trimmed[1..^1].Replace("\"\"", "\"", StringComparison.Ordinal);
        }

        return trimmed;
    }

    private static byte[]? TryReadStockProfileFile(GameArchiveSource gameArchiveSource, string path)
    {
        var normalized = path.Replace('/', '\\');
        var candidates = new[]
        {
            normalized,
            normalized.Replace(@"units\", @"Units\", StringComparison.OrdinalIgnoreCase),
            normalized.Replace(@"Units\", @"units\", StringComparison.OrdinalIgnoreCase)
        };

        foreach (var candidate in candidates.Distinct(StringComparer.OrdinalIgnoreCase))
        {
            var data = gameArchiveSource.TryRead(candidate);
            if (data is not null)
            {
                return data;
            }
        }

        return null;
    }

    private static string Decode(byte[] data)
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

        if (data.Length >= 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF)
        {
            return new UTF8Encoding(true).GetString(data, 3, data.Length - 3);
        }

        try
        {
            return new UTF8Encoding(false, throwOnInvalidBytes: true).GetString(data);
        }
        catch (DecoderFallbackException)
        {
            return Encoding.GetEncoding("GB18030").GetString(data);
        }
    }
}
