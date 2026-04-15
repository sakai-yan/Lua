//=========================================================================== 
// Trigger: xuezhao4
//=========================================================================== 
function InitTrig_xuezhao4 takes nothing returns nothing
set gg_trg_xuezhao4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xuezhao4,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_xuezhao4,Condition(function Trig_xuezhao4_Conditions))
call TriggerAddAction(gg_trg_xuezhao4,function Trig_xuezhao4_Actions)
endfunction

function Trig_xuezhao4_Actions takes nothing returns nothing
set udg_R_xunzhaotongmen4[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFCCFFCC燃|r|cFFCCFFDD火|r|cFFCCFFEE大|r|cFFCCFFFF王|r |cFF00FF001|r|cFFFFFF99/1\n提示：成功杀死燃火大王，回去找雷风吧！|r")
if(Trig_xuezhao4_Func004001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_xuezhao4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_xuezhao4_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nkol'))then
return false
endif
if(not(udg_R_xunzhaotongmen3[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==true))then
return false
endif
if(not(udg_R_xunzhaotongmen4[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==false))then
return false
endif
return true
endfunction