//=========================================================================== 
// Trigger: J QXJF2
//=========================================================================== 
function InitTrig_J_QXJF2 takes nothing returns nothing
set gg_trg_J_QXJF2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_QXJF2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_QXJF2,Condition(function Trig_J_QXJF2_Conditions))
call TriggerAddAction(gg_trg_J_QXJF2,function Trig_J_QXJF2_Actions)
endfunction

function Trig_J_QXJF2_Actions takes nothing returns nothing
set gg_trg_J_QXJF=CreateTrigger()
call TriggerAddCondition(gg_trg_J_QXJF,Condition(function Trig_J_QXJF_Conditions))
call TriggerAddAction(gg_trg_J_QXJF,function Trig_J_QXJF_Actions)
call TriggerRegisterUnitEvent(gg_trg_J_QXJF,GetSpellTargetUnit(),EVENT_UNIT_DAMAGED)
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
call CreateNUnitsAtLoc(1,'nowl',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(0.50,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
call IssueTargetOrder(GetLastCreatedUnit(),"attackonce",GetSpellTargetUnit())
endfunction

function Trig_J_QXJF2_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='mt21'))then
return false
endif
return true
endfunction

function Trig_J_QXJF_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetEventDamageSource())=='nowl'))then
return false
endif
return true
endfunction

function Trig_J_QXJF_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_J_QXJF_Func003C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetHeroLevel(GetTriggerUnit())))
if(Trig_J_QXJF_Func003Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.20+(0.03*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.20+(0.03*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetUnitLevel(GetTriggerUnit())))
if(Trig_J_QXJF_Func003Func004C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(1.20+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*((1.00*udg_LVsLV)*(1.20+(0.10*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction