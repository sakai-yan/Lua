//=========================================================================== 
// Trigger: J HYZ
//=========================================================================== 
function InitTrig_J_HYZ takes nothing returns nothing
set gg_trg_J_HYZ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_HYZ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_HYZ,Condition(function Trig_J_HYZ_Conditions))
call TriggerAddAction(gg_trg_J_HYZ,function Trig_J_HYZ_Actions)
endfunction

function Trig_J_HYZ_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetSpellTargetUnit())
call AddSpecialEffectTargetUnitBJ("overhead",GetSpellTargetUnit(),"WaterFlash.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
call AddSpecialEffectTargetUnitBJ("overhead",GetSpellTargetUnit(),"WaterFlash.mdx")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(256.00,udg_SP,Condition(function Trig_J_HYZ_Func006002003))
call ForGroupBJ(udg_GROUP,function Trig_J_HYZ_Func007A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
endfunction

function Trig_J_HYZ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AHbn'))then
return false
endif
return true
endfunction

function Trig_J_HYZ_Func006002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction