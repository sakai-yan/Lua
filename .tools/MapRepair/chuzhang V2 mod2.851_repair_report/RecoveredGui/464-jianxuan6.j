//=========================================================================== 
// Trigger: jianxuan6
//=========================================================================== 
function InitTrig_jianxuan6 takes nothing returns nothing
set gg_trg_jianxuan6=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_jianxuan6,gg_rct______________046)
call TriggerAddCondition(gg_trg_jianxuan6,Condition(function Trig_jianxuan6_Conditions))
call TriggerAddAction(gg_trg_jianxuan6,function Trig_jianxuan6_Actions)
endfunction

function Trig_jianxuan6_Actions takes nothing returns nothing
set udg_MP_jianxuan6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetRectCenter(gg_rct______________046)
if(Trig_jianxuan6_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00村民甲：|r|cFFCCFFCC大家不要退缩！！村子可是你们的妻儿老小！！绝对不能让那些妖魔近村！！！\n|r|cFFFFCC00村民乙：|r|cFFCCFFCC这些混蛋太强大了！！看来这次顶不住了！！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00阻止妖魔进入村子\n|r")
if(Trig_jianxuan6_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan6_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
call PauseUnitBJ(false,gg_unit_ndqn_0615)
call ShowUnitShow(gg_unit_ndqn_0615)
call IssuePointOrderLoc(gg_unit_ndqn_0615,"attack",GetRectCenter(gg_rct______________080))
call StartTimerBJ(udg_MP_jianxuan_time,false,60.00)
call CreateTimerDialogBJ(GetLastCreatedTimerBJ(),"坚持时间")
set udg_MP_jianxuan_win=GetLastCreatedTimerDialogBJ()
call EnableTrigger(gg_trg_jianxuannpc)
endfunction

function Trig_jianxuan6_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction