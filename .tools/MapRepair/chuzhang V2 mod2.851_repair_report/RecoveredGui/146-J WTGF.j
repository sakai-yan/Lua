//=========================================================================== 
// Trigger: J WTGF
//=========================================================================== 
function InitTrig_J_WTGF takes nothing returns nothing
set gg_trg_J_WTGF=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_WTGF,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_WTGF,Condition(function Trig_J_WTGF_Conditions))
call TriggerAddAction(gg_trg_J_WTGF,function Trig_J_WTGF_Actions)
endfunction

function Trig_J_WTGF_Actions takes nothing returns nothing
if(Trig_J_WTGF_Func001C())then
call SetUnitAnimation(GetAttacker(),"Attack Slam")
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(250.00,udg_SP,Condition(function Trig_J_WTGF_Func001Func004002003))
call ForGroupBJ(udg_GROUP,function Trig_J_WTGF_Func001Func005A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_J_WTGF_Conditions takes nothing returns boolean
if(not(GetUnitAbilityLevelSwapped('A04F',GetAttacker())==1))then
return false
endif
return true
endfunction

function Trig_J_WTGF_Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetAttacker()))==true)
endfunction