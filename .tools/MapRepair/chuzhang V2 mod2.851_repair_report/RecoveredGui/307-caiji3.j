//=========================================================================== 
// Trigger: caiji3
//=========================================================================== 
function InitTrig_caiji3 takes nothing returns nothing
set gg_trg_caiji3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_caiji3,256,gg_unit_npn2_0009)
call TriggerAddCondition(gg_trg_caiji3,Condition(function Trig_caiji3_Conditions))
call TriggerAddAction(gg_trg_caiji3,function Trig_caiji3_Actions)
endfunction

function Trig_caiji3_Actions takes nothing returns nothing
set udg_R_CJ_shenggancao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn2_0009)
if(Trig_caiji3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call UnitAddItemByIdSwapped('pgma',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('pgma',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD2136|r|cFFFFD926瓶|r|cFFFFE64C行|r|cFFFFF273气|r|cFFFFFF99散|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-0.00))*50.00))
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_caiji3_Func013C())then
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
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF采集生甘草|r")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00谢大夫：|r|cFFCCFFCC好大颗的生甘草啊，我把它调配成了|r|cFF00FF00蛇伤药|r|cFFCCFFCC了，你能帮我送给|r|cFF00FF00铁匠铺的老周吗|r|cFFCCFFCC？铁匠铺就在村子的东门上头。\n|r|cFFFF6600任|r|cFFFF8833务|r|cFFFFAA66提|r|cFFFFCC99示：|r|cFF00FF00把蛇伤药拿给铁匠铺老周|r")
set udg_SP=GetUnitLoc(gg_unit_nmh0_0012)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call UnitAddItemByIdSwapped('sreg',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call RemoveLocation(udg_SP)
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_nmh0_0012)
if(Trig_caiji3_Func029001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_caiji3_Func030001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_caiji3_Conditions takes nothing returns boolean
if(not(udg_R_CJ_shenggancao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_shenggancao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=7))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction