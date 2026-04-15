//=========================================================================== 
// Trigger: fBSCL
//=========================================================================== 
function InitTrig_fBSCL takes nothing returns nothing
set gg_trg_fBSCL=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_fBSCL,1.00)
call TriggerAddAction(gg_trg_fBSCL,function Trig_fBSCL_Actions)
endfunction

function Trig_fBSCL_Actions takes nothing returns nothing
if(Trig_fBSCL_Func001C())then
set udg_TIME[0]=GetTick(0)
set udg_TIME[1]=udg_TIME[0]
else
set udg_TIME[0]=GetTick(0)
set udg_TIME[1]=(udg_TIME[1]+1)
endif
if(Trig_fBSCL_Func002C())then
call ForForce(GetPlayersAll(),function Trig_fBSCL_Func002Func001A)
else
endif
endfunction