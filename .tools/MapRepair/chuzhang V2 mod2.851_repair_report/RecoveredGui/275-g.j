//=========================================================================== 
// Trigger: g
//=========================================================================== 
function InitTrig_g takes nothing returns nothing
set gg_trg_g=CreateTrigger()
call TriggerAddCondition(gg_trg_g,Condition(function Trig_g_Conditions))
call TriggerAddAction(gg_trg_g,function Trig_g_Actions)
endfunction

function Trig_g_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_g_Func003C())then
call DisableTrigger(GetTriggeringTrigger())
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((98.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
else
endif
if(Trig_g_Func004C())then
call DisableTrigger(GetTriggeringTrigger())
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((170.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
else
endif
if(Trig_g_Func005C())then
call DisableTrigger(GetTriggeringTrigger())
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((220.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
else
endif
if(Trig_g_Func006C())then
call DisableTrigger(GetTriggeringTrigger())
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((600.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
else
endif
if(Trig_g_Func007C())then
call DisableTrigger(GetTriggeringTrigger())
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((320.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_NORMAL)
else
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_g_Conditions takes nothing returns boolean
if(not(GetEventDamage()>0.00))then
return false
endif
return true
endfunction