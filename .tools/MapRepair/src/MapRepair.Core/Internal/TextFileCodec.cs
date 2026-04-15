using System.Text;

namespace MapRepair.Core.Internal;

internal sealed record DecodedTextFile(string Text, Encoding Encoding);

internal static class TextFileCodec
{
    static TextFileCodec()
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
    }

    public static DecodedTextFile Read(string filePath)
    {
        return Decode(File.ReadAllBytes(filePath));
    }

    public static DecodedTextFile Decode(byte[] bytes)
    {
        ArgumentNullException.ThrowIfNull(bytes);

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

    public static byte[] Encode(DecodedTextFile textFile)
    {
        ArgumentNullException.ThrowIfNull(textFile);

        var contentBytes = textFile.Encoding.GetBytes(textFile.Text);
        var preamble = textFile.Encoding.GetPreamble();
        if (preamble.Length == 0)
        {
            return contentBytes;
        }

        var result = new byte[preamble.Length + contentBytes.Length];
        Buffer.BlockCopy(preamble, 0, result, 0, preamble.Length);
        Buffer.BlockCopy(contentBytes, 0, result, preamble.Length, contentBytes.Length);
        return result;
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
