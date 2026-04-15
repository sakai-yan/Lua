//=========================================================================== 
// Trigger: J XJDFX
//=========================================================================== 
function InitTrig_J_XJDFX takes nothing returns nothing
set gg_trg_J_XJDFX=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_XJDFX,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_XJDFX,Condition(function Trig_J_XJDFX_Conditions))
call TriggerAddAction(gg_trg_J_XJDFX,function Trig_J_XJDFX_Actions)
endfunction

function Trig_J_XJDFX_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_J_XJDFX_Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetHeroLevel(GetAttackedUnitBJ())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))/I2R(GetUnitLevel(GetAttackedUnitBJ())))
endif
if(Trig_J_XJDFX_Func006C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]*(udg_LVsLV*1.00))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],GetAttackedUnitBJ(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*(udg_LVsLV*1.00))*(0.80+(0.04*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endfunction

function Trig_J_XJDFX_Conditions takes nothing returns boolean
if(not(UnitHasBuffBJ(GetAttacker(),'Buhf')==true))then
return false
endif
return true
endfunction