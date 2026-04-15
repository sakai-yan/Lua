//=========================================================================== 
// Trigger: J SHSYWH
//=========================================================================== 
function InitTrig_J_SHSYWH takes nothing returns nothing
set gg_trg_J_SHSYWH=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_SHSYWH,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_SHSYWH,Condition(function Trig_J_SHSYWH_Conditions))
call TriggerAddAction(gg_trg_J_SHSYWH,function Trig_J_SHSYWH_Actions)
endfunction

function Trig_J_SHSYWH_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
if(Trig_J_SHSYWH_Func002C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetHeroLevel(GetSpellTargetUnit())))
if(Trig_J_SHSYWH_Func002Func002C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*1.00))*(2.00+(0.10*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*1.00))*(2.00+(0.10*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetUnitLevel(GetSpellTargetUnit())))
if(Trig_J_SHSYWH_Func002Func004C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(udg_LVsLV*1.00))*(2.00+(0.35*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1.00*(udg_LVsLV*1.00))*(2.00+(0.35*I2R(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
endif
call CreateNUnitsAtLoc(1,'e004',GetOwningPlayer(GetSpellTargetUnit()),udg_SP,bj_UNIT_FACING)
call SetUnitPathing(GetLastCreatedUnit(),false)
call UnitApplyTimedLife(GetLastCreatedUnit(),'BHwe',1.00)
call IssueTargetOrder(GetLastCreatedUnit(),"creepthunderbolt",GetTriggerUnit())
call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl",GetSpellTargetUnit(),"chest"))
call RemoveLocation(udg_SP)
endfunction

function Trig_J_SHSYWH_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A04K'))then
return false
endif
return true
endfunction