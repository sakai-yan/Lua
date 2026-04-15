local Unit = require "Core.Entity.Unit"
local csv = require("Config.UnitType.Csv")
local Attr = require "FrameWork.GameSetting.Attribute"
local Tool = require "Lib.API.Tool"
local Class = require "Lib.Base.Class"


--单位属性名映射，中文→物编
local attr_mapper
if __DEBUG__ then
    attr_mapper = {
        --虚拟属性名映射物编属性名
        ["名字"] = "Name",
        ["称谓"] = "Propernames",
        ["攻击类型"] = "atkType1",
        ["种族"] = "race",
        ["等级"] = "level",
        ["模型"] = "file",
        ["图标"] = "Art",
        ["模型缩放"] = "modelScale",
        ["碰撞体积"] = "collision",
        ["移动类型"] = "movetp",
        ["固定移速"] = "spd",
        ["转身速度"] = "turnRate",
        ["高度"] = "moveHeight",
        ["动画-跑步速度"] = "run",
        ["动画-行走速度"] = "walk",
        ["动画-混合时间"] = "blend",
        ["主动攻击范围"] = "acquire",
        ["小地图隐藏"] = "hideOnMinimap",
        ["死亡时间"] = "death",
        ["装甲类型"] = "armor",
        ["武器声音"] = "weapType1",
        ["目标允许"] = "targs1",
        ["作为目标类型"] = "tarType",
        ["投射物模型"] = "Missileart",
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
        ["死亡类型"] = "deathType",
        ["射弹弧度"] = "Missilearc",
        ["射弹速度"] = "Missilespeed",

        
        --将中文属性映射为物编英文属性
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
        
    }
end

local function OverWrite()
    local mapper        --物编属性映射表
    local common_fields --公共属性，所有单位都一样
    local slk_file
    local able = __DEBUG__
    local Tab_local_Code
    local Tab_set_Code
    local Tab_str_Code
    local exceptList_common --规避清单：生成物编时，不读取这些键
    if able then
        mapper = attr_mapper or error("Unit.Config.OverWrite:attr_mapper未定义")
        --专门用于连接local row = xx
        --第一个nil是行数，第二个是基础模板，第三个是单位类型ID字符串
        Tab_local_Code = {"local row", nil, " = slk.unit.", nil, ":new \'", nil, "\'\n"}
        --用于连接赋值语句
        --第一个nil是行数，第二个是物编键名，第三个是物编值（表格值）
        Tab_set_Code = {"row", nil, ".", nil, " = ", nil, "\n"}
        --用于将应为字符串格式的value包装成字符串，nil为value
        Tab_str_Code = {"\"", nil, "\""}
        --共同字段数据表
        common_fields = {"defType","goldcost", "lumbercost", "fused", "canFlee", "canSleep"}
        common_fields.defType = "hero"
        common_fields.goldcost = "0"
        common_fields.lumbercost = "0"
        common_fields.fused = "0"
        common_fields.canFlee = "false"
        common_fields.canSleep = "false"
        common_fields.targs1 = "ground, structure, debris, air, item, ward"
        --设置规避清单
        exceptList_common = {        
            STR = true,
            AGI = true,
            INT = true,
            STRplus = true,
            AGIplus = true,
            INTplus = true
        }
        --近战普通单位规避清单
        Unit.__unit_meele.exceptList = setmetatable({
            Missilearc = true,
            Missileart = true,
            Missilespeed = true
        }, exceptList_common)
        --近战英雄单位规避清单
        Unit.__hero_meele.exceptList = {
            Missilearc = true,
            Missileart = true,
            Missilespeed = true
        }
        --远程普通单位规避清单
        Unit.__unit_remote.exceptList = exceptList_common
        --创建物编
        local err
        slk_file, err = io.open("MFLua\\SLKimport.j", "w")
        if not slk_file then
            error("文件打开失败: ".. err)
        end
        --开始生成lua代码段
        slk_file:write("<?\n")
        -- 写入文件头部注释
        slk_file:write("-- 自动生成的Lua文件\n")
        slk_file:write("-- 来源CSV文件: " .. "Unit.Data.csv" .. "\n")
        slk_file:write("-- 生成时间: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
        slk_file:write("local slk = require \'slk\'\n\n")
    end

    local Unit = Class.get("Unit") or error("Unit.Config:Unit类未生成")
    local IDGenerator = require("GameSettings.IDGenerator")
    local Hero_Remote_IdGenerator = IDGenerator.create("H", "R")        --远程英雄ID生成器
    local Hero_Meele_IdGenerator = IDGenerator.create("H", "M")         --近战英雄ID生成器
    local Unit_Remote_IdGenerator = IDGenerator.create("U", "R")        --远程单位ID生成器
    local Unit_Meele_IdGenerator = IDGenerator.create("U", "M")         --近战单位ID生成器
    local unit_config_constructor

    --开始遍历每一行
    ---@param line_num integer 行号
    ---@param headers string[] 表头
    ---@param row table 行数据
    for line_num, headers, row in csv:rows("Data.csv") do
        if not row or not row["名字"] or row["名字"] == "" then
            print("OverWrite:", "row[名字]为空", row and row["名字"] or "nil")
            print("OverWrite:", "row", row)
            print("OverWrite:", "headers", headers)
            print("OverWrite:", "line_num", line_num)
            goto next_row
        end
        local template, unitId
        --只执行一次的，生成UnitType的config构造器函数，用于生成UnitType实例
        if not unit_config_constructor then
            local constructor_codestr = {"return {name = false, \n"}
            local instance_attribute_list = {}
            local table_insert = table.insert
            for key, _ in pairs(Unit.__setattr__) do
                instance_attribute_list[key] = true
            end
            for key, _ in pairs(Unit.__getattr__) do
                instance_attribute_list[key] = true
            end
            for index = 1, #headers do
                local key_name = headers[index]
                if key_name and key_name ~= "" then
                    --不属于属性名的，就初始化为false
                    if not instance_attribute_list[key_name] then
                        table_insert(constructor_codestr, key_name .. " = false, \n")
                    end
                end
            end
            table_insert(constructor_codestr, "__unit_type_id = false}")
            unit_config_constructor = load(table.concat(constructor_codestr)) or error("Unit.Config:生成器代码加载失败")
        end

        if row["英雄"] then
            if row["远程"] then
                unitId = Hero_Remote_IdGenerator() or error("Hero_Remote_IdGenerator:生成器已耗尽")
                template = Unit.__hero_remote
            else
                unitId = Hero_Meele_IdGenerator() or error("Hero_Meele_IdGenerator:生成器已耗尽")
                template = Unit.__hero_meele
            end
        else
            if row["远程"] then
                unitId = Unit_Remote_IdGenerator() or error("Unit_Remote_IdGenerator:生成器已耗尽")
                template = Unit.__unit_remote
            else
                unitId = Unit_Meele_IdGenerator() or error("Unit_Meele_IdGenerator:生成器已耗尽")
                template = Unit.__unit_meele
            end
        end
        
        local unit_type = Unit.unitType(row["名字"], unit_config_constructor())

        unit_type.__unit_type_id = unitId
        
        if not able then goto next_field_normal end
        do  --读取每一行数据，存入unit_type，并生成物编
            local exceptList = template.exceptList
            local baseId = template.baseId
            --写入local新建单位类型
            Tab_local_Code[2] = line_num
            Tab_local_Code[4] = baseId
            Tab_local_Code[6] = Tool.Id2S(unitId)
            slk_file:write(table.concat(Tab_local_Code))
            --先生成公共字段
            for index, key in ipairs(common_fields) do
                -- 处理值的格式（字符串需要引号，数字不需要）
                local value = common_fields[key]
                if not tonumber(value) then
                    -- 转义字符串中的特殊字符
                    value = value:gsub('"', '\\"')
                    value = value:gsub("'", "\\'")
                    Tab_str_Code[2] = value
                    value = table.concat(Tab_str_Code)
                end
                Tab_set_Code[2] = line_num
                Tab_set_Code[4] = key
                Tab_set_Code[6] = value
                slk_file:write(table.concat(Tab_set_Code))
                --slk_file:write("\n")
            end
            --读取每一列数据，存入unit_type，并生成物编
            for index = 1, #row do
                local value = row[index]
                local key = headers[index]
                --若表格中不存在值，则读取默认值
                if value == "" then
                    value = template[key]    --有可能把""变成nil
                end
                if not value or value == "" then goto next_field_one end     --空单元格会被解析为空字符串，而不是nil
                local base_key = Attr.getBaseName(key)
                --base_key存在则表明为属性字段，否则为普通字段
                if base_key then
                    unit_type[base_key] = value
                else
                    unit_type[key] = value
                end
            
                --若该键不在规避清单中且存在映射，则需要生成物编    
                if (not exceptList or not exceptList[key]) and mapper[key] then 
                    local real_key = mapper[key]
                    --若value需转换为物编值
                    local real_value = mapper[value] or value
                    -- 处理值的格式（字符串需要引号，数字不需要）
                    if not tonumber(real_value) then
                        -- 转义字符串中的特殊字符
                        real_value = real_value:gsub("\\", "\\\\")
                        real_value = real_value:gsub('"', '\\"')
                        real_value = real_value:gsub("'", "\\'")
                        
                        Tab_str_Code[2] = real_value
                        real_value = table.concat(Tab_str_Code)
                    end
                    Tab_set_Code[2] = line_num
                    Tab_set_Code[4] = real_key
                    Tab_set_Code[6] = real_value
                    slk_file:write(table.concat(Tab_set_Code))
                end
                ::next_field_one::
            end
            slk_file:write("\n\n")
        end
        ::next_field_normal::
        --读取每一行数据，存入unit_type，不生成物编
        for index = 1, #row do
            local value = row[index]
            local key = headers[index]
            --若表格中不存在值，则读取默认值
            if value == "" then
                value = template[key]
            end
            if not value or value == "" then goto next_field_two end       --空单元格会被解析为空字符串，而不是nil
            if Attr.isAttr(key) then    --若是属性名，则存入基础属性
                local base_key = Attr.getBaseName(key) or error("Unit.Config:获取基础属性名失败")
                unit_type[base_key] = value
            else
                unit_type[key] = value
            end
            ::next_field_two::
        end
        ::next_row::
    end
    --读取每一行的循环结束

    if able then
        --结束lua代码段
        slk_file:write("?>\n")
        slk_file:close()
    end

    
end
OverWrite()
