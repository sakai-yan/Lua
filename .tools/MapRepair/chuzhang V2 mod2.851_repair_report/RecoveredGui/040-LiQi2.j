//=========================================================================== 
// Trigger: LiQi2
//=========================================================================== 
function InitTrig_LiQi2 takes nothing returns nothing
set gg_trg_LiQi2=CreateTrigger()
call TriggerAddCondition(gg_trg_LiQi2,Condition(function Trig_LiQi2_Conditions))
call TriggerAddAction(gg_trg_LiQi2,function Trig_LiQi2_Actions)
endfunction

function Trig_LiQi2_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_LiQi2_Func002C())then
set udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
else
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_LiQi2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetEventDamageSource(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetEventDamageSource(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetEventDamageSource()))==true))then
return false
endif
return true
endfunction