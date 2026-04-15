//=========================================================================== 
// Trigger: shiwusucai3
//=========================================================================== 
function InitTrig_shiwusucai3 takes nothing returns nothing
set gg_trg_shiwusucai3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shiwusucai3,256,gg_unit_ndtt_0383)
call TriggerAddCondition(gg_trg_shiwusucai3,Condition(function Trig_shiwusucai3_Conditions))
call TriggerAddAction(gg_trg_shiwusucai3,function Trig_shiwusucai3_Actions)
endfunction

function Trig_shiwusucai3_Actions takes nothing returns nothing
set udg_shiwusucai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndtt_0383)
if(Trig_shiwusucai3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A30|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(3000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+3000)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-22.00))*400.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_shiwusucai3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF食物素材\n|r|cFFFFCC00陆小丰：|r|cFFCCFFCC这是你的报酬，下次有需要帮忙你就尽管找我吧|r")
endfunction

function Trig_shiwusucai3_Conditions takes nothing returns boolean
if(not(udg_shiwusucai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_shiwusucai_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
return true
endfunction