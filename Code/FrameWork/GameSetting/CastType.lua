--[[============================================================================
    CastType - 技能释放类型封装库
    
    模块说明:
    --------
    本模块用于管理魔兽争霸3中技能的释放类型，提供了类型安全的封装对象。  
    内部通过位运算来实现高效的类型组合，支持使用字符串、整数、CastTypeObject 对象作为参数。  
    旨在方便开发者定义技能的释放类型，并确保技能释放类型的正确性与高效性。
    
    类型体系:
    --------
    基本类型（互斥，必选其一）：
      - NonTarget (无目标)   : 无需选择目标即可释放（如：区域技能、全屏技能等）
      - Point (点目标)       : 需要选择一个地面位置
      - Target (指定目标)    : 需要选择一个单位/可破坏物
    
    附加类型（可叠加，可选）：
      - Alone (单独释放)     : 技能独占释放，不可与其他技能同时释放
      - Restore (命令恢复)   : 释放后恢复之前的命令
      - Area (区域选取)      : 显示区域选取图像（AOE指示器）
      - Instant (立即释放)   : 跳过施法前摇，立即生效
    
    设计模式:
    --------
    1. 享元模式 (Flyweight) - 相同类型值共享同一个对象实例
    2. 位运算 - 内部使用整数位标志实现高效的类型组合
    3. 多态参数 - API支持字符串、整数、类型对象三种输入方式，灵活高效
    
    使用示例:
    --------
    ```lua
    local CastType = require "GameSettings.CastType"
    
    -- 方式1: 使用预定义类型
    local type1 = CastType.Point
    local type2 = CastType.PointInstant
    
    -- 方式2: 通过 create 创建组合类型
    local type3 = CastType.create("Point", "Area", "Instant")
    
    -- 方式3: 函数式调用（等同于 create）
    local type4 = CastType("Target", "Instant")
    
    -- 方式4: 从现有类型添加/移除附加类型
    local type5 = CastType.add(CastType.Point, "Area")
    local type6 = CastType.remove(type5, "Area")
    
    -- 类型检查
    if CastType.isPoint(type3) then
        print("这是点目标技能")
    end
    if CastType.has(type3, "Instant") then
        print("这是立即释放技能")
    end
    ```
    
    注意事项:
    --------
    1. 相同组合的类型对象是同一个实例，可用 `==` 或 `rawequal` 比较
    2. 基本类型互斥，create 时第一个参数必须是基本类型
    3. 不能将基本类型作为附加类型添加
    4. 支持中英文名称，推荐使用英文以保持一致性
    
============================================================================]]--

local Constant = require("Lib.API.Constant")
local BitSet   = require("Lib.Base.BitSet")

--==============================================================================
-- 内部常量定义
--==============================================================================

-- Base 类型（低位，互斥）
local NONTARGET = Constant.ABILITY_CAST_TYPE_NONTARGET
local POINT     = Constant.ABILITY_CAST_TYPE_POINT
local TARGET    = Constant.ABILITY_CAST_TYPE_TARGET

-- Extra 类型（高位，可叠加）
local ALONE     = Constant.ABILITY_CAST_TYPE_ALONE
local RESTORE   = Constant.ABILITY_CAST_TYPE_RESTORE
local AREA      = Constant.ABILITY_CAST_TYPE_AREA
local INSTANT   = Constant.ABILITY_CAST_TYPE_INSTANT

-- 掩码
local BASE_MASK  = BitSet.adds(NONTARGET, POINT, TARGET)
local EXTRA_MASK = BitSet.adds(ALONE, RESTORE, AREA, INSTANT)

-- Base 集合（用于快速校验）
local _BaseTypes = {
    [NONTARGET] = true,
    [POINT]     = true,
    [TARGET]    = true,
}

-- Extra 列表（用于遍历 / 生成名称）
local EXTRA_TYPES = {
    { flag = ALONE,   en = "Alone",   cn = "单独释放" },
    { flag = RESTORE, en = "Restore", cn = "命令恢复" },
    { flag = AREA,    en = "Area",    cn = "区域选取" },
    { flag = INSTANT, en = "Instant", cn = "立即释放" },
}

--==============================================================================
-- 名称映射
--==============================================================================

local _BaseTypeNames = {
    [NONTARGET] = { en = "NonTarget", cn = "无目标" },
    [POINT]     = { en = "Point",     cn = "点目标" },
    [TARGET]    = { en = "Target",    cn = "指定目标" },
}

-- 名称 -> 位值
local _NameToValue = {}

for value, names in pairs(_BaseTypeNames) do
    _NameToValue[names.en] = value
    _NameToValue[names.cn] = value
end

for _, extra in ipairs(EXTRA_TYPES) do
    _NameToValue[extra.en] = extra.flag
    _NameToValue[extra.cn] = extra.flag
end

--==============================================================================
-- CastTypeObject 定义（不可变享元对象）
--==============================================================================

---@class CastTypeObject
---@field value integer 位标志整数值
---@field name string 英文名称
---@field nameCN string 中文名称
local CastTypeObject = {}
CastTypeObject.__index = CastTypeObject

function CastTypeObject:__eq(other)
    return type(other) == "table" and self.value == other.value
end

function CastTypeObject:__tostring()
    return self.name
end

--==============================================================================
-- 享元缓存
--==============================================================================

local _TypeCache = {}

--==============================================================================
-- 内部工具函数
--==============================================================================

--- 是否为基本类型
---@param value integer 位标志整数值
---@return boolean 是否为基本类型
local function _isBaseFlag(value)
    return _BaseTypes[value] == true
end

--- 解析值
---@param param table|number|string 参数
---@return integer|nil 位标志整数值
local function _parseValue(param)
    local t = type(param)
    if t == "number" then
        return param
    elseif t == "string" then
        return _NameToValue[param]
    elseif t == "table" then
        return param.value
    end
    return nil
end

--- 生成名称
---@param value number 位标志整数值
---@return string 名称
local function _makeName(value)
    local parts = {}
    local base = BitSet.get(value, BASE_MASK)
    local info = _BaseTypeNames[base]
    parts[1] = info and info.en or "Unknown"

    for i = 1, #EXTRA_TYPES do
        local e = EXTRA_TYPES[i]
        if BitSet.has(value, e.flag) then
            parts[#parts + 1] = e.en
        end
    end
    return table.concat(parts, "|")
end

--- 生成中文名称
---@param value number 位标志整数值
---@return string 中文名称
local function _makeNameCN(value)
    local parts = {}
    local base = BitSet.get(value, BASE_MASK)
    local info = _BaseTypeNames[base]
    parts[1] = info and info.cn or "未知类型"

    for i = 1, #EXTRA_TYPES do
        local e = EXTRA_TYPES[i]
        if BitSet.has(value, e.flag) then
            parts[#parts + 1] = e.cn
        end
    end
    return table.concat(parts, "|")
end

--- 获取或创建释放类型实例
---@param value number 位标志整数值
---@return table 释放类型实例
local function _getOrCreateType(value)
    local cached = _TypeCache[value]
    if cached then
        return cached
    end

    local obj = setmetatable({
        value  = value,
        name   = _makeName(value),
        nameCN = _makeNameCN(value),
    }, CastTypeObject)

    _TypeCache[value] = obj
    return obj
end

--==============================================================================
-- CastType 模块
--==============================================================================

---@class CastType
local CastType = {}

--==============================================================================
-- 创建类型
--==============================================================================

--- 创建技能释放类型
--- @param base string|integer|CastTypeObject Base 类型
--- @param ... string|integer|CastTypeObject Extra 类型
--- @return CastTypeObject
function CastType.create(base, ...)
    local value = _parseValue(base) or 0
    local baseFlag = BitSet.get(value, BASE_MASK)

    if not _BaseTypes[baseFlag] then
        if __DEBUG__ then
            error("CastType.create: 无效的基本类型")
        end
        value = NONTARGET
    end

    local n = select("#", ...)
    if n > 0 then
        local extras = { ... }
        for i = 1, n do
            local v = _parseValue(extras[i])
            if v then
                if _isBaseFlag(v) then
                    if __DEBUG__ then
                        error("CastType.create: 不能将基本类型作为附加类型")
                    end
                else
                    value = BitSet.add(value, v)
                end
            end
        end
    end

    return _getOrCreateType(value)
end

--==============================================================================
-- 预定义类型
--==============================================================================

CastType.NonTarget = _getOrCreateType(NONTARGET)
CastType.Point     = _getOrCreateType(POINT)
CastType.Target    = _getOrCreateType(TARGET)

CastType.Alone     = _getOrCreateType(ALONE)
CastType.Restore   = _getOrCreateType(RESTORE)
CastType.Area      = _getOrCreateType(AREA)
CastType.Instant   = _getOrCreateType(INSTANT)

-- 常用组合
CastType.PointInstant       = _getOrCreateType(BitSet.add(POINT, INSTANT))
CastType.PointArea          = _getOrCreateType(BitSet.add(POINT, AREA))
CastType.PointAreaInstant   = _getOrCreateType(BitSet.adds(POINT, AREA, INSTANT))
CastType.TargetInstant      = _getOrCreateType(BitSet.add(TARGET, INSTANT))
CastType.NonTargetInstant   = _getOrCreateType(BitSet.add(NONTARGET, INSTANT))

--==============================================================================
-- 类型操作
--==============================================================================

--- 添加 Extra 类型（不会破坏 Base）
---@param castType table 释放类型实例
---@param extra table 额外类型实例
---@return table 新的释放类型实例
function CastType.add(castType, extra)
    local baseValue  = _parseValue(castType)
    local extraValue = _parseValue(extra)

    if not baseValue or not extraValue or _isBaseFlag(extraValue) then
        if __DEBUG__ then
            error("CastType.add: 非法参数")
        end
        return _getOrCreateType(baseValue or NONTARGET)
    end

    return _getOrCreateType(BitSet.add(baseValue, extraValue))
end

--- 移除 Extra 类型（禁止移除 Base）
---@param castType table 释放类型实例
---@param extra table 额外类型实例
---@return table 新的释放类型实例
function CastType.remove(castType, extra)
    local baseValue  = _parseValue(castType)
    local extraValue = _parseValue(extra)

    if not baseValue or not extraValue or _isBaseFlag(extraValue) then
        if __DEBUG__ then
            error("CastType.remove: 非法参数")
        end
        return _getOrCreateType(baseValue or NONTARGET)
    end

    return _getOrCreateType(BitSet.del(baseValue, extraValue))
end

--- 是否包含某类型
---@param castType table 释放类型实例
---@param flag table 额外类型实例
---@return boolean 是否包含
function CastType.has(castType, flag)
    local v = _parseValue(castType)
    local f = _parseValue(flag)
    return v and f and BitSet.has(v, f) or false
end

--==============================================================================
-- Base 判断
--==============================================================================

--- 是否为无目标类型
---@param castType table 释放类型实例
---@return boolean 是否为无目标类型
function CastType.isNonTarget(castType)
    return BitSet.get(_parseValue(castType) or 0, BASE_MASK) == NONTARGET
end

--- 是否为点目标类型
---@param castType table 释放类型实例
---@return boolean 是否为点目标类型
function CastType.isPoint(castType)
    return BitSet.get(_parseValue(castType) or 0, BASE_MASK) == POINT
end

--- 是否为目标类型
---@param castType table 释放类型实例
---@return boolean 是否为目标类型
function CastType.isTarget(castType)
    return BitSet.get(_parseValue(castType) or 0, BASE_MASK) == TARGET
end

--==============================================================================
-- 与 WAR3 API 交互
--==============================================================================

--- 转换为整数值
---@param castType table 释放类型实例
---@return number 整数值
function CastType.toValue(castType)
    return _parseValue(castType) or NONTARGET
end

--- 从整数值转换为释放类型实例
---@param value number 整数值
---@return table 释放类型实例
function CastType.fromValue(value)
    if type(value) ~= "number" then
        return CastType.NonTarget
    end

    local base = BitSet.get(value, BASE_MASK)
    if not _BaseTypes[base] then
        value = BitSet.add(NONTARGET, BitSet.get(value, EXTRA_MASK))
    end

    return _getOrCreateType(value)
end

--==============================================================================
-- 显示辅助
--==============================================================================

--- 转换为中文名称
---@param castType table 释放类型实例
---@return string 中文名称
function CastType.toStringCN(castType)
    local obj = _getOrCreateType(_parseValue(castType) or NONTARGET)
    return obj.nameCN
end

--==============================================================================
-- 函数式调用
--==============================================================================

setmetatable(CastType, {
    --函数式调用
    --@param base table 基本类型实例
    --@param ... table 额外类型实例
    --@return table 新的释放类型实例
    __call = function(_, base, ...)
        return CastType.create(base, ...)
    end
})

return CastType
