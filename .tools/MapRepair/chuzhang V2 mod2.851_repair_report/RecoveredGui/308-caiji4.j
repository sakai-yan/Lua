//=========================================================================== 
// Trigger: caiji4
//=========================================================================== 
function InitTrig_caiji4 takes nothing returns nothing
set gg_trg_caiji4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_caiji4,256,gg_unit_nmh0_0012)
call TriggerAddCondition(gg_trg_caiji4,Condition(function Trig_caiji4_Conditions))
call TriggerAddAction(gg_trg_caiji4,function Trig_caiji4_Actions)
endfunction

function Trig_caiji4_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sreg')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_R_CJ_shenggancao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nmh0_0012)
if(Trig_caiji4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_caiji4_Func006C())then
call UnitAddItemByIdSwapped('stel',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_caiji4_Func006Func001C())then
call UnitAddItemByIdSwapped('gcel',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_caiji4_Func006Func001Func001C())then
call UnitAddItemByIdSwapped('stel',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_caiji4_Func006Func001Func001Func001C())then
call UnitAddItemByIdSwapped('glsk',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_caiji4_Func006Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('gcel',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_caiji4_Func006Func001Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('gopr',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('wolg',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
endif
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41AE|r|cFFFFDD33级|r|cFFFFEE66武|r|cFFFFFF99器|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-1.00))*30.00))
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_caiji4_Func014C())then
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
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF送药\n|r|cFFFFCC00老周：|r|cFFCCFFCC谢谢你啊，年青人...|r")
endfunction

function Trig_caiji4_Conditions takes nothing returns boolean
if(not(udg_R_CJ_shenggancao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_shenggancao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sreg')==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction