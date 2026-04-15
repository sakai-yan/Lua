//=========================================================================== 
// Trigger: J PYDF
//=========================================================================== 
function InitTrig_J_PYDF takes nothing returns nothing
set gg_trg_J_PYDF=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_PYDF,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_PYDF,Condition(function Trig_J_PYDF_Conditions))
call TriggerAddAction(gg_trg_J_PYDF,function Trig_J_PYDF_Actions)
endfunction

function Trig_J_PYDF_Actions takes nothing returns nothing
if(Trig_J_PYDF_Func001C())then
call SetUnitAnimation(GetAttacker(),"Attack Slam")
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_J_PYDF_Func001Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetHeroLevel(GetAttackedUnitBJ())))
if(Trig_J_PYDF_Func001Func005Func002C())then
if(Trig_J_PYDF_Func001Func005Func002Func003C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.03*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.03*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J_PYDF_Func001Func005Func002Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*1.00))*(0.80+(0.03*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*1.00))*(0.80+(0.03*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetUnitLevel(GetAttackedUnitBJ())))
if(Trig_J_PYDF_Func001Func005Func004C())then
if(Trig_J_PYDF_Func001Func005Func004Func003C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J_PYDF_Func001Func005Func004Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*1.00))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*1.00))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
endif
else
endif
endfunction

function Trig_J_PYDF_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('A04J',GetAttacker())==1))then
return false
endif
return true
endfunction