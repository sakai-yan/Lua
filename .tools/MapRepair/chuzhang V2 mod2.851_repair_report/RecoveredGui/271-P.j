//=========================================================================== 
// Trigger: P
//=========================================================================== 
function InitTrig_P takes nothing returns nothing
set gg_trg_P=CreateTrigger()
call TriggerAddAction(gg_trg_P,function Trig_P_Actions)
endfunction

function Trig_P_Actions takes nothing returns nothing
call ForGroupBJ(GetUnitsOfPlayerAll(Player(PLAYER_NEUTRAL_AGGRESSIVE)),function Trig_P_Func001A)
endfunction