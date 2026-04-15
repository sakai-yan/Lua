local Event = require "FrameWork.Manager.Event"

local Event_execute = Event.execute

local Unit_Delete_Event = Event.getTypeByName("Unit_Delete_Event")

function Unit_Delete_Event.emit(unit_delete_event)
    local is_sucess = true
    local unit = unit_delete_event.unit

    is_sucess = Event_execute(unit_delete_event, "unit", unit)
    if not is_sucess then goto recycle end

    is_sucess = Event_execute(unit_delete_event, "unit", unit.type)
    if not is_sucess then goto recycle end

    --任意事件
    is_sucess = Event_execute(unit_delete_event)

    ::recycle::
    unit_delete_event:recycle()
    return is_sucess
end

--注册单位删除事件
--@param object table unit|unit_type|nil（任意事件）
--@usage Event.onUnitDelete(function(event_instance), unit)
function Event.onUnitDelete(callback, object)
    Event.on(Unit_Delete_Event, callback, "unit", object)
end

--注销单位删除事件
--@param object table unit|unit_type|nil（任意事件）
--@usage Event.offUnitDelete(function(event_instance), unit)
function Event.offUnitDelete(callback, object)
    Event.off(Unit_Delete_Event, callback, "unit", object)
end
