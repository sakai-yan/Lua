//=========================================================================== 
// Trigger: J LLS
//=========================================================================== 
function InitTrig_J_LLS takes nothing returns nothing
set gg_trg_J_LLS=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_LLS,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_LLS,Condition(function Trig_J_LLS_Conditions))
call TriggerAddAction(gg_trg_J_LLS,function Trig_J_LLS_Actions)
endfunction

function Trig_J_LLS_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=40
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP2=PolarProjectionBJ(GetUnitLoc(GetSpellTargetUnit()),250.00,(GetUnitFacing(GetTriggerUnit())*(9.00+I2R(GetForLoopIndexA()))))
call AddSpecialEffectLocBJ(udg_SP2,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP2)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=20
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP2=PolarProjectionBJ(GetUnitLoc(GetSpellTargetUnit()),120.00,(GetUnitFacing(GetTriggerUnit())*(18.00+I2R(GetForLoopIndexA()))))
call AddSpecialEffectLocBJ(udg_SP2,"Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP2)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
set udg_GROUP=GetUnitsInRangeOfLocMatching(300.00,udg_SP,Condition(function Trig_J_LLS_Func004002003))
call ForGroupBJ(udg_GROUP,function Trig_J_LLS_Func005A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
endfunction

function Trig_J_LLS_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A045'))then
return false
endif
return true
endfunction

function Trig_J_LLS_Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction