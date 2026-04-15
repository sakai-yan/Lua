using System.Globalization;
using System.Text;

namespace MapRepair.Core.Internal;

internal static class LiteralValueParser
{
    public static int ParseInt(string rawValue) =>
        int.Parse(rawValue.Trim(), CultureInfo.InvariantCulture);

    public static float ParseFloat(string rawValue) =>
        float.Parse(rawValue.Trim(), CultureInfo.InvariantCulture);

    public static string ParseQuotedString(string rawValue)
    {
        var value = rawValue.Trim();
        if (value.Length >= 2 && value[0] == '"' && value[^1] == '"')
        {
            value = value[1..^1];
        }

        var builder = new StringBuilder(value.Length);
        for (var index = 0; index < value.Length; index++)
        {
            var current = value[index];
            if (current != '\\' || index == value.Length - 1)
            {
                builder.Append(current);
                continue;
            }

            index++;
            builder.Append(value[index] switch
            {
                '0' => '\0',
                'n' => '\n',
                'r' => '\r',
                't' => '\t',
                '\\' => '\\',
                '"' => '"',
                var other => other
            });
        }

        return builder.ToString();
    }

    public static int[] ParseIntArray(string rawValue)
    {
        var items = SplitArray(rawValue);
        var values = new int[items.Count];
        for (var index = 0; index < items.Count; index++)
        {
            values[index] = ParseInt(items[index]);
        }

        return values;
    }

    public static float[] ParseFloatArray(string rawValue)
    {
        var items = SplitArray(rawValue);
        var values = new float[items.Count];
        for (var index = 0; index < items.Count; index++)
        {
            values[index] = ParseFloat(items[index]);
        }

        return values;
    }

    public static byte[] ParseByteArray(string rawValue)
    {
        var items = SplitArray(rawValue);
        var values = new byte[items.Count];
        for (var index = 0; index < items.Count; index++)
        {
            values[index] = byte.Parse(items[index], CultureInfo.InvariantCulture);
        }

        return values;
    }

    public static uint BuildPlayerMask(IEnumerable<int> playerNumbers)
    {
        uint mask = 0;
        foreach (var playerNumber in playerNumbers)
        {
            if (playerNumber <= 0 || playerNumber > 32)
            {
                continue;
            }

            mask |= 1u << (playerNumber - 1);
        }

        return mask;
    }

    private static List<string> SplitArray(string rawValue)
    {
        var value = rawValue.Trim();
        if (value.StartsWith('{'))
        {
            value = value[1..];
        }

        if (value.EndsWith('}'))
        {
            value = value[..^1];
        }

        return value
            .Split([',', '\r', '\n'], StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Where(item => !string.IsNullOrWhiteSpace(item))
            .ToList();
    }
}
