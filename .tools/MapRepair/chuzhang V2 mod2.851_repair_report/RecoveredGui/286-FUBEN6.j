//=========================================================================== 
// Trigger: FUBEN6
//=========================================================================== 
function InitTrig_FUBEN6 takes nothing returns nothing
set gg_trg_FUBEN6=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_FUBEN6,gg_rct_fuben6)
call TriggerAddCondition(gg_trg_FUBEN6,Condition(function Trig_FUBEN6_Conditions))
call TriggerAddAction(gg_trg_FUBEN6,function Trig_FUBEN6_Actions)
endfunction

function Trig_FUBEN6_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetRectCenter(gg_rct_fuben7)
call IssuePointOrderByIdLoc(gg_unit_u321_0583,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0584,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0586,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u321_0585,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u322_0587,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0588,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0589,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u321_0590,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u321_0591,851990,udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_FUBEN6_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction