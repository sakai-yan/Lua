//=========================================================================== 
// Trigger: eqweq2
//=========================================================================== 
function InitTrig_eqweq2 takes nothing returns nothing
set gg_trg_eqweq2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_eqweq2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_eqweq2,Condition(function Trig_eqweq2_Conditions))
call TriggerAddAction(gg_trg_eqweq2,function Trig_eqweq2_Actions)
endfunction

function Trig_eqweq2_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_T1=GetManipulatedItem()
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=6
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_eqweq2_Func003Func001C())then
call UnitRemoveItemSwapped(udg_T1,GetTriggerUnit())
call EnableTrigger(GetTriggeringTrigger())
else
call DoNothing()
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call EnableTrigger(GetTriggeringTrigger())
endfunction

function Trig_eqweq2_Conditions takes nothing returns boolean
if(not(GetItemType(GetManipulatedItem())==ITEM_TYPE_PERMANENT))then
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