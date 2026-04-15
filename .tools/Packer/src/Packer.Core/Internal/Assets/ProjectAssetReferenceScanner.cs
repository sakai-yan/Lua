using System.Text;

namespace Packer.Core.Internal.Assets;

internal enum AssetReferenceSourceKind
{
    ProjectText,
    UnitTypeField,
    ModelTexture
}

internal sealed record AssetReferenceCandidate(
    string RawValue,
    string SourcePath,
    AssetReferenceSourceKind SourceKind);

internal sealed class ProjectAssetReferenceScanner
{
    private static readonly HashSet<string> SupportedExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        ".lua",
        ".j",
        ".ai",
        ".fdf",
        ".f",
        ".toc",
        ".ini"
    };

    public IReadOnlyList<AssetReferenceCandidate> ScanFiles(IEnumerable<ProjectSourceFile> projectFiles)
    {
        var candidates = new List<AssetReferenceCandidate>();

        foreach (var projectFile in projectFiles)
        {
            var extension = Path.GetExtension(projectFile.SourcePath);

            if (!SupportedExtensions.Contains(extension))
            {
                continue;
            }

            foreach (var rawValue in Extract(projectFile.SourcePath, extension))
            {
                candidates.Add(new AssetReferenceCandidate(rawValue, projectFile.SourcePath, AssetReferenceSourceKind.ProjectText));
            }
        }

        return candidates;
    }

    private static IReadOnlyList<string> Extract(string filePath, string extension)
    {
        var decodedFile = TextFileCodec.Read(filePath);
        var text = decodedFile.Text;

        return extension.ToLowerInvariant() switch
        {
            ".lua" => ExtractLuaStrings(text),
            ".j" or ".ai" or ".fdf" or ".f" => ExtractQuotedStrings(text, allowSlashSlashComments: true, allowSemicolonComments: false),
            ".toc" => ExtractTocPaths(text),
            ".ini" => ExtractQuotedStrings(text, allowSlashSlashComments: true, allowSemicolonComments: true),
            _ => Array.Empty<string>()
        };
    }

    private static IReadOnlyList<string> ExtractLuaStrings(string text)
    {
        var results = new List<string>();
        var index = 0;

        while (index < text.Length)
        {
            if (text[index] == '-' && index + 1 < text.Length && text[index + 1] == '-')
            {
                index += 2;

                if (TryGetLongBracketLength(text, index, out var bracketLength))
                {
                    index = SkipLongBracket(text, index, bracketLength);
                    continue;
                }

                while (index < text.Length && text[index] is not '\r' and not '\n')
                {
                    index++;
                }

                continue;
            }

            if (text[index] is '"' or '\'')
            {
                results.Add(ReadQuotedString(text, ref index, text[index]));
                continue;
            }

            if (TryGetLongBracketLength(text, index, out var literalBracketLength))
            {
                index = SkipLongBracket(text, index, literalBracketLength);
                continue;
            }

            index++;
        }

        return results;
    }

    private static IReadOnlyList<string> ExtractQuotedStrings(
        string text,
        bool allowSlashSlashComments,
        bool allowSemicolonComments)
    {
        var results = new List<string>();
        var lines = text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n');

        foreach (var line in lines)
        {
            var index = 0;

            while (index < line.Length)
            {
                if (allowSlashSlashComments &&
                    line[index] == '/' &&
                    index + 1 < line.Length &&
                    line[index + 1] == '/')
                {
                    break;
                }

                if (allowSemicolonComments && (line[index] == ';' || line[index] == '#'))
                {
                    break;
                }

                if (line[index] == '"')
                {
                    results.Add(ReadQuotedString(line, ref index, '"'));
                    continue;
                }

                index++;
            }
        }

        return results;
    }

    private static IReadOnlyList<string> ExtractTocPaths(string text)
    {
        var results = new List<string>();
        var lines = text.Replace("\r\n", "\n", StringComparison.Ordinal).Split('\n');

        foreach (var rawLine in lines)
        {
            var line = rawLine.Trim();

            if (string.IsNullOrWhiteSpace(line) ||
                line.StartsWith("//", StringComparison.Ordinal) ||
                line.StartsWith(";", StringComparison.Ordinal) ||
                line.StartsWith("#", StringComparison.Ordinal))
            {
                continue;
            }

            results.Add(line.Trim('"'));
        }

        return results;
    }

    private static string ReadQuotedString(string text, ref int index, char quote)
    {
        var builder = new StringBuilder();
        index++;

        while (index < text.Length)
        {
            var current = text[index];

            if (current == quote)
            {
                index++;
                return builder.ToString();
            }

            if (current == '\\' && index + 1 < text.Length)
            {
                index++;
                var escaped = text[index];
                builder.Append(escaped switch
                {
                    'n' => '\n',
                    'r' => '\r',
                    't' => '\t',
                    '"' => '"',
                    '\'' => '\'',
                    '\\' => '\\',
                    _ => escaped
                });
                index++;
                continue;
            }

            builder.Append(current);
            index++;
        }

        return builder.ToString();
    }

    private static bool TryGetLongBracketLength(string text, int index, out int bracketLength)
    {
        bracketLength = 0;

        if (index >= text.Length || text[index] != '[')
        {
            return false;
        }

        var cursor = index + 1;

        while (cursor < text.Length && text[cursor] == '=')
        {
            cursor++;
        }

        if (cursor >= text.Length || text[cursor] != '[')
        {
            return false;
        }

        bracketLength = cursor - index - 1;
        return true;
    }

    private static int SkipLongBracket(string text, int index, int bracketLength)
    {
        var closingSequence = "]" + new string('=', bracketLength) + "]";
        var contentStart = index + bracketLength + 2;
        var closingIndex = text.IndexOf(closingSequence, contentStart, StringComparison.Ordinal);

        return closingIndex < 0
            ? text.Length
            : closingIndex + closingSequence.Length;
    }
}
