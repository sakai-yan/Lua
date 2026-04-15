//=========================================================================== 
// Trigger: qijian3
//=========================================================================== 
function InitTrig_qijian3 takes nothing returns nothing
set gg_trg_qijian3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qijian3,356.00,gg_unit_ndh1_0368)
call TriggerAddCondition(gg_trg_qijian3,Condition(function Trig_qijian3_Conditions))
call TriggerAddAction(gg_trg_qijian3,function Trig_qijian3_Actions)
endfunction

function Trig_qijian3_Actions takes nothing returns nothing
call RemoveUnit(GetTriggerUnit())
set udg_MP_qijian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
if(Trig_qijian3_Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：卓小云已经安全地回到了御剑门！找卓腾云谈谈吧！|r")
call RemoveLocation(udg_SP)
endfunction

function Trig_qijian3_Conditions takes nothing returns boolean
if(not(udg_MP_qijian1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qijian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nwe2'))then
return false
endif
return true
endfunction