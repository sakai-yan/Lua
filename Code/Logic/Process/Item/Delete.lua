local Jass = require "Lib.API.Jass"
local Event = require "FrameWork.Manager.Event"
local Item = require "Core.Entity.Item"

local Event_execute = Event.execute

 local Item_Del_Event = Event.getTypeByName("物品删除")

function Item_Del_Event.emit(item_del_event)
    local item = item_del_event.item
    local is_sucess
    
    --触发物品删除事件
    local is_sucess = Event_execute(item_del_event, "item", item)
    if not is_sucess then goto recycle end

    is_sucess = Event_execute(item_del_event, "item", item.type)
    if not is_sucess then goto recycle end

    --任意事件
    is_sucess = Event_execute(item_del_event)

    ::recycle::
    item_del_event:recycle()

    return is_sucess
end

--注册物品删除事件
---@param object table "item"或"itemtype"
function Event.onItemDel(callback, object)
    Event.on(Item_Del_Event, callback, "item", object)
end

--注销物品删除事件
function Event.offItemDel(callback, object)
    Event.off(Item_Del_Event, callback, "item", object)
end

--物品删除事件触发器
Jass.MHItemRemoveEvent_RegisterByCode(function ()
    local item_handle = Jass.MHEvent_GetItem()
    local item = Item.getByHandle(item_handle)
    --当主动使用item:destroy()销毁物品时，会触发物品删除事件，且会清除封装对象，最后才Remove item_handle
    --如果这里还能获取到封装对象item，说明该物品删除不是使用item:destroy()销毁的，则需要执行一次destroy

    if item then
        item:destroy()
    else
        Jass.RemoveItem(item_handle) --再次删除，防止系统删不干净
    end
end)


