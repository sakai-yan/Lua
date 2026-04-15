//=========================================================================== 
// Trigger: J TMF
//=========================================================================== 
function InitTrig_J_TMF takes nothing returns nothing
set gg_trg_J_TMF=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_TMF,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_TMF,Condition(function Trig_J_TMF_Conditions))
call TriggerAddAction(gg_trg_J_TMF,function Trig_J_TMF_Actions)
endfunction

function Trig_J_TMF_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
call CreateNUnitsAtLoc(1,'now2',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
if(Trig_J_TMF_Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetHeroLevel(GetSpellTargetUnit())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetUnitLevel(GetSpellTargetUnit())))
endif
if(Trig_J_TMF_Func006C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*udg_LVsLV)*(1.00+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
call SetUnitManaBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())-((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]))*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*0.20)*(1+(0.04*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))))))
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((1.00*udg_LVsLV)*(1.00+(0.05*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
call SetUnitManaBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())-((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]))*(0.20*(1+(0.04*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))))))
endif
endfunction

function Trig_J_TMF_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Ambd'))then
return false
endif
return true
endfunction