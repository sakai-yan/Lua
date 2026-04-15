//=========================================================================== 
// Trigger: nianhuoshi3
//=========================================================================== 
function InitTrig_nianhuoshi3 takes nothing returns nothing
set gg_trg_nianhuoshi3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_nianhuoshi3,356.00,gg_unit_nfr2_0125)
call TriggerAddCondition(gg_trg_nianhuoshi3,Condition(function Trig_nianhuoshi3_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi3,function Trig_nianhuoshi3_Actions)
endfunction

function Trig_nianhuoshi3_Actions takes nothing returns nothing
if(Trig_nianhuoshi3_Func001C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'fgdg')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('sand',GetTriggerUnit())
set udg_MP_nianhuoshi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
if(Trig_nianhuoshi3_Func001Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC恩，这确实是灵力火种，拿着这些|r|cFF00FF00火种|r|cFFCCFFCC去找法魂掌门|r|cFF00FF00胡絮|r|cFFCCFFCC吧，他老人家会告诉你下一步应该掌门走。\n|r|cFF00FFFF提示：|r|cFF00FF00找胡絮谈谈|r")
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
if(Trig_nianhuoshi3_Func001Func011001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_nianhuoshi3_Func001Func012001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig_nianhuoshi3_Func001Func001C())then
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
if(Trig_nianhuoshi3_Func001Func001Func002001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00FFFF提示：|r|cFF00FF00你快去找胡絮谈谈吧|r")
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
if(Trig_nianhuoshi3_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
endfunction

function Trig_nianhuoshi3_Conditions takes nothing returns boolean
if(not(udg_MP_nianhuoshi1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
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