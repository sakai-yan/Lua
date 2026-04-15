using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace MapRepair.Core.Internal;

internal sealed record InferredRegion(
    string VariableName,
    float Left,
    float Bottom,
    float Right,
    float Top,
    int RegionId,
    string WeatherEffect,
    string AmbientSound);

internal sealed record InferredCamera(
    string VariableName,
    float TargetX,
    float TargetY,
    float OffsetZ,
    float Rotation,
    float AngleOfAttack,
    float Distance,
    float Roll,
    float FieldOfView,
    float FarClipping,
    float NearClipping,
    float LocalPitch,
    float LocalYaw,
    float LocalRoll,
    string Name);

internal sealed record InferredSound(
    string VariableName,
    string SoundPath,
    string SoundEax,
    bool IsLooping,
    bool Is3dSound,
    bool StopWhenOutOfRange,
    bool IsMusic,
    int FadeInRate,
    int FadeOutRate,
    int Volume,
    float Pitch,
    int Channel,
    float MinDistance,
    float MaxDistance,
    float CutoffDistance);

internal static class JassPanelInference
{
    private static readonly Regex RegionRectRegex = new(
        @"set\s+(gg_rct_[A-Za-z0-9_]+)\s*=\s*Rect\(([-0-9.]+),([-0-9.]+),([-0-9.]+),([-0-9.]+)\)",
        RegexOptions.Compiled);

    private static readonly Regex RegionWeatherRegex = new(
        @"AddWeatherEffect\((gg_rct_[A-Za-z0-9_]+),'(.{4})'\)",
        RegexOptions.Compiled);

    private static readonly Regex CameraCreateRegex = new(
        @"set\s+(gg_cam_[A-Za-z0-9_]+)\s*=\s*CreateCameraSetup\(\)",
        RegexOptions.Compiled);

    private static readonly Regex CameraFieldRegex = new(
        @"CameraSetupSetField\((gg_cam_[A-Za-z0-9_]+),\s*CAMERA_FIELD_([A-Z_]+),\s*([-0-9.]+),",
        RegexOptions.Compiled);

    private static readonly Regex CameraDestRegex = new(
        @"CameraSetupSetDestPosition\((gg_cam_[A-Za-z0-9_]+),\s*([-0-9.]+),\s*([-0-9.]+),\s*([-0-9.]+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundCreateRegex = new(
        "set\\s+(gg_snd_[A-Za-z0-9_]+)\\s*=\\s*CreateSound\\(\"([^\"]*)\",(true|false),(true|false),(true|false),(\\d+),(\\d+),\"([^\"]*)\"\\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundDurationRegex = new(
        @"SetSoundDuration\((gg_snd_[A-Za-z0-9_]+),(\d+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundChannelRegex = new(
        @"SetSoundChannel\((gg_snd_[A-Za-z0-9_]+),(-?\d+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundVolumeRegex = new(
        @"SetSoundVolume\((gg_snd_[A-Za-z0-9_]+),(-?\d+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundPitchRegex = new(
        @"SetSoundPitch\((gg_snd_[A-Za-z0-9_]+),([-0-9.]+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundDistanceRegex = new(
        @"SetSoundDistances\((gg_snd_[A-Za-z0-9_]+),([-0-9.]+),([-0-9.]+)\)",
        RegexOptions.Compiled);

    private static readonly Regex SoundCutoffRegex = new(
        @"SetSoundDistanceCutoff\((gg_snd_[A-Za-z0-9_]+),([-0-9.]+)\)",
        RegexOptions.Compiled);

    public static IReadOnlyList<InferredRegion> InferRegions(string jassScript)
    {
        var weatherByRegion = RegionWeatherRegex.Matches(jassScript)
            .ToDictionary(
                match => match.Groups[1].Value,
                match => match.Groups[2].Value,
                StringComparer.OrdinalIgnoreCase);

        var regions = new List<InferredRegion>();
        var regionId = 0;
        foreach (Match match in RegionRectRegex.Matches(jassScript))
        {
            var variableName = match.Groups[1].Value;
            regions.Add(new InferredRegion(
                variableName,
                ParseFloat(match.Groups[2].Value),
                ParseFloat(match.Groups[3].Value),
                ParseFloat(match.Groups[4].Value),
                ParseFloat(match.Groups[5].Value),
                regionId++,
                weatherByRegion.TryGetValue(variableName, out var weather) ? weather : "\0\0\0\0",
                string.Empty));
        }

        return regions;
    }

    public static IReadOnlyList<InferredCamera> InferCameras(string jassScript)
    {
        var cameras = new Dictionary<string, MutableCamera>(StringComparer.OrdinalIgnoreCase);

        foreach (Match match in CameraCreateRegex.Matches(jassScript))
        {
            var variableName = match.Groups[1].Value;
            cameras[variableName] = new MutableCamera(variableName);
        }

        foreach (Match match in CameraFieldRegex.Matches(jassScript))
        {
            var variableName = match.Groups[1].Value;
            if (!cameras.TryGetValue(variableName, out var camera))
            {
                continue;
            }

            var fieldName = match.Groups[2].Value;
            var value = ParseFloat(match.Groups[3].Value);
            camera.ApplyField(fieldName, value);
        }

        foreach (Match match in CameraDestRegex.Matches(jassScript))
        {
            var variableName = match.Groups[1].Value;
            if (!cameras.TryGetValue(variableName, out var camera))
            {
                continue;
            }

            camera.TargetX = ParseFloat(match.Groups[2].Value);
            camera.TargetY = ParseFloat(match.Groups[3].Value);
            camera.OffsetZ = ParseFloat(match.Groups[4].Value);
        }

        return cameras.Values
            .Select(camera => camera.ToImmutable())
            .ToArray();
    }

    public static IReadOnlyList<InferredSound> InferSounds(string jassScript, IReadOnlyDictionary<int, string> wts)
    {
        var sounds = new Dictionary<string, MutableSound>(StringComparer.OrdinalIgnoreCase);

        foreach (Match match in SoundCreateRegex.Matches(jassScript))
        {
            var variableName = match.Groups[1].Value;
            var soundPath = ResolveWts(match.Groups[2].Value, wts);
            sounds[variableName] = new MutableSound(
                variableName,
                soundPath,
                ResolveWts(match.Groups[7].Value, wts),
                ParseBool(match.Groups[3].Value),
                ParseBool(match.Groups[4].Value),
                ParseBool(match.Groups[5].Value),
                IsMusicPath(soundPath),
                int.Parse(match.Groups[6].Value, CultureInfo.InvariantCulture),
                int.Parse(match.Groups[6].Value, CultureInfo.InvariantCulture));
        }

        foreach (Match match in SoundChannelRegex.Matches(jassScript))
        {
            if (sounds.TryGetValue(match.Groups[1].Value, out var sound))
            {
                sound.Channel = int.Parse(match.Groups[2].Value, CultureInfo.InvariantCulture);
            }
        }

        foreach (Match match in SoundVolumeRegex.Matches(jassScript))
        {
            if (sounds.TryGetValue(match.Groups[1].Value, out var sound))
            {
                sound.Volume = int.Parse(match.Groups[2].Value, CultureInfo.InvariantCulture);
            }
        }

        foreach (Match match in SoundPitchRegex.Matches(jassScript))
        {
            if (sounds.TryGetValue(match.Groups[1].Value, out var sound))
            {
                sound.Pitch = ParseFloat(match.Groups[2].Value);
            }
        }

        foreach (Match match in SoundDistanceRegex.Matches(jassScript))
        {
            if (sounds.TryGetValue(match.Groups[1].Value, out var sound))
            {
                sound.MinDistance = ParseFloat(match.Groups[2].Value);
                sound.MaxDistance = ParseFloat(match.Groups[3].Value);
            }
        }

        foreach (Match match in SoundCutoffRegex.Matches(jassScript))
        {
            if (sounds.TryGetValue(match.Groups[1].Value, out var sound))
            {
                sound.CutoffDistance = ParseFloat(match.Groups[2].Value);
            }
        }

        return sounds.Values.Select(sound => sound.ToImmutable()).ToArray();
    }

    public static IReadOnlyDictionary<int, string> ParseWts(string text)
    {
        var values = new Dictionary<int, string>();
        var normalized = text.Replace("\r\n", "\n", StringComparison.Ordinal);
        var lines = normalized.Split('\n');
        for (var index = 0; index < lines.Length; index++)
        {
            var line = lines[index].Trim();
            if (!line.StartsWith("STRING ", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            if (!int.TryParse(line["STRING ".Length..].Trim(), NumberStyles.Integer, CultureInfo.InvariantCulture, out var id))
            {
                continue;
            }

            while (index + 1 < lines.Length && string.IsNullOrWhiteSpace(lines[index + 1]))
            {
                index++;
            }

            if (index + 1 >= lines.Length || lines[index + 1].Trim() != "{")
            {
                continue;
            }

            index += 2;
            var builder = new StringBuilder();
            while (index < lines.Length && lines[index].Trim() != "}")
            {
                if (builder.Length > 0)
                {
                    builder.Append('\n');
                }

                builder.Append(lines[index]);
                index++;
            }

            values[id] = builder.ToString();
        }

        return values;
    }

    private static bool ParseBool(string rawValue) =>
        rawValue.Equals("true", StringComparison.OrdinalIgnoreCase);

    private static float ParseFloat(string rawValue) =>
        float.Parse(rawValue, CultureInfo.InvariantCulture);

    private static string ResolveWts(string rawValue, IReadOnlyDictionary<int, string> wts)
    {
        if (!rawValue.StartsWith("TRIGSTR_", StringComparison.OrdinalIgnoreCase))
        {
            return rawValue;
        }

        if (!int.TryParse(rawValue["TRIGSTR_".Length..], NumberStyles.Integer, CultureInfo.InvariantCulture, out var id))
        {
            return rawValue;
        }

        return wts.TryGetValue(id, out var value) ? value : rawValue;
    }

    private static bool IsMusicPath(string soundPath) =>
        soundPath.EndsWith(".mp3", StringComparison.OrdinalIgnoreCase) ||
        soundPath.Contains("music", StringComparison.OrdinalIgnoreCase) ||
        soundPath.Contains("muisc", StringComparison.OrdinalIgnoreCase);

    private sealed class MutableCamera
    {
        public MutableCamera(string variableName)
        {
            VariableName = variableName;
        }

        public string VariableName { get; }
        public float TargetX { get; set; }
        public float TargetY { get; set; }
        public float OffsetZ { get; set; }
        public float Rotation { get; set; }
        public float AngleOfAttack { get; set; }
        public float Distance { get; set; }
        public float Roll { get; set; }
        public float FieldOfView { get; set; } = 70f;
        public float FarClipping { get; set; } = 5000f;
        public float NearClipping { get; set; } = 100f;
        public float LocalPitch { get; set; }
        public float LocalYaw { get; set; }
        public float LocalRoll { get; set; }

        public void ApplyField(string fieldName, float value)
        {
            switch (fieldName)
            {
                case "ZOFFSET":
                    OffsetZ = value;
                    break;
                case "ROTATION":
                    Rotation = value;
                    break;
                case "ANGLE_OF_ATTACK":
                    AngleOfAttack = value;
                    break;
                case "TARGET_DISTANCE":
                    Distance = value;
                    break;
                case "ROLL":
                    Roll = value;
                    break;
                case "FIELD_OF_VIEW":
                    FieldOfView = value;
                    break;
                case "FARZ":
                    FarClipping = value;
                    break;
                case "NEARZ":
                    NearClipping = value;
                    break;
                case "LOCAL_PITCH":
                    LocalPitch = value;
                    break;
                case "LOCAL_YAW":
                    LocalYaw = value;
                    break;
                case "LOCAL_ROLL":
                    LocalRoll = value;
                    break;
            }
        }

        public InferredCamera ToImmutable() =>
            new(
                VariableName,
                TargetX,
                TargetY,
                OffsetZ,
                Rotation,
                AngleOfAttack,
                Distance,
                Roll,
                FieldOfView,
                FarClipping,
                NearClipping,
                LocalPitch,
                LocalYaw,
                LocalRoll,
                VariableName.Replace("gg_cam_", string.Empty, StringComparison.OrdinalIgnoreCase));
    }

    private sealed class MutableSound
    {
        public MutableSound(
            string variableName,
            string soundPath,
            string soundEax,
            bool isLooping,
            bool is3dSound,
            bool stopWhenOutOfRange,
            bool isMusic,
            int fadeInRate,
            int fadeOutRate)
        {
            VariableName = variableName;
            SoundPath = soundPath;
            SoundEax = soundEax;
            IsLooping = isLooping;
            Is3dSound = is3dSound;
            StopWhenOutOfRange = stopWhenOutOfRange;
            IsMusic = isMusic;
            FadeInRate = fadeInRate;
            FadeOutRate = fadeOutRate;
        }

        public string VariableName { get; }
        public string SoundPath { get; }
        public string SoundEax { get; }
        public bool IsLooping { get; }
        public bool Is3dSound { get; }
        public bool StopWhenOutOfRange { get; }
        public bool IsMusic { get; }
        public int FadeInRate { get; }
        public int FadeOutRate { get; }
        public int Volume { get; set; } = -1;
        public float Pitch { get; set; } = 1.0f;
        public int Channel { get; set; } = 0;
        public float MinDistance { get; set; } = 0;
        public float MaxDistance { get; set; } = 0;
        public float CutoffDistance { get; set; } = 0;

        public InferredSound ToImmutable() =>
            new(
                VariableName,
                SoundPath,
                SoundEax,
                IsLooping,
                Is3dSound,
                StopWhenOutOfRange,
                IsMusic,
                FadeInRate,
                FadeOutRate,
                Volume,
                Pitch,
                Channel,
                MinDistance,
                MaxDistance,
                CutoffDistance);
    }
}
