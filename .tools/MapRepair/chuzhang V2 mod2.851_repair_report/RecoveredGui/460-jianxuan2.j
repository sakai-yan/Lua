//=========================================================================== 
// Trigger: jianxuan2
//=========================================================================== 
function InitTrig_jianxuan2 takes nothing returns nothing
set gg_trg_jianxuan2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan2,356.00,gg_unit_nfor_0612)
call TriggerAddCondition(gg_trg_jianxuan2,Condition(function Trig_jianxuan2_Conditions))
call TriggerAddAction(gg_trg_jianxuan2,function Trig_jianxuan2_Actions)
endfunction

function Trig_jianxuan2_Actions takes nothing returns nothing
set udg_MP_jianxuan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
if(Trig_jianxuan2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00尹月行：|r|cFFCCFFCC小兄弟你认错人了，速速离开吧，我是个不祥之人，再不走恐怕你会后悔莫及~~~\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回去找岩青|r")
if(Trig_jianxuan2_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan2_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nsel_0597)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan2_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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