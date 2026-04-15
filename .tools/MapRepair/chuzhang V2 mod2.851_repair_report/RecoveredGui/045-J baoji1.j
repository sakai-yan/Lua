//=========================================================================== 
// Trigger: J baoji1
//=========================================================================== 
function InitTrig_J_baoji1 takes nothing returns nothing
set gg_trg_J_baoji1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_baoji1,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_baoji1,Condition(function Trig_J_baoji1_Conditions))
call TriggerAddAction(gg_trg_J_baoji1,function Trig_J_baoji1_Actions)
endfunction

function Trig_J_baoji1_Actions takes nothing returns nothing
if(Trig_J_baoji1_Func002C())then
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_J_baoji1_Func002Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetHeroLevel(GetAttackedUnitBJ())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetUnitLevel(GetAttackedUnitBJ())))
endif
if(Trig_J_baoji1_Func002Func006C())then
if(Trig_J_baoji1_Func002Func006Func001C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.03*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*(1+((GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())-GetUnitStateSwap(UNIT_STATE_LIFE,GetAttacker()))/GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetAttacker())))))*(0.80+(0.03*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
if(Trig_J_baoji1_Func002Func006Func003C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*udg_LVsLV)*(0.80+(0.03*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_BJX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*(1.00*(0.80+(0.02*I2R(GetHeroLevel(GetAttacker())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
else
endif
endfunction

function Trig_J_baoji1_Conditions takes nothing returns boolean
if(not(IsUnitType(GetAttacker(),UNIT_TYPE_HERO)==true))then
return false
endif                                                  //a
return true
endfunction