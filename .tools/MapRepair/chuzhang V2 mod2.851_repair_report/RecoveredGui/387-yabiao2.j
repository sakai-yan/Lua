//=========================================================================== 
// Trigger: yabiao2
//=========================================================================== 
function InitTrig_yabiao2 takes nothing returns nothing
set gg_trg_yabiao2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_yabiao2,356.00,gg_unit_ndr1_0260)
call TriggerAddCondition(gg_trg_yabiao2,Condition(function Trig_yabiao2_Conditions))
call TriggerAddAction(gg_trg_yabiao2,function Trig_yabiao2_Actions)
endfunction

function Trig_yabiao2_Actions takes nothing returns nothing
call RemoveUnit(GetTriggerUnit())
set udg_SP=GetUnitLoc(gg_unit_ndr1_0260)
if(Trig_yabiao2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+70|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(7000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+7000)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—魂山\n|r|cFFFFCC00龙远：|r|cFFCCFFCC这个是你的酬金，拿好了！|r")
set udg_yabiao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FFFF你目前侠义值为|r:"+(" |cFFFFFF00"+(I2S(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FFFF点|r"))))
endfunction

function Trig_yabiao2_Conditions takes nothing returns boolean
if(not(udg_yabiao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='hrdh'))then
return false
endif
return true
endfunction