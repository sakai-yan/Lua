-- Buff
local Class    = require "Lib.Base.Class"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Timer = require "FrameWork.Manager.Timer"

local table_insert = table.insert
local table_remove = table.remove

-- 影响负面 Buff 持续时间的属性
local LIMIT_ATTR = "意志"

-- Buff 类
local Buff
Buff = Class("Buff", {

    --存储所有Buff实例，强引用，避免被GC回收
    __buffs = {},

    --实例以键值弱引用的方式存储数据
    __mode = "kv",

    --存储所有Buff类型
    _buff_types_by_name = {},

    -- Buff 实例构造器
    ---@usage Buff.new(BuffType, origin)
    ---@param origin table buff来源
    __constructor__ = function (class, buff_type, origin)
        if __DEBUG__ then
            assert(DataType.get(buff_type) == "bufftype",
                "Buff.__constructor__: buff_type must be bufftype")
            assert(type(origin) == "table",
                "Buff.__constructor__: origin must be table")
        end

        local buff = {
            origin        = origin,                 -- Buff 来源
            type          = buff_type,              -- BuffType
            duration      = buff_type.duration,     --持续时间
            interval      = buff_type.interval,     --循环间隔时间

            expire_timer  = false,                  -- 生命周期Timer（所有Buff必须有，即到期计时器）
            tick_timer    = false,                  -- 行为Timer（仅interval Buff有，即循环触发计时器）
            target        = false,                  -- 目标（Buff作用的目标）
        }

        return DataType.set(buff, "buff")
    end,

    -- Buff 实例缺省字段回退到 BuffType，如果BuffType也没有，则会回退到Buff基类
    __index__ = function (buff, key)
        return buff.type[key]
    end,

    --定义Buff类型
    ---@param buff_type_config table Buff类型配置
    --[[
    buff_type_config = {
            name = "buff_name",                 --名称，不用在配置表里填，默认用buff_name
            art = "buff_art",                   --图标路径，可选
            description = "buff_description",   --描述，可选，用于UI显示
            duration = 10,                      --默认持续时间，秒，可选
            interval = 1,                       --默认循环间隔时间，秒，可选
            add_rule = function (buff) end,       --添加回调，可选
            remove_rule = function (buff) end,    --删除回调，可选
            update_rule = function (buff) end,    --更新回调，可选
        }
    --]]
    buffType = function (buff_name, buff_type_config)
        if __DEBUG__ then
            assert(type(buff_name) == "string")
            assert(type(buff_type_config) == "table")
            assert(type(buff_type_config.name) == "string")
            assert(type(buff_type_config.art) == "string")
            assert(type(buff_type_config.description) == "string")
            assert(type(buff_type_config.duration) == "number")
            assert(not buff_type_config.interval
                or type(buff_type_config.interval) == "number")
        end

        if Buff._buff_types_by_name[buff_name] then
            error("Buff.buffType: buff '" .. buff_name .. "' already exists")
        end

        buff_type_config.name = buff_name
        Buff._buff_types_by_name[buff_name] = buff_type_config

        return DataType.set(buff_type_config, "bufftype")
    end,

    -- 根据名称获取 BuffType
    getTypeByName = function (buff_name)
        return Buff._buff_types_by_name[buff_name]
    end,

    -- Buff 事件定义
    _buff_add_event = Event.eventType("Buff添加", {
        fields = {"buff","origin", "target"},
        roles = {"bufftype", "origin", "target"}
    }),

    _buff_update_event = Event.eventType("Buff更新", {
        fields = {"buff","origin", "target"},
        roles = {"bufftype", "origin", "target"}
    }),

    _buff_remove_event = Event.eventType("Buff移除", {
        fields = {"buff","origin", "target"},
        roles = {"bufftype", "origin", "target"}
    }),
})


local BUFF_ADD_EVENT = Buff._buff_add_event
local BUFF_UPDATE_EVENT = Buff._buff_update_event
local BUFF_REMOVE_EVENT = Buff._buff_remove_event

-- 通用 Buff 循环 Tick（interval 回调）
local function _buff_tick(buff)
    if buff.update_rule then
        buff.update_rule(buff)
    end

    local evt = Event.new(BUFF_UPDATE_EVENT, buff)
    evt:emit()
end

-- 添加 Buff
function Buff.add(buff, target)
    if __DEBUG__ then
        assert(DataType.get(buff) == "buff")
        assert(type(target) == "table")
    end

    -- 获取 / 创建 Buff 栏
    local buffbar = target._buffbar
    if not buffbar then
        buffbar = {}
        target._buffbar = buffbar
    end

    buff.target = target

    -- 根据目标属性修正持续时间（负面 Buff）
    if buff.polarity == false then
        buff.duration = buff.duration * (1 - (target[LIMIT_ATTR] or 0) / 100)
    end

    table_insert(buffbar, buff)

    -- 生命周期 Timer（即到期计时器）
    if buff.duration > 0 then
        buff.expire_timer = Timer.delay(
            buff.duration,
            Buff.remove,
            buff,
            target
        )
    end

    -- 循环 Timer（仅 interval Buff）
    if buff.interval and buff.interval > 0 then
        buff.tick_timer = Timer.loop(
            0.0, -- 循环buff在下一帧会先触发一次
            buff.interval,
            _buff_tick,
            buff
        )
    end

    -- Buff 添加回调
    if buff.add_rule then
        buff.add_rule(buff)
    end

    -- Buff 添加事件
    local evt = Event.new(BUFF_ADD_EVENT, buff)
    evt:emit(target)

    return buff
end

-- 移除 Buff（统一出口）
function Buff.remove(buff, target)
    if __DEBUG__ then
        assert(DataType.get(buff) == "buff")
        assert(type(target) == "table")
    end

    local buffbar = target._buffbar
    if not buffbar then
        return false
    end

    -- 从 Buff 栏移除
    for i = #buffbar, 1, -1 do
        if buffbar[i] == buff then
            table_remove(buffbar, i)
        end
    end

    -- 取消循环 Timer
    if buff.tick_timer then
        Timer.cancel(buff.tick_timer)
        buff.tick_timer = nil
    end

    -- 取消生命周期 Timer
    if buff.expire_timer then
        Timer.cancel(buff.expire_timer)
        buff.expire_timer = nil
    end

    -- Buff 移除回调
    if buff.remove_rule then
        buff.remove_rule(buff)
    end

    -- Buff 移除事件
    local evt = Event.new(BUFF_REMOVE_EVENT, buff)
    evt:emit(target)

    return true
end

-- 获取 Buff 剩余时间（秒）
function Buff.getRemainTime(buff)
    if DataType.get(buff) ~= "buff" then
        return 0
    end

    if not buff.expire_timer then
        return 0
    end

    return Timer.getRemaining(buff.expire_timer) or 0
end

-- 获取 Buff 总持续时间
function Buff.getDurationTime(buff)
    if DataType.get(buff) ~= "buff" then
        return 0
    end
    return buff.duration
end


--注册buff添加事件
--@param callback function 回调函数
--@param role string 事件角色|nil（任意事件） origin或target
--@param object any 对象实例|对象类型|nil（任意事件）
---@usage Buff.onAdd(callback, "origin", unit)
---@usage Buff.onAdd(callback, "bufftype", bufftype)
function Buff.onAdd(callback, role, object)
    Event.on(BUFF_ADD_EVENT, callback, role, object)
end

--注销buff添加事件，role或object填nil可注册任意事件
---@usage Buff.offAdd(callback, "origin", unit)
function Buff.offAdd(callback, role, object)
    Event.off(BUFF_ADD_EVENT, callback, role, object)
end

--注册buff更新事件，role或object填nil可注册任意事件
---@usage Buff.onUpdate(callback, "origin", unit)
function Buff.onUpdate(callback, role, object)
    Event.on(BUFF_UPDATE_EVENT, callback, role, object)
end

--注销buff更新事件，role或object填nil可注册任意事件
---@usage Buff.offUpdate(callback, "origin", unit)
function Buff.offUpdate(callback, role, object)
    Event.off(BUFF_UPDATE_EVENT, callback, role, object)
end

--注册buff移除事件，role或object填nil可注册任意事件
---@usage Buff.onRemove(callback, "origin", unit)
function Buff.onRemove(callback, role, object)
    Event.on(BUFF_REMOVE_EVENT, callback, role, object)
end

--注销buff移除事件，role或object填nil可注册任意事件
---@usage Buff.offRemove(callback, "origin", unit)
function Buff.offRemove(callback, role, object)
    Event.off(BUFF_REMOVE_EVENT, callback, role, object)
end

return Buff
