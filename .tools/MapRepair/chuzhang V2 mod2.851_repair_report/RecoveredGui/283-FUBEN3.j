//=========================================================================== 
// Trigger: FUBEN3
//=========================================================================== 
function InitTrig_FUBEN3 takes nothing returns nothing
set gg_trg_FUBEN3=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_FUBEN3,gg_rct_fuben3)
call TriggerAddCondition(gg_trg_FUBEN3,Condition(function Trig_FUBEN3_Conditions))
call TriggerAddAction(gg_trg_FUBEN3,function Trig_FUBEN3_Actions)
endfunction

function Trig_FUBEN3_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetRectCenter(gg_rct_fuben7)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0552,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0553,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0555,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0554,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0556,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0557,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0559,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0560,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0558,851990,udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_FUBEN3_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction