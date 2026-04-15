//=========================================================================== 
// Trigger: set goldandwood
//=========================================================================== 
function InitTrig_set_goldandwood takes nothing returns nothing
set gg_trg_set_goldandwood=CreateTrigger()
call DisableTrigger(gg_trg_set_goldandwood)
call TriggerRegisterTimerEventPeriodic(gg_trg_set_goldandwood,0.50)
call TriggerAddAction(gg_trg_set_goldandwood,function Trig_set_goldandwood_Actions)
endfunction

function Trig_set_goldandwood_Actions takes nothing returns nothing
set udg_G=1
loop
exitwhen udg_G>12
if(Trig_set_goldandwood_Func001Func001C())then
call SetPlayerStateBJ(ConvertedPlayer(udg_G),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[udg_G])
else
endif
set udg_G=udg_G+1
endloop
call SetMapFlag(MAP_LOCK_RESOURCE_TRADING,true)
call SetMapFlag(MAP_RESOURCE_TRADING_ALLIES_ONLY,true)
call SetMapFlag(MAP_LOCK_ALLIANCE_CHANGES,true)
call SetMapFlag(MAP_ALLIANCE_CHANGES_HIDDEN,true)
endfunction