//=========================================================================== 
// Trigger: hanweicunzhuang2
//=========================================================================== 
function InitTrig_hanweicunzhuang2 takes nothing returns nothing
set gg_trg_hanweicunzhuang2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_hanweicunzhuang2,256,gg_unit_ngz2_0015)
call TriggerAddCondition(gg_trg_hanweicunzhuang2,Condition(function Trig_hanweicunzhuang2_Conditions))
call TriggerAddAction(gg_trg_hanweicunzhuang2,function Trig_hanweicunzhuang2_Actions)
endfunction

function Trig_hanweicunzhuang2_Actions takes nothing returns nothing
set udg_R_FS_hanwei_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
if(Trig_hanweicunzhuang2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-10.00))*250.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
if(Trig_hanweicunzhuang2_Func006C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_hanweicunzhuang2_Func006Func004C())then
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
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A15|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(1500,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1500)
if(Trig_hanweicunzhuang2_Func018C())then
call UnitAddItemByIdSwapped(udg_ITEM_BB[11],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_hanweicunzhuang2_Func018Func001C())then
call UnitAddItemByIdSwapped('rhth',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
if(Trig_hanweicunzhuang2_Func018Func001Func001C())then
call UnitAddItemByIdSwapped('dsum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
if(Trig_hanweicunzhuang2_Func018Func001Func001Func001C())then
call UnitAddItemByIdSwapped('rhth',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
if(Trig_hanweicunzhuang2_Func018Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('dsum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
if(Trig_hanweicunzhuang2_Func018Func001Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('dsum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
if(Trig_hanweicunzhuang2_Func018Func001Func001Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('dsum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
else
call UnitAddItemByIdSwapped('dsum',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,188)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,118)],udg_SP)
endif
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF捍卫村庄\n|r|cFFFFCC00张凡：|r|cFFCCFFCC呼~~多亏你的帮助，文莱村总算安全了~~~这些东西你就拿去吧！|r")
endfunction

function Trig_hanweicunzhuang2_Conditions takes nothing returns boolean
if(not(udg_R_FS_hanwei_num2==10))then
return false
endif
if(not(udg_R_FS_hanwei_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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