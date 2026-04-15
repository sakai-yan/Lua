//=========================================================================== 
// Trigger: biaoche 2
//=========================================================================== 
function InitTrig_biaoche_2 takes nothing returns nothing
set gg_trg_biaoche_2=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_biaoche_2,gg_rct_yabiao4)
call TriggerRegisterEnterRectSimple(gg_trg_biaoche_2,gg_rct_yabiao7)
call TriggerRegisterEnterRectSimple(gg_trg_biaoche_2,gg_rct_yabiao8)
call TriggerRegisterEnterRectSimple(gg_trg_biaoche_2,gg_rct_yabiao9)
call TriggerRegisterEnterRectSimple(gg_trg_biaoche_2,gg_rct_yabiao10)
call TriggerAddCondition(gg_trg_biaoche_2,Condition(function Trig_biaoche_2_Conditions))
call TriggerAddAction(gg_trg_biaoche_2,function Trig_biaoche_2_Actions)
endfunction

function Trig_biaoche_2_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,260.00,GetRandomDirectionDeg())
call CreateNUnitsAtLoc(1,'nban',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call RemoveLocation(udg_SP2)
call UnitApplyTimedLifeBJ(30.00,'BHwe',GetLastCreatedUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,260.00,GetRandomDirectionDeg())
call CreateNUnitsAtLoc(1,'nbrg',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call RemoveLocation(udg_SP2)
call UnitApplyTimedLifeBJ(30.00,'BHwe',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_biaoche_2_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nbel'))then
return false
endif
return true
endfunction