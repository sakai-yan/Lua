//=========================================================================== 
// Trigger: tiaocha6
//=========================================================================== 
function InitTrig_tiaocha6 takes nothing returns nothing
set gg_trg_tiaocha6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tiaocha6,256,gg_unit_nanm_0508)
call TriggerAddCondition(gg_trg_tiaocha6,Condition(function Trig_tiaocha6_Conditions))
call TriggerAddAction(gg_trg_tiaocha6,function Trig_tiaocha6_Actions)
endfunction

function Trig_tiaocha6_Actions takes nothing returns nothing
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'odef'))
set udg_tiaocha5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00石中保：|r|cFFCCFFCC多亏大侠的帮忙，制止了即将发生的悲剧。我代表龙泉镇的百姓感谢你，这点心意您就手下吧。\n|r|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF调查苗寨|r")
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
if(Trig_tiaocha6_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-24.00))*300.00))
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_tiaocha6_Func008C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(2000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2000)
call CreateTextTagUnitBJ("|cFFFFCC00+70|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_tiaocha6_Func022C())then
call UnitAddItemByIdSwapped('tbsm',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_tiaocha6_Func022Func001C())then
call UnitAddItemByIdSwapped('hbth',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_tiaocha6_Func022Func001Func001C())then
call UnitAddItemByIdSwapped('tbak',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_tiaocha6_Func022Func001Func001Func001C())then
call UnitAddItemByIdSwapped('sor2',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('sor3',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
call CreateTextTagUnitBJ("|CFF00FF00随机材料|R",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],20.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
endfunction

function Trig_tiaocha6_Conditions takes nothing returns boolean
if(not(udg_tiaocha4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_tiaocha5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'odef')==true))then
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