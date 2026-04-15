//=========================================================================== 
// Trigger: Cxxfz33
//=========================================================================== 
function InitTrig_Cxxfz33 takes nothing returns nothing
    set gg_trg_Cxxfz33=CreateTrigger()
    call TriggerAddAction(gg_trg_Cxxfz33, function Trig_Cxxfz33_Actions)
endfunction

function Trig_Cxxfz33_Actions takes nothing returns nothing
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 0.00), bj_UNIT_FACING)
    set udg_QQxf33[1]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 40.00), bj_UNIT_FACING)
    set udg_QQxf33[2]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 80.00), bj_UNIT_FACING)
    set udg_QQxf33[3]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 120.00), bj_UNIT_FACING)
    set udg_QQxf33[4]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 160.00), bj_UNIT_FACING)
    set udg_QQxf33[5]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 200.00), bj_UNIT_FACING)
    set udg_QQxf33[6]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 240.00), bj_UNIT_FACING)
    set udg_QQxf33[7]=GetLastCreatedUnit()
    call CreateNUnitsAtLoc(1, 'xxz1', GetOwningPlayer(GetTriggerUnit()), PolarProjectionBJ(GetUnitLoc(udg_Bxf22), 312.00, 280.00), bj_UNIT_FACING)
    set udg_QQxf33[8]=GetLastCreatedUnit()
    call TriggerSleepAction(0.05)
    set udg_SSxf44=( DistanceBetweenPoints(GetUnitLoc(udg_QQxf33[1]), GetUnitLoc(udg_Bxf22)) / 15.00 )
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[1], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[2], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[3], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[4], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[5], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[6], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[7], udg_Bxf22, 0)
    call SetUnitFacingToFaceUnitTimed(udg_QQxf33[8], udg_Bxf22, 0)
    call TriggerSleepAction(0.10)
    call EnableTrigger(gg_trg_Dxxfz44)
endfunction