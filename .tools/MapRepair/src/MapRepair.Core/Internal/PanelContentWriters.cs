using System.Text;

namespace MapRepair.Core.Internal;

internal static class PanelContentWriters
{
    public static byte[] WriteRegions(IReadOnlyList<InferredRegion> regions)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(5);
        writer.Write(regions.Count);

        foreach (var region in regions)
        {
            writer.Write(region.Left);
            writer.Write(region.Bottom);
            writer.Write(region.Right);
            writer.Write(region.Top);
            WriteNullTerminatedString(writer, region.VariableName.Replace("gg_rct_", string.Empty, StringComparison.OrdinalIgnoreCase));
            writer.Write(region.RegionId);
            WriteFourCc(writer, region.WeatherEffect);
            WriteNullTerminatedString(writer, region.AmbientSound);
            writer.Write((byte)255);
            writer.Write((byte)255);
            writer.Write((byte)255);
            writer.Write((byte)255);
        }

        return stream.ToArray();
    }

    public static byte[] WriteCameras(IReadOnlyList<InferredCamera> cameras)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(0);
        writer.Write(cameras.Count);

        foreach (var camera in cameras)
        {
            writer.Write(camera.TargetX);
            writer.Write(camera.TargetY);
            writer.Write(camera.OffsetZ);
            writer.Write(camera.Rotation);
            writer.Write(camera.AngleOfAttack);
            writer.Write(camera.Distance);
            writer.Write(camera.Roll);
            writer.Write(camera.FieldOfView);
            writer.Write(camera.FarClipping);
            writer.Write(camera.NearClipping);
            WriteNullTerminatedString(writer, camera.Name);
        }

        return stream.ToArray();
    }

    public static byte[] WriteSounds(IReadOnlyList<InferredSound> sounds)
    {
        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);
        writer.Write(1);
        writer.Write(sounds.Count);

        foreach (var sound in sounds)
        {
            WriteNullTerminatedString(writer, sound.VariableName);
            WriteNullTerminatedString(writer, sound.SoundPath);
            WriteNullTerminatedString(writer, sound.SoundEax);
            writer.Write(BuildFlags(sound));
            writer.Write(sound.FadeInRate);
            writer.Write(sound.FadeOutRate);
            writer.Write(sound.Volume);
            writer.Write(sound.Pitch);
            writer.Write(0f);
            writer.Write(0f);
            writer.Write(sound.Channel);
            writer.Write(sound.MinDistance);
            writer.Write(sound.MaxDistance);
            writer.Write(sound.CutoffDistance);
            writer.Write(0f);
            writer.Write(0f);
            writer.Write(0f);
            writer.Write(0f);
            writer.Write(0);
            writer.Write(0);
        }

        return stream.ToArray();
    }

    private static int BuildFlags(InferredSound sound)
    {
        var flags = 0;
        if (sound.IsLooping) flags |= 0x01;
        if (sound.Is3dSound) flags |= 0x02;
        if (sound.StopWhenOutOfRange) flags |= 0x04;
        if (sound.IsMusic) flags |= 0x08;
        return flags;
    }

    private static void WriteFourCc(BinaryWriter writer, string value)
    {
        var chars = (value ?? string.Empty).PadRight(4, '\0')[..4];
        writer.Write(Encoding.ASCII.GetBytes(chars));
    }

    private static void WriteNullTerminatedString(BinaryWriter writer, string value)
    {
        writer.Write(Encoding.UTF8.GetBytes(value ?? string.Empty));
        writer.Write((byte)0);
    }
}
