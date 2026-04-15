//=========================================================================== 
// Trigger: J YJS
//=========================================================================== 
function InitTrig_J_YJS takes nothing returns nothing
set gg_trg_J_YJS=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_YJS,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_YJS,Condition(function Trig_J_YJS_Conditions))
call TriggerAddAction(gg_trg_J_YJS,function Trig_J_YJS_Actions)
endfunction

function Trig_J_YJS_Actions takes nothing returns nothing
if(Trig_J_YJS_Func001C())then
call SetUnitAnimation(GetAttacker(),"Attack Slam")
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_J_YJS_Func001Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetHeroLevel(GetAttackedUnitBJ())))
if(Trig_J_YJS_Func001Func005Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*udg_LVsLV)*(0.80+(0.02*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*udg_LVsLV)*(0.80+(0.02*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetUnitLevel(GetAttackedUnitBJ())))
if(Trig_J_YJS_Func001Func005Func004C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),(((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false)))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*udg_LVsLV)*(0.80+(0.03*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),(((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false)))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*udg_LVsLV)*(0.80+(0.03*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
else
endif
endfunction

function Trig_J_YJS_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('A048',GetAttacker())==1))then
return false
endif
return true
endfunction