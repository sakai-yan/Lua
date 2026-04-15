//=========================================================================== 
// Trigger: 001
//=========================================================================== 
function InitTrig____________________001 takes nothing returns nothing
set gg_trg____________________001=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________001,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg____________________001,Condition(function Trig____________________001_Conditions))
call TriggerAddAction(gg_trg____________________001,function Trig____________________001_Actions)
endfunction

function Trig____________________001_Actions takes nothing returns nothing
if(Trig____________________001_Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆建议把村子里的《|r|cFF00FFFF送信|r|cFF00FF00》《|r|cFF00FFFF采集生根草|r|cFF00FF00》《|r|cFF00FFFF野猪成群|r|cFF00FF00》《|r|cFF00FFFF甜美的青枣|r|cFF00FF00》四个新手任务完成。\n◆跟随《|r|cFF00FFFF甜美的青枣|r|cFF00FF00》任务的要求，到五石阵找NPC|r|cFFFFCC00阿亥|r|cFF00FF00。|r")
set udg_SP=GetRectCenter(gg_rct______________032)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆把《|r|cFF00FFFF修复石阵|r|cFF00FF00》任务完成，即可达到|r|cFFFFCC007|r|cFF00FF00级\n◆接着把《|r|cFF00FFFF寻找同门师兄|r|cFF00FF00》任务完成，获得D1专用武器。|r")
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func003C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆到海边把《|r|cFF00FFFF清除水怪|r|cFF00FF00》《|r|cFF00FFFF奇怪的妖花|r|cFF00FF00》两个任务完成\n◆随《|r|cFF00FFFF奇怪的妖花|r|cFF00FF00》任务要求去清心阁\n◆如果你有10级，推荐去西边完成任务《|r|cFF00FFFF熊皮生意|r|cFF00FF00》|r")
set udg_SP=GetRectCenter(gg_rct_yaohua1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func004C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆到塔木码头把《|r|cFF00FFFF塔木之根|r|cFF00FF00》任务完成，顺便杀怪升级\n◆把自己的等级提升到14级，然后去塔木村|r")
set udg_SP=GetRectCenter(gg_rct______________138)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________081_______u)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func005C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆到塔木村的《|r|cFF00FFFF净化野兽|r|cFF00FF00》《|r|cFF00FFFF同样的暴怒|r|cFF00FF00》任务完成\n◆把自己的等级提升到16级，然后去塔木森林内部找塔木长老|r\n")
set udg_SP=GetUnitLoc(gg_unit_ncg1_0205)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________081_______u)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func006C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆到塔木森林的《|r|cFF00FFFF凶残的鹿妖|r|cFF00FF00》任务完成\n◆|r|cFFFF6600《|r|cFF00FFFF祭品的童子|r|cFFFF6600》|r|cFF00FF00任务难度较大且属于主线任务，慎重。\n◆把自己的等级练到|r|cFFFFFF0020|r|cFF00FF00级，然后去做自己的|r|cFFFFCC00转职任务|r|cFF00FF00。|r")
set udg_SP=GetRectCenter(gg_rct_xiongcan)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xuemi)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
if(Trig____________________001_Func007C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00CCFF新手指导：\n|r|cFF00FF00◆找到你|r|cFFFFCC00所属的门派|r|cFF00FF00所在，去完成转职任务吧。\n◆当你完成转职任务后，你已经不是新手了，去找|r|cFFFFCC00孙末肖|r|cFF00FF00过关吧\n|r")
set udg_SP=GetRectCenter(gg_rct_guanka2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
if(Trig____________________001_Func007Func005C())then
set udg_SP=GetRectCenter(gg_rct______________081________2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________081)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001Func001Func001C())then
set udg_SP=GetRectCenter(gg_rct______________124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ndh0_0717)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig____________________001_Func007Func005Func001Func001Func001Func001Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
endif
endif
endif
endif
endif
else
endif
endfunction

function Trig____________________001_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='esaz'))then
return false
endif
return true
endfunction