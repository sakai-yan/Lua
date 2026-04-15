//=========================================================================== 
// Trigger: FUBEN1
//=========================================================================== 
function InitTrig_FUBEN1 takes nothing returns nothing
set gg_trg_FUBEN1=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_FUBEN1,gg_rct_fuben1)
call TriggerAddCondition(gg_trg_FUBEN1,Condition(function Trig_FUBEN1_Conditions))
call TriggerAddAction(gg_trg_FUBEN1,function Trig_FUBEN1_Actions)
endfunction

function Trig_FUBEN1_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetRectCenter(gg_rct_fuben7)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0544,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0523,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0543,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0524,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0545,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0546,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0547,851990,udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_FUBEN1_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction