local Jass = require "Lib.API.Jass"
local DataType = require "Lib.Base.DataType"
local Event = require "FrameWork.Manager.Event"
local Ability = require "Core.Entity.Ability"

local Event_execute = Event.execute

local Ability_Del_Event
Ability_Del_Event = Event.eventType("技能删除",{
    fields = {"ability", "unit"},
    roles = {"ability", "unit"},
    emit = function (ability_del_event)
        local ability = ability_del_event.ability
        local unit = ability_del_event.unit
        --技能删除规则，一般会读取到skill的remove_rule，但如果实例覆写了remove_rule，则执行实例的remove_rule
        if ability.remove_rule then
            ability.remove_rule(ability, unit)
        end
        
        --触发删除技能事件
        local is_sucess = Event_execute(ability_del_event, "ability", ability)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_del_event, "ability", ability.type)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_del_event, "unit", unit)
        if not is_sucess then
            goto recycle
        end

        is_sucess = Event_execute(ability_del_event, "unit", unit.type)
        if not is_sucess then 
            goto recycle
        end

        --任意事件
        is_sucess = Event_execute(ability_del_event)

        ::recycle::
        ability_del_event:recycle()
        return is_sucess
    end
})

--从对象删除技能
---@return boolean 是否成功删除
function Ability.del(ability, unit)
    if __DEBUG__ then
        assert(DataType.get(unit) == "unit" and DataType.get(ability) == "ability", "Ability.del:尝试对非单位或非技能进行删除")
    end
    if not ability then return false end

    local abilbar = Ability.getBar(unit)
    if not abilbar then return false end

    --事件实例创建
    local event_instance = Event.new(Ability_Del_Event, ability, unit)
    event_instance:emit()

    Ability.removeFromBar(abilbar, ability)

    --handle移除在Ability类的__del__逻辑中
    ability.destroy(ability)

    return true
end

--注册技能删除事件
---@param callback function 回调函数，参数为事件实例
---@param role string 事件角色 "ability"或"unit"
---@param object any 对象实例|对象类型|nil（任意事件）
---@use Event.onAbilityRemove(function(event_instance), "unit", unit)
function Event.onAbilityRemove(callback, role, object)
    Event.on(Ability_Del_Event, callback, role, object)
end

--注销技能删除事件
function Event.offAbilityRemove(callback, role, object)
    Event.off(Ability_Del_Event, callback, role, object)
end
