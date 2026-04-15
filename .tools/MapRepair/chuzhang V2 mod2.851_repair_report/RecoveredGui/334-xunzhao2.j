//=========================================================================== 
// Trigger: xunzhao2
//=========================================================================== 
function InitTrig_xunzhao2 takes nothing returns nothing
set gg_trg_xunzhao2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xunzhao2,256,gg_unit_ngsp_0145)
call TriggerAddCondition(gg_trg_xunzhao2,Condition(function Trig_xunzhao2_Conditions))
call TriggerAddAction(gg_trg_xunzhao2,function Trig_xunzhao2_Actions)
endfunction

function Trig_xunzhao2_Actions takes nothing returns nothing
set udg_R_xunzhaotongmen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
if(Trig_xunzhao2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
set udg_SP=GetUnitLoc(gg_unit_npn6_0144)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_xunzhao2_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：寻找到了|r|cFFFFFF00周适|r|cFFFFFF99的尸体，回去向雷风汇报吧。|r")
endfunction

function Trig_xunzhao2_Conditions takes nothing returns boolean
if(not(udg_R_xunzhaotongmen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_xunzhaotongmen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction