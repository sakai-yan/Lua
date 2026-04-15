using System.Globalization;
using System.Text;

namespace MapRepair.Core.Internal;

internal static class ObjectDataFileWriter
{
    public static byte[] Write(
        IReadOnlyList<ObjectDefinition> objects,
        bool includeLevelAndPointer = false,
        bool originalModificationUsesBaseIdTerminator = false)
    {
        var originals = objects.Where(obj => !obj.IsCustom).ToArray();
        var customs = objects.Where(obj => obj.IsCustom).ToArray();

        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(2);
        writer.Write(originals.Length);
        foreach (var obj in originals)
        {
            WriteObject(writer, obj, includeLevelAndPointer, originalModificationUsesBaseIdTerminator);
        }

        writer.Write(customs.Length);
        foreach (var obj in customs)
        {
            WriteObject(writer, obj, includeLevelAndPointer, originalModificationUsesBaseIdTerminator);
        }

        return stream.ToArray();
    }

    private static void WriteObject(
        BinaryWriter writer,
        ObjectDefinition obj,
        bool includeLevelAndPointer,
        bool originalModificationUsesBaseIdTerminator)
    {
        WriteRawCode(writer, obj.BaseId);
        if (obj.IsCustom)
        {
            WriteRawCode(writer, obj.NewId);
        }
        else
        {
            writer.Write(0);
        }

        writer.Write(obj.Modifications.Count);
        var terminatorId = obj.IsCustom
            ? obj.NewId
            : (originalModificationUsesBaseIdTerminator ? obj.BaseId : string.Empty);
        foreach (var modification in obj.Modifications)
        {
            WriteRawCode(writer, modification.RawCode);
            writer.Write((int)modification.ValueKind);
            if (includeLevelAndPointer)
            {
                writer.Write(modification.Level);
                writer.Write(modification.Pointer);
            }
            WriteValue(writer, modification);
            WriteRawCode(writer, terminatorId);
        }
    }

    private static void WriteValue(BinaryWriter writer, ObjectModification modification)
    {
        switch (modification.ValueKind)
        {
            case ObjectValueKind.Int:
                writer.Write(Convert.ToInt32(modification.Value, CultureInfo.InvariantCulture));
                break;

            case ObjectValueKind.Real:
            case ObjectValueKind.Unreal:
                writer.Write(Convert.ToSingle(modification.Value, CultureInfo.InvariantCulture));
                break;

            case ObjectValueKind.String:
                WriteNullTerminatedString(writer, Convert.ToString(modification.Value, CultureInfo.InvariantCulture) ?? string.Empty);
                break;

            default:
                throw new InvalidOperationException($"未知的物编值类型：{modification.ValueKind}");
        }
    }

    private static void WriteRawCode(BinaryWriter writer, string rawCode)
    {
        var bytes = Encoding.ASCII.GetBytes((rawCode ?? string.Empty).PadRight(4, '\0')[..4]);
        writer.Write(bytes);
    }

    private static void WriteNullTerminatedString(BinaryWriter writer, string value)
    {
        writer.Write(Encoding.UTF8.GetBytes(value));
        writer.Write((byte)0);
    }
}
