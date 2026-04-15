//=========================================================================== 
// Trigger: attack
//=========================================================================== 
function InitTrig_attack takes nothing returns nothing
set gg_trg_attack=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_attack,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_attack,Condition(function Trig_attack_Conditions))
call TriggerAddAction(gg_trg_attack,function Trig_attack_Actions)
endfunction

function Trig_attack_Actions takes nothing returns nothing
set gg_trg_SkillUpGJ=CreateTrigger()
call TriggerAddCondition(gg_trg_SkillUpGJ,Condition(function Trig_SkillUpGJ_Conditions))
call TriggerAddAction(gg_trg_SkillUpGJ,function Trig_SkillUpGJ_Actions)
call TriggerRegisterUnitEvent(gg_trg_SkillUpGJ,GetTriggerUnit(),EVENT_UNIT_DAMAGED)
if(Trig_attack_Func006C())then
call StartTimerBJ(udg_shulian_time[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false,0.70)
else
endif
endfunction

function Trig_attack_Conditions takes nothing returns boolean
if(not(IsUnitType(GetAttacker(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetAttacker(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetAttacker()))==true))then
return false
endif
if(not(GetPlayerController(GetOwningPlayer(GetAttackedUnitBJ()))!=MAP_CONTROL_USER))then
return false
endif
return true
endfunction

function Trig_SkillUpGJ_Conditions takes nothing returns boolean
if(not(IsUnitType(GetEventDamageSource(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetEventDamageSource(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitEnemy(GetTriggerUnit(),GetOwningPlayer(GetEventDamageSource()))==true))then
return false
endif
if(not(TimerGetRemaining(udg_shulian_time[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])>0.00))then
return false
endif
return true
endfunction

function Trig_SkillUpGJ_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=45
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_SkillUpGJ_Func006Func001C())then
if(Trig_SkillUpGJ_Func006Func001Func001C())then
set udg_Exp_FX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_Exp_FX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
if(Trig_SkillUpGJ_Func006Func001Func001Func002C())then
set udg_Exp_FX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=0
set udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetEventDamageSource()),0,0,30,("你的法杖系熟练度修炼到了第"+(I2S(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+"重")))
call AddSpecialEffectTargetUnitBJ("origin",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
endif
else
endif
else
endif
if(Trig_SkillUpGJ_Func006Func002C())then
if(Trig_SkillUpGJ_Func006Func002Func001C())then
set udg_Exp_DX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_Exp_DX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
if(Trig_SkillUpGJ_Func006Func002Func001Func002C())then
set udg_Exp_DX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=0
set udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetEventDamageSource()),0,0,30,("你的刀系熟练度修炼到了第"+(I2S(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+"重")))
call AddSpecialEffectTargetUnitBJ("origin",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
endif
else
endif
else
endif
if(Trig_SkillUpGJ_Func006Func003C())then
if(Trig_SkillUpGJ_Func006Func003Func001C())then
set udg_Exp_GX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_Exp_GX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
if(Trig_SkillUpGJ_Func006Func003Func001Func002C())then
set udg_Exp_GX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=0
set udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetEventDamageSource()),0,0,30,("你的长柄系熟练度修炼到了第"+(I2S(udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+"重")))
call AddSpecialEffectTargetUnitBJ("origin",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
endif
else
endif
else
endif
if(Trig_SkillUpGJ_Func006Func004C())then
if(Trig_SkillUpGJ_Func006Func004Func001C())then
set udg_Exp_JX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_Exp_JX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
if(Trig_SkillUpGJ_Func006Func004Func001Func002C())then
set udg_Exp_JX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=0
set udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetEventDamageSource()),0,0,30,("你的剑系熟练度修炼到了第"+(I2S(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+"重")))
call AddSpecialEffectTargetUnitBJ("origin",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
endif
else
endif
else
endif
if(Trig_SkillUpGJ_Func006Func005C())then
if(Trig_SkillUpGJ_Func006Func005Func001C())then
set udg_Exp_QX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_Exp_QX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
if(Trig_SkillUpGJ_Func006Func005Func001Func002C())then
set udg_Exp_QX_skill[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=0
set udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]=(udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetEventDamageSource()),0,0,30,("你的拳爪系熟练度修炼到了第"+(I2S(udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))])+"重")))
call AddSpecialEffectTargetUnitBJ("origin",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetEventDamageSource()))],"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
endif
else
endif
else
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call DestroyTrigger(GetTriggeringTrigger())
endfunction