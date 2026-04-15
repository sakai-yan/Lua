//=========================================================================== 
// Trigger: eqweq4
//=========================================================================== 
function InitTrig_eqweq4 takes nothing returns nothing
set gg_trg_eqweq4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_eqweq4,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_eqweq4,Condition(function Trig_eqweq4_Conditions))
call TriggerAddAction(gg_trg_eqweq4,function Trig_eqweq4_Actions)
endfunction

function Trig_eqweq4_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_T1=GetManipulatedItem()
set bj_forLoopBIndex=0
set bj_forLoopBIndexEnd=5
loop
exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
if(Trig_eqweq4_Func004Func001C())then
call UnitRemoveItemSwapped(udg_T1,GetTriggerUnit())
call EnableTrigger(GetTriggeringTrigger())
else
call DoNothing()
endif
set bj_forLoopBIndex=bj_forLoopBIndex+1
endloop
call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_eqweq4_Conditions takes nothing returns boolean
if(not Trig_eqweq4_Func001C())then
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