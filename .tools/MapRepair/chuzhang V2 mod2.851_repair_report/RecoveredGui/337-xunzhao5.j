//=========================================================================== 
// Trigger: xunzhao5
//=========================================================================== 
function InitTrig_xunzhao5 takes nothing returns nothing
set gg_trg_xunzhao5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xunzhao5,256,gg_unit_npn6_0144)
call TriggerAddCondition(gg_trg_xunzhao5,Condition(function Trig_xunzhao5_Conditions))
call TriggerAddAction(gg_trg_xunzhao5,function Trig_xunzhao5_Actions)
endfunction

function Trig_xunzhao5_Actions takes nothing returns nothing
set udg_R_xunzhaotongmen5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
if(Trig_xunzhao5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-6.00))*180.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_xunzhao5_Func007C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A9|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(900,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+900)
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41AD|r|cFFFFDD33级|r|cFFFFEE66武|r|cFFFFFF99器|r",GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_xunzhao5_Func025C())then
call UnitAddItemByIdSwapped('k3m3',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_xunzhao5_Func025Func001C())then
call UnitAddItemByIdSwapped('kymn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_xunzhao5_Func025Func001Func001C())then
call UnitAddItemByIdSwapped('k3m3',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_xunzhao5_Func025Func001Func001Func001C())then
call UnitAddItemByIdSwapped('k3m1',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_xunzhao5_Func025Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('kymn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_xunzhao5_Func025Func001Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('ledg',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('azhr',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF复仇\n|r|cFFFFCC00雷风：|r|cFFCCFFCC大仇得报，希望师兄在九泉之下能够安息。|r")
endfunction

function Trig_xunzhao5_Conditions takes nothing returns boolean
if(not(udg_R_xunzhaotongmen4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_xunzhaotongmen5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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