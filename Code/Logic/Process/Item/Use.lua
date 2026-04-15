local Jass = require "Lib.API.Jass"
local Tool = require "Lib.API.Tool"
local Constant = require "Lib.API.Constant"
local Event = require "FrameWork.Manager.Event"
local Item = require "Core.Entity.Item"
local Unit = require "Core.Entity.Unit"

local Event_execute = Event.execute
local Event_on = Event.on
local Event_off = Event.off

local Item_use_Event = Event.eventType("Item_use_Event", {
    fields = {"item", "user"},
    roles = {"item", "user"},
    emit = function (item_use_event)
        local item = item_use_event.item
        local user = item_use_event.user

        --物品使用规则，一般会读取到item的use_rule，但如果实例覆写了use_rule，则执行实例的use_rule
        if item.use_rule then
            item.use_rule(item, user)
        end

        local is_sucess = Event_execute(item_use_event, "item", item)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(item_use_event, "item", item.type)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(item_use_event, "user", user)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(item_use_event, "user", user.type)
        if not is_sucess then goto recycle end

        --任意事件
        is_sucess = Event_execute(item_use_event)

        ::recycle::
        item_use_event:recycle()

        return is_sucess
    end
})

--物品使用事件触发器
Tool.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_USE_ITEM, function ()
    local item = Item.getByHandle(Jass.GetManipulatedItem())
    local user = Unit.getByHandle(Jass.GetManipulatingUnit())
    if not item or not user then return end

    local item_use_event = Event.new(Item_use_Event, item, user)
    item_use_event:emit()
end)

--注册物品使用事件
--@param role string 监听角色，"item"|"user"|nil（监听所有）
--@param object table 监听对象，可以是具体的item/unit实例，也可以是item/unit类型，或者nil（监听所有）
function Event.onItemUse(callback, role, object)
    Event_on(Item_use_Event, callback, role, object)
end

--注销物品使用事件
function Event.offItemUse(callback, role, object)
    Event_off(Item_use_Event, callback, role, object)
end
