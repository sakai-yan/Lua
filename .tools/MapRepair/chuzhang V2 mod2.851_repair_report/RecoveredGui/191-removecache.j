//=========================================================================== 
// Trigger: removecache
//=========================================================================== 
function InitTrig_removecache takes nothing returns nothing
set gg_trg_removecache=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_removecache,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddAction(gg_trg_removecache,function Trig_removecache_Actions)
endfunction

function Trig_removecache_Actions takes nothing returns nothing
if(Trig_removecache_Func001C())then
call FlushStoredMission(udg_Cache,H2S(GetManipulatedItem()))
else
if(Trig_removecache_Func001Func001C())then
call FlushStoredMission(udg_Cache,H2S(GetManipulatedItem()))
else
endif
endif
endfunction