//=========================================================================== 
// Trigger: J YXZ DEAD
//=========================================================================== 
function InitTrig_J_YXZ_DEAD takes nothing returns nothing
set gg_trg_J_YXZ_DEAD=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_YXZ_DEAD,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_J_YXZ_DEAD,function Trig_J_YXZ_DEAD_Actions)
endfunction

function Trig_J_YXZ_DEAD_Actions takes nothing returns nothing
if(Trig_J_YXZ_DEAD_Func001C())then
call KillUnit(udg_J_YXZ_UNIT2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_YXZ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
set udg_J_YXZ_UNIT2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
else
endif
if(Trig_J_YXZ_DEAD_Func002C())then
call KillUnit(udg_J_YXZ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_YXZ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
set udg_J_YXZ_UNIT2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
else
endif
endfunction