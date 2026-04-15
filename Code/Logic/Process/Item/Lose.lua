--物品丢弃
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Item = require "Core.Entity.Item"
local Unit = require "Core.Entity.Unit"
local Ability = require "Core.Entity.Ability"
local Jass    = require "Lib.API.Jass"
local Tool    = require "Lib.API.Tool"
local Constant= require "Lib.API.Constant"

local DataType_get = DataType.get
local Event_execute = Event.execute
local Ability_del = Ability.del

local Item_Lose_Event
Item_Lose_Event = Event.eventType("物品失去", {
    fields = {"item", "unit"},
    roles = {"item", "unit"},
    emit = function (item_lose_event)
        local item = item_lose_event.item
        local unit = item_lose_event.unit

        --物品丢弃时，将物品属性从单位上移除，列表里的是属性config
        local attr_list = Unit.__need_init_attr
        for index = 1, #attr_list do
            local bonus_attr_name = attr_list[index].bonus_name
            if item[bonus_attr_name] then
                unit[bonus_attr_name] = (unit[bonus_attr_name] or 0.0) - item[bonus_attr_name]
            end
        end

        --物品丢弃时，移除物品附带的技能，其中主动技能skills.active的移除会因物品丢失由魔兽原生移除物品技能机制，在Process.Ability.Remove中已经处理过了，这里只处理被动技能
        local ability_list = item.ability_list
        if ability_list then
            for index = #ability_list, 1, -1 do
                local ability = ability_list[index]
                Ability_del(ability, unit)
                ability_list[index] = nil
            end

            --兜底机制，若物品技能列表里还有技能，说明有技能因意外情况丢失造成数组空洞，则清空列表
            if next(ability_list) ~= nil then
                item.ability_list = {}
                print("物品失去时，物品技能列表未清空，已执行兜底清空")
            end
        end
        
        --触发物品失去事件
        local is_sucess = Event_execute(item_lose_event, "item", item)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_lose_event, "item", item.type)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_lose_event, "unit", unit)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(item_lose_event, "unit", unit.type)
        if not is_sucess then 
            goto recycle
        end

        --任意事件
        is_sucess = Event_execute(item_lose_event)

        ::recycle::

        item.owner = false
        item_lose_event:recycle()
        return is_sucess
    end
})

--物品失去触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_DROP_ITEM, function ()
    local item = Item.getByHandle(Jass.GetManipulatedItem())
    local unit = Unit.getByHandle(Jass.GetManipulatingUnit())

    if not item or not unit then return end

    local event_instance = Event.new(Item_Lose_Event, item, unit)
    event_instance:emit()
end)

--丢弃物品
function Item.discard(item, unit)
    if __DEBUG__ then
        assert(DataType_get(item) == "item", "Item.discard: 物品错误")
        assert(DataType_get(unit) == "unit", "Item.discard: 单位错误")
    end

    Jass.UnitRemoveItem(unit.handle, item.handle)
end
