//=========================================================================== 
// Trigger: J LY
//=========================================================================== 
function InitTrig_J_LY takes nothing returns nothing
set gg_trg_J_LY=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_LY,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_LY,Condition(function Trig_J_LY_Conditions))
call TriggerAddAction(gg_trg_J_LY,function Trig_J_LY_Actions)
endfunction

function Trig_J_LY_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
call CreateNUnitsAtLoc(1,'e002',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
if(Trig_J_LY_Func004C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetHeroLevel(GetSpellTargetUnit())))
if(Trig_J_LY_Func004Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*udg_LVsLV)*(2.00+(0.13*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_LIGHTNING)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))])*((1.00*udg_LVsLV)*(2.00+(0.13*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_LIGHTNING)
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetUnitLevel(GetSpellTargetUnit())))
if(Trig_J_LY_Func004Func004C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*udg_LVsLV)*(2.00+(0.15*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_LIGHTNING)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetEnumUnit()))])*((1.00*udg_LVsLV)*(2.00+(0.15*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_LIGHTNING)
endif
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_J_LY_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='ACfd'))then
return false
endif
return true
endfunction