local Slk_Mapper = {

    --打包器会根据attr_key映射物编属性键，生成物编ini
    attr_key = {
        --虚拟属性名映射物编属性名
        ["名字"] = "Name",
        ["称谓"] = "Propernames",
        ["攻击类型"] = "atkType1",
        ["种族"] = "race",
        ["等级"] = "level",
        ["固定移速"] = "spd",
        ["主动攻击范围"] = "acquire",
        ["施法前摇"] = "castpt",
        ["施法后摇"] = "castbsw",
        ["攻击前摇"] = "backSw1",
        ["攻击后摇"] = "dmgpt1",
        ["攻击距离"] = "rangeN1",
        ["攻击间隔"] = "cool1",
        ["体魄"] = "STR",
        ["身法"] = "AGI",
        ["元神"] = "INT",
        ["攻击"] = "dmgplus1",
        ["主要属性"] = "Primary",
        ["体魄成长"] = "STRplus",
        ["身法成长"] = "AGIplus",
        ["元神成长"] = "INTplus",
        ["护甲"] = "def",
        ["生命"] = "HP",
        ["法力"] = "manaN",
        ["生命恢复"] = "regenHP",
        ["法力恢复"] = "regenMana",
        ["模型"] = "file",
        ["模型缩放"] = "modelScale",
        ["图标"] = "Art",
        ["投射物模型"] = "Missileart",
        ["武器声音"] = "weapType1",
        ["高度"] = "moveHeight",
        ["转身速度"] = "turnRate",
        ["动画-跑步速度"] = "run",
        ["动画-行走速度"] = "walk",
        ["动画-混合时间"] = "blend",
        ["移动类型"] = "movetp",
        ["碰撞体积"] = "collision",
        ["射弹弧度"] = "Missilearc",
        ["射弹速度"] = "Missilespeed",
        ["死亡类型"] = "deathType",
        ["死亡时间"] = "death",
        ["装甲类型"] = "armor",   
        ["目标允许"] = "targs1",
        ["作为目标类型"] = "tarType",
        ["小地图隐藏"] = "hideOnMinimap",
    },

    attr_value = {
        --打包器会根据attr_value映射物编属性值，生成物编ini
        --攻击类型
        ["物理"] = "normal",
        ["法术"] = "spells",
        ["真实"] = "chaos",
        --种族
        ["平民"] = "commoner",  --平民
        ["野外生物"] = "creeps",    --野外生物
        ["佛"] = "critters",  --动物
        ["魔"] = "demon",     --恶魔
        ["人"] = "human",     --人族
        ["蓝血人"] = "naga",    --娜迦
        ["神"] = "nightelf",  --暗夜
        ["妖"] = "orc",       --兽族
        ["仙"] = "other",     --其他
        ["鬼"] = "undead",    --不死族
        ["无"] = "unknown",   --无

        --武器声音
        ["金属中切"] = "MetalMediumSlice",
        ["斧头中砍"] = "AxeMediumChop",
        ["金属重击"] = "MetalHeavyBash",
        ["金属重砍"] = "MetalHeavyChop",
        ["金属重切"] = "MetalHeavySlice",
        ["金属轻砍"] = "MetalLightChop",
        ["金属轻切"] = "MetalLightSlice",
        ["金属中击"] = "MetalMediumBash",
        ["金属中砍"] = "metalMediumChop",
        ["岩石重击"] = "RockHeavyBash",
        ["木头重击"] = "WoodHeavyBash",
        ["木头轻击"] = "WoodLightBash",
        ["木头中击"] = "WoodMediumBash",
        --死亡类型
        ["无法召唤，不会腐化"] = 0,
        ["可召唤，不会腐化"] = 1,
        ["无法召唤，会腐化"] = 2,
        ["可召唤，会腐化"] = 3,
        --移动类型
        ["步行"] = "foot",
        ["骑马"] = "horse",
        ["飞行"] = "fly",
        ["浮空(陆)"] = "hover",
        ["漂浮(水)"] = "float",
        ["两栖"] = "amph",
        --装甲类型
        ["没有"] = "",
        ["金属"] = "Metal",
        ["木头"] = "Wood",
        ["气态"] = "Ethereal",
        ["肉体"] = "Flesh",
        ["石头"] = "Stone"
    },

    --默认值
    default = {

        --英雄
        hero = {
            --远程
            remote = {
                parent = "Hblm",           --基础模板，血魔法师    
                ["射弹弧度"] = 0.15,    --射弹弧度
                ["投射物模型"] = "Abilities\\Weapons\\PriestMissile\\PriestMissile.mdl",    --投射物模型
                ["射弹速度"] = 900,      --射弹速度
                ["攻击距离"] = "500",
            },
            --近战
            meele = {
                parent = "Hpal",        --基础模板，圣骑士
                ["攻击距离"] = "90",
            },

            common = {
                ["体魄"] = "10",
                ["身法"] = "10",
                ["元神"] = "10",
                ["主要属性"] = "体魄",
                ["体魄成长"] = "2.00",
                ["身法成长"] = "2.00",
                ["元神成长"] = "2.00",
            }
        },

        --单位
        unit = {
            --远程
            remote = {
                parent = "hmpr",            --基础模板，牧师
                ["射弹弧度"] = 0.15,     --射弹弧度
                ["投射物模型"] = "Abilities\\Weapons\\PriestMissile\\PriestMissile.mdl",    --投射物模型
                ["射弹速度"] = 900,       --射弹速度
                ["攻击距离"] = "500",
            },
            --近战
            meele = {
                parent = "hfoo",        --基础模板，步兵
                ["攻击距离"] = "90",
            }
        },

        common = {
            ["碰撞体积"] = 32.00,
            ["动画-跑步速度"] = 250.00,
            ["动画-行走速度"] = 250.00,
            ["混合时间"] = 0.15,
            ["移动类型"] = "步行",
            ["高度"] = 0.00,
            ["固定移速"] = 270.00,
            ["转身速度"] = 0.60,
            ["装甲类型"] = "肉体",
            ["作为目标类型"] = "地面",
            ["移动速度"] = 100.00,
            ["攻击速度"] = 100.00,
            ["物理暴击伤害"] = 200.00,
            ["法术暴击伤害"] = 200.00,
            ["攻击类型"] = "物理",
            ["种族"] = "人族",
            ["等级"] = 1,
            ["施法前摇"] = 0.300,
            ["施法后摇"] = 0.510,
            ["攻击前摇"] = 0.500,
            ["攻击后摇"] = 0.500,
            ["攻击间隔"] = 1.35,
            ["攻击"] = 10.0,
            ["护甲"] = 2.0,
            ["生命"] = 500.0,
            ["法力"] = 100.0,
            ["生命恢复"] = 0.25,
            ["法力恢复"] = 0.10,
            ["模型缩放"] = 1.00,
            ["动画-混合时间"] = 0.15,
            ["主动攻击范围"] = 500.00,
            ["小地图隐藏"] = 1,
            ["死亡时间"] = 3.00,
            ["武器声音"] = "金属中切",
            ["目标允许"] = "ground,enemies,air",
            ["死亡类型"] = 3,
            ["射弹弧度"] = 0.15,
            ["射弹速度"] = 900,
        }
    }
}
--[[
Packer会将所有目标文件夹下的lua文件合并生成一个总的UnitTypeInit.lua文件，目标xlsx文件中的数据以及default里的数据都会被补充到各自的unitType函数定义中，attr_key中的键要额外生成ini
1.default作为默认值
2.default.hero作为英雄默认值
3.default.unit作为单位默认值
4.default.common作为通用默认值
5.default.hero.remote作为英雄远程默认值
6.default.hero.meele作为英雄近战默认值
7.default.hero.common作为英雄通用默认值
8.default.unit.remote作为单位远程默认值
9.default.unit.meele作为单位近战默认值
10.default.unit.common作为单位通用默认值
11.生成ini时，default里的key也要被attr_key映射，default里的value也要被attr_value映射
12.根据单位ID首字母是否大写，决定default.hero还是default.unit，以及分配parent
--]]

-- 当前 Packer 行为请以 `.tools/Packer/README.md`、`.tools/Packer/USAGE.md` 和 `.tools/Packer/RULES.md` 为准。
return Slk_Mapper
