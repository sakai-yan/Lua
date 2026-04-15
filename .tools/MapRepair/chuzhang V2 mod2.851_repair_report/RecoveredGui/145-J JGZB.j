//=========================================================================== 
// Trigger: J JGZB
//=========================================================================== 
function InitTrig_J_JGZB takes nothing returns nothing
set gg_trg_J_JGZB=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_JGZB,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_JGZB,Condition(function Trig_J_JGZB_Conditions))
call TriggerAddAction(gg_trg_J_JGZB,function Trig_J_JGZB_Actions)
endfunction

function Trig_J_JGZB_Actions takes nothing returns nothing
if(Trig_J_JGZB_Func001C())then
set udg_SP=GetUnitLoc(GetAttacker())
call CreateNUnitsAtLoc(1,'e000',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call ShowUnitHide(GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"thunderbolt",GetAttacker())
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())+(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*0.08)))
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_J_JGZB_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('Atru',GetTriggerUnit())==1))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction