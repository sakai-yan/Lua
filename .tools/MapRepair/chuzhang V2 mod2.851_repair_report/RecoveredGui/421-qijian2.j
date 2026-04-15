//=========================================================================== 
// Trigger: qijian2
//=========================================================================== 
function InitTrig_qijian2 takes nothing returns nothing
set gg_trg_qijian2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qijian2,356.00,gg_unit_ngir_0369)
call TriggerAddCondition(gg_trg_qijian2,Condition(function Trig_qijian2_Conditions))
call TriggerAddAction(gg_trg_qijian2,function Trig_qijian2_Actions)
endfunction

function Trig_qijian2_Actions takes nothing returns nothing
if(Trig_qijian2_Func001C())then
set udg_MP_qijian_true[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngir_0369)
if(Trig_qijian2_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓小云：|r|cFFCCFFCC我其实很想回万剑山，但我好害怕沿途的怪叔叔（强盗）```现在有你保护我，我就不怕了。我们快走吧!我好想我哥哥了```\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00护送卓小云回御剑门|r")
if(Trig_qijian2_Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_qijian2_Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call CreateNUnitsAtLoc(1,'nwe1',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca2',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_qijian2_Conditions takes nothing returns boolean
if(not(udg_MP_qijian1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qijian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction