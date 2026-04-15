namespace MapRepair.Core.Internal;

internal sealed record W3iPlayerTemplate(
    int PlayerId,
    int Type,
    int Race,
    int FixedStartPosition,
    string Name,
    float StartX,
    float StartY,
    uint LowPriorityMask,
    uint HighPriorityMask);

internal sealed record W3iForceTemplate(
    bool Allied,
    bool AlliedVictory,
    bool ShareVision,
    bool ShareUnitControl,
    bool ShareAdvancedControl,
    uint PlayerMask,
    string Name);

internal sealed class W3iTemplate
{
    public int FileVersion { get; init; }
    public int MapVersion { get; init; }
    public int EditorVersion { get; init; }
    public string MapName { get; init; } = string.Empty;
    public string AuthorName { get; init; } = string.Empty;
    public string MapDescription { get; init; } = string.Empty;
    public string RecommendedPlayers { get; init; } = string.Empty;
    public int[] CameraBoundsComplements { get; init; } = [6, 6, 4, 8];
    public char MainGroundTileset { get; init; } = 'L';
    public bool DisablePreview { get; init; }
    public bool CustomAllyPriority { get; init; }
    public bool MeleeMap { get; init; }
    public bool MaskedAreaShowTerrain { get; init; }
    public bool CustomForce { get; init; }
    public bool CustomTechTree { get; init; }
    public bool CustomAbility { get; init; }
    public bool CustomUpgrade { get; init; }
    public bool ShowWaveOnCliff { get; init; }
    public bool ShowWaveOnRolling { get; init; }
    public int LoadingScreenIndex { get; init; } = -1;
    public string LoadingScreenPath { get; init; } = string.Empty;
    public string LoadingScreenText { get; init; } = string.Empty;
    public string LoadingScreenTitle { get; init; } = string.Empty;
    public string LoadingScreenSubtitle { get; init; } = string.Empty;
    public string ProloguePath { get; init; } = string.Empty;
    public string PrologueText { get; init; } = string.Empty;
    public string PrologueTitle { get; init; } = string.Empty;
    public string PrologueSubtitle { get; init; } = string.Empty;
    public int FogType { get; init; }
    public float FogStartZ { get; init; }
    public float FogEndZ { get; init; }
    public float FogDensity { get; init; }
    public byte[] FogColor { get; init; } = [0, 0, 0, 255];
    public string WeatherId { get; init; } = "\0\0\0\0";
    public string SoundEnvironment { get; init; } = string.Empty;
    public char LightEnvironment { get; init; } = '\0';
    public byte[] WaterColor { get; init; } = [255, 255, 255, 255];
    public IReadOnlyList<W3iPlayerTemplate> Players { get; init; } = [];
    public IReadOnlyList<W3iForceTemplate> Forces { get; init; } = [];
}
