//=========================================================================== 
// Trigger: songxin2
//=========================================================================== 
function InitTrig_songxin2 takes nothing returns nothing
set gg_trg_songxin2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_songxin2,256,gg_unit_npn2_0009)
call TriggerAddCondition(gg_trg_songxin2,Condition(function Trig_songxin2_Conditions))
call TriggerAddAction(gg_trg_songxin2,function Trig_songxin2_Actions)
endfunction

function Trig_songxin2_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'tcas')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_R_SX_CZ2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn2_0009)
if(Trig_songxin2_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call UnitAddItemByIdSwapped('pghe',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('pghe',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD2136|r|cFFFFD926瓶|r|cFFFFE64C金|r|cFFFFF273创|r|cFFFFFF99药|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-0.00))*17.00))
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_songxin2_Func015C())then
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
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF送信\n|r|cFFFFCC00谢大夫：|r|cFFCCFFCC谢谢你啊，年青人...|r")
endfunction

function Trig_songxin2_Conditions takes nothing returns boolean
if(not(udg_R_SX_CZ1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_SX_CZ2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'tcas')==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction