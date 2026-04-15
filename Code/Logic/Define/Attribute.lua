--============================================================
-- 单位属性定义
-- 设计模式：两阶段配置
-- 1. 第一阶段：定义所有属性，获取配置对象
-- 2. 第二阶段：配置 reward，使用配置对象作为 key（避免硬编码）
--============================================================


local Jass = require "Lib.API.Jass"
local Tool = require "Lib.API.Tool"
local Constant = require "Lib.API.Constant"
local Class = require"Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Event= require "FrameWork.Manager.Event"
local Attr = require "FrameWork.GameSetting.Attribute"
local Unit = require "Core.Entity.Unit"
local Item = require "Core.Entity.Item"

local math_floor = math.floor
local rawget = rawget
local rawset = rawset

--单位类，功能函数对外接口
local DataType_get = DataType.get
local attr_change_event = Attr.change_event
local Event_new = Event.new

-- 缓存 Class.get 函数
local Class_get = Class.get


--============================================================
-- 属性技能 ID 缓存
--============================================================

local ATTR_ABILITY_ATK = Tool.S2Id("ASG1")
local ATTR_ABILITY_ARMOR = Tool.S2Id("ASG2")
local ATTR_ABILITY_STR = Tool.S2Id("ASG3")
local ATTR_ABILITY_AGI = Tool.S2Id("ASG4")
local ATTR_ABILITY_INT = Tool.S2Id("ASG5")
local ATTR_ABILITY_MOVE_SPEED = Tool.S2Id("ASG6")
local ATTR_ABILITY_ATK_SPEED = Tool.S2Id("ASG7")

--============================================================
-- 初始化函数
--============================================================
local GetUnitAbilityLevel = Jass.GetUnitAbilityLevel
local MHUnit_AddAbility = Jass.MHUnit_AddAbility
local UnitMakeAbilityPermanent = Jass.UnitMakeAbilityPermanent

function Unit.attributeInit(unit)
    if __DEBUG__ then
        assert(DataType.get(unit) == "unit", "Unit.attributeInit: 尝试对非单位进行初始化")
    end
    local unit_handle = unit.handle
    if Tool.isHandleType(unit_handle, "unit") and GetUnitAbilityLevel(unit_handle, ATTR_ABILITY_ATK) == 0 then
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_ATK, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_ATK)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_ARMOR, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_ARMOR)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_STR, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_STR)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_AGI, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_AGI)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_INT, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_INT)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_MOVE_SPEED, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_MOVE_SPEED)
        MHUnit_AddAbility(unit_handle, ATTR_ABILITY_ATK_SPEED, false)
        UnitMakeAbilityPermanent(unit_handle, true, ATTR_ABILITY_ATK_SPEED)
    end
end

---设置单位属性（完整流程：监听 → setter → reward）
---@param unit table 单位对象
---@param real_Attr_name string 真实属性名（__base_xxx 或 __bonus_xxx，可用Attr.getBaseName或Attr.getBonusName获取）
---@param value number 属性值
---@param mode string "add"|"set"，默认 "set"
function Unit.setAttr(unit, real_Attr_name, value, mode)
    if __DEBUG__ then
        assert(type(real_Attr_name) == "string", "Unit.setAttr: 属性名必须为字符串")
        assert(type(value) == "number", "Unit.setAttr: 属性值必须为数值")
        assert(DataType_get(unit) == "unit", "Unit.setAttr: 单位错误")
    end

    -- 获取旧值
    local old_val = unit[real_Attr_name] or 0.00
    
    -- 计算新值和差值
    local new_val, delta
    if mode == "add" then
        delta = value
        new_val = old_val + delta
    else
        new_val = value
        delta = new_val - old_val
    end
    
    -- 无变化则直接返回
    if delta == 0.00 then
        return
    end
    
    -- 触发监听事件
    local attr_change_event_instance = Event_new(attr_change_event, real_Attr_name, old_val, new_val, unit, delta)
    local is_sucess = attr_change_event_instance:emit()
    if not is_sucess then return false end

    -- 执行 setter（通过赋值触发 __setattr__）
    unit[real_Attr_name] = new_val
    
    -- 执行 reward（直接用真实属性名查找）
    local handler = Attr.__reward[real_Attr_name]
    if handler then
        handler(attr_change_event_instance)
    end

    return true
end

--设置单位属性
function Item.setAttr(item, real_Attr_name, value, mode)
    if __DEBUG__ then
        assert(type(real_Attr_name) == "string", "Item.setAttr: 属性名必须为字符串")
        assert(type(value) == "number", "Item.setAttr: 属性值必须为数值")
        assert(DataType_get(item) == "item", "Item.setAttr: 物品错误")
    end

    local old_val = item[real_Attr_name] or 0.00
    
    local new_val, delta
    if mode == "add" then
        delta = value
        new_val = old_val + delta
    else
        new_val = value
        delta = new_val - old_val
    end
    
    if delta == 0.00 then
        return
    end

    -- 触发监听事件
    local attr_change_event_instance = Event_new(attr_change_event, real_Attr_name, old_val, new_val, item, delta)
    local is_sucess = attr_change_event_instance:emit()
    if not is_sucess then return false end
    
    item[real_Attr_name] = new_val
    
    --item不执行属性变更的reward
    return true
end

local setAttr = Unit.setAttr
--============================================================

--定义一个需初始化赋值的属性
--@param Attr_name string 属性名
--@param template table 属性模板
--@return table 属性配置对象
local config_define = function (Attr_name, template)
    local config = Attr.define(Attr_name, template)
    table.insert(Unit.__need_init_attr, config)
    return config
end

--模拟属性的通用setter
local _common_setter = function(unit, real_Attr_name, newVal)
    rawset(unit, real_Attr_name, newVal)
end

-- 模拟属性工厂
local function defineSimulatedAttr(Attr_name)
    local base_name = "__base_" .. Attr_name
    local bonus_name = "__bonus_" .. Attr_name
    return config_define(Attr_name, {
        base_setattr = _common_setter,
        bonus_setattr = _common_setter,
        total_getattr = function(unit, name)
            return (rawget(unit, base_name) or 0.00) + (rawget(unit, bonus_name) or 0.00)
        end
    })
end

-- 动态属性工厂
local function defineDynamicAttr(Attr_name, targetConfig, getBaseValue)
    local base_name = "__base_" .. Attr_name
    local bonus_name = "__bonus_" .. Attr_name
    
    local function setter(unit, real_Attr_name, newVal)
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local baseValue = getBaseValue(unit)
        rawset(unit, real_Attr_name, newVal)
        if baseValue ~= 0.00 then
            setAttr(unit, targetConfig.bonus_name, baseValue * (newVal - oldVal) / 100.00, "add")
        end
    end
    
    return config_define(Attr_name, {
        base_setattr = setter,
        bonus_setattr = setter,
        total_getattr = function(unit, name)
            return (rawget(unit, base_name) or 0.00) + (rawget(unit, bonus_name) or 0.00)
        end
    })
end

if __DEBUG__ then
    print("=== 属性定义：第一阶段开始 ===")
end

--============================================================
--                    第一阶段：定义所有属性
--============================================================



-- 攻击
local atk_config = config_define("攻击", {
    base_setattr = function(unit, real_Attr_name, newVal)
        Jass.MHUnit_SetAtkDataInt(unit.handle, Constant.UNIT_ATK_DATA_BASE_DAMAGE1, math_floor(newVal))
    end,
    base_getattr = function(unit, real_Attr_name)
        return Jass.MHUnit_GetAtkDataInt(unit.handle, Constant.UNIT_ATK_DATA_BASE_DAMAGE1)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local abilcode = ATTR_ABILITY_ATK
        Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A, newVal)
        Jass.IncUnitAbilityLevel(unit.handle, abilcode)
        Jass.DecUnitAbilityLevel(unit.handle, abilcode)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        return Jass.MHAbility_GetCustomLevelDataReal(unit.handle, ATTR_ABILITY_ATK, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A)
    end
})

-- 体魄
local str_config = config_define("体魄", {
    base_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            Jass.SetHeroStr(unit.handle, math_floor(newVal), true)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    base_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroStr(unit.handle, false)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            local abilcode = ATTR_ABILITY_STR
            Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_C, newVal)
            Jass.IncUnitAbilityLevel(unit.handle, abilcode)
            Jass.DecUnitAbilityLevel(unit.handle, abilcode)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    bonus_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_STR, Constant.ABILITY_LEVEL_DEF_DATA_DATA_C)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    total_getattr = function(unit, Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroStr(unit.handle, true)
        end
        local config = Attr.getAttrConfig(Attr_name)
        return (rawget(unit, config.base_name) or 0.00) + (rawget(unit, config.bonus_name) or 0.00)
    end
})

-- 法理
local agi_config = config_define("法理", {
    base_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            Jass.SetHeroAgi(unit.handle, math_floor(newVal), true)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    base_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroAgi(unit.handle, false)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            local abilcode = ATTR_ABILITY_AGI
            Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A, newVal)
            Jass.IncUnitAbilityLevel(unit.handle, abilcode)
            Jass.DecUnitAbilityLevel(unit.handle, abilcode)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    bonus_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_AGI, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    total_getattr = function(unit, Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroAgi(unit.handle, true)
        end
        local config = Attr.getAttrConfig(Attr_name)
        return (rawget(unit, config.base_name) or 0.00) + (rawget(unit, config.bonus_name) or 0.00)
    end
})

-- 元神
local int_config = config_define("元神", {
    base_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            Jass.SetHeroInt(unit.handle, math_floor(newVal), true)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    base_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroInt(unit.handle, false)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        if unit["英雄"] then
            local abilcode = ATTR_ABILITY_INT
            Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_B, newVal)
            Jass.IncUnitAbilityLevel(unit.handle, abilcode)
            Jass.DecUnitAbilityLevel(unit.handle, abilcode)
        else
            rawset(unit, real_Attr_name, math_floor(newVal))
        end
    end,
    bonus_getattr = function(unit, real_Attr_name)
        if unit["英雄"] then
            return Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_INT, Constant.ABILITY_LEVEL_DEF_DATA_DATA_B)
        end
        return rawget(unit, real_Attr_name) or 0.00
    end,
    total_getattr = function(unit, Attr_name)
        if unit["英雄"] then
            return Jass.GetHeroInt(unit.handle, true)
        end
        local config = Attr.getAttrConfig(Attr_name)
        return (rawget(unit, config.base_name) or 0.00) + (rawget(unit, config.bonus_name) or 0.00)
    end
})

-- 生命
local life_config = config_define("生命", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local hpmax = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MAX_LIFE)
        local hpnew = hpmax - oldVal + newVal
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MAX_LIFE, hpnew)
        if Tool.UnitAlive(unit_handle) then
            local current_hp = Jass.GetUnitState(unit_handle, Constant.UNIT_STATE_LIFE)
            Jass.SetUnitState(unit_handle, Constant.UNIT_STATE_LIFE, hpnew * (current_hp / hpmax))
        end
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local hpmax = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MAX_LIFE)
        local hpnew = hpmax - oldVal + newVal
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MAX_LIFE, hpnew)
        if Tool.UnitAlive(unit_handle) then
            local current_hp = Jass.GetUnitState(unit_handle, Constant.UNIT_STATE_LIFE)
            Jass.SetUnitState(unit_handle, Constant.UNIT_STATE_LIFE, hpnew * (current_hp / hpmax))
        end
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MAX_LIFE) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MAX_LIFE)
    end
})

-- 法力
local mana_config = config_define("法力", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local mpmax = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MAX_MANA)
        local mpnew = mpmax - oldVal + newVal
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MAX_MANA, mpnew)
        if Tool.UnitAlive(unit_handle) then
            local p = mpmax ~= 0.00 and (Jass.GetUnitState(unit_handle, Constant.UNIT_STATE_MANA) / mpmax) or 1.00
            Jass.SetUnitState(unit_handle, Constant.UNIT_STATE_MANA, mpnew * p)
        end
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local mpmax = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MAX_MANA)
        local mpnew = mpmax - oldVal + newVal
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MAX_MANA, mpnew)
        if Tool.UnitAlive(unit_handle) then
            local p = mpmax ~= 0.00 and (Jass.GetUnitState(unit_handle, Constant.UNIT_STATE_MANA) / mpmax) or 1.00
            Jass.SetUnitState(unit_handle, Constant.UNIT_STATE_MANA, mpnew * p)
        end
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MAX_MANA) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MAX_MANA)
    end
})

-- 生命恢复
local life_regen_config = config_define("生命恢复", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_LIFE_REGEN)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_LIFE_REGEN, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_LIFE_REGEN)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_LIFE_REGEN, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_LIFE_REGEN) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_LIFE_REGEN)
    end
})

-- 法力恢复
local mana_regen_config = config_define("法力恢复", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MANA_REGEN)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MANA_REGEN, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_MANA_REGEN)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_MANA_REGEN, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MANA_REGEN) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_MANA_REGEN)
    end
})

-- 护甲
local armor_config = config_define("护甲", {
    base_setattr = function(unit, real_Attr_name, newVal)
        Jass.MHUnit_SetData(unit.handle, Constant.UNIT_DATA_DEF_VALUE, newVal)
    end,
    base_getattr = function(unit, real_Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_DEF_VALUE)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local abilcode = ATTR_ABILITY_ARMOR
        Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A, newVal)
        Jass.IncUnitAbilityLevel(unit.handle, abilcode)
        Jass.DecUnitAbilityLevel(unit.handle, abilcode)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        return Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_ARMOR, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A)
    end
})

-- 攻击距离
local atk_range_config = config_define("攻击距离", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1)
        Jass.MHUnit_SetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1)
        Jass.MHUnit_SetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetAtkDataReal(unit.handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetAtkDataReal(unit.handle, Constant.UNIT_ATK_DATA_ATTACK_RANGE1)
    end
})

-- 攻击间隔
local atk_interval_config = config_define("攻击间隔", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_BAT1)
        Jass.MHUnit_SetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_BAT1, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_BAT1)
        Jass.MHUnit_SetAtkDataReal(unit_handle, Constant.UNIT_ATK_DATA_BAT1, current - oldVal + newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return Jass.MHUnit_GetAtkDataReal(unit.handle, Constant.UNIT_ATK_DATA_BAT1) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetAtkDataReal(unit.handle, Constant.UNIT_ATK_DATA_BAT1)
    end
})

-- 固定移速
local fixed_move_speed_config = config_define("固定移速", {
    base_setattr = function(unit, real_Attr_name, newVal)
        Jass.SetUnitMoveSpeed(unit.handle, newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local abilcode = ATTR_ABILITY_MOVE_SPEED
        Jass.MHAbility_SetCustomLevelDataReal(unit.handle, abilcode, 1, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A, newVal)
        Jass.IncUnitAbilityLevel(unit.handle, abilcode)
        Jass.DecUnitAbilityLevel(unit.handle, abilcode)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        return Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_MOVE_SPEED, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A)
    end,
    total_getattr = function(unit, Attr_name)
        local config = Attr.getAttrConfig(Attr_name)
        return (rawget(unit, config.base_name) or 0.00) + Jass.MHAbility_GetCustomDataInt(unit.handle, ATTR_ABILITY_MOVE_SPEED, Constant.ABILITY_LEVEL_DEF_DATA_DATA_A)
    end
})

-- 移动速度
local move_speed_config = config_define("移动速度", {
    base_setattr = function(unit, real_Attr_name, newVal)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_DATA_BONUS_MOVESPEED)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_DATA_BONUS_MOVESPEED, current + (newVal - oldVal) / 100.00)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        return (Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_BONUS_MOVESPEED) * 100.00) - 100.00
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_BONUS_MOVESPEED) * 100.00
    end
})

-- 攻击速度
local atk_speed_config = config_define("攻击速度", {
    base_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED, current + (newVal - oldVal) / 100.00)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_setattr = function(unit, real_Attr_name, newVal)
        local unit_handle = unit.handle
        local oldVal = rawget(unit, real_Attr_name) or 0.00
        local current = Jass.MHUnit_GetData(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED)
        Jass.MHUnit_SetData(unit_handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED, current + (newVal - oldVal) / 100.00)
        rawset(unit, real_Attr_name, newVal)
    end,
    bonus_getattr = function(unit, real_Attr_name)
        local config = Attr.getAttrConfig(real_Attr_name)
        return (Jass.MHUnit_GetData(unit.handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED) * 100.00) - (rawget(unit, config.base_name) or 0.00)
    end,
    total_getattr = function(unit, Attr_name)
        return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_ATK_DATA_ATTACK_SPEED) * 100.00
    end
})

-- 模拟属性
local magic_resist_config = defineSimulatedAttr("法术抗性")
local dodge_speed_config = defineSimulatedAttr("遁法速度")
local shield_config = defineSimulatedAttr("护体真元")
local willpower_config = defineSimulatedAttr("意志")
local phys_pen_config = defineSimulatedAttr("物理穿透")
local magic_pen_config = defineSimulatedAttr("法术穿透")
local magic_dmg_config = defineSimulatedAttr("法术固伤")
local phys_dmg_config = defineSimulatedAttr("物理固伤")
local fixed_phys_pen_config = defineSimulatedAttr("无视护甲")
local fixed_magic_pen_config = defineSimulatedAttr("无视法抗")
local phys_reduce_config = defineSimulatedAttr("物理减伤")
local magic_crit_config = defineSimulatedAttr("法术暴击")
local phys_crit_config = defineSimulatedAttr("物理暴击")
local phys_crit_dmg_config = defineSimulatedAttr("物理暴击伤害")
local magic_crit_dmg_config = defineSimulatedAttr("法术暴击伤害")
local magic_reduce_config = defineSimulatedAttr("法术减伤")
local phys_immune_config = defineSimulatedAttr("物理免伤")
local magic_immune_config = defineSimulatedAttr("法术免伤")
local atk_dmg_config = defineSimulatedAttr("攻击伤害")
local skill_dmg_config = defineSimulatedAttr("技能伤害")
local phys_vamp_config = defineSimulatedAttr("物理吸血")
local magic_vamp_config = defineSimulatedAttr("法术吸血")
local talent_config = defineSimulatedAttr("天赋")
local luck_config = defineSimulatedAttr("气运")

