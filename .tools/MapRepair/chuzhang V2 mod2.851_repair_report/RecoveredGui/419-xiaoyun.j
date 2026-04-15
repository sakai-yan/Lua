//=========================================================================== 
// Trigger: xiaoyun
//=========================================================================== 
function InitTrig_xiaoyun takes nothing returns nothing
set gg_trg_xiaoyun=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_xiaoyun,gg_rct_yabiao2)
call TriggerRegisterEnterRectSimple(gg_trg_xiaoyun,gg_rct_yabiao6)
call TriggerRegisterEnterRectSimple(gg_trg_xiaoyun,gg_rct_yabiao3)
call TriggerRegisterEnterRectSimple(gg_trg_xiaoyun,gg_rct_yabiao9)
call TriggerRegisterEnterRectSimple(gg_trg_xiaoyun,gg_rct_yabiao10)
call TriggerAddCondition(gg_trg_xiaoyun,Condition(function Trig_xiaoyun_Conditions))
call TriggerAddAction(gg_trg_xiaoyun,function Trig_xiaoyun_Actions)
endfunction

function Trig_xiaoyun_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,260.00,GetRandomDirectionDeg())
call CreateNUnitsAtLoc(1,'nass',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call RemoveLocation(udg_SP2)
call UnitApplyTimedLifeBJ(30.00,'BHwe',GetLastCreatedUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,260.00,GetRandomDirectionDeg())
call CreateNUnitsAtLoc(1,'nrog',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call RemoveLocation(udg_SP2)
call UnitApplyTimedLifeBJ(30.00,'BHwe',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_xiaoyun_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nwe2'))then
return false
endif
return true
endfunction