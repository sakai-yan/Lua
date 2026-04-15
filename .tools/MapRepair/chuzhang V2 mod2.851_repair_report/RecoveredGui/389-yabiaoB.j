//=========================================================================== 
// Trigger: yabiaoB
//=========================================================================== 
function InitTrig_yabiaoB takes nothing returns nothing
set gg_trg_yabiaoB=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_yabiaoB,356.00,gg_unit_nqb4_0244)
call TriggerAddCondition(gg_trg_yabiaoB,Condition(function Trig_yabiaoB_Conditions))
call TriggerAddAction(gg_trg_yabiaoB,function Trig_yabiaoB_Actions)
endfunction

function Trig_yabiaoB_Actions takes nothing returns nothing
call RemoveUnit(GetTriggerUnit())
set udg_SP=GetUnitLoc(gg_unit_nqb4_0244)
if(Trig_yabiaoB_Func003001())then
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
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—塔木村\n|r|cFFFFCC00李淮山：|r|cFFCCFFCC这个是你的酬金，拿好了！|r")
set udg_yabiaoA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FFFF你目前侠义值为|r:"+(" |cFFFFFF00"+(I2S(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FFFF点|r"))))
endfunction

function Trig_yabiaoB_Conditions takes nothing returns boolean
if(not(udg_yabiaoA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='hrdh'))then
return false
endif
return true
endfunction