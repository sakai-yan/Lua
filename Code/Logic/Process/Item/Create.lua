
local Event= require "FrameWork.Manager.Event"

local Event_execute = Event.execute

local Item_New_Event = Event.getTypeByName("物品创建")

function Item_New_Event.emit(item_new_event)
    local is_sucess = true
    local item = item_new_event.item

    --触发物品创建事件
    local is_sucess = Event_execute(item_new_event, "item", item)
    if not is_sucess then goto recycle end

    is_sucess = Event_execute(item_new_event, "item", item.type)
    if not is_sucess then goto recycle end

    --任意事件
    is_sucess = Event_execute(item_new_event)

    ::recycle::
    item_new_event:recycle()
    return is_sucess
end

--注册物品创建事件
---@param item_type table 物品类型
function Event.onItemCreate(callback, item_type)
    Event.on(Item_New_Event, callback, "item", item_type)
end

--注销物品创建事件
function Event.offItemCreate(callback, item_type)
    Event.off(Item_New_Event, callback, "item", item_type)
end


