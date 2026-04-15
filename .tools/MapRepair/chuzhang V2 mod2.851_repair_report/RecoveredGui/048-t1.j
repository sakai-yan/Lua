//=========================================================================== 
// Trigger: t1
//=========================================================================== 
function InitTrig_t1 takes nothing returns nothing
set gg_trg_t1=CreateTrigger()
call TriggerAddCondition(gg_trg_t1,Condition(function Trig_t1_Conditions))
call TriggerAddAction(gg_trg_t1,function Trig_t1_Actions)
endfunction

function Trig_t1_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_GROUP=GetUnitsInRangeOfLocMatching(200.00,udg_SP,Condition(function Trig_t1_Func003002003))
call ForGroupBJ(udg_GROUP,function Trig_t1_Func004A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
call RemoveUnit(GetEventDamageSource())
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_t1_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetEventDamageSource())=='ewsp'))then
return false
endif
return true
endfunction

function Trig_t1_Func003002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetEventDamageSource()))==true)
endfunction