//=========================================================================== 
// Trigger: tiaocha5
//=========================================================================== 
function InitTrig_tiaocha5 takes nothing returns nothing
set gg_trg_tiaocha5=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tiaocha5,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_tiaocha5,Condition(function Trig_tiaocha5_Conditions))
call TriggerAddAction(gg_trg_tiaocha5,function Trig_tiaocha5_Actions)
endfunction

function Trig_tiaocha5_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateItemLoc('odef',udg_SP)
if(Trig_tiaocha5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把蛊毒拿给石中保|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tiaocha5_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='ndrd'))then
return false
endif
return true
endfunction