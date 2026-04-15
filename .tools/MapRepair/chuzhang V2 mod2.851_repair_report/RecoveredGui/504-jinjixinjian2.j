//=========================================================================== 
// Trigger: jinjixinjian2
//=========================================================================== 
function InitTrig_jinjixinjian2 takes nothing returns nothing
set gg_trg_jinjixinjian2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jinjixinjian2,256,gg_unit_ncnk_0296)
call TriggerAddCondition(gg_trg_jinjixinjian2,Condition(function Trig_jinjixinjian2_Conditions))
call TriggerAddAction(gg_trg_jinjixinjian2,function Trig_jinjixinjian2_Actions)
endfunction

function Trig_jinjixinjian2_Actions takes nothing returns nothing
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pgin'))
set udg_jinjixinjian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
if(Trig_jinjixinjian2_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-20.00))*100.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_jinjixinjian2_Func008C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF紧急书信\n|r|cFFFFCC00石龙保：|r|cFFCCFFCC看来事态不容小视啊~~龙泉镇的兵力面对苗人将会很吃力|r")
endfunction

function Trig_jinjixinjian2_Conditions takes nothing returns boolean
if(not(udg_jinjixinjian1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_jinjixinjian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'pgin')==true))then
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