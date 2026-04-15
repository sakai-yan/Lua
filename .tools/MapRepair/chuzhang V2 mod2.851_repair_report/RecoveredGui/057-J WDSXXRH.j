//=========================================================================== 
// Trigger: J WDSXXRH
//=========================================================================== 
function InitTrig_J_WDSXXRH takes nothing returns nothing
set gg_trg_J_WDSXXRH=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_WDSXXRH,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_WDSXXRH,Condition(function Trig_J_WDSXXRH_Conditions))
call TriggerAddAction(gg_trg_J_WDSXXRH,function Trig_J_WDSXXRH_Actions)
endfunction

function Trig_J_WDSXXRH_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_GROUP=GetUnitsInRangeOfLocMatching(450.00,udg_SP,Condition(function Trig_J_WDSXXRH_Func002002003))
call ForGroupBJ(udg_GROUP,function Trig_J_WDSXXRH_Func003A)
call DestroyGroup(udg_GROUP)
set udg_SP2=PolarProjectionBJ(GetUnitLoc(GetTriggerUnit()),450.00,(GetUnitFacing(GetTriggerUnit())+(10.00*I2R(GetForLoopIndexA()))))
call CreateNUnitsAtLoc(1,'hmtm',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP2)
call RemoveLocation(udg_SP)
endfunction

function Trig_J_WDSXXRH_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A04H'))then
return false
endif
return true
endfunction

function Trig_J_WDSXXRH_Func002002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction