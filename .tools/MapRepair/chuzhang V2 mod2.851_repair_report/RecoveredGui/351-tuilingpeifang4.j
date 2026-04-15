//=========================================================================== 
// Trigger: tuilingpeifang4
//=========================================================================== 
function InitTrig_tuilingpeifang4 takes nothing returns nothing
set gg_trg_tuilingpeifang4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tuilingpeifang4,256,gg_unit_ngz3_0167)
call TriggerAddCondition(gg_trg_tuilingpeifang4,Condition(function Trig_tuilingpeifang4_Conditions))
call TriggerAddAction(gg_trg_tuilingpeifang4,function Trig_tuilingpeifang4_Actions)
endfunction

function Trig_tuilingpeifang4_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'wild')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_R_CJ_tuiling3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz3_0167)
if(Trig_tuilingpeifang4_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call UnitAddItemByIdSwapped('ankh',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD61F还|r|cFFFFEB5C魂|r|cFFFFFF99丹|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-10.00))*160.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_tuilingpeifang4_Func017C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call UnitAddItemByIdSwapped('ajen',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF拜访阿达\n|r|cFFFFCC00阿达：|r|cFFCCFFCC有了这退灵散，以后我就可以自己去摘花了，呵呵|r")
endfunction

function Trig_tuilingpeifang4_Conditions takes nothing returns boolean
if(not(udg_R_CJ_tuiling2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_tuiling3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'wild')==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction