//=========================================================================== 
// Trigger: tianyuan41
//=========================================================================== 
function InitTrig_tianyuan41 takes nothing returns nothing
set gg_trg_tianyuan41=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan41,356.00,gg_unit_ngz1_0002)
call TriggerAddCondition(gg_trg_tianyuan41,Condition(function Trig_tianyuan41_Conditions))
call TriggerAddAction(gg_trg_tianyuan41,function Trig_tianyuan41_Actions)
endfunction

function Trig_tianyuan41_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=4
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00老村长：|r|cFFCCFFCC我不了解什么灭魔圣器，或许我的祖先遗留的书籍里会有些记载吧，大侠稍等一会~~~~\n|r|cFFC0C0C0顷刻之后···\n|r|cFFFFCC00老村长：|r|cFFCCFFCC书籍里有一段关于杀死魔者的记载：|r|cFF00FF00天地四方，凝而聚合，非玄金不能；星宿四象，收以为用，非晶魂不利|r|cFFCCFFCC。看来这便是你们所寻求的灭魔圣器的铸造方法吧。对于八卦相学非我能理解，我建议你去找一个称为|r|cFF00FF00天策乾\n坤|r|cFFCCFFCC的道长吧，他是一个无所不知的神人。现在应该在|r|cFF00FF00东海群岛的琊谷附近。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00寻找天策乾坤|r")
if(Trig_tianyuan41_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan41_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nftk_0733)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan41_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==3))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not Trig_tianyuan41_Func013C())then
return false
endif
return true
endfunction