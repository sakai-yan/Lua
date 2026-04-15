//=========================================================================== 
// Trigger: tianyuan33
//=========================================================================== 
function InitTrig_tianyuan33 takes nothing returns nothing
set gg_trg_tianyuan33=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan33,356.00,gg_unit_nfh1_0124)
call TriggerAddCondition(gg_trg_tianyuan33,Condition(function Trig_tianyuan33_Conditions))
call TriggerAddAction(gg_trg_tianyuan33,function Trig_tianyuan33_Actions)
endfunction

function Trig_tianyuan33_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC尹月行修炼的乃是阴阳禁术，能使唤死灵和邪魔，施放天地禁制，自身的武学更是毫不逊色于武林宗师。对于灭魔一事我们不同于武林各派的以战为主，我清心阁更倾向于以救为己任，静心救治在魔祸里受伤人的世人。|r|cFF00FF00文莱村村长|r|cFFCCFFCC是吾挚友，他或许对于魔的来历比我更了解，你不妨去探访下他吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到文莱村找村长|r")
if(Trig_tianyuan33_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan33_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan33_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not Trig_tianyuan33_Func013C())then
return false
endif
return true
endfunction