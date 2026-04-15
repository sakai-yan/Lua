//=========================================================================== 
// Trigger: FUBEN4
//=========================================================================== 
function InitTrig_FUBEN4 takes nothing returns nothing
set gg_trg_FUBEN4=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_FUBEN4,gg_rct_fuben4)
call TriggerAddCondition(gg_trg_FUBEN4,Condition(function Trig_FUBEN4_Conditions))
call TriggerAddAction(gg_trg_FUBEN4,function Trig_FUBEN4_Actions)
endfunction

function Trig_FUBEN4_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetRectCenter(gg_rct_fuben7)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0561,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0562,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0563,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u322_0564,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0565,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0566,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u321_0567,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0568,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0569,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_u322_0570,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0572,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0571,851990,udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_FUBEN4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction