//=========================================================================== 
// Trigger: kuangshi 3x
//=========================================================================== 
function InitTrig_kuangshi_3x takes nothing returns nothing
set gg_trg_kuangshi_3x=CreateTrigger()
call TriggerAddAction(gg_trg_kuangshi_3x,function Trig_kuangshi_3x_Actions)
endfunction

function Trig_kuangshi_3x_Actions takes nothing returns nothing
call CreateItemLoc('asbl',GetDestructableLoc(GetDyingDestructable()))
call PolledWait(GetRandomReal(60.00,120.00))
set udg_SP2=GetRectCenter(udg_li[GetRandomInt(1,15)])
call CreateDestructableLoc('DTsh',udg_SP2,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_3xx,GetLastCreatedDestructable())
call RemoveLocation(udg_SP2)
endfunction