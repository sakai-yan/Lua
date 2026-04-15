//=========================================================================== 
// Trigger: J GXJJ3
//=========================================================================== 
function InitTrig_J_GXJJ3 takes nothing returns nothing
set gg_trg_J_GXJJ3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_GXJJ3,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_GXJJ3,Condition(function Trig_J_GXJJ3_Conditions))
call TriggerAddAction(gg_trg_J_GXJJ3,function Trig_J_GXJJ3_Actions)
endfunction

function Trig_J_GXJJ3_Actions takes nothing returns nothing
if(Trig_J_GXJJ3_Func001C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetHeroLevel(GetAttackedUnitBJ())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetUnitLevel(GetAttackedUnitBJ())))
endif
if(Trig_J_GXJJ3_Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*udg_LVsLV)*(0.20+(0.01*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*udg_LVsLV)*(0.20+(0.01*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endfunction

function Trig_J_GXJJ3_Conditions takes nothing returns boolean
if(not Trig_J_GXJJ3_Func003C())then
return false
endif
return true
endfunction