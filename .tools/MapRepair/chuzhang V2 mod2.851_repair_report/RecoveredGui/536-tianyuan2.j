//=========================================================================== 
// Trigger: tianyuan2
//=========================================================================== 
function InitTrig_tianyuan2 takes nothing returns nothing
set gg_trg_tianyuan2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan2,356.00,gg_unit_nfor_0612)
call TriggerAddCondition(gg_trg_tianyuan2,Condition(function Trig_tianyuan2_Conditions))
call TriggerAddAction(gg_trg_tianyuan2,function Trig_tianyuan2_Actions)
endfunction

function Trig_tianyuan2_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=2
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
if(Trig_tianyuan2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00尹月行：|r|cFFCCFFCC你也觉得我是一个魔头么？不过我已经习惯别人用这种眼光来看我了~~~年纪轻轻便有如此侠义之气，难得啊。你让我想起了自己的过去，有着不屈不挠的傲气。但要收拾我，恐怕你还得多练练了~~~\n\n|r|cFFFF0000只见你不到一招便败倒\n\n|r|cFFFFCC00尹月行：|r|cFFCCFFCC你走吧，给你一次机会，想好怎么打败我再来吧！\n|r")
if(Trig_tianyuan2_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan2_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
if(Trig_tianyuan2_Func008C())then
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回法魂门找掌门胡絮询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005C())then
set udg_SP=GetUnitLoc(gg_unit_nlv2_0262)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回御剑门找掌门蔡景阳询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005Func005C())then
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回清心阁找楼主白鹿先生询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005Func005Func006C())then
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回鬼冢找半蓑人询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005Func005Func006Func005C())then
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回太虚门找掌门张真人询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005Func005Func006Func005Func005C())then
set udg_SP=GetUnitLoc(gg_unit_nfa2_0514)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回佛圣门找智空大师询问|r")
call RemoveLocation(udg_SP)
else
if(Trig_tianyuan2_Func008Func005Func005Func006Func005Func005Func001C())then
set udg_SP=GetUnitLoc(gg_unit_ndh0_0717)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回月刀门找持刀人史前能|r")
call RemoveLocation(udg_SP)
else
endif
endif
endif
endif
endif
endif
endif
endfunction

function Trig_tianyuan2_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==1))then
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