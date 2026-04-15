local Game = require "Game"
local Jass = require "Lib.API.Jass"
local Event = require "FrameWork.Manager.Event"
local Unit = require "Core.Entity.Unit"

local Event_execute = Event.execute

local Unit_Create_Event = Event.getTypeByName("Unit_Create_Event")

function Unit_Create_Event.emit(unit_create_event)
    local is_sucess = true
    local unit = unit_create_event.unit
    local attr_list = Unit.__need_init_attr
    local unit_type = unit.type
    unit.setAttr = Unit.setAttr     --设置单位属性
    --缓存单位属性到单位实例中
    if unit.handle then
        --添加属性技能
        unit:attributeInit()
        
        for index = 1, #attr_list do
            local attr_config = attr_list[index]
            unit[attr_config.base_name] = unit_type[attr_config.name] or 0.00
        end
    else
        for index = 1, #attr_list do
            local attr_config = attr_list[index]
            rawset(unit, attr_config.base_name, unit_type[attr_config.name] or 0.00)
        end
    end

    --触发单位创建事件
    is_sucess = Event_execute(unit_create_event, "unit", unit.type)
    if not is_sucess then goto recycle end

    --任意事件
    is_sucess = Event_execute(unit_create_event)

    ::recycle::
    unit_create_event:recycle()
    return is_sucess
end

--初始化地图上的单位
Game.hookInit(function ()
    local group = Jass.CreateGroup()
    Jass.GroupEnumUnitsInRect(group, Jass.GetWorldBounds(), nil)
    Jass.ForGroup(group, function ()
        local unit_handle = Jass.GetEnumUnit()
        local name = Jass.GetUnitName(unit_handle)
        local unit_type = Unit.getTypeByName(name)

        if not unit_type then return end

        Unit.new(unit_type, unit_handle)
    end)
    Jass.GroupClear(group)
    Jass.DestroyGroup(group)
end)

--注册单位创建事件
--@param unit_type|nil（任意事件） table 单位类型
--@usage Event.onUnitCreate(function(event_instance), unit_type)
function Event.onUnitCreate(callback, unit_type)
    Event.on(Unit_Create_Event, callback, "unit_type", unit_type)
end

--注销单位创建事件
function Event.offUnitCreate(callback, unit_type)
    Event.off(Unit_Create_Event, callback, "unit_type", unit_type)
end
