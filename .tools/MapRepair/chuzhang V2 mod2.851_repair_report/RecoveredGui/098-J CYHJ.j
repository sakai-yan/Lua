//=========================================================================== 
// Trigger: J CYHJ
//=========================================================================== 
function InitTrig_J_CYHJ takes nothing returns nothing
set gg_trg_J_CYHJ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_CYHJ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_CYHJ,Condition(function Trig_J_CYHJ_Conditions))
call TriggerAddAction(gg_trg_J_CYHJ,function Trig_J_CYHJ_Actions)
endfunction

function Trig_J_CYHJ_Actions takes nothing returns nothing
call UnitAddAbilityBJ('A02K',GetTriggerUnit())
call GroupClear(udg_GROUP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_CY_unit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTriggerUnit()
set udg_SP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetUnitLoc(GetTriggerUnit())
set udg_SP_CY_UNMOOV[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetUnitLoc(GetTriggerUnit())
set udg_J_CY_P[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetSpellTargetLoc()
set udg_J_d[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=DistanceBetweenPoints(udg_J_CY_P[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_d2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=DistanceBetweenPoints(udg_J_CY_P[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_CY_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_J_D[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=AngleBetweenPoints(udg_J_CY_P[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_CY_TRUE[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call RemoveLocation(udg_SP_CY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_J_CYHJ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='ACsh'))then
return false
endif
return true
endfunction