//=========================================================================== 
// Trigger: fengyin3
//=========================================================================== 
function InitTrig_fengyin3 takes nothing returns nothing
set gg_trg_fengyin3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_fengyin3,256,gg_unit_nfpl_0606)
call TriggerAddCondition(gg_trg_fengyin3,Condition(function Trig_fengyin3_Conditions))
call TriggerAddAction(gg_trg_fengyin3,function Trig_fengyin3_Actions)
endfunction

function Trig_fengyin3_Actions takes nothing returns nothing
set udg_fengyin3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfpl_0606)
if(Trig_fengyin3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+50|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(5000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+5000)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-29.00))*1000.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
if(Trig_fengyin3_Func013C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_fengyin3_Func013Func004C())then
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
call CreateTextTagUnitBJ("|cFF00FF00随机材料|r",GetTriggerUnit(),20.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_fengyin3_Func023C())then
call UnitAddItemByIdSwapped('sor2',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])             //gh
else
if(Trig_fengyin3_Func023Func001C())then
call UnitAddItemByIdSwapped('guvi',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_fengyin3_Func023Func001Func001C())then
call UnitAddItemByIdSwapped('thdm',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_fengyin3_Func023Func001Func001Func001C())then
call UnitAddItemByIdSwapped('rej6',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_fengyin3_Func023Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped(udg_ITEM_BB[GetRandomInt(1,9)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('sor3',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF封印\n|r|cFFFFCC00司徒西风：|r|cFFCCFFCC总算完成了师傅的嘱托，我可以回去向他老人家复命了，这次真的多亏大侠相助啊！|r")
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+3)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FFFF你目前侠义值为|r:"+(" |cFFFFFF00"+(I2S(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FFFF点|r"))))
endfunction

function Trig_fengyin3_Conditions takes nothing returns boolean
if(not(udg_fengyin2==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_fengyin3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction