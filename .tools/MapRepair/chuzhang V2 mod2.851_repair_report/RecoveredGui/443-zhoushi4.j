//=========================================================================== 
// Trigger: zhoushi4
//=========================================================================== 
function InitTrig_zhoushi4 takes nothing returns nothing
set gg_trg_zhoushi4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhoushi4,256,gg_unit_nshw_0366)
call TriggerAddCondition(gg_trg_zhoushi4,Condition(function Trig_zhoushi4_Conditions))
call TriggerAddAction(gg_trg_zhoushi4,function Trig_zhoushi4_Actions)
endfunction

function Trig_zhoushi4_Actions takes nothing returns nothing
call UnitAddItemByIdSwapped('sor5',GetTriggerUnit())
set udg_MP_zhoushi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
if(Trig_zhoushi4_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00伏樱师：|r|cFFCCFFCC这些|r|cFF00FF00胆囊|r|cFFCCFFCC可以炼制出奇毒无比的毒药，你拿去给|r|cFF00FF00陆容大夫|r|cFFCCFFCC，让他帮你炼制。炼制好后再回来找我吧。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把胆囊交个陆容大夫|r")
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_zhoushi4_Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhoushi4_Func009001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_zhoushi4_Conditions takes nothing returns boolean
if(not(udg_MP_zhoushi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_zhoushi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_zhoushi_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=5))then
return false
endif
return true
endfunction