//=========================================================================== 
// Trigger: Cage Pre Cast
//=========================================================================== 
function InitTrig_Cage_Pre_Cast takes nothing returns nothing
    set gg_trg_Cage_Pre_Cast = CreateTrigger(  )
    call TriggerRegisterAnyUnitEventBJ( gg_trg_Cage_Pre_Cast, EVENT_PLAYER_UNIT_SPELL_CHANNEL )
    call TriggerAddCondition( gg_trg_Cage_Pre_Cast, Condition( function Trig_Cage_Pre_Cast_Conditions ) )
    call TriggerAddAction( gg_trg_Cage_Pre_Cast, function Trig_Cage_Pre_Cast_Actions )
endfunction

function Trig_Cage_Pre_Cast_Actions takes nothing returns nothing
    set udg_guiTempPoint1 = GetSpellTargetLoc()
    call AddSpecialEffectLocBJ( udg_guiTempPoint1, "Abilities\\Spells\\Demon\\DarkPortal\\DarkPortalTarget.mdl" )
    call DestroyEffect( GetLastCreatedEffectBJ() )
    set bj_forLoopAIndex = 1
    set bj_forLoopAIndexEnd = 24
    loop
 //call UnitDamagePoint   ( udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))], 0, 500,udg_guiTempPoint1, (((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(1.40+(0.16*I2R(udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))*2),, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS )
        exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
        set udg_guiTempPoint2 = PolarProjectionBJ(udg_guiTempPoint1, 280.00, ( 15.00 * I2R(GetForLoopIndexA()) ))
        call CreateNUnitsAtLoc( 1, 'hgui', GetOwningPlayer(GetTriggerUnit()), udg_guiTempPoint2, ( ( 15.00 * I2R(GetForLoopIndexA()) ) - 180.00 ) )
        call UnitApplyTimedLifeBJ( 1.00, 'BTLF', GetLastCreatedUnit() )
        call UnitAddAbilityBJ( 'AguH', GetLastCreatedUnit() )
        call IssuePointOrderLoc( GetLastCreatedUnit(), "flamestrike", udg_guiTempPoint2 )
        call RemoveLocation (udg_guiTempPoint2)
        set bj_forLoopAIndex = bj_forLoopAIndex + 1
    endloop
    call RemoveLocation (udg_guiTempPoint1)
endfunction

function Trig_Cage_Pre_Cast_Conditions takes nothing returns boolean
    if ( not ( GetSpellAbilityId() == 'Agu8' ) ) then
        return false                //
    endif
    return true
endfunction