//=========================================================================== 
// Trigger: jianxuan3
//=========================================================================== 
function InitTrig_jianxuan3 takes nothing returns nothing
set gg_trg_jianxuan3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan3,356.00,gg_unit_nsel_0597)
call TriggerAddCondition(gg_trg_jianxuan3,Condition(function Trig_jianxuan3_Conditions))
call TriggerAddAction(gg_trg_jianxuan3,function Trig_jianxuan3_Actions)
endfunction

function Trig_jianxuan3_Actions takes nothing returns nothing
set udg_MP_jianxuan3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsel_0597)
if(Trig_jianxuan3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00岩青：|r|cFFCCFFCC你找他的行踪了？很好，为师命令你速速|r|cFF00FF00抓拿尹月行|r|cFFCCFFCC，但务必小心，因为他的能力...总之你去吧！你不会后悔接受这个任务的。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00抓拿尹月行|r")
if(Trig_jianxuan3_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan3_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call ShowUnitHide(gg_unit_nfor_0612)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan3_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_jianxuan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
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