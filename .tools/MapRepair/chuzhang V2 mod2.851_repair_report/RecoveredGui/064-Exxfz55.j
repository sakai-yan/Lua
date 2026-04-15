//=========================================================================== 
// Trigger: Exxfz55
//=========================================================================== 
function InitTrig_Exxfz55 takes nothing returns nothing
    set gg_trg_Exxfz55=CreateTrigger()
    call TriggerAddAction(gg_trg_Exxfz55, function Trig_Exxfz55_Actions)
endfunction

function Trig_Exxfz55_Actions takes nothing returns nothing
    set bj_forLoopAIndex=1
    set bj_forLoopAIndexEnd=10
    loop
        exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
        call RemoveUnit(udg_QQxf33[9])
      //  call RemoveUnit(udg_Bxf22)
        set bj_forLoopAIndex=bj_forLoopAIndex + 1
    endloop
endfunction