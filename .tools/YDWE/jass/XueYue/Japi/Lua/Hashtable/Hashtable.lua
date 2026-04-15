---@diagnostic disable: param-type-mismatch
local XGJAPI = XGJAPI
local isCanSetNull = false
local cj = require 'jass.common'

local RemoveSavedHandle = cj.RemoveSavedHandle

local list_hashtable_setnullFunc = {
    'SavePlayerHandle',
    'SaveWidgetHandle',
    'SaveDestructableHandle',
    'SaveItemHandle',
    'SaveUnitHandle',
    'SaveAbilityHandle',
    'SaveTimerHandle',
    'SaveTriggerHandle',
    'SaveTriggerConditionHandle',
    'SaveTriggerActionHandle',
    'SaveTriggerEventHandle',
    'SaveForceHandle',
    'SaveGroupHandle',
    'SaveLocationHandle',
    'SaveRectHandle',
    'SaveBooleanExprHandle',
    'SaveSoundHandle',
    'SaveEffectHandle',
    'SaveUnitPoolHandle',
    'SaveItemPoolHandle',
    'SaveQuestHandle',
    'SaveQuestItemHandle',
    'SaveDefeatConditionHandle',
    'SaveTimerDialogHandle',
    'SaveLeaderboardHandle',
    'SaveMultiboardHandle',
    'SaveMultiboardItemHandle',
    'SaveTrackableHandle',
    'SaveDialogHandle',
    'SaveButtonHandle',
    'SaveTextTagHandle',
    'SaveLightningHandle',
    'SaveImageHandle',
    'SaveUbersplatHandle',
    'SaveRegionHandle',
    'SaveFogStateHandle',
    'SaveFogModifierHandle',
    'SaveAgentHandle',
    'SaveHashtableHandle',
}

local patchs = {}

local function setIsCanNull( value )
    isCanSetNull = value
    if value and patchs[1] == nil then
        for i, v in ipairs(list_hashtable_setnullFunc) do
            patchs[i] = patch(v)

            patchs[i]:PreFix(function ( __result, ht, parentKey, childKey, v, oFunc )
                if v == nil or v == 0 then
                    return RemoveSavedHandle(ht, parentKey, childKey)
                else
                    return oFunc(ht, parentKey, childKey, v)
                end
            end)
        end
        return
    end

    -- 取消对空值的支持
    for i, v in ipairs(patchs) do
        v:del()
    end
end

Xfunc['XG_Hashtable_SetBoolConstant'] = function ()
    local constName = XGJAPI.string[1]
    local value = XGJAPI.bool[2]
    if not constName or constName == '' then
        return
    end
    if constName == 'isCanSetNull' then
        setIsCanNull(value)
    end
    
end
