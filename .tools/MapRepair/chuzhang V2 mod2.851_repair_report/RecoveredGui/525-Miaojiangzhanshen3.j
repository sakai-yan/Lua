//=========================================================================== 
// Trigger: Miaojiangzhanshen3
//=========================================================================== 
function InitTrig_Miaojiangzhanshen3 takes nothing returns nothing
set gg_trg_Miaojiangzhanshen3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_Miaojiangzhanshen3,256,gg_unit_ncnk_0296)
call TriggerAddCondition(gg_trg_Miaojiangzhanshen3,Condition(function Trig_Miaojiangzhanshen3_Conditions))
call TriggerAddAction(gg_trg_Miaojiangzhanshen3,function Trig_Miaojiangzhanshen3_Actions)
endfunction

function Trig_Miaojiangzhanshen3_Actions takes nothing returns nothing
set udg_Miaojiangzhanshen3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
if(Trig_Miaojiangzhanshen3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A15|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(1500,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1500)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-26.00))*800.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_Miaojiangzhanshen3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_Miaojiangzhanshen3_Func020C())then
call UnitAddItemByIdSwapped('rde1',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func020Func002C())then
call UnitAddItemByIdSwapped('belv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func020Func002Func001C())then
call UnitAddItemByIdSwapped('rde3',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func020Func002Func001Func001C())then
call UnitAddItemByIdSwapped('belv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func020Func002Func001Func001Func001C())then
call UnitAddItemByIdSwapped('belv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func020Func002Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('belv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('belv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
endif
endif
if(Trig_Miaojiangzhanshen3_Func021C())then
call UnitAddItemByIdSwapped('soul',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func021Func001C())then
call UnitAddItemByIdSwapped('crdt',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func021Func001Func001C())then
call UnitAddItemByIdSwapped('jdrn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_Miaojiangzhanshen3_Func021Func001Func001Func001C())then
call UnitAddItemByIdSwapped('gemt',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('shdt',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
call CreateTextTagUnitBJ("|cFF00FF00D首饰，防具|r",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],20.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF苗疆战神\n|r|cFFFFCC00石龙保：|r|cFFCCFFCC苗疆战神的倒下，苗军士气大降,真的大快人心啊！！|r")
endfunction

function Trig_Miaojiangzhanshen3_Conditions takes nothing returns boolean
if(not(udg_Miaojiangzhanshen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_Miaojiangzhanshen3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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