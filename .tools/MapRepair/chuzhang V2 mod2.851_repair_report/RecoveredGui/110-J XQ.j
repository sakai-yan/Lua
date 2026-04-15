//=========================================================================== 
// Trigger: J XQ
//=========================================================================== 
function InitTrig_J_XQ takes nothing returns nothing
set gg_trg_J_XQ=CreateTrigger()
call TriggerAddCondition(gg_trg_J_XQ,Condition(function Trig_J_XQ_Conditions))
call TriggerAddAction(gg_trg_J_XQ,function Trig_J_XQ_Actions)
endfunction

function Trig_J_XQ_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_J_XQ_Func002C())then
call SetUnitAnimation(GetAttacker(),"Attack Slam")
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"Objects\\Spawnmodels\\Orc\\Orcblood\\BattrollBlood.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))/2.00)+((I2R(GetHeroLevel(GetAttacker()))/1.00)+(udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]/10.00)))))
if(Trig_J_XQ_Func002Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetHeroLevel(GetTriggerUnit())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetUnitLevel(GetTriggerUnit())))
endif
if(Trig_J_XQ_Func002Func006C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEventDamageSource())-GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEventDamageSource())))))*(0.80+(0.03*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEventDamageSource())-GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEventDamageSource())))))*(0.80+(0.03*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
call RemoveLocation(udg_SP)
else
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_J_XQ_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('Aimp',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])==1))then
return false
endif
if(not(GetEventDamage()>0.00))then
return false
endif
return true
endfunction