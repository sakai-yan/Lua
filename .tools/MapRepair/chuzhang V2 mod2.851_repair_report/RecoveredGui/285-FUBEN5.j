//=========================================================================== 
// Trigger: FUBEN5
//=========================================================================== 
function InitTrig_FUBEN5 takes nothing returns nothing
set gg_trg_FUBEN5=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_FUBEN5,gg_rct_fuben5)
call TriggerAddCondition(gg_trg_FUBEN5,Condition(function Trig_FUBEN5_Conditions))
call TriggerAddAction(gg_trg_FUBEN5,function Trig_FUBEN5_Actions)
endfunction

function Trig_FUBEN5_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
set udg_SP=GetRectCenter(gg_rct_fuben7)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0577,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0578,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0579,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0581,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_njga_0580,851990,udg_SP)
call IssuePointOrderByIdLoc(gg_unit_nmpg_0582,851990,udg_SP)
call RemoveLocation(udg_SP)
endfunction

function Trig_FUBEN5_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
return true
endfunction