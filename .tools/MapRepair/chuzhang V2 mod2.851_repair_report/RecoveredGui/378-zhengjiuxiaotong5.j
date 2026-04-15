//=========================================================================== 
// Trigger: zhengjiuxiaotong5
//=========================================================================== 
function InitTrig_zhengjiuxiaotong5 takes nothing returns nothing
set gg_trg_zhengjiuxiaotong5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhengjiuxiaotong5,256,gg_unit_ncg1_0205)
call TriggerAddCondition(gg_trg_zhengjiuxiaotong5,Condition(function Trig_zhengjiuxiaotong5_Conditions))
call TriggerAddAction(gg_trg_zhengjiuxiaotong5,function Trig_zhengjiuxiaotong5_Actions)
endfunction

function Trig_zhengjiuxiaotong5_Actions takes nothing returns nothing
set udg_R_ZJ_xiaotong3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncg1_0205)
if(Trig_zhengjiuxiaotong5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+70|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(3000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+3000)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-16.00))*400.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
if(Trig_zhengjiuxiaotong5_Func013C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_zhengjiuxiaotong5_Func013Func004C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"！因等级不达任务要求，无经验收入")
endif
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_zhengjiuxiaotong5_Func018C())then
call UnitAddItemByIdSwapped(udg_ITEM_BB[11],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('flag',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateTextTagUnitBJ("|cFFF9FFE6突锲盾|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF祭奠的童子\n|r|cFFFFCC00塔木长老：|r|cFFCCFFCC多谢大侠拯救我族孩儿~~此等厚恩末齿难忘~|r")
endfunction

function Trig_zhengjiuxiaotong5_Conditions takes nothing returns boolean
if(not(udg_R_ZJ_xiaotong2==true))then
return false
endif
if(not(udg_R_ZJ_xiaotong3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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