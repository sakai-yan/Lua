//=========================================================================== 
// Trigger: daokuang5
//=========================================================================== 
function InitTrig_daokuang5 takes nothing returns nothing
set gg_trg_daokuang5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_daokuang5,356.00,gg_unit_zcso_0720)
call TriggerAddCondition(gg_trg_daokuang5,Condition(function Trig_daokuang5_Conditions))
call TriggerAddAction(gg_trg_daokuang5,function Trig_daokuang5_Actions)
endfunction

function Trig_daokuang5_Actions takes nothing returns nothing
set udg_MP_daokuang3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
if(Trig_daokuang5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC恩~~你速度还真是惊人啊！那我就告诉你什么才是真正的疯狂吧！杀死一只|r|cFF00FF00残凶鹿妖|r|cFFCCFFCC再回来吧！只有战胜它，最能成为月刀门的真正刀狂！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死残凶鹿妖|r")
if(Trig_daokuang5_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_daokuang5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xiongcan)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_daokuang5_Conditions takes nothing returns boolean
if(not(udg_MP_daokuang2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_daokuang3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_daokuang_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=15))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction