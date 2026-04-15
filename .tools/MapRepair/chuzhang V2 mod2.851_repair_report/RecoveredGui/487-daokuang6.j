//=========================================================================== 
// Trigger: daokuang6
//=========================================================================== 
function InitTrig_daokuang6 takes nothing returns nothing
set gg_trg_daokuang6=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_daokuang6,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_daokuang6,Condition(function Trig_daokuang6_Conditions))
call TriggerAddAction(gg_trg_daokuang6,function Trig_daokuang6_Actions)
endfunction

function Trig_daokuang6_Actions takes nothing returns nothing
if(Trig_daokuang6_Func001C())then
set udg_MP_daokuang4[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_daokuang6_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：你已经杀死了残凶鹿妖，速速回去月刀岛找卯人敌吧！|r")
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
if(Trig_daokuang6_Func001Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_daokuang6_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nowk'))then
return false
endif
return true
endfunction