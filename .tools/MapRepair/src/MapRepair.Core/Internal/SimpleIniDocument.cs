using System.Text;

namespace MapRepair.Core.Internal;

internal sealed class SimpleIniDocument
{
    private readonly Dictionary<string, Dictionary<string, string>> _sections;

    private SimpleIniDocument(Dictionary<string, Dictionary<string, string>> sections)
    {
        _sections = sections;
    }

    public IEnumerable<string> SectionNames => _sections.Keys;

    public static SimpleIniDocument Parse(string text)
    {
        var sections = new Dictionary<string, Dictionary<string, string>>(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, string>? currentSection = null;
        string? currentSectionName = null;
        string? pendingKey = null;
        StringBuilder? pendingValue = null;
        var pendingBraceDepth = 0;

        foreach (var rawLine in text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n'))
        {
            var line = rawLine.Trim();

            if (pendingKey is not null && pendingValue is not null)
            {
                pendingValue.AppendLine(rawLine);
                pendingBraceDepth += Count(line, '{');
                pendingBraceDepth -= Count(line, '}');

                if (pendingBraceDepth <= 0 && line.Contains('}'))
                {
                    currentSectionName ??= string.Empty;
                    currentSection ??= EnsureSection(sections, currentSectionName);
                    currentSection[pendingKey] = pendingValue.ToString().Trim();
                    pendingKey = null;
                    pendingValue = null;
                    pendingBraceDepth = 0;
                }

                continue;
            }

            if (string.IsNullOrWhiteSpace(line) || line.StartsWith(';') || line.StartsWith('#'))
            {
                continue;
            }

            if (line.StartsWith('[') && line.EndsWith(']'))
            {
                currentSectionName = line[1..^1].Trim();
                currentSection = EnsureSection(sections, currentSectionName);
                continue;
            }

            var separatorIndex = line.IndexOf('=');
            if (separatorIndex <= 0)
            {
                continue;
            }

            var key = line[..separatorIndex].Trim();
            var value = line[(separatorIndex + 1)..].Trim();
            currentSection ??= EnsureSection(sections, currentSectionName ?? string.Empty);

            if (value == "{" || (value.StartsWith('{') && !value.Contains('}')))
            {
                pendingKey = key;
                pendingValue = new StringBuilder();
                pendingValue.AppendLine(rawLine[(rawLine.IndexOf('=') + 1)..].Trim());
                pendingBraceDepth = Count(value, '{') - Count(value, '}');
                continue;
            }

            currentSection[key] = value;
        }

        return new SimpleIniDocument(sections);
    }

    public bool TryGetValue(string sectionName, string key, out string value)
    {
        value = string.Empty;

        if (!_sections.TryGetValue(sectionName, out var section))
        {
            return false;
        }

        if (!section.TryGetValue(key, out var sectionValue))
        {
            return false;
        }

        value = sectionValue;
        return true;
    }

    public IReadOnlyDictionary<string, string>? GetSection(string sectionName) =>
        _sections.TryGetValue(sectionName, out var section) ? section : null;

    private static Dictionary<string, string> EnsureSection(
        IDictionary<string, Dictionary<string, string>> sections,
        string sectionName)
    {
        if (!sections.TryGetValue(sectionName, out var section))
        {
            section = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
            sections[sectionName] = section;
        }

        return section;
    }

    private static int Count(string text, char value)
    {
        var count = 0;
        foreach (var ch in text)
        {
            if (ch == value)
            {
                count++;
            }
        }

        return count;
    }
}
