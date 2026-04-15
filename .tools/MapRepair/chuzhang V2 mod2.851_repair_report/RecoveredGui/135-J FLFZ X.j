//=========================================================================== 
// Trigger: J FLFZ X
//=========================================================================== 
function InitTrig_J_FLFZ_X takes nothing returns nothing
set gg_trg_J_FLFZ_X=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_FLFZ_X,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_FLFZ_X,Condition(function Trig_J_FLFZ_X_Conditions))
call TriggerAddAction(gg_trg_J_FLFZ_X,function Trig_J_FLFZ_X_Actions)
endfunction

function Trig_J_FLFZ_X_Actions takes nothing returns nothing
set udg_FLFZ=1
loop
exitwhen udg_FLFZ>12
set udg_SP=GetUnitLoc(GetAttacker())
set udg_SP2=GetUnitLoc(udg_J_FLFZ_UNIT[udg_FLFZ])
if(Trig_J_FLFZ_X_Func001Func003C())then
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Undead\\Possession\\PossessionMissile.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
if(Trig_J_FLFZ_X_Func001Func003Func003C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[udg_FLFZ]))/I2R(GetHeroLevel(GetAttacker())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[udg_FLFZ]))/I2R(GetUnitLevel(GetAttacker())))
endif
if(Trig_J_FLFZ_X_Func001Func003Func004C())then
call UnitDamageTargetBJ(udg_HERO[udg_FLFZ],GetAttacker(),(((I2R(GetHeroInt(udg_HERO[udg_FLFZ],true))+udg_JX[udg_FLFZ])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((udg_BUFF_F[udg_FLFZ]*udg_LVsLV)*(1.00+(0.06*I2R(udg_JX_lv[udg_FLFZ]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[udg_FLFZ],GetAttacker(),(((I2R(GetHeroInt(udg_HERO[udg_FLFZ],true))+udg_JX[udg_FLFZ])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*((1.00*udg_LVsLV)*(1.00+(0.06*I2R(udg_JX_lv[udg_FLFZ]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
endif
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
set udg_FLFZ=udg_FLFZ+1
endloop
endfunction

function Trig_J_FLFZ_X_Conditions takes nothing returns boolean
if(not(UnitHasBuffBJ(GetAttacker(),'BUau')==true))then
return false
endif
if(not(IsUnitEnemy(GetAttacker(),GetOwningPlayer(GetAttackedUnitBJ()))==true))then
return false
endif
return true
endfunction