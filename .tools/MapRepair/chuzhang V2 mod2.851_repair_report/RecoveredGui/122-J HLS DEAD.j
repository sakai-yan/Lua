//=========================================================================== 
// Trigger: J HLS DEAD
//=========================================================================== 
function InitTrig_J_HLS_DEAD takes nothing returns nothing
set gg_trg_J_HLS_DEAD=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_HLS_DEAD,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_J_HLS_DEAD,Condition(function Trig_J_HLS_DEAD_Conditions))
call TriggerAddAction(gg_trg_J_HLS_DEAD,function Trig_J_HLS_DEAD_Actions)
endfunction

function Trig_J_HLS_DEAD_Actions takes nothing returns nothing
if(Trig_J_HLS_DEAD_Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
set udg_GROUP=GetUnitsInRangeOfLocMatching(300.00,udg_SP,Condition(function Trig_J_HLS_DEAD_Func001Func004002003))
call ForGroupBJ(udg_GROUP,function Trig_J_HLS_DEAD_Func001Func005A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_J_HLS_DEAD_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())==udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))then
return false
endif
return true
endfunction

function Trig_J_HLS_DEAD_Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction