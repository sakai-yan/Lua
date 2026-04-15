using System.Text;
using System.Text.RegularExpressions;

namespace Packer.Core.Internal.Assets;

internal sealed class ModelTextureReferenceReader
{
    private static readonly Regex BitmapBlockRegex = new(
        @"Bitmap\s*\{(?<body>.*?)\}",
        RegexOptions.IgnoreCase | RegexOptions.Singleline | RegexOptions.Compiled);

    private static readonly Regex ImageRegex = new(
        @"Image\s+""(?<path>[^""]+)""",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    private static readonly Regex ReplaceableIdRegex = new(
        @"ReplaceableId\s+(?<id>\d+)",
        RegexOptions.IgnoreCase | RegexOptions.Compiled);

    public IReadOnlyList<string> ReadTextureReferences(string modelPath)
    {
        var extension = Path.GetExtension(modelPath);

        return extension.ToLowerInvariant() switch
        {
            ".mdl" => ReadMdlTextureReferences(modelPath),
            ".mdx" => ReadMdxTextureReferences(modelPath),
            _ => Array.Empty<string>()
        };
    }

    private static IReadOnlyList<string> ReadMdlTextureReferences(string modelPath)
    {
        var decodedFile = TextFileCodec.Read(modelPath);
        var results = new List<string>();

        foreach (Match match in BitmapBlockRegex.Matches(decodedFile.Text))
        {
            var body = match.Groups["body"].Value;
            var replaceableMatch = ReplaceableIdRegex.Match(body);

            if (replaceableMatch.Success &&
                int.TryParse(replaceableMatch.Groups["id"].Value, out var replaceableId) &&
                replaceableId > 0)
            {
                continue;
            }

            var imageMatch = ImageRegex.Match(body);

            if (imageMatch.Success)
            {
                results.Add(imageMatch.Groups["path"].Value.Trim());
            }
        }

        return results;
    }

    private static IReadOnlyList<string> ReadMdxTextureReferences(string modelPath)
    {
        var bytes = File.ReadAllBytes(modelPath);

        if (bytes.Length < 8 || Encoding.ASCII.GetString(bytes, 0, 4) != "MDLX")
        {
            throw new InvalidDataException("不是合法的 MDX 文件头。");
        }

        var results = new List<string>();
        var offset = 4;

        while (offset + 8 <= bytes.Length)
        {
            var chunkId = Encoding.ASCII.GetString(bytes, offset, 4);
            var chunkSize = BitConverter.ToInt32(bytes, offset + 4);
            offset += 8;

            if (chunkSize < 0 || offset + chunkSize > bytes.Length)
            {
                throw new InvalidDataException($"MDX chunk `{chunkId}` 的长度非法。");
            }

            if (!string.Equals(chunkId, "TEXS", StringComparison.Ordinal))
            {
                offset += chunkSize;
                continue;
            }

            var chunkEnd = offset + chunkSize;

            while (offset + 268 <= chunkEnd)
            {
                var replaceableId = BitConverter.ToInt32(bytes, offset);
                var pathBytes = bytes.AsSpan(offset + 4, 260);
                var terminatorIndex = pathBytes.IndexOf((byte)0);

                if (terminatorIndex < 0)
                {
                    terminatorIndex = pathBytes.Length;
                }

                var texturePath = Encoding.UTF8.GetString(pathBytes[..terminatorIndex]).Trim();

                if (replaceableId <= 0 && !string.IsNullOrWhiteSpace(texturePath))
                {
                    results.Add(texturePath);
                }

                offset += 268;
            }

            offset = chunkEnd;
        }

        return results;
    }
}
