//=========================================================================== 
// Trigger: zhiguliangyao3
//=========================================================================== 
function InitTrig_zhiguliangyao3 takes nothing returns nothing
set gg_trg_zhiguliangyao3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhiguliangyao3,256,gg_unit_ndrp_0299)
call TriggerAddCondition(gg_trg_zhiguliangyao3,Condition(function Trig_zhiguliangyao3_Conditions))
call TriggerAddAction(gg_trg_zhiguliangyao3,function Trig_zhiguliangyao3_Actions)
endfunction

function Trig_zhiguliangyao3_Actions takes nothing returns nothing
set udg_zhiguliangyao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndrp_0299)
if(Trig_zhiguliangyao3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-22.00))*200.00))
if(Trig_zhiguliangyao3_Func005C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00伊不活：|r|cFFCCFFCC这是研制好的解药，你拿去给|r|cFF00FF00客栈|r|cFFCCFFCC交给|r|cFF00FF00陆小丰|r|cFFCCFFCC老板吧。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把解药拿去给客栈的陆小丰|r")
set udg_SP=GetUnitLoc(gg_unit_ndtt_0383)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call UnitAddItemByIdSwapped('shen',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call RemoveLocation(udg_SP)
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_ndrp_0299)
if(Trig_zhiguliangyao3_Func021001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhiguliangyao3_Func022001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_zhiguliangyao3_Conditions takes nothing returns boolean
if(not(udg_zhiguliangyao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_zhiguliangyao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
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