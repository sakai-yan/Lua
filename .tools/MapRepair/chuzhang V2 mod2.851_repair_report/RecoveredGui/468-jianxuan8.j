//=========================================================================== 
// Trigger: jianxuan8
//=========================================================================== 
function InitTrig_jianxuan8 takes nothing returns nothing
set gg_trg_jianxuan8=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan8,356.00,gg_unit_nsel_0597)
call TriggerAddCondition(gg_trg_jianxuan8,Condition(function Trig_jianxuan8_Conditions))
call TriggerAddAction(gg_trg_jianxuan8,function Trig_jianxuan8_Actions)
endfunction

function Trig_jianxuan8_Actions takes nothing returns nothing
set udg_MP_jianxuan8[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsel_0597)
if(Trig_jianxuan8_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00岩青：|r|cFFCCFFCC居然发生了这种事情~~~但你别忘了他毕竟是一个修炼邪魔之术的太虚叛徒。别被他的言行迷惑，再下山去吧，这次务必要把他捉住！！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00再次去捉拿尹月行|r")
if(Trig_jianxuan8_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan8_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan8_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan8[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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