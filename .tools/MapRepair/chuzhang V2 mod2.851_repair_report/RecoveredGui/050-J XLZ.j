//=========================================================================== 
// Trigger: J XLZ
//=========================================================================== 
function InitTrig_J_XLZ takes nothing returns nothing
set gg_trg_J_XLZ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_XLZ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_XLZ,Condition(function Trig_J_XLZ_Conditions))
call TriggerAddAction(gg_trg_J_XLZ,function Trig_J_XLZ_Actions)
endfunction

function Trig_J_XLZ_Actions takes nothing returns nothing
if(Trig_J_XLZ_Func001C())then
if(Trig_J_XLZ_Func001Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*0.50)*(1.60+(0.20*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((1.00*0.50)*(1.60+(0.20*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
endif
else
if(Trig_J_XLZ_Func001Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*-1.00)*(1.60+(0.20*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((1.00*-1.00)*(1.60+(0.20*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
endif
endif
if(Trig_J_XLZ_Func002C())then
call SetUnitLifeBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())+100.00))
else
endif
endfunction

function Trig_J_XLZ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AHhb'))then
return false
endif
if(not(GetUnitTypeId(GetSpellTargetUnit())!='nsgg'))then
return false
endif
if(not(GetUnitTypeId(GetSpellTargetUnit())!='n006'))then
return false
endif
return true
endfunction