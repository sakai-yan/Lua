//=========================================================================== 
// Trigger: chulaizadao
//=========================================================================== 
function InitTrig_chulaizadao takes nothing returns nothing
set gg_trg_chulaizadao=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_chulaizadao,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_chulaizadao,Condition(function Trig_chulaizadao_Conditions))
call TriggerAddAction(gg_trg_chulaizadao,function Trig_chulaizadao_Actions)
endfunction

function Trig_chulaizadao_Actions takes nothing returns nothing
if(Trig_chulaizadao_Func002C())then
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
if(Trig_chulaizadao_Func002Func002001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00老村长：|r|cFFCCFFCC欢迎来到文莱村，这些日子村子里可真热闹啊！你是刚出来江湖闯荡的吧，看你衣身单薄的，这|r|cFF00FF00800铜钱|r|cFFCCFFCC你就先收下吧|r")
set udg_R_chulaizadao[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A8|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(800,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800)
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A8|r|cFFFFE64C0|r|cFFFFEE66经|r|cFFFFFF99验|r",GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
set udg_EXP=80
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_chulaizadao_Func002Func019C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call CreateTextTagUnitBJ("|cFF00FF00把村民的委托都完成一遍吧|r",GetTriggerUnit(),200.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
endif
endfunction

function Trig_chulaizadao_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetItemTypeId(GetManipulatedItem())=='spro'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])>=0))then
return false
endif
if(not(udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction