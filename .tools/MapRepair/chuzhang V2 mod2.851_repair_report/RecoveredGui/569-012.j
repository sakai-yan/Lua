//=========================================================================== 
// Trigger: 012
//=========================================================================== 
function InitTrig____________________012 takes nothing returns nothing
set gg_trg____________________012=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg____________________012,1.00)
call TriggerAddAction(gg_trg____________________012,function Trig____________________012_Actions)
endfunction

function Trig____________________012_Actions takes nothing returns nothing
set udg_FZB=1
loop
exitwhen udg_FZB>12
if(Trig____________________012_Func001Func001C())then
set udg_V_00[udg_FZB]=1000

else
endif
set udg_FZB=udg_FZB+1
endloop
endfunction