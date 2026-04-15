//=========================================================================== 
// Trigger: J SMYD
//=========================================================================== 
function InitTrig_J_SMYD takes nothing returns nothing
set gg_trg_J_SMYD=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_SMYD,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_SMYD,Condition(function Trig_J_SMYD_Conditions))
call TriggerAddAction(gg_trg_J_SMYD,function Trig_J_SMYD_Actions)
endfunction

function Trig_J_SMYD_Actions takes nothing returns nothing
if(Trig_J_SMYD_Func001C())then
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())-(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*0.20)))
if(Trig_J_SMYD_Func001Func009C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetHeroLevel(GetSpellTargetUnit())))
if(Trig_J_SMYD_Func001Func009Func002C())then
if(Trig_J_SMYD_Func001Func009Func002Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())))))*(2.00+(0.15*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())))))*(2.00+(0.15*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J_SMYD_Func001Func009Func002Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*1.00))*(2.00+(0.15*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*1.00))*(2.00+(0.15*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetUnitLevel(GetSpellTargetUnit())))
if(Trig_J_SMYD_Func001Func009Func004C())then
if(Trig_J_SMYD_Func001Func009Func004Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())))))*(2.00+(0.12*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())-GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())))))*(2.00+(0.12*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J_SMYD_Func001Func009Func004Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*1.00))*(2.00+(0.12*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*1.00))*(2.00+(0.12*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
endif
else
call CreateTextTagUnitBJ("体力不足",GetTriggerUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_SMYD_Func001Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endfunction

function Trig_J_SMYD_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AOcl'))then
return false
endif
return true
endfunction