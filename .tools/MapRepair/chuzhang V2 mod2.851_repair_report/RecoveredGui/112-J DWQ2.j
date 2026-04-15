//=========================================================================== 
// Trigger: J DWQ2
//=========================================================================== 
function InitTrig_J_DWQ2 takes nothing returns nothing
set gg_trg_J_DWQ2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_DWQ2,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_DWQ2,Condition(function Trig_J_DWQ2_Conditions))
call TriggerAddAction(gg_trg_J_DWQ2,function Trig_J_DWQ2_Actions)
endfunction

function Trig_J_DWQ2_Actions takes nothing returns nothing
if(Trig_J_DWQ2_Func001C())then
call SetUnitAnimation(GetAttacker(),"Attack Slam")
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(250.00,udg_SP,Condition(function Trig_J_DWQ2_Func001Func004002003))
call ForGroupBJ(udg_GROUP,function Trig_J_DWQ2_Func001Func005A)
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_J_DWQ2_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('A04J',GetAttacker())==1))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('Aflk',GetAttacker())==1))then
return false
endif
return true
endfunction

function Trig_J_DWQ2_Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetAttacker()))==true)
endfunction