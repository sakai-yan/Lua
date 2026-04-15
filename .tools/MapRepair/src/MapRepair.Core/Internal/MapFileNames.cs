namespace MapRepair.Core.Internal;

internal static class MapFileNames
{
    public const string ListFile = "(listfile)";
    public const string MapInfo = "war3map.w3i";
    public const string Terrain = "war3map.w3e";
    public const string Pathing = "war3map.wpm";
    public const string Doodads = "war3map.doo";
    public const string Units = "war3mapUnits.doo";
    public const string TriggerData = "war3map.wtg";
    public const string TriggerStrings = "war3map.wct";
    public const string ScriptJ = "war3map.j";
    public const string ScriptLua = "war3map.lua";
    public const string Strings = "war3map.wts";
    public const string Imports = "war3map.imp";
    public const string Shadows = "war3map.shd";
    public const string Regions = "war3map.w3r";
    public const string Cameras = "war3map.w3c";
    public const string Sounds = "war3map.w3s";
    public const string UiConfig = @"ui\config";
    public const string UiTriggerData = @"ui\TriggerData.txt";
    public const string UiTriggerStrings = @"ui\TriggerStrings.txt";

    public static readonly IReadOnlyList<string> StandardEntries =
    [
        ListFile,
        MapInfo,
        Terrain,
        Pathing,
        Doodads,
        Units,
        TriggerData,
        TriggerStrings,
        ScriptJ,
        ScriptLua,
        Strings,
        Imports,
        Shadows,
        Regions,
        Cameras,
        Sounds,
        UiConfig,
        UiTriggerData,
        UiTriggerStrings,
        "war3map.mmp",
        "war3map.w3r",
        "war3map.w3c",
        "war3map.w3u",
        "war3map.w3t",
        "war3map.w3a",
        "war3map.w3b",
        "war3map.w3d",
        "war3map.w3h",
        "war3map.w3q",
        "war3map.w3o",
        "war3mapMap.blp",
        "war3mapMisc.txt",
        "war3mapSkin.txt",
        "war3mapExtra.txt"
    ];

    public static readonly IReadOnlyList<string> RecoverableEntries =
    [
        MapInfo,
        Terrain,
        Pathing,
        Doodads,
        Units,
        TriggerData,
        TriggerStrings
    ];

    public static readonly IReadOnlyList<string> ObjectDataEntries =
    [
        "war3map.w3u",
        "war3map.w3t",
        "war3map.w3a",
        "war3map.w3b",
        "war3map.w3d",
        "war3map.w3h",
        "war3map.w3q"
    ];
}
