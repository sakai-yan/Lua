//=========================================================================== 
// Trigger: group KILL
//=========================================================================== 
function InitTrig_group_KILL takes nothing returns nothing
set gg_trg_group_KILL=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_group_KILL,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_group_KILL,Condition(function Trig_group_KILL_Conditions))
call TriggerAddAction(gg_trg_group_KILL,function Trig_group_KILL_Actions)
endfunction

function Trig_group_KILL_Actions takes nothing returns nothing
call SetMapFlag(MAP_LOCK_ALLIANCE_CHANGES,true)
call SetMapFlag(MAP_ALLIANCE_CHANGES_HIDDEN,true)
if(Trig_group_KILL_Func003C())then
call ForForce(GetPlayersAll(),function Trig_group_KILL_Func003Func002A)
call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()),GetOwningPlayer(GetSpellTargetUnit()),bj_ALLIANCE_UNALLIED)
call SetPlayerAllianceStateBJ(GetOwningPlayer(GetSpellTargetUnit()),GetOwningPlayer(GetTriggerUnit()),bj_ALLIANCE_UNALLIED)
else
if(Trig_group_KILL_Func003Func001C())then
call ForForce(GetPlayersAll(),function Trig_group_KILL_Func003Func001Func001A)
call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()),GetOwningPlayer(GetSpellTargetUnit()),bj_ALLIANCE_ALLIED)
call SetPlayerAllianceStateBJ(GetOwningPlayer(GetSpellTargetUnit()),GetOwningPlayer(GetTriggerUnit()),bj_ALLIANCE_ALLIED)
else
endif
endif
endfunction

function Trig_group_KILL_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A03N'))then
return false
endif
if(not(GetPlayerController(GetOwningPlayer(GetSpellTargetUnit()))==MAP_CONTROL_USER))then
return false
endif
if(not(IsUnitType(GetSpellTargetUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction