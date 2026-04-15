using System.Text;

namespace Packer.Core.Internal;

internal sealed record DecodedTextFile(string Text, Encoding Encoding);

internal static class TextFileCodec
{
    static TextFileCodec()
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
    }

    public static DecodedTextFile Read(string filePath)
    {
        var bytes = File.ReadAllBytes(filePath);

        if (bytes.Length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF)
        {
            return new DecodedTextFile(new UTF8Encoding(true).GetString(bytes, 3, bytes.Length - 3), new UTF8Encoding(true));
        }

        if (TryDecodeUtf8(bytes, out var utf8Text))
        {
            return new DecodedTextFile(utf8Text, new UTF8Encoding(false));
        }

        var gb18030 = Encoding.GetEncoding("GB18030");
        return new DecodedTextFile(gb18030.GetString(bytes), gb18030);
    }

    public static byte[] Encode(string content, Encoding encoding)
    {
        var preamble = encoding.GetPreamble();
        var body = encoding.GetBytes(content);

        if (preamble.Length == 0)
        {
            return body;
        }

        var combined = new byte[preamble.Length + body.Length];
        Buffer.BlockCopy(preamble, 0, combined, 0, preamble.Length);
        Buffer.BlockCopy(body, 0, combined, preamble.Length, body.Length);
        return combined;
    }

    private static bool TryDecodeUtf8(byte[] bytes, out string text)
    {
        try
        {
            text = new UTF8Encoding(false, throwOnInvalidBytes: true).GetString(bytes);
            return true;
        }
        catch (DecoderFallbackException)
        {
            text = string.Empty;
            return false;
        }
    }
}
