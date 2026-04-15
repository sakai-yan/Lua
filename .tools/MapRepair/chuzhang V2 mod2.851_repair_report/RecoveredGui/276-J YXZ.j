//=========================================================================== 
// Trigger: J YXZ
//=========================================================================== 
function InitTrig_J_YXZ takes nothing returns nothing
set gg_trg_J_YXZ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_YXZ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_YXZ,Condition(function Trig_J_YXZ_Conditions))
call TriggerAddAction(gg_trg_J_YXZ,function Trig_J_YXZ_Actions)
endfunction

function Trig_J_YXZ_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,700.00,GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,'efon',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call SetUnitPathing(GetLastCreatedUnit(),false)
call UnitApplyTimedLifeBJ(6.00,'BTLF',GetLastCreatedUnit())
set udg_J_YXZ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP2)
call CreateNUnitsAtLoc(1,'edtm',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call UnitApplyTimedLifeBJ(6.00,'BTLF',GetLastCreatedUnit())
set udg_J_YXZ_UNIT2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
endfunction

function Trig_J_YXZ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A08R'))then
return false
endif
return true
endfunction