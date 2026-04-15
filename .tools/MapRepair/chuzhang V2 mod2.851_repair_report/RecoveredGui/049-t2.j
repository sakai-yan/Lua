//=========================================================================== 
// Trigger: t2
//=========================================================================== 
function InitTrig_t2 takes nothing returns nothing
set gg_trg_t2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_t2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_t2,Condition(function Trig_t2_Conditions))
call TriggerAddAction(gg_trg_t2,function Trig_t2_Actions)
endfunction

function Trig_t2_Actions takes nothing returns nothing
set gg_trg_t1=CreateTrigger()
call TriggerAddCondition(gg_trg_t1,Condition(function Trig_t1_Conditions))
call TriggerAddAction(gg_trg_t1,function Trig_t1_Actions)
call TriggerRegisterUnitEvent(gg_trg_t1,GetSpellTargetUnit(),EVENT_UNIT_DAMAGED)
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'ewsp',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"deathcoil",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
endfunction

function Trig_t2_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='ANcl'))then    //nnnn
return false
endif
return true
endfunction

function Trig_t1_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetEventDamageSource())=='ewsp'))then
return false
endif
return true
endfunction

function Trig_t1_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_GROUP=GetUnitsInRangeOfLocMatching(200.00,udg_SP,Condition(function Trig_t1_Func003002003))
call ForGroupBJ(udg_GROUP,function Trig_t1_Func004A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
call RemoveUnit(GetEventDamageSource())
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_t1_Func003002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetEventDamageSource()))==true)
endfunction