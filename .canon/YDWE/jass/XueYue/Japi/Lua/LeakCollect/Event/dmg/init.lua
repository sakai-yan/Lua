local CJ = require 'jass.common'
local unref = require 'jass.debug'.handle_unref
local get_def = require 'jass.debug'.handledef
----------------------------------------
--    伤害事件自动排泄    by 雪月灬雪歌
----------------------------------------

local cache_evt_dmg = table.new()


local evt_dmg = CJ.ConvertUnitEvent(52)

--PostFix
patch('TriggerRegisterUnitEvent'):PostFix(
    function ( __result, _trig, _unit, _evt )
        --筛选伤害事件
        if _evt ~= evt_dmg then
            return __result
        end
        ----------------------------------------
        --             增强部分
        ----------------------------------------

        local cache = {
            trig = _trig,
            unit = _unit,
            --evt = _evt,
            ret = __result,
        }

        cache_evt_dmg:insert(cache)

        return __result
    end

)


local function collect_evt_dmg( in_type , in_value)
    local i,iMax = 1, cache_evt_dmg[0]

    while i <= iMax do
        local cache = cache_evt_dmg[i]

        if cache[in_type] == in_value then
            cache.trig = nil
            cache.unit = nil
            --cache.evt = nil

            local def = get_def(cache.ret)
            if def and def.reference then
                for _ = 1, def.reference do
                    unref(cache.ret)
                end
            end
            cache.ret = nil

            cache_evt_dmg[i] = cache_evt_dmg[iMax]
            cache_evt_dmg[iMax] = nil

            iMax = iMax - 1
        else
            i = i + 1
        end

    end
    cache_evt_dmg[0] = iMax
end

--PreFix
patch('DestroyTrigger'):NoReturnValue():PreFix(
    function ( __result, _trig )
        collect_evt_dmg('trig', _trig)
        return __result
    end
)

--PreFix
patch('RemoveUnit'):NoReturnValue():PreFix(
    function ( __result, _unit )
        collect_evt_dmg('unit', _unit)
        return __result
    end
)
----------------------------------------
--          死亡排泄
----------------------------------------

--例外名单
local except = {}
local XGJAPI = XGJAPI

local cj_DyingUnit = CJ.GetDyingUnit
local convert_sid = base.sid
local u2id = CJ.GetUnitTypeId

local function collect_UnitDeath()
    local _unit = cj_DyingUnit()
    local iid = u2id(_unit)
    local sid = convert_sid( iid )
    local c = sid:byte(1,1)
    if c >= 65 and c <= 90 then
        return --英雄跳过处理
    end
    if except[iid]  then
        return --例外名单不处理
    end
    collect_evt_dmg('unit', _unit)
end

local trig_UnitDeath
local switch = false
Xfunc['XG_LeakCollect_evt_dmg_onDying'] = function ()
    if switch then
        return
    end
    switch = true

    trig_UnitDeath = CJ.CreateTrigger()

    for i = 0, 15 do
        CJ.TriggerRegisterPlayerUnitEvent( trig_UnitDeath, CJ.Player(i), CJ.EVENT_PLAYER_UNIT_DEATH, nil  )
    end

    CJ.TriggerAddAction(trig_UnitDeath, collect_UnitDeath)
end

Xfunc['XG_LeakCollect_evt_dmg_onDying_addExcept'] = function ()
    except [ XGJAPI.integer[1] ] = true
end
