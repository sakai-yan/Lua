//=========================================================================== 
// Trigger: kuangshi 4x
//=========================================================================== 
function InitTrig_kuangshi_4x takes nothing returns nothing
set gg_trg_kuangshi_4x=CreateTrigger()
call TriggerAddAction(gg_trg_kuangshi_4x,function Trig_kuangshi_4x_Actions)
endfunction

function Trig_kuangshi_4x_Actions takes nothing returns nothing
call CreateItemLoc('tmmt',GetDestructableLoc(GetDyingDestructable()))
call PolledWait(GetRandomReal(60.00,120.00))
set udg_SP2=GetRectCenter(udg_tree[GetRandomInt(1,13)])
call CreateDestructableLoc('NTtw',udg_SP2,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_4xx,GetLastCreatedDestructable())
call RemoveLocation(udg_SP2)
endfunction