//=========================================================================== 
// Trigger: Cage Cast
//=========================================================================== 
function InitTrig_Cage_Cast takes nothing returns nothing
    set gg_trg_Cage_Cast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cage_Cast, EVENT_PLAYER_UNIT_SPELL_EFFECT )
    call TriggerAddCondition( gg_trg_Cage_Cast, Condition( function Trig_Cage_Cast_Conditions ) )
    call TriggerAddAction( gg_trg_Cage_Cast, function Trig_Cage_Cast_Actions )
endfunction

function Trig_Cage_Cast_Actions takes nothing returns nothing
    set udg_guiCageAnimLock[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] = true
    if ( Trig_Cage_Cast_Func002C() ) then
        call AddSpecialEffectTargetUnitBJ( "origin", GetTriggerUnit(), "Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl" )
        call DestroyEffect( GetLastCreatedEffectBJ() )
        call UnitRemoveBuffBJ( 'gui1', GetTriggerUnit() )
        set udg_guiTempPoint1 = GetUnitLoc(GetTriggerUnit())
    else
        set udg_guiTempPoint1 = GetSpellTargetLoc()
    endif
    call AddSpecialEffectLocBJ( udg_guiTempPoint1, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl" )
    call DestroyEffect( GetLastCreatedEffectBJ() )
    call CreateNUnitsAtLoc( 1, 'hgui', GetOwningPlayer(GetTriggerUnit()), udg_guiTempPoint1, bj_UNIT_FACING )
    call UnitApplyTimedLifeBJ( 9.90, 'BTLF', GetLastCreatedUnit() )
    set udg_guiDarkOrigin[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GetLastCreatedUnit()
    call RemoveLocation (udg_guiTempPoint1)
    set bj_forLoopAIndex = 1
    set bj_forLoopAIndexEnd = 24
    loop
        exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
        set udg_guiTempPoint1 = GetUnitLoc(udg_guiDarkOrigin[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        set udg_guiTempPoint2 = PolarProjectionBJ(udg_guiTempPoint1, 280.00, ( 15.00 * I2R(GetForLoopIndexA()) ))
        call CreateNUnitsAtLoc( 1, 'hgu3', GetOwningPlayer(GetTriggerUnit()), udg_guiTempPoint2, ( ( 15.00 * I2R(GetForLoopIndexA()) ) - 180.00 ) )
        call UnitApplyTimedLifeBJ( 9.90, 'BTLF', GetLastCreatedUnit() )
        call SetUnitPathing( GetLastCreatedUnit(), false )
        call SetUnitPositionLoc( GetLastCreatedUnit(), udg_guiTempPoint2 )
        call GroupAddUnitSimple( GetLastCreatedUnit(), udg_guiDarkDummyGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] )
        call RemoveLocation (udg_guiTempPoint1)
        call RemoveLocation (udg_guiTempPoint2)
        set bj_forLoopAIndex = bj_forLoopAIndex + 1
    endloop
    call StartTimerBJ( udg_guiCageAnimHoldTimer[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))], false, 0.40 )
    call TriggerSleepAction( 0.41 )
    set udg_guiCageAnimLock[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] = false
    // Part 2
    set bj_forLoopBIndex = 1
    set bj_forLoopBIndexEnd = 8
    loop
        exitwhen bj_forLoopBIndex > bj_forLoopBIndexEnd
        set udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GroupPickRandomUnit(udg_guiDarkDummyGroup[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        call UnitAddAbilityBJ( 'Agu9', udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] )
        set udg_guiTempPoint1 = GetUnitLoc(udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
        set udg_guiTempPoint2 = PolarProjectionBJ(udg_guiTempPoint1, 256.00, GetUnitFacing(udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))
        call AddSpecialEffectLocBJ( udg_guiTempPoint2, "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeTarget.mdl" )
        call DestroyEffect( GetLastCreatedEffectBJ() )
        call IssuePointOrderLoc( udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))], "impale", udg_guiTempPoint1 )
        call RemoveLocation (udg_guiTempPoint1)
        call RemoveLocation (udg_guiTempPoint2)
        call TriggerSleepAction( 1.00 )
        call UnitRemoveAbilityBJ( 'Agu9', udg_guiPickedNail[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))] )
        set bj_forLoopBIndex = bj_forLoopBIndex + 1
    endloop
endfunction

function Trig_Cage_Cast_Conditions takes nothing returns boolean
    if ( not ( GetSpellAbilityId() == 'Agu8' ) ) then
        return false
    endif
    return true
endfunction