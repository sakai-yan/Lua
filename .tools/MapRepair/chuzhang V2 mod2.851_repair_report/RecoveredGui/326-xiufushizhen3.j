//=========================================================================== 
// Trigger: xiufushizhen3
//=========================================================================== 
function InitTrig_xiufushizhen3 takes nothing returns nothing
set gg_trg_xiufushizhen3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xiufushizhen3,256,gg_unit_ngzc_0094)
call TriggerAddCondition(gg_trg_xiufushizhen3,Condition(function Trig_xiufushizhen3_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen3,function Trig_xiufushizhen3_Actions)
endfunction

function Trig_xiufushizhen3_Actions takes nothing returns nothing
set udg_R_xiufushizhen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
if(Trig_xiufushizhen3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A8|r|cFFFFDD336|r|cFFFFE64C5|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(865,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+865)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-4.00))*80.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_xiufushizhen3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF修复石阵（1）|R")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00阿亥：|r|cFFCCFFCC哦，你果然没令我失望啊！哎呀，石阵的损坏程度比我想象的要高，我还需要|r|cFF00FF0010份燃火精髓|r|cFFCCFFCC和|r|cFF00FF0010份石料|r|cFFCCFFCC，记住只有个别的|r|cFF00FF00燃火狗妖|r|cFFCCFFCC才有燃火精髓，一路小心\n\n|r|cFFFF6600任|r|cFFFF8C00务|r|cFFFFB200提|r|cFFFFD900示|r|cFFFFFF00：|r|cFF00FF00收集10份燃火精髓和10份石料|r")
set udg_SP=GetUnitLoc(gg_unit_ncnt_0088)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
if(Trig_xiufushizhen3_Func028001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_xiufushizhen3_Func029001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_xiufushizhen3_Conditions takes nothing returns boolean
if(not(udg_R_xiufushizhen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_R_xiufushizhen_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
return true
endfunction