//=========================================================================== 
// Trigger: tianyuan37
//=========================================================================== 
function InitTrig_tianyuan37 takes nothing returns nothing
set gg_trg_tianyuan37=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan37,356.00,gg_unit_ndh0_0717)
call TriggerAddCondition(gg_trg_tianyuan37,Condition(function Trig_tianyuan37_Conditions))
call TriggerAddAction(gg_trg_tianyuan37,function Trig_tianyuan37_Actions)
endfunction

function Trig_tianyuan37_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00史前能：|r|cFFCCFFCC太虚门那个叛徒最近被传得沸沸扬扬，许多门派都将他正法，以立声望。月刀门岁不图声望，但此人的功法或许对于我门有着至关重要的作用。去寻来灭魔圣器，尝试下让他交出修炼功法吧。|r|cFF00FF00龙泉镇山海镖局的总镖头|r|cFFCCFFCC和我有一定交情，去找他询问关于灭魔圣器的事情吧，我想他应该知道一点消息的。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到龙泉镇找任我飞|r")
if(Trig_tianyuan37_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan37_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ndtp_0375)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan37_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==2))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('A04J',GetTriggerUnit())!=0))then
return false
endif
return true
endfunction