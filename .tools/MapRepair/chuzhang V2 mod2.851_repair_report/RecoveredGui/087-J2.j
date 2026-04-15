//=========================================================================== 
// Trigger: J2
//=========================================================================== 
function InitTrig_J2 takes nothing returns nothing
set gg_trg_J2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J2,Condition(function Trig_J2_Conditions))
call TriggerAddAction(gg_trg_J2,function Trig_J2_Actions)
endfunction

function Trig_J2_Actions takes nothing returns nothing
set gg_trg_J1=CreateTrigger()
call TriggerAddCondition(gg_trg_J1,Condition(function Trig_J1_Conditions))
call TriggerAddAction(gg_trg_J1,function Trig_J1_Actions)
call TriggerRegisterUnitEvent(gg_trg_J1,GetSpellTargetUnit(),EVENT_UNIT_DAMAGED)
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
call CreateNUnitsAtLoc(1,'earc',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
call IssueTargetOrder(GetLastCreatedUnit(),"attackonce",GetSpellTargetUnit())
endfunction

function Trig_J2_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A00W'))then
return false
endif
return true
endfunction

function Trig_J1_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetEventDamageSource())=='earc'))then
return false
endif
return true
endfunction

function Trig_J1_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"BAOJI.mdx")
call PlaySoundAtPointBJ(gg_snd_BansheeDeath,100,udg_SP,0)
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_J1_Func008C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetHeroLevel(GetTriggerUnit())))
if(Trig_J1_Func008Func002C())then
if(Trig_J1_Func008Func002Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.35+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.35+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J1_Func008Func002Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.35+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.35+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
endif
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetUnitLevel(GetTriggerUnit())))
if(Trig_J1_Func008Func004C())then
if(Trig_J1_Func008Func004Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.35+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.35+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J1_Func008Func004Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.35+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.35+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
endif
endif
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction