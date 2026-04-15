//=========================================================================== 
// Trigger: kuangshi 2x
//=========================================================================== 
function InitTrig_kuangshi_2x takes nothing returns nothing
set gg_trg_kuangshi_2x=CreateTrigger()
call TriggerAddAction(gg_trg_kuangshi_2x,function Trig_kuangshi_2x_Actions)
endfunction

function Trig_kuangshi_2x_Actions takes nothing returns nothing
call CreateItemLoc('amrc',GetDestructableLoc(GetDyingDestructable()))
call PolledWait(GetRandomReal(60.00,120.00))
set udg_SP2=GetRectCenter(udg_tong[GetRandomInt(1,20)])
call CreateDestructableLoc('OTtw',udg_SP2,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_2xx,GetLastCreatedDestructable())
call RemoveLocation(udg_SP2)
endfunction