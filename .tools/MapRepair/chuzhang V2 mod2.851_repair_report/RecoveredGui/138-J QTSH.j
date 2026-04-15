//=========================================================================== 
// Trigger: J QTSH
//=========================================================================== 
function InitTrig_J_QTSH takes nothing returns nothing
set gg_trg_J_QTSH=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_QTSH,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_QTSH,Condition(function Trig_J_QTSH_Conditions))
call TriggerAddAction(gg_trg_J_QTSH,function Trig_J_QTSH_Actions)
endfunction

function Trig_J_QTSH_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'ewsp',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueImmediateOrder(GetLastCreatedUnit(),"howlofterror")
call CreateNUnitsAtLoc(1,'e000',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"devourmagic",udg_SP)
set udg_GROUP=GetUnitsInRangeOfLocMatching(410.00,udg_SP,Condition(function Trig_J_QTSH_Func010002003))
call ForGroupBJ(udg_GROUP,function Trig_J_QTSH_Func011A)
call RemoveLocation(udg_SP)
call DestroyGroup(udg_GROUP)
endfunction

function Trig_J_QTSH_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Atau'))then
return false
endif
return true
endfunction

function Trig_J_QTSH_Func010002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_QTSH_Func010002003001(),Trig_J_QTSH_Func010002003002())
endfunction