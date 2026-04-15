using System.Text;

namespace MapRepair.Core.Internal;

internal static class W3iBinaryWriter
{
    private const int ForceFlagAllied = 0x0001;
    private const int ForceFlagAlliedVictory = 0x0002;
    private const int ForceFlagShareVision = 0x0008;
    private const int ForceFlagShareUnitControl = 0x0010;
    private const int ForceFlagShareAdvancedUnitControl = 0x0020;

    private const int MapFlagHidePreview = 0x0001;
    private const int MapFlagCustomAllyPriority = 0x0002;
    private const int MapFlagMeleeMap = 0x0004;
    private const int MapFlagRevealTerrain = 0x0010;
    private const int MapFlagCustomForces = 0x0040;
    private const int MapFlagCustomTechTree = 0x0080;
    private const int MapFlagCustomAbilities = 0x0100;
    private const int MapFlagCustomUpgrades = 0x0200;
    private const int MapFlagWaveOnCliff = 0x0800;
    private const int MapFlagWaveOnRolling = 0x1000;

    public static byte[] Write(W3iTemplate template, TerrainInfo terrain, string mapName)
    {
        var version = template.FileVersion;

        using var stream = new MemoryStream();
        using var writer = new BinaryWriter(stream, Encoding.UTF8, leaveOpen: true);

        writer.Write(version);
        writer.Write(template.MapVersion);
        writer.Write(template.EditorVersion);

        if (version >= 28)
        {
            // Rebuilt map info does not preserve a Warcraft version tuple, but official parsers
            // still expect four ints before the string fields when version >= 28.
            writer.Write(0);
            writer.Write(0);
            writer.Write(0);
            writer.Write(0);
        }

        WriteCString(writer, mapName);
        WriteCString(writer, template.AuthorName);
        WriteCString(writer, template.MapDescription);
        WriteCString(writer, template.RecommendedPlayers);

        foreach (var value in BuildCameraBounds(terrain.MapWidth, terrain.MapHeight))
        {
            writer.Write(value);
        }

        foreach (var value in template.CameraBoundsComplements)
        {
            writer.Write(value);
        }

        writer.Write(terrain.MapWidth);
        writer.Write(terrain.MapHeight);
        writer.Write(BuildMapFlags(template));
        writer.Write((byte)template.MainGroundTileset);

        if (version >= 25)
        {
            writer.Write(template.LoadingScreenIndex);
            WriteCString(writer, template.LoadingScreenPath);
            WriteCString(writer, template.LoadingScreenText);
            WriteCString(writer, template.LoadingScreenTitle);
            WriteCString(writer, template.LoadingScreenSubtitle);

            // Keep rebuilt map info on the default game-data setting.
            writer.Write(0);

            WriteCString(writer, template.ProloguePath);
            WriteCString(writer, template.PrologueText);
            WriteCString(writer, template.PrologueTitle);
            WriteCString(writer, template.PrologueSubtitle);

            writer.Write(template.FogType);
            writer.Write(template.FogStartZ);
            writer.Write(template.FogEndZ);
            writer.Write(template.FogDensity);
            WriteColor(writer, template.FogColor);
            WriteFourCc(writer, template.WeatherId);
            WriteCString(writer, template.SoundEnvironment);
            writer.Write((byte)template.LightEnvironment);
            WriteColor(writer, template.WaterColor);

            if (version >= 28)
            {
                // 0 = JASS, 1 = Lua in the official w3x2lni parser.
                writer.Write(0);
            }

            if (version >= 31)
            {
                writer.Write(0);
                writer.Write(0);
            }
        }
        else if (version == 18)
        {
            writer.Write(template.LoadingScreenIndex);
            WriteCString(writer, template.LoadingScreenText);
            WriteCString(writer, template.LoadingScreenTitle);
            WriteCString(writer, template.LoadingScreenSubtitle);
            writer.Write(-1);
            WriteCString(writer, template.PrologueText);
            WriteCString(writer, template.PrologueTitle);
            WriteCString(writer, template.PrologueSubtitle);
        }

        writer.Write(template.Players.Count);
        foreach (var player in template.Players)
        {
            writer.Write(player.PlayerId);
            writer.Write(player.Type);
            writer.Write(player.Race);
            writer.Write(player.FixedStartPosition);
            WriteCString(writer, player.Name);
            writer.Write(player.StartX);
            writer.Write(player.StartY);
            writer.Write(player.LowPriorityMask);
            writer.Write(player.HighPriorityMask);

            if (version >= 31)
            {
                writer.Write(0);
                writer.Write(0);
            }
        }

        writer.Write(template.Forces.Count);
        foreach (var force in template.Forces)
        {
            writer.Write(BuildForceFlags(force));
            writer.Write(force.PlayerMask);
            WriteCString(writer, force.Name);
        }

        // Upgrade, tech, random unit, and random item sections.
        writer.Write(0);
        writer.Write(0);
        writer.Write(0);
        if (version >= 25)
        {
            writer.Write(0);
        }

        return stream.ToArray();
    }

    private static IReadOnlyList<float> BuildCameraBounds(int mapWidth, int mapHeight)
    {
        var left = -mapWidth * 64f + 512f;
        var bottom = -mapHeight * 64f;
        var right = mapWidth * 64f - 512f;
        var top = mapHeight * 64f - 512f;

        return
        [
            left,
            bottom,
            right,
            top,
            left,
            top,
            right,
            bottom
        ];
    }

    private static int BuildMapFlags(W3iTemplate template)
    {
        var flags = 0;

        if (template.DisablePreview) flags |= MapFlagHidePreview;
        if (template.CustomAllyPriority) flags |= MapFlagCustomAllyPriority;
        if (template.MeleeMap) flags |= MapFlagMeleeMap;
        if (template.MaskedAreaShowTerrain) flags |= MapFlagRevealTerrain;
        if (template.CustomForce) flags |= MapFlagCustomForces;
        if (template.CustomTechTree) flags |= MapFlagCustomTechTree;
        if (template.CustomAbility) flags |= MapFlagCustomAbilities;
        if (template.CustomUpgrade) flags |= MapFlagCustomUpgrades;
        if (template.ShowWaveOnCliff) flags |= MapFlagWaveOnCliff;
        if (template.ShowWaveOnRolling) flags |= MapFlagWaveOnRolling;

        return flags;
    }

    private static int BuildForceFlags(W3iForceTemplate force)
    {
        var flags = 0;
        if (force.Allied) flags |= ForceFlagAllied;
        if (force.AlliedVictory) flags |= ForceFlagAlliedVictory;
        if (force.ShareVision) flags |= ForceFlagShareVision;
        if (force.ShareUnitControl) flags |= ForceFlagShareUnitControl;
        if (force.ShareAdvancedControl) flags |= ForceFlagShareAdvancedUnitControl;
        return flags;
    }

    private static void WriteCString(BinaryWriter writer, string value)
    {
        var bytes = Encoding.UTF8.GetBytes(value);
        writer.Write(bytes);
        writer.Write((byte)0);
    }

    private static void WriteColor(BinaryWriter writer, byte[] color)
    {
        writer.Write(color.Length > 0 ? color[0] : (byte)0);
        writer.Write(color.Length > 1 ? color[1] : (byte)0);
        writer.Write(color.Length > 2 ? color[2] : (byte)0);
        writer.Write(color.Length > 3 ? color[3] : (byte)255);
    }

    private static void WriteFourCc(BinaryWriter writer, string value)
    {
        var chars = value.PadRight(4, '\0');
        for (var index = 0; index < 4; index++)
        {
            writer.Write((byte)chars[index]);
        }
    }
}
