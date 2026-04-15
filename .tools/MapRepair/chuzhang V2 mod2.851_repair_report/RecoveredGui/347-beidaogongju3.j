//=========================================================================== 
// Trigger: beidaogongju3
//=========================================================================== 
function InitTrig_beidaogongju3 takes nothing returns nothing
set gg_trg_beidaogongju3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_beidaogongju3,256,gg_unit_npnw_0364)
call TriggerAddCondition(gg_trg_beidaogongju3,Condition(function Trig_beidaogongju3_Conditions))
call TriggerAddAction(gg_trg_beidaogongju3,function Trig_beidaogongju3_Actions)
endfunction

function Trig_beidaogongju3_Actions takes nothing returns nothing
call UnitAddItemByIdSwapped('tlum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_R_CJ_gongju2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npnw_0364)
if(Trig_beidaogongju3_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-12.00))*100.00))
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_beidaogongju3_Func007C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF被盗的工具|r")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁右佻：|r|cFFCCFFCC你居然单枪匹马地去把工具拿回来了，我真佩服得物体投地啊！！|r")
endfunction

function Trig_beidaogongju3_Conditions takes nothing returns boolean
if(not(udg_R_CJ_gongju1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_gongju2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_R_CJ_gongju_T[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
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