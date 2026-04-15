//=========================================================================== 
// Trigger: xiongpi3
//=========================================================================== 
function InitTrig_xiongpi3 takes nothing returns nothing
set gg_trg_xiongpi3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xiongpi3,256,gg_unit_ngz4_0179)
call TriggerAddCondition(gg_trg_xiongpi3,Condition(function Trig_xiongpi3_Conditions))
call TriggerAddAction(gg_trg_xiongpi3,function Trig_xiongpi3_Actions)
endfunction

function Trig_xiongpi3_Actions takes nothing returns nothing
set udg_R_xiongpi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
if(Trig_xiongpi3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD3161|r|cFFFFDB2C2|r|cFFFFE2420|r|cFFFFE9570|r|cFFFFF06D铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(1200,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1200)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-9.00))*90.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_xiongpi3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF熊皮生意（1）|R")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张业：|r|cFFCCFFCC不错的熊皮啊，但要出成品还需要|r|cFF00FF0010份熊骨|r|cFFCCFFCC，我相信你一定乐意帮我，对吧？\n|r|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF熊皮生意（2）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00再杀10份熊骨|r")
set udg_SP=GetRectCenter(gg_rct_tamu_p1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
if(Trig_xiongpi3_Func028001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_xiongpi3_Func029001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_xiongpi3_Conditions takes nothing returns boolean
if(not(udg_R_xiongpi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_R_xiongpi_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
return true
endfunction