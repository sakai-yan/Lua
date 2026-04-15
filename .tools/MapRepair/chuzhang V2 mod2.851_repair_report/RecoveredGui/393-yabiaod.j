//=========================================================================== 
// Trigger: yabiaod
//=========================================================================== 
function InitTrig_yabiaod takes nothing returns nothing
set gg_trg_yabiaod=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_yabiaod,356.00,gg_unit_ndr3_0263)
call TriggerAddCondition(gg_trg_yabiaod,Condition(function Trig_yabiaod_Conditions))
call TriggerAddAction(gg_trg_yabiaod,function Trig_yabiaod_Actions)
endfunction

function Trig_yabiaod_Actions takes nothing returns nothing
call ForGroupBJ(GetUnitsInRectMatching(GetPlayableMapRect(),Condition(function Trig_yabiaod_Func001001002)),function Trig_yabiaod_Func001A)
set udg_SP=GetUnitLoc(gg_unit_ndr3_0263)
if(Trig_yabiaod_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+130|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(13000,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+13000)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF押镖—寻仙村\n|r|cFFFFCC00伍百：|r|cFFCCFFCC这个是你的酬金，拿好了！|r")
set udg_yabiaoc[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FFFF你目前侠义值为|r:"+(" |cFFFFFF00"+(I2S(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FFFF点|r"))))
endfunction

function Trig_yabiaod_Conditions takes nothing returns boolean
if(not(udg_yabiaoc[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nbel'))then
return false
endif
return true
endfunction

function Trig_yabiaod_Func001001002 takes nothing returns boolean
return GetBooleanAnd(Trig_yabiaod_Func001001002001(),Trig_yabiaod_Func001001002002())
endfunction