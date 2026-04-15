namespace MapRepair.Core.Internal.Mpq;

// Behavior port based on zlib's contrib/blast/blast.c (PKWARE implode decoder).
internal sealed class PkwareExploder
{
    private const int MaxBits = 13;
    private const int MaxWindow = 4096;

    private static readonly Lazy<DecoderTables> Tables = new(BuildTables);

    private readonly byte[] _input;
    private readonly MemoryStream _output = new();
    private readonly byte[] _window = new byte[MaxWindow];

    private int _inputPosition;
    private int _bitsInBuffer;
    private int _bitBuffer;
    private int _windowPosition;
    private bool _firstWindow = true;

    private PkwareExploder(byte[] input)
    {
        _input = input;
    }

    public static byte[] Decompress(byte[] input, int expectedSize)
    {
        var exploder = new PkwareExploder(input);
        var result = exploder.Execute();

        if (expectedSize >= 0 && result.Length > expectedSize)
        {
            return result[..expectedSize];
        }

        return result;
    }

    private byte[] Execute()
    {
        var literalCoding = ReadBits(8);
        if (literalCoding is < 0 or > 1)
        {
            throw new InvalidDataException($"PKWARE implode literal 模式无效：{literalCoding}");
        }

        var dictionaryBits = ReadBits(8);
        if (dictionaryBits is < 4 or > 6)
        {
            throw new InvalidDataException($"PKWARE implode 字典位数无效：{dictionaryBits}");
        }

        var tables = Tables.Value;

        while (true)
        {
            if (ReadBits(1) != 0)
            {
                var symbol = Decode(tables.LengthCode);
                if (symbol < 0)
                {
                    throw new InvalidDataException("PKWARE implode 在解码长度码时失败。");
                }

                var length = tables.LengthBase[symbol] + ReadBits(tables.LengthExtra[symbol]);
                if (length == 519)
                {
                    break;
                }

                var distanceExtraBits = length == 2 ? 2 : dictionaryBits;
                var distanceSymbol = Decode(tables.DistanceCode);
                if (distanceSymbol < 0)
                {
                    throw new InvalidDataException("PKWARE implode 在解码距离码时失败。");
                }

                var distance = (distanceSymbol << distanceExtraBits) + ReadBits(distanceExtraBits) + 1;
                if (_firstWindow && distance > _windowPosition)
                {
                    throw new InvalidDataException("PKWARE implode 产生了越界的回溯距离。");
                }

                CopyFromDistance(distance, length);
            }
            else
            {
                var literal = literalCoding != 0 ? Decode(tables.LiteralCode) : ReadBits(8);
                if (literal < 0)
                {
                    throw new InvalidDataException("PKWARE implode 在解码字面量时失败。");
                }

                WriteByte((byte)literal);
            }
        }

        FlushWindow();
        return _output.ToArray();
    }

    private void CopyFromDistance(int distance, int length)
    {
        while (length > 0)
        {
            var from = _windowPosition - distance;
            var copy = MaxWindow;

            if (_windowPosition < distance)
            {
                from += copy;
                copy = distance;
            }

            copy -= _windowPosition;
            if (copy > length)
            {
                copy = length;
            }

            length -= copy;
            for (var index = 0; index < copy; index++)
            {
                WriteByte(_window[from + index]);
            }
        }
    }

    private void WriteByte(byte value)
    {
        _window[_windowPosition++] = value;
        if (_windowPosition == MaxWindow)
        {
            FlushWindow();
            _windowPosition = 0;
            _firstWindow = false;
        }
    }

    private void FlushWindow()
    {
        if (_windowPosition > 0)
        {
            _output.Write(_window, 0, _windowPosition);
        }
    }

    private int ReadBits(int need)
    {
        var value = _bitBuffer;
        while (_bitsInBuffer < need)
        {
            if (_inputPosition >= _input.Length)
            {
                throw new InvalidDataException("PKWARE implode 输入流提前结束。");
            }

            value |= _input[_inputPosition++] << _bitsInBuffer;
            _bitsInBuffer += 8;
        }

        _bitBuffer = value >> need;
        _bitsInBuffer -= need;
        return value & ((1 << need) - 1);
    }

    private int Decode(HuffmanTable table)
    {
        var code = 0;
        var first = 0;
        var index = 0;

        for (var len = 1; len <= MaxBits; len++)
        {
            code |= ReadBits(1) ^ 1;
            var count = table.Counts[len];

            if (code < first + count)
            {
                return table.Symbols[index + (code - first)];
            }

            index += count;
            first += count;
            first <<= 1;
            code <<= 1;
        }

        return -1;
    }

    private static DecoderTables BuildTables()
    {
        var literalCode = Construct(
        [
            11, 124, 8, 7, 28, 7, 188, 13, 76, 4, 10, 8, 12, 10, 12, 10, 8, 23, 8,
            9, 7, 6, 7, 8, 7, 6, 55, 8, 23, 24, 12, 11, 7, 9, 11, 12, 6, 7, 22, 5,
            7, 24, 6, 11, 9, 6, 7, 22, 7, 11, 38, 7, 9, 8, 25, 11, 8, 11, 9, 12,
            8, 12, 5, 38, 5, 38, 5, 11, 7, 5, 6, 21, 6, 10, 53, 8, 7, 24, 10, 27,
            44, 253, 253, 253, 252, 252, 252, 13, 12, 45, 12, 45, 12, 61, 12, 45,
            44, 173
        ]);

        var lengthCode = Construct([2, 35, 36, 53, 38, 23]);
        var distanceCode = Construct([2, 20, 53, 230, 247, 151, 248]);

        return new DecoderTables(
            literalCode,
            lengthCode,
            distanceCode,
            [3, 2, 4, 5, 6, 7, 8, 9, 10, 12, 16, 24, 40, 72, 136, 264],
            [0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8]);
    }

    private static HuffmanTable Construct(IReadOnlyList<int> repeats)
    {
        var lengths = new List<short>(256);
        foreach (var entry in repeats)
        {
            var repeat = (entry >> 4) + 1;
            var bitLength = (short)(entry & 0x0F);
            for (var index = 0; index < repeat; index++)
            {
                lengths.Add(bitLength);
            }
        }

        var counts = new short[MaxBits + 1];
        foreach (var bitLength in lengths)
        {
            counts[bitLength]++;
        }

        var offsets = new short[MaxBits + 1];
        offsets[1] = 0;
        for (var bitLength = 1; bitLength < MaxBits; bitLength++)
        {
            offsets[bitLength + 1] = (short)(offsets[bitLength] + counts[bitLength]);
        }

        var symbols = new short[lengths.Count - counts[0]];
        for (short symbol = 0; symbol < lengths.Count; symbol++)
        {
            var bitLength = lengths[symbol];
            if (bitLength == 0)
            {
                continue;
            }

            symbols[offsets[bitLength]++] = symbol;
        }

        return new HuffmanTable(counts, symbols);
    }

    private sealed record HuffmanTable(short[] Counts, short[] Symbols);

    private sealed record DecoderTables(
        HuffmanTable LiteralCode,
        HuffmanTable LengthCode,
        HuffmanTable DistanceCode,
        short[] LengthBase,
        byte[] LengthExtra);
}
