//=========================================================================== 
// Trigger: J HY
//=========================================================================== 
function InitTrig_J_HY takes nothing returns nothing
set gg_trg_J_HY=CreateTrigger()
call TriggerAddCondition(gg_trg_J_HY,Condition(function Trig_J_HY_Conditions))
call TriggerAddAction(gg_trg_J_HY,function Trig_J_HY_Actions)
endfunction

function Trig_J_HY_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"FlameBomb.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"FlameBomb.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
call AddSpecialEffectTargetUnitBJ("overhead",GetTriggerUnit(),"FlameBomb.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(250.00,udg_SP,Condition(function Trig_J_HY_Func009002003))
call ForGroupBJ(udg_GROUP,function Trig_J_HY_Func010A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
call RemoveUnit(GetEventDamageSource())
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_J_HY_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetEventDamageSource())=='e000'))then
return false
endif
return true
endfunction

function Trig_J_HY_Func009002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetEventDamageSource()))==true)
endfunction