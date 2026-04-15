//=========================================================================== 
// Trigger: tuilingpeifang3
//=========================================================================== 
function InitTrig_tuilingpeifang3 takes nothing returns nothing
set gg_trg_tuilingpeifang3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tuilingpeifang3,256,gg_unit_ngza_0168)
call TriggerAddCondition(gg_trg_tuilingpeifang3,Condition(function Trig_tuilingpeifang3_Conditions))
call TriggerAddAction(gg_trg_tuilingpeifang3,function Trig_tuilingpeifang3_Actions)
endfunction

function Trig_tuilingpeifang3_Actions takes nothing returns nothing
set udg_R_CJ_tuiling2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_tuilingpeifang3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD3161|r|cFFFFDB2C5|r|cFFFFE2420|r|cFFFFE9570|r|cFFFFF06D铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(1500,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1500)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-10.00))*160.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_tuilingpeifang3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF退灵配方|r")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00陆容大夫：|r|cFFCCFFCC我把你弄回来的材料作成了这瓶|r|cFF00FF00退灵散|r|cFFCCFFCC，你拿回去给|r|cFF00FF00阿达|r|cFFCCFFCC吧。\n|r|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF拜访阿达\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把退灵散较给阿达|r")
set udg_SP=GetUnitLoc(gg_unit_ngz3_0167)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call UnitAddItemByIdSwapped('wild',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])

call UnitAddItemByIdSwapped('I02X',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])        //huanling
call RemoveLocation(udg_SP)
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_ngz3_0167)
if(Trig_tuilingpeifang3_Func029001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tuilingpeifang3_Func030001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_tuilingpeifang3_Conditions takes nothing returns boolean
if(not(udg_R_CJ_tuiling_a1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_tuiling_a2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_tuiling_a3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_tuiling1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_tuiling2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction