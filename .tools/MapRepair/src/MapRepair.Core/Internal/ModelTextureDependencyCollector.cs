using System.Text;

namespace MapRepair.Core.Internal;

internal static class ModelTextureDependencyCollector
{
    private const int ChunkHeaderSize = 8;
    private const int TextureRecordSize = 268;
    private const int TexturePathLength = 260;

    private static readonly HashSet<string> ModelExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        ".mdl",
        ".mdx"
    };

    private static readonly HashSet<string> TextureExtensions = new(StringComparer.OrdinalIgnoreCase)
    {
        ".blp",
        ".bmp",
        ".dds",
        ".jpeg",
        ".jpg",
        ".pcx",
        ".png",
        ".tga"
    };

    public static IReadOnlyList<string> CollectTexturePaths(string entryName, byte[] data)
    {
        if (data.Length == 0 ||
            (!LooksLikeModelFile(entryName) && !LooksLikeBinaryMdx(data)))
        {
            return [];
        }

        var textures = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        if (LooksLikeBinaryMdx(data))
        {
            CollectBinaryMdxTexturePaths(data, textures);
        }
        else
        {
            CollectTextMdlTexturePaths(data, textures);
        }

        return textures
            .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    public static bool LooksLikeBinaryMdx(byte[] data)
    {
        return data.Length >= 4 &&
               data[0] == (byte)'M' &&
               data[1] == (byte)'D' &&
               data[2] == (byte)'L' &&
               data[3] == (byte)'X';
    }

    public static bool LooksLikeModelFile(string? entryName)
    {
        var extension = Path.GetExtension(entryName ?? string.Empty);
        return ModelExtensions.Contains(extension);
    }

    private static void CollectBinaryMdxTexturePaths(byte[] data, ISet<string> textures)
    {
        using var stream = new MemoryStream(data, writable: false);
        using var reader = new BinaryReader(stream, Encoding.UTF8, leaveOpen: false);

        _ = reader.ReadBytes(4);
        while (stream.Position + ChunkHeaderSize <= stream.Length)
        {
            var chunkName = Encoding.ASCII.GetString(reader.ReadBytes(4));
            var chunkSize = reader.ReadInt32();
            if (chunkSize < 0 || stream.Position + chunkSize > stream.Length)
            {
                break;
            }

            if (!chunkName.Equals("TEXS", StringComparison.Ordinal))
            {
                stream.Position += chunkSize;
                continue;
            }

            var chunkEnd = stream.Position + chunkSize;
            while (stream.Position + TextureRecordSize <= chunkEnd)
            {
                _ = reader.ReadInt32();
                var pathBytes = reader.ReadBytes(TexturePathLength);
                _ = reader.ReadInt32();
                AddTextureCandidate(DecodeCString(pathBytes), textures);
            }

            stream.Position = chunkEnd;
        }
    }

    private static void CollectTextMdlTexturePaths(byte[] data, ISet<string> textures)
    {
        var text = Encoding.UTF8.GetString(data);
        foreach (var literal in ExtractQuotedStrings(text))
        {
            AddTextureCandidate(literal, textures);
        }
    }

    private static string DecodeCString(byte[] bytes)
    {
        var terminatorIndex = Array.IndexOf(bytes, (byte)0);
        var length = terminatorIndex >= 0 ? terminatorIndex : bytes.Length;
        return Encoding.UTF8.GetString(bytes, 0, length);
    }

    private static IEnumerable<string> ExtractQuotedStrings(string text)
    {
        if (string.IsNullOrEmpty(text))
        {
            yield break;
        }

        var buffer = new StringBuilder();
        var inString = false;

        foreach (var ch in text)
        {
            if (!inString)
            {
                if (ch == '"')
                {
                    inString = true;
                    buffer.Clear();
                }

                continue;
            }

            if (ch == '"')
            {
                if (buffer.Length > 0)
                {
                    yield return buffer.ToString();
                }

                buffer.Clear();
                inString = false;
                continue;
            }

            buffer.Append(ch);
        }
    }

    private static void AddTextureCandidate(string rawValue, ISet<string> textures)
    {
        var normalized = NormalizeValue(rawValue);
        if (string.IsNullOrWhiteSpace(normalized))
        {
            return;
        }

        var extension = Path.GetExtension(normalized);
        if (!TextureExtensions.Contains(extension))
        {
            return;
        }

        textures.Add(normalized);
    }

    private static string NormalizeValue(string rawValue)
    {
        return (rawValue ?? string.Empty)
            .Trim()
            .Trim('"')
            .Replace('/', '\\')
            .TrimStart('\\')
            .Trim();
    }
}
