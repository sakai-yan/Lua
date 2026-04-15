--物品获得
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Item = require "Core.Entity.Item"
local Ability = require "Core.Entity.Ability"
local Tool    = require "Lib.API.Tool"
local Jass    = require "Lib.API.Jass"
local Constant= require "Lib.API.Constant"
local Unit    = require "Core.Entity.Unit"

local Event_execute = Event.execute
local DataType_get = DataType.get

local Item_Get_Event
Item_Get_Event = Event.eventType("物品获得",{
    fields = {"item", "unit"},
    roles = {"item", "unit"},
    emit = function (item_get_event)
        local item = item_get_event.item
        local unit = item_get_event.unit

        item.owner = unit

        --获得物品时，将物品属性添加到单位上，列表里的是属性config
        local attr_list = Unit.__need_init_attr
        for index = 1, #attr_list do
            local bonus_attr_name = attr_list[index].bonus_name
            if item[bonus_attr_name] then
                unit[bonus_attr_name] = (unit[bonus_attr_name] or 0.0) + item[bonus_attr_name]
            end
        end

        --获得物品时，添加物品附带的技能，其中主动技能skills.active的添加在Process.Ability.Add中已经处理过了，这里只处理被动技能
        local skills = item.skills
        if skills and #skills > 0 then
            --物品给单位的技能在这个表里记录，方便丢弃物品时移除技能
            local ability_list = item.ability_list
            if not ability_list then
                ability_list = table.setmode({}, "kv")
                item.ability_list = ability_list
            end
            --将技能添加到单位上，并记录到物品的ability_list里，若skills里某些skill已被覆写为ability实例，则直接添加
            for index = 1, #skills do
                local datatype = DataType_get(skills[index])
                local ability
                if datatype == "skill" then
                    --封装技能
                    ability = Ability.new(skills[index])
                    Ability.add(ability, unit, false, nil)
                    ability_list[#ability_list + 1] = ability
                elseif datatype == "ability" then
                    ability = skills[index]
                    Ability.add(ability, unit, false, nil)
                    ability_list[#ability_list + 1] = ability
                end
            end
        end
        
        --触发物品获得事件
        local is_sucess = Event_execute(item_get_event, "item", item)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_get_event, "item", item.type)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_get_event, "unit", unit)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_get_event, "unit", unit.type)
        if not is_sucess then
            goto recycle
        end

        --任意事件
        is_sucess = Event_execute(item_get_event)

        ::recycle::
        item_get_event:recycle()
        return is_sucess
    end
})

--物品获得触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_PICKUP_ITEM, function ()
    local item = Item.getByHandle(Jass.GetManipulatedItem())
    local unit = Unit.getByHandle(Jass.GetManipulatingUnit())

    if not item or not unit then return end

    local event_instance = Event.new(Item_Get_Event, item, unit)
    event_instance:emit()
end)

--给予物品给单位
function Item.give(item, unit)
    if __DEBUG__ then
        assert(DataType_get(item) == "item", "Item.give: 物品错误")
        assert(DataType_get(unit) == "unit", "Item.give: 单位错误")
    end
    Jass.UnitAddItem(unit.handle, item.handle)
    return item
end

--注册物品获得事件
---@param role string "item"或"unit"
---@param object table item|itemtype|unit|unittype
function Event.onItemGet(callback, role, object)
    Event.on(Item_Get_Event, callback, role, object)
end

--注销物品获得事件
function Event.offItemGet(callback, role, object)
    Event.off(Item_Get_Event, callback, role, object)
end