-- 动态属性
local dyn_str_config = defineDynamicAttr("动态体魄", str_config, function(unit)
    if unit["英雄"] then return Jass.GetHeroStr(unit.handle, false) end
    return rawget(unit, str_config.base_name) or 0.00
end)

local dyn_agi_config = defineDynamicAttr("动态法理", agi_config, function(unit)
    if unit["英雄"] then return Jass.GetHeroAgi(unit.handle, false) end
    return rawget(unit, agi_config.base_name) or 0.00
end)

local dyn_int_config = defineDynamicAttr("动态元神", int_config, function(unit)
    if unit["英雄"] then return Jass.GetHeroInt(unit.handle, false) end
    return rawget(unit, int_config.base_name) or 0.00
end)

local dyn_atk_config = defineDynamicAttr("动态攻击", atk_config, function(unit)
    return Jass.MHUnit_GetAtkDataInt(unit.handle, Constant.UNIT_ATK_DATA_BASE_DAMAGE1)
end)

local dyn_armor_config = defineDynamicAttr("动态护甲", armor_config, function(unit)
    return Jass.MHUnit_GetData(unit.handle, Constant.UNIT_DATA_DEF_VALUE)
end)

local dyn_resist_config = defineDynamicAttr("动态法抗", magic_resist_config, function(unit)
    return rawget(unit, magic_resist_config.base_name) or 0.00
end)

if __DEBUG__ then
    print("=== 属性定义：第一阶段结束 ===")
    print("=== 属性定义：第二阶段开始(配置 reward)===")
end

--============================================================
--                    第二阶段：配置 reward
-- 使用配置对象作为 key，避免硬编码字符串
--============================================================

-- 攻击：基础攻击变化时，根据动态攻击计算附加攻击增量
Attr.reward(atk_config, {
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_atk_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, atk_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

-- 体魄：每点体魄增加生命、生命恢复、物理固伤、护甲
Attr.reward(str_config, {
    [life_config] = 25.00,
    [life_regen_config] = 0.05,
    [phys_dmg_config] = 1.00,
    [armor_config] = 0.50,
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_str_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, str_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

-- 法理：每点法理增加攻击伤害、技能伤害、遁法速度、攻击速度
Attr.reward(agi_config, {
    [atk_dmg_config] = 0.05,
    [skill_dmg_config] = 0.05,
    [dodge_speed_config] = 0.10,
    [atk_speed_config] = 0.02,
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_agi_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, agi_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

-- 元神：每点元神增加法力、法力恢复、法术固伤、法术抗性
Attr.reward(int_config, {
    [mana_config] = 15.00,
    [mana_regen_config] = 0.05,
    [magic_dmg_config] = 1.00,
    [magic_resist_config] = 0.50,
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_int_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, int_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

-- 护甲：基础护甲变化时，根据动态护甲计算附加护甲增量
Attr.reward(armor_config, {
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_armor_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, armor_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

-- 法术抗性：基础法抗变化时，根据动态法抗计算附加法抗增量
Attr.reward(magic_resist_config, {
    base_reward = function(event)
        local unit = event.object
        local total_dynamic = rawget(unit, dyn_resist_config.bonus_name) or 0.00
        if total_dynamic ~= 0.00 then
            setAttr(unit, magic_resist_config.bonus_name, event.delta * total_dynamic / 100.00, "add")
        end
    end
})

if __DEBUG__ then
    print("=== 属性定义：第二阶段结束 ===")
end

--[[
tips:附加移速影响方式 = (英雄基础移速＋鞋子移速) * 附加移速，而且是实时影响，即如果减少了基础移速或者脱下鞋子，那么总移速会根据这个公式再次计算
基础移速用的是SetUnitMoveSpeed
]]