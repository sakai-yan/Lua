//=========================================================================== 
// Trigger: bsk
//=========================================================================== 
function InitTrig_bsk takes nothing returns nothing
set gg_trg_bsk=CreateTrigger()
call TriggerAddCondition(gg_trg_bsk,Condition(function Trig_bsk_Conditions))
call TriggerAddAction(gg_trg_bsk,function Trig_bsk_Actions)
endfunction

function Trig_bsk_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_bsk_Func003C())then
if(Trig_bsk_Func003Func001001())then
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())+I2R(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
else
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())+GetEventDamage()))
endif
else
endif
if(Trig_bsk_Func005C())then
if(Trig_bsk_Func005Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.50),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*50.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_bsk_Func007C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetEventDamageSource())+(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())*0.08)))
else
endif
if(Trig_bsk_Func008C())then
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*0.05)))
else
endif
if(Trig_bsk_Func009C())then
call SetUnitManaBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_MANA,GetEventDamageSource())+(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetEventDamageSource())*0.10)))
else
endif
if(Trig_bsk_Func010C())then
call SetUnitManaBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],(GetUnitStateSwap(UNIT_STATE_MANA,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+(GetUnitStateSwap(UNIT_STATE_MAX_MANA,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])*0.07)))
else
endif
if(Trig_bsk_Func012C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_bsk_Func012Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetHeroLevel(GetTriggerUnit())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetUnitLevel(GetTriggerUnit())))
endif
if(Trig_bsk_Func012Func006C())then
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+0.00)*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(0.80+(0.03*I2R(GetHeroLevel(GetEventDamageSource())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+0.00)*((1.00*udg_LVsLV)*(0.80+(0.03*I2R(GetHeroLevel(GetEventDamageSource())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
endif
if(Trig_bsk_Func013C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Weapons\\GlaiveMissile\\GlaiveMissileTarget.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP)
if(Trig_bsk_Func013Func005C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetHeroLevel(GetTriggerUnit())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]))/I2R(GetUnitLevel(GetTriggerUnit())))
endif
if(Trig_bsk_Func013Func006C())then
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+0.00)*((udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]*udg_LVsLV)*(0.80+(0.03*I2R(GetHeroLevel(GetEventDamageSource())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(GetEventDamageSource(),GetTriggerUnit(),((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],false))+0.00)*((1.00*udg_LVsLV)*(0.80+(0.03*I2R(GetHeroLevel(GetEventDamageSource())))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
else
endif
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_bsk_Conditions takes nothing returns boolean
if(not(GetEventDamage()>0.00))then
return false
endif
return true
endfunction