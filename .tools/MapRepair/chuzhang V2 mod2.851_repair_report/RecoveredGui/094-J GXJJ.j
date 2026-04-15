//=========================================================================== 
// Trigger: J GXJJ
//=========================================================================== 
function InitTrig_J_GXJJ takes nothing returns nothing
set gg_trg_J_GXJJ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_GXJJ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_GXJJ,Condition(function Trig_J_GXJJ_Conditions))
call TriggerAddAction(gg_trg_J_GXJJ,function Trig_J_GXJJ_Actions)
endfunction

function Trig_J_GXJJ_Actions takes nothing returns nothing
if(Trig_J_GXJJ_Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'nfpc',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call UnitApplyTimedLifeBJ(6.00,'BTLF',GetLastCreatedUnit())
call ShowUnitHide(GetLastCreatedUnit())
set udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
call IssueTargetOrder(udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"attack",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
if(Trig_J_GXJJ_Func001Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'n00J',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call UnitApplyTimedLifeBJ(6.00,'BTLF',GetLastCreatedUnit())
call ShowUnitHide(GetLastCreatedUnit())
set udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
call IssueTargetOrder(udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"attack",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'nfps',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call UnitApplyTimedLifeBJ(6.00,'BTLF',GetLastCreatedUnit())
call ShowUnitHide(GetLastCreatedUnit())
set udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
call IssueTargetOrder(udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],"attack",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
endif
endif
endfunction

function Trig_J_GXJJ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A04A'))then
return false
endif
return true
endfunction