//=========================================================================== 
// Trigger: Regrow Trees
//=========================================================================== 
function InitTrig_Regrow_Trees takes nothing returns nothing
set gg_trg_Regrow_Trees=CreateTrigger()
call TriggerRegisterDestDeathInRegionEvent(gg_trg_Regrow_Trees,gg_rct______________146)
call TriggerAddAction(gg_trg_Regrow_Trees,function Trig_Regrow_Trees_Actions)
endfunction

function Trig_Regrow_Trees_Actions takes nothing returns nothing
if(Trig_Regrow_Trees_Func001C())then
call CreateItemLoc('I02H',GetDestructableLoc(GetDyingDestructable()))
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=12
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_Regrow_Trees_Func001Func003Func001C())then
call DisplayTextToPlayer(ConvertedPlayer(bj_forLoopAIndex),0,0,"|cFF00FFFF有人挖出了一颗奇特的蘑菇！！|r")
else
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
else
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=12
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_Regrow_Trees_Func001Func001Func001C())then
call DisplayTextToPlayer(ConvertedPlayer(bj_forLoopAIndex),0,0,"有人好不容易把蘑菇挖了出来，发现这只是普通的蘑菇~~~~~")
else
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
endif
call TriggerSleepAction(1.00)
call SetDestructableAnimation(GetDyingDestructable(),"Birth")
call SetDestAnimationSpeedPercent(GetDyingDestructable(),5.00)
call TriggerSleepAction(70.20)
call SetDestructableAnimation(GetDyingDestructable(),"stand")
call SetDestAnimationSpeedPercent(GetDyingDestructable(),100.00)
call DestructableRestoreLife(GetDyingDestructable(),GetDestructableMaxLife(GetLastCreatedDestructable()),false)
endfunction