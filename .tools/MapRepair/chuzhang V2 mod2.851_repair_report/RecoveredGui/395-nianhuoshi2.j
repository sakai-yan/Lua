//=========================================================================== 
// Trigger: nianhuoshi2
//=========================================================================== 
function InitTrig_nianhuoshi2 takes nothing returns nothing
set gg_trg_nianhuoshi2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_nianhuoshi2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_nianhuoshi2,Condition(function Trig_nianhuoshi2_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi2,function Trig_nianhuoshi2_Actions)
endfunction

function Trig_nianhuoshi2_Actions takes nothing returns nothing
if(Trig_nianhuoshi2_Func001C())then
if(Trig_nianhuoshi2_Func001Func002C())then
if(Trig_nianhuoshi2_Func001Func002Func001C())then
set udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC灵|r|cFFCCFFDD力|r|cFFCCFFEE火|r|cFFCCFFFF种|r"+(" |cFFFFFF00"+(I2S(udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/5|r"))))
if(Trig_nianhuoshi2_Func001Func002Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call UnitRemoveAbilityBJ('A01Y',GetSpellTargetUnit())
call SetUnitAnimation(GetSpellTargetUnit(),"Death")
call UnitApplyTimedLifeBJ(60,'BTLF',GetSpellTargetUnit())
else
set udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC灵|r|cFFCCFFDD力|r|cFFCCFFEE火|r|cFFCCFFFF种|r"+(" |cFFFFFF00"+(I2S(udg_MP_nianhuoshi_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/5|r"))))
if(Trig_nianhuoshi2_Func001Func002Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：灵力火种已经收集完成，回去找胡不留吧！|r")
call UnitRemoveAbilityBJ('A01Y',GetSpellTargetUnit())
call SetUnitAnimation(GetSpellTargetUnit(),"Death")
call UnitApplyTimedLifeBJ(60,'BTLF',GetSpellTargetUnit())
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endif
else
if(Trig_nianhuoshi2_Func001Func002Func002001())then
call PlaySoundAtPointBJ(gg_snd_QuestLog,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000没有火种|r")
endif
else
endif
endfunction

function Trig_nianhuoshi2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetUnitTypeId(GetSpellTargetUnit())=='npng'))then
return false
endif
if(not(GetSpellAbilityId()=='A01Y'))then
return false
endif
return true
endfunction