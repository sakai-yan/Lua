namespace MapRepair.Core.Internal;

internal sealed class W3iIniTemplateLoader
{
    public W3iTemplate Load(DecodedTextFile source)
    {
        var ini = SimpleIniDocument.Parse(source.Text);
        var players = new List<W3iPlayerTemplate>();
        var forces = new List<W3iForceTemplate>();

        var playerCount = GetRequiredInt(ini, "玩家", "玩家数量");
        for (var index = 1; index <= playerCount; index++)
        {
            var sectionName = $"玩家{index}";
            players.Add(new W3iPlayerTemplate(
                GetRequiredInt(ini, sectionName, "玩家"),
                GetRequiredInt(ini, sectionName, "类型"),
                GetRequiredInt(ini, sectionName, "种族"),
                GetRequiredInt(ini, sectionName, "修正出生点"),
                GetRequiredString(ini, sectionName, "名字"),
                LiteralValueParser.ParseFloatArray(GetRequiredRaw(ini, sectionName, "出生点"))[0],
                LiteralValueParser.ParseFloatArray(GetRequiredRaw(ini, sectionName, "出生点"))[1],
                LiteralValueParser.BuildPlayerMask(LiteralValueParser.ParseIntArray(GetRequiredRaw(ini, sectionName, "低结盟优先权标记"))),
                LiteralValueParser.BuildPlayerMask(LiteralValueParser.ParseIntArray(GetRequiredRaw(ini, sectionName, "高结盟优先权标记")))));
        }

        var forceCount = GetRequiredInt(ini, "队伍", "队伍数量");
        for (var index = 1; index <= forceCount; index++)
        {
            var sectionName = $"队伍{index}";
            forces.Add(new W3iForceTemplate(
                GetRequiredInt(ini, sectionName, "结盟") != 0,
                GetRequiredInt(ini, sectionName, "结盟胜利") != 0,
                GetRequiredInt(ini, sectionName, "共享视野") != 0,
                GetRequiredInt(ini, sectionName, "共享单位控制") != 0,
                GetRequiredInt(ini, sectionName, "共享高级单位设置") != 0,
                LiteralValueParser.BuildPlayerMask(LiteralValueParser.ParseIntArray(GetRequiredRaw(ini, sectionName, "玩家列表"))),
                GetRequiredString(ini, sectionName, "队伍名称")));
        }

        return new W3iTemplate
        {
            FileVersion = GetRequiredInt(ini, "地图", "文件版本"),
            MapVersion = GetRequiredInt(ini, "地图", "地图版本"),
            EditorVersion = GetRequiredInt(ini, "地图", "编辑器版本"),
            MapName = GetRequiredString(ini, "地图", "地图名称"),
            AuthorName = GetRequiredString(ini, "地图", "作者名字"),
            MapDescription = GetRequiredString(ini, "地图", "地图描述"),
            RecommendedPlayers = GetRequiredString(ini, "地图", "推荐玩家"),
            CameraBoundsComplements = LiteralValueParser.ParseIntArray(GetRequiredRaw(ini, "镜头", "镜头范围扩充")),
            MainGroundTileset = GetRequiredString(ini, "地形", "地形类型").FirstOrDefault('L'),
            DisablePreview = GetRequiredInt(ini, "选项", "关闭预览图") != 0,
            CustomAllyPriority = GetRequiredInt(ini, "选项", "自定义结盟优先权") != 0,
            MeleeMap = GetRequiredInt(ini, "选项", "对战地图") != 0,
            MaskedAreaShowTerrain = GetRequiredInt(ini, "选项", "迷雾区域显示地形") != 0,
            CustomForce = GetRequiredInt(ini, "选项", "自定义队伍") != 0,
            CustomTechTree = GetRequiredInt(ini, "选项", "自定义科技树") != 0,
            CustomAbility = GetRequiredInt(ini, "选项", "自定义技能") != 0,
            CustomUpgrade = GetRequiredInt(ini, "选项", "自定义升级") != 0,
            ShowWaveOnCliff = GetRequiredInt(ini, "选项", "地形悬崖显示水波") != 0,
            ShowWaveOnRolling = GetRequiredInt(ini, "选项", "地形起伏显示水波") != 0,
            LoadingScreenIndex = GetRequiredInt(ini, "载入图", "序号"),
            LoadingScreenPath = GetRequiredString(ini, "载入图", "路径"),
            LoadingScreenText = GetRequiredString(ini, "载入图", "文本"),
            LoadingScreenTitle = GetRequiredString(ini, "载入图", "标题"),
            LoadingScreenSubtitle = GetRequiredString(ini, "载入图", "子标题"),
            ProloguePath = GetRequiredString(ini, "战役", "路径"),
            PrologueText = GetRequiredString(ini, "战役", "文本"),
            PrologueTitle = GetRequiredString(ini, "战役", "标题"),
            PrologueSubtitle = GetRequiredString(ini, "战役", "子标题"),
            FogType = GetRequiredInt(ini, "迷雾", "类型"),
            FogStartZ = GetRequiredFloat(ini, "迷雾", "z轴起点"),
            FogEndZ = GetRequiredFloat(ini, "迷雾", "z轴终点"),
            FogDensity = GetRequiredFloat(ini, "迷雾", "密度"),
            FogColor = LiteralValueParser.ParseByteArray(GetRequiredRaw(ini, "迷雾", "颜色")),
            WeatherId = GetRequiredString(ini, "环境", "天气"),
            SoundEnvironment = GetRequiredString(ini, "环境", "音效"),
            LightEnvironment = GetRequiredString(ini, "环境", "光照").FirstOrDefault('\0'),
            WaterColor = LiteralValueParser.ParseByteArray(GetRequiredRaw(ini, "环境", "水面颜色")),
            Players = players,
            Forces = forces
        };
    }

    private static int GetRequiredInt(SimpleIniDocument ini, string section, string key) =>
        LiteralValueParser.ParseInt(GetRequiredRaw(ini, section, key));

    private static float GetRequiredFloat(SimpleIniDocument ini, string section, string key) =>
        LiteralValueParser.ParseFloat(GetRequiredRaw(ini, section, key));

    private static string GetRequiredString(SimpleIniDocument ini, string section, string key) =>
        LiteralValueParser.ParseQuotedString(GetRequiredRaw(ini, section, key));

    private static string GetRequiredRaw(SimpleIniDocument ini, string section, string key)
    {
        if (!ini.TryGetValue(section, key, out var value))
        {
            throw new InvalidDataException($"w3i.ini 缺少字段 [{section}] {key}");
        }

        return value;
    }
}
