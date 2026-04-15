//=========================================================================== 
// Trigger: Dxxfz44
//=========================================================================== 
function InitTrig_Dxxfz44 takes nothing returns nothing
    set gg_trg_Dxxfz44=CreateTrigger()
    call DisableTrigger(gg_trg_Dxxfz44)
    call TriggerRegisterTimerEventPeriodic(gg_trg_Dxxfz44, 0.03)
    call TriggerAddAction(gg_trg_Dxxfz44, function Trig_Dxxfz44_Actions)
endfunction

function Trig_Dxxfz44_Actions takes nothing returns nothing
    set udg_ZZxf55=( udg_ZZxf55 + 1 )
    call SetUnitPositionLoc(udg_QQxf33[1], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[1]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[1]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[2], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[2]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[2]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[3], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[3]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[3]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[4], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[4]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[4]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[5], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[5]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[5]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[6], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[6]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[6]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[7], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[7]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[7]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitPositionLoc(udg_QQxf33[8], PolarProjectionBJ(GetUnitLoc(udg_QQxf33[8]), udg_SSxf44, ( AngleBetweenPoints(GetUnitLoc(udg_QQxf33[8]), GetUnitLoc(udg_Bxf22)) + 3.00 )))
    call SetUnitFlyHeight(udg_QQxf33[1], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[2], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[3], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[4], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[5], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[6], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[7], 0.00, 1200.00)
    call SetUnitFlyHeight(udg_QQxf33[8], 0.00, 1200.00)
    if ( Trig_Dxxfz44_Func018C() ) then
        call RemoveUnit(udg_QQxf33[1])
        call RemoveUnit(udg_QQxf33[2])
        call RemoveUnit(udg_QQxf33[3])
        call RemoveUnit(udg_QQxf33[4])
        call RemoveUnit(udg_QQxf33[5])
        call RemoveUnit(udg_QQxf33[6])
        call RemoveUnit(udg_QQxf33[7])
        call RemoveUnit(udg_QQxf33[8])
        call AddSpecialEffectLocBJ(GetUnitLoc(udg_Bxf22), "Objects\\Spawnmodels\\Undead\\UCancelDeath\\UCancelDeath.mdl")
        call AddSpecialEffectLocBJ(GetUnitLoc(udg_Bxf22), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 0), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 45.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 90.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 135.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 180.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 225.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 270.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 315.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call AddSpecialEffectLocBJ(PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 50.00, 360.00), "Objects\\Spawnmodels\\Orc\\OrcLargeDeathExplode\\OrcLargeDeathExplode.mdl")
        call TriggerSleepAction(0.05)
        call ConditionalTriggerExecute(gg_trg_Exxfz55)
    else
    endif
    if ( Trig_Dxxfz44_Func019C() ) then
        set udg_ZZxf55=0
        call DisableTrigger(GetTriggeringTrigger())
    else
    endif
endfunction