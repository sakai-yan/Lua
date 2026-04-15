//=========================================================================== 
// Trigger: eqweq1
//=========================================================================== 
function InitTrig_eqweq1 takes nothing returns nothing
set gg_trg_eqweq1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_eqweq1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_eqweq1,Condition(function Trig_eqweq1_Conditions))
call TriggerAddAction(gg_trg_eqweq1,function Trig_eqweq1_Actions)
endfunction

function Trig_eqweq1_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_T1=GetManipulatedItem()
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=6
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_eqweq1_Func003Func001C())then
call UnitRemoveItemSwapped(udg_T1,GetTriggerUnit())
call EnableTrigger(GetTriggeringTrigger())
else
call DoNothing()
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_eqweq1_Conditions takes nothing returns boolean
if(not(GetItemType(GetManipulatedItem())==ITEM_TYPE_CAMPAIGN))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction