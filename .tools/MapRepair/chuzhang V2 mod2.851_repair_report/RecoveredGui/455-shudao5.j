//=========================================================================== 
// Trigger: shudao5
//=========================================================================== 
function InitTrig_shudao5 takes nothing returns nothing
set gg_trg_shudao5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shudao5,356.00,gg_unit_ngza_0168)
call TriggerAddCondition(gg_trg_shudao5,Condition(function Trig_shudao5_Conditions))
call TriggerAddAction(gg_trg_shudao5,function Trig_shudao5_Actions)
endfunction

function Trig_shudao5_Actions takes nothing returns nothing
set udg_MP_shudao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_shudao5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00陆容大夫：|r|cFFCCFFCC雀红散，想不到最近中了此毒的人有这么多啊！很遗憾我们的雀红散已经用光了，虽然可以马上配制，但我们缺少药引|r|cFF00FF00雀丹素|r|cFFCCFFCC，它能在|r|cFF00FF00涉毒鹿妖身|r|cFFCCFFCC上得到，看来此次你得到|r|cFF00FF00塔木森林|r|cFFCCFFCC去一躺了，一个就足够。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00从塔木森林的涉毒鹿妖身上找寻雀丹素|r")
if(Trig_shudao5_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shudao5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xuesi5)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shudao5_Conditions takes nothing returns boolean
if(not(udg_MP_shudao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shudao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction