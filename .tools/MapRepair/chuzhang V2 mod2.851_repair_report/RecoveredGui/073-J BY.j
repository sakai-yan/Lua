//=========================================================================== 
// Trigger: J BY
//=========================================================================== 
function InitTrig_J_BY takes nothing returns nothing
set gg_trg_J_BY=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_BY,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_BY,Condition(function Trig_J_BY_Conditions))
call TriggerAddAction(gg_trg_J_BY,function Trig_J_BY_Actions)
endfunction

function Trig_J_BY_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"ApocalypseCowStomp.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
call AddSpecialEffectLocBJ(udg_SP,"ApocalypseCowStomp.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
call AddSpecialEffectLocBJ(udg_SP,"ApocalypseCowStomp.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(400.00,udg_SP,Condition(function Trig_J_BY_Func010002003))
call ForGroupBJ(udg_GROUP,function Trig_J_BY_Func011A)
call DestroyGroup(udg_GROUP)
set udg_GROUP2=GetUnitsInRangeOfLocMatching(800.00,udg_SP,Condition(function Trig_J_BY_Func013002003))
call ForGroupBJ(udg_GROUP2,function Trig_J_BY_Func014A)
call DestroyGroup(udg_GROUP2)
call RemoveLocation(udg_SP)
endfunction

function Trig_J_BY_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Awrs'))then
return false
endif
return true
endfunction

function Trig_J_BY_Func010002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction

function Trig_J_BY_Func013002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction