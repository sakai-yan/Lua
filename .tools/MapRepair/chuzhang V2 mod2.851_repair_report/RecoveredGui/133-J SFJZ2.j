//=========================================================================== 
// Trigger: J SFJZ2
//=========================================================================== 
function InitTrig_J_SFJZ2 takes nothing returns nothing
set gg_trg_J_SFJZ2=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_SFJZ2,0.25)
call TriggerAddAction(gg_trg_J_SFJZ2,function Trig_J_SFJZ2_Actions)
endfunction

function Trig_J_SFJZ2_Actions takes nothing returns nothing
set udg_SFJZ2=1
loop
exitwhen udg_SFJZ2>18   /////////////////////       ʮ������
if(Trig_J_SFJZ2_Func001Func001C())then
set udg_J_SFJZ_num[udg_SFJZ2]=(udg_J_SFJZ_num[udg_SFJZ2]+1)
if(Trig_J_SFJZ2_Func001Func001Func003C())then
set udg_J_SFJZ_group[udg_SFJZ2]=GetUnitsInRangeOfLocMatching(600.00,udg_J_SFJZ_P[udg_SFJZ2],Condition(function Trig_J_SFJZ2_Func001Func001Func003Func005002003))
if(Trig_J_SFJZ2_Func001Func001Func003Func006C())then
set udg_J_SFJZ[udg_SFJZ2]=GroupPickRandomUnit(udg_J_SFJZ_group[udg_SFJZ2])
call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",udg_J_SFJZ[udg_SFJZ2],"chest"))
set udg_SP2=GetUnitLoc(udg_J_SFJZ[udg_SFJZ2])
call SetUnitAnimation(udg_J_SFJZ_unit[udg_SFJZ2],"Attack Slam")
call SetUnitPositionLoc(udg_J_SFJZ_unit[udg_SFJZ2],udg_SP2)
if(Trig_J_SFJZ2_Func001Func001Func003Func006Func006C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[udg_SFJZ2]))/I2R(GetHeroLevel(udg_J_SFJZ[udg_SFJZ2])))
if(Trig_J_SFJZ2_Func001Func001Func003Func006Func006Func004C())then
call UnitDamageTargetBJ(udg_HERO[udg_SFJZ2],udg_J_SFJZ[udg_SFJZ2],((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[udg_SFJZ2],false))+2*udg_JX[udg_SFJZ2])*((udg_BUFF_Z[udg_SFJZ2]*udg_LVsLV)*(1.20+(0.03*I2R(udg_JX_lv[udg_SFJZ2]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[udg_SFJZ2],udg_J_SFJZ[udg_SFJZ2],((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[udg_SFJZ2],false))+2*udg_JX[udg_SFJZ2])*((1.00*udg_LVsLV)*(1.20+(0.03*I2R(udg_JX_lv[udg_SFJZ2]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[udg_SFJZ2]))/I2R(GetUnitLevel(udg_J_SFJZ[udg_SFJZ2])))
if(Trig_J_SFJZ2_Func001Func001Func003Func006Func006Func002C())then
call UnitDamageTargetBJ(udg_HERO[udg_SFJZ2],udg_J_SFJZ[udg_SFJZ2],((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[udg_SFJZ2],false))+2*udg_JX[udg_SFJZ2])*((udg_BUFF_Z[udg_SFJZ2]*udg_LVsLV)*(1.20+(0.04*I2R(udg_JX_lv[udg_SFJZ2]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[udg_SFJZ2],udg_J_SFJZ[udg_SFJZ2],((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[udg_SFJZ2],false))+2*udg_JX[udg_SFJZ2])*((1.00*udg_LVsLV)*(1.20+(0.04*I2R(udg_JX_lv[udg_SFJZ2]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
call RemoveLocation(udg_SP2)
else
call UnitRemoveAbilityBJ('A04E',udg_J_SFJZ_unit[udg_SFJZ2])
call SetUnitPositionLoc(udg_J_SFJZ_unit[udg_SFJZ2],udg_J_SFJZ_P[udg_SFJZ2])
set udg_J_SFJZ_unit[udg_SFJZ2]=null
call RemoveLocation(udg_J_SFJZ_P[udg_SFJZ2])
endif
call DestroyGroup(udg_J_SFJZ_group[udg_SFJZ2])
set udg_J_SFJZ_group[udg_SFJZ2]=CreateGroup()
else
call UnitRemoveAbilityBJ('A04E',udg_J_SFJZ_unit[udg_SFJZ2])
call SetUnitPositionLoc(udg_J_SFJZ_unit[udg_SFJZ2],udg_J_SFJZ_P[udg_SFJZ2])
set udg_J_SFJZ_unit[udg_SFJZ2]=null
call RemoveLocation(udg_J_SFJZ_P[udg_SFJZ2])
endif
else
endif
set udg_SFJZ2=udg_SFJZ2+1
endloop
endfunction

function Trig_J_SFJZ2_Func001Func001Func003Func005002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_SFJZ2_Func001Func001Func003Func005002003001(),Trig_J_SFJZ2_Func001Func001Func003Func005002003002())
endfunction