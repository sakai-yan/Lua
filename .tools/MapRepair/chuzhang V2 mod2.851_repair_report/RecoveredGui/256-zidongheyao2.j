//=========================================================================== 
// Trigger: zidongheyao2
//=========================================================================== 
function InitTrig_zidongheyao2 takes nothing returns nothing
set gg_trg_zidongheyao2=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_zidongheyao2,5.00)
call TriggerAddAction(gg_trg_zidongheyao2,function Trig_zidongheyao2_Actions)
endfunction

function Trig_zidongheyao2_Actions takes nothing returns nothing
set udg_BBtime2=1
loop
exitwhen udg_BBtime2>12
if(Trig_zidongheyao2_Func001Func001C())then
call UnitUseItem(udg_HERO_BB[udg_BBtime2],UnitItemInSlotBJ(udg_HERO_BB[udg_BBtime2],1))
else
endif
if(Trig_zidongheyao2_Func001Func002C())then
call UnitUseItem(udg_HERO_BB[udg_BBtime2],UnitItemInSlotBJ(udg_HERO_BB[udg_BBtime2],2))
else
endif
set udg_BBtime2=udg_BBtime2+1
endloop
endfunction