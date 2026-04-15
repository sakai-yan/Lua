//=========================================================================== 
// Trigger: J BXHJ
//=========================================================================== 
function InitTrig_J_BXHJ takes nothing returns nothing
set gg_trg_J_BXHJ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_BXHJ,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_BXHJ,Condition(function Trig_J_BXHJ_Conditions))
call TriggerAddAction(gg_trg_J_BXHJ,function Trig_J_BXHJ_Actions)
endfunction

function Trig_J_BXHJ_Actions takes nothing returns nothing
if(Trig_J_BXHJ_Func001C())then
set udg_SP=GetUnitLoc(GetAttackedUnitBJ())
call CreateNUnitsAtLoc(1,'e000',GetOwningPlayer(GetAttackedUnitBJ()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"creepthunderbolt",GetAttacker())
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_J_BXHJ_Conditions takes nothing returns boolean
if(not(UnitHasBuffBJ(GetAttackedUnitBJ(),'BUfa')==true))then
return false
endif
return true
endfunction