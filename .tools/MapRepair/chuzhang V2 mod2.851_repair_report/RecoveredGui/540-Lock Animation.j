//=========================================================================== 
// Trigger: Lock Animation
//=========================================================================== 
function InitTrig_Lock_Animation takes nothing returns nothing
    set gg_trg_Lock_Animation = CreateTrigger(  )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[1] )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[2] )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[3] )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[4] )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[5] )
    call TriggerRegisterTimerExpireEventBJ( gg_trg_Lock_Animation, udg_guiCageAnimHoldTimer[6] )
    call TriggerAddAction( gg_trg_Lock_Animation, function Trig_Lock_Animation_Actions )
endfunction

function Trig_Lock_Animation_Actions takes nothing returns nothing
    set bj_forLoopAIndex = 1
    set bj_forLoopAIndexEnd = 6
    loop
        exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
        if ( Trig_Lock_Animation_Func001Func001C() ) then
            call ForGroupBJ( udg_guiDarkDummyGroup[GetForLoopIndexA()], function Trig_Lock_Animation_Func001Func001Func002A )
        else
        endif
        set bj_forLoopAIndex = bj_forLoopAIndex + 1
    endloop
endfunction