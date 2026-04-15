local Jass = require "Lib.API.Jass"
local Constant = require "Lib.API.Constant"
local Event = require "FrameWork.Manager.Event"
local CastType = require "FrameWork.GameSetting.CastType"
local Ability = require "Core.Entity.Ability"
local Unit = require "Core.Entity.Unit"

local Event_execute = Event.execute
local Ability_getByHandle = Ability.getByHandle
local Unit_getByHandle = Unit.getByHandle
local GetSpellAbility = Jass.GetSpellAbility
local GetSpellAbilityUnit = Jass.GetSpellAbilityUnit
local GetSpellTargetUnit = Jass.GetSpellTargetUnit
local GetSpellTargetX = Jass.GetSpellTargetX
local GetSpellTargetY = Jass.GetSpellTargetY
local GetUnitX = Jass.GetUnitX
local GetUnitY = Jass.GetUnitY

--ability的施法状态记录，存储对应的事件实例，有事件实例说明该ability正在施法
--spell_state[ability] = event_instance
local spell_state = {}

local PROCESS_ROLE_ABILITY = "ability"
local PROCESS_ROLE_CASTER = "caster"
local PROCESS_ROLE_TARGET = "target"
local PROCESS_ROLE_INRANGE = "inrange"

local Ability_Spell_Event

local function processExecute(callbacks_set, ability_spell_event)
    local ok = false
    local obj = ability_spell_event[PROCESS_ROLE_ABILITY]
    --技能
    local list = callbacks_set[PROCESS_ROLE_ABILITY][obj]
    if list then
        ok = list:forEachExecute(ability_spell_event)
    end

    if ok then
        list = callbacks_set[PROCESS_ROLE_ABILITY][obj.type]
        if list then
            ok = list:forEachExecute(ability_spell_event)
        end
    end

    --目标或在技能范围内的单位
    if ok then
        local role
        if ability_spell_event.__is_target then
            role = PROCESS_ROLE_TARGET
        else
            role = PROCESS_ROLE_INRANGE
        end
        
        obj = ability_spell_event[role]
        list = callbacks_set[role][obj]
        if list then
            ok = list:forEachExecute(ability_spell_event)
        end

        if ok then
            list = callbacks_set[role][obj.type]
            if list then
                ok = list:forEachExecute(ability_spell_event)
            end
        end
    end

    --施法者
    if ok then
        obj = ability_spell_event[PROCESS_ROLE_CASTER]
        list = callbacks_set[PROCESS_ROLE_CASTER][obj]
        if list then
            ok = list:forEachExecute(ability_spell_event)
        end

        if ok then
            list = callbacks_set[PROCESS_ROLE_CASTER][obj.type]
            if list then
                ok = list:forEachExecute(ability_spell_event)
            end
        end
    end

    return ok
end

local prepare_callbacks_set = Event.newProcessCallbackSets({ PROCESS_ROLE_ABILITY, PROCESS_ROLE_CASTER }, processExecute)
local spell_callbacks_set = Event.newProcessCallbackSets({ PROCESS_ROLE_ABILITY, PROCESS_ROLE_CASTER }, processExecute)
local stop_callbacks_set = Event.newProcessCallbackSets({ PROCESS_ROLE_ABILITY, PROCESS_ROLE_CASTER }, processExecute)

Ability_Spell_Event = Event.eventType("技能施放", {
    fields = {"ability", "caster", "target", "x", "y", "__is_target"},
    roles = {"ability", "caster", "target"},
    emit = function (ability_spell_event)
        local ability = ability_spell_event.ability
        local caster = ability_spell_event.caster

        --触发技能准备施放事件
        local is_sucess = Event_execute(ability_spell_event, "ability", ability)
        if not is_sucess then goto recycle end
            
        is_sucess = Event_execute(ability_spell_event, "ability", ability.type)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(ability_spell_event, "caster", caster)
        if not is_sucess then goto recycle end

        is_sucess = Event_execute(ability_spell_event, "caster", caster.type)
        if not is_sucess then goto recycle end

        --任意事件
        is_sucess = Event_execute(ability_spell_event)
        if not is_sucess then goto recycle end

        ::recycle::
        ability_spell_event:recycle()
        return is_sucess
    end
})

--技能准备施放触发器
Jass.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_SPELL_CHANNEL, function ()
    local ability_handle = GetSpellAbility()
    local caster_handle = GetSpellAbilityUnit()

    local ability = Ability_getByHandle(ability_handle)
    local caster = Unit_getByHandle(caster_handle)

    if ability and caster then
        local target, x, y, __is_target = nil, nil, nil, false
        local cast_type = ability.cast_type
        if CastType.isTarget(cast_type) then
            target = Unit_getByHandle(GetSpellTargetUnit())
            __is_target = true
        elseif CastType.isPoint(cast_type) then
            x = GetSpellTargetX()
            y = GetSpellTargetY()
        else
            --无目标技能，target保持nil
            x = GetUnitX(caster_handle)
            y = GetUnitY(caster_handle)
        end

        --事件实例创建
        local event_instance = Event.new(Ability_Spell_Event, ability, caster, target, x, y, __is_target)
        --记录技能施放事件
        spell_state[ability] = event_instance

        --技能准备施放规则，一般会读取到skill的prepare_rule，但如果实例覆写了prepare_rule，则执行实例的prepare_rule
        if ability.prepare_rule then
            ability.prepare_rule(event_instance)
        end
        
        --执行技能准备施放流程，允许回调返回false来中断施放
        if not processExecute(prepare_callbacks_set, event_instance) then
            spell_state[ability] = nil
            event_instance:recycle()
        end
    end
end)

--技能发动效果触发器
Jass.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_SPELL_EFFECT, function ()
    local ability_handle = GetSpellAbility()
    local caster_handle = GetSpellAbilityUnit()

    local ability = Ability_getByHandle(ability_handle)
    local caster = Unit_getByHandle(caster_handle)

    if ability and caster then
        local event_instance = spell_state[ability]
        if not event_instance then return end
        --技能施放规则
        if ability.spell_rule then
            ability.spell_rule(event_instance)
        end

        --执行技能发动效果流程
        if not processExecute(spell_callbacks_set, event_instance) then
            spell_state[ability] = nil
            event_instance:recycle()
        end
    end
end)

--技能停止施放触发器
Jass.cjAnyEventRegister(Jass.CreateTrigger(), Constant.EVENT_PLAYER_UNIT_SPELL_ENDCAST, function ()
    local ability_handle = GetSpellAbility()
    local caster_handle = GetSpellAbilityUnit()

    local ability = Ability_getByHandle(ability_handle)
    local caster = Unit_getByHandle(caster_handle)

    if ability and caster then
        local event_instance = spell_state[ability]      
        if not event_instance then return end
        
        --技能停止施放规则
        if ability.stop_rule then
            ability.stop_rule(event_instance)
        end

        --执行技能停止施放流程
        if processExecute(stop_callbacks_set, event_instance) then
            event_instance:emit()
        end

        spell_state[ability] = nil
    end
end)

--注册技能准备施放事件
--@param role string "ability"|"unit"|"target"|"inrange" target:目标单位，inrange:技能范围内的单位
--@param obj table ability|unit|ability_type|unit_type
--@usage Event.onAbilityPrepare(callback, "unit", unit)
Event.onAbilityPrepare = prepare_callbacks_set.onProcess
--注册技能发动效果事件
Event.onAbilitySpell = spell_callbacks_set.onProcess
--注册技能停止施放事件
Event.onAbilityStop = stop_callbacks_set.onProcess

--注销技能准备施放事件
Event.offAbilityPrepare = prepare_callbacks_set.offProcess
--注销技能发动效果事件
Event.offAbilitySpell = spell_callbacks_set.offProcess
--注销技能停止施放事件
Event.offAbilityStop = stop_callbacks_set.offProcess
