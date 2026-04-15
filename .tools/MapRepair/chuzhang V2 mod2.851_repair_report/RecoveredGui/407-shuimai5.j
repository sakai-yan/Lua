//=========================================================================== 
// Trigger: shuimai5
//=========================================================================== 
function InitTrig_shuimai5 takes nothing returns nothing
set gg_trg_shuimai5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shuimai5,356.00,gg_unit_nsha_0367)
call TriggerAddCondition(gg_trg_shuimai5,Condition(function Trig_shuimai5_Conditions))
call TriggerAddAction(gg_trg_shuimai5,function Trig_shuimai5_Actions)
endfunction

function Trig_shuimai5_Actions takes nothing returns nothing
set udg_MP_shuimai3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsha_0367)
if(Trig_shuimai5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC杀掉咕噜龙并没有什么了不起，你要面对的是更大的挑战。龙骨瀑布上的古龙守护者，你能打败|r|cFF00FF007个龙骨守护者|r|cFFCCFFCC我才能真正认可你有资格成为水脉师。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死7个龙骨守护者|r")
set udg_SP=GetRectCenter(gg_rct_longgu_mdd)
if(Trig_shuimai5_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shuimai5_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shuimai5_Conditions takes nothing returns boolean
if(not(udg_MP_shuimai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shuimai3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_shuimai_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=9))then
return false
endif
return true
endfunction