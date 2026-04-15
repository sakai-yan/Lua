//=========================================================================== 
// Trigger: jinghuayeshou2
//=========================================================================== 
function InitTrig_jinghuayeshou2 takes nothing returns nothing
set gg_trg_jinghuayeshou2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jinghuayeshou2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_jinghuayeshou2,Condition(function Trig_jinghuayeshou2_Conditions))
call TriggerAddAction(gg_trg_jinghuayeshou2,function Trig_jinghuayeshou2_Actions)
endfunction

function Trig_jinghuayeshou2_Actions takes nothing returns nothing
if(Trig_jinghuayeshou2_Func001C())then
if(Trig_jinghuayeshou2_Func001Func001C())then
set udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC净|r|cFFCCFFDD化|r|cFFCCFFEE羚|r|cFFCCFFFF鹿|r"+(" |cFFFFFF00"+(I2S(udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/15|r"))))
if(Trig_jinghuayeshou2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
call KillUnit(GetSpellTargetUnit())
else
set udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC净|r|cFFCCFFDD化|r|cFFCCFFEE羚|r|cFFCCFFFF鹿|r"+(" |cFFFFFF00"+(I2S(udg_R_jinghua_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/15|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：净化了足够数量的羚鹿，回去找塔木村长吧！|r")
set udg_SP=GetUnitLoc(gg_unit_ncg3_0189)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_jinghuayeshou2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
endfunction

function Trig_jinghuayeshou2_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))==MAP_CONTROL_USER))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(GetUnitTypeId(GetSpellTargetUnit())=='njgb'))then
return false
endif
if(not(GetSpellAbilityId()=='A06N'))then
return false
endif
return true
endfunction