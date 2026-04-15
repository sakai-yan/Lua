----------------------------------------
--       特效开关       by 雪月灬雪歌
----------------------------------------

--[[
    native AddSpecialEffect takes string modelName, real x, real y returns effect
    native AddSpecialEffectLoc takes string modelName, location where returns effect
    native AddSpecialEffectTarget takes string modelName, widget targetWidget, string attachPointName returns effect
    
    native AddSpellEffect takes string abilityString, effecttype t, real x, real y returns effect
    native AddSpellEffectById takes integer abilityId, effecttype t,real x, real y returns effect
    native AddSpellEffectByIdLoc takes integer abilityId, effecttype t,location where returns effect
    native AddSpellEffectLoc takes string abilityString, effecttype t,location where returns effect
    native AddSpellEffectTarget takes string modelName, effecttype t, widget targetWidget, string attachPoint returns effect
    native AddSpellEffectTargetById takes integer abilityId, effecttype t, widget targetWidget, string attachPoint returns effect

]]

local CJ = require 'jass.common'
local patch = patch
--关闭列表
local turnOff = {

}

local localPlayerId = CJ.GetPlayerId( CJ.GetLocalPlayer() )

local hPatch = {
    AddSpecialEffect = patch('AddSpecialEffect'),
    AddSpecialEffectLoc = patch('AddSpecialEffectLoc'),
    AddSpecialEffectTarget = patch('AddSpecialEffectTarget'),
}


hPatch.AddSpecialEffect:PreFix(
    function ( __result, modelName, x, y)
        if turnOff[localPlayerId] then
            modelName = ''
        end

        local orig = hPatch.AddSpecialEffect.fake or hPatch.AddSpecialEffect.real
        if orig then
            return orig(modelName or '', x, y)
        end
        return __result
    end
)

hPatch.AddSpecialEffectLoc:PreFix(
    function ( __result, modelName, loc)
        if turnOff[localPlayerId] then
            modelName = ''
        end

        local orig = hPatch.AddSpecialEffectLoc.fake or hPatch.AddSpecialEffectLoc.real
        if orig then
            return orig(modelName or '', loc)
        end
        return __result
    end
)

hPatch.AddSpecialEffectTarget:PreFix(
    function ( __result, modelName, targetWidget, attachPointName )
        if turnOff[localPlayerId] then
            modelName = ''
        end

        local orig = hPatch.AddSpecialEffectTarget.fake or hPatch.AddSpecialEffectTarget.real
        if orig then
            return orig( modelName or '', targetWidget, attachPointName )
        end
        return __result
    end
)

local XGJAPI = XGJAPI

Xfunc['XG_EffectSwitch_TurnOff'] = function ()
    local pid = XGJAPI.integer[1]
    if pid < 0 or pid > 15 then
        return 0
    end

    turnOff[pid] = XGJAPI.bool[2]

    return 1
end
