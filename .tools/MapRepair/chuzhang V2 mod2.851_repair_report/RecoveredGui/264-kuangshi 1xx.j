//=========================================================================== 
// Trigger: kuangshi 1xx
//=========================================================================== 
function InitTrig_kuangshi_1xx takes nothing returns nothing
set gg_trg_kuangshi_1xx=CreateTrigger()
call TriggerAddAction(gg_trg_kuangshi_1xx,function Trig_kuangshi_1xx_Actions)
endfunction

function Trig_kuangshi_1xx_Actions takes nothing returns nothing
call CreateItemLoc('fgun',GetDestructableLoc(GetDyingDestructable()))
call PolledWait(GetRandomReal(60.00,120.00))
set udg_SP2=GetRandomLocInRect(udg_tie[GetRandomInt(1,24)])
call CreateDestructableLoc('BTtw',udg_SP2,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_1x,GetLastCreatedDestructable())
call RemoveLocation(udg_SP2)
endfunction