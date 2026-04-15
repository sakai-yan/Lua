//=========================================================================== 
// Trigger: qingzao2
//=========================================================================== 
function InitTrig_qingzao2 takes nothing returns nothing
set gg_trg_qingzao2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qingzao2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_qingzao2,Condition(function Trig_qingzao2_Conditions))
call TriggerAddAction(gg_trg_qingzao2,function Trig_qingzao2_Actions)
endfunction

function Trig_qingzao2_Actions takes nothing returns nothing
if(Trig_qingzao2_Func001C())then
if(Trig_qingzao2_Func001Func001C())then
set udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC青|r|cFFCCFFFF枣|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
if(Trig_qingzao2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC青|r|cFFCCFFFF枣|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/20|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99青枣收集完成，回去找阿苟姑娘吧|r")
set udg_SP=GetUnitLoc(gg_unit_nqb1_0093)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_qingzao2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(8.50)
call CreateItemLoc('mcri',udg_R_qingzao_p1[GetRandomInt(1,8)])
endfunction

function Trig_qingzao2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='mcri'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction