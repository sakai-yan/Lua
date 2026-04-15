//=========================================================================== 
// Trigger: daokuang3
//=========================================================================== 
function InitTrig_daokuang3 takes nothing returns nothing
set gg_trg_daokuang3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_daokuang3,356.00,gg_unit_zcso_0720)
call TriggerAddCondition(gg_trg_daokuang3,Condition(function Trig_daokuang3_Conditions))
call TriggerAddAction(gg_trg_daokuang3,function Trig_daokuang3_Actions)
endfunction

function Trig_daokuang3_Actions takes nothing returns nothing
set udg_MP_daokuang2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
if(Trig_daokuang3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC呀！你这个小子还来真的！有意思！但暴怒鹿妖不足以证明你的胆识，你如果敢去挑战|r|cFF00FF00草齿兽|r|cFFCCFFCC，我就认同你是个狂人了！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死15只草齿兽|r")
if(Trig_daokuang3_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_daokuang3_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_daokuang3_Conditions takes nothing returns boolean
if(not(udg_MP_daokuang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_daokuang2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_daokuang_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=15))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction