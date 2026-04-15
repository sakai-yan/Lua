//=========================================================================== 
// Trigger: caiji2
//=========================================================================== 
function InitTrig_caiji2 takes nothing returns nothing
set gg_trg_caiji2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_caiji2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_caiji2,Condition(function Trig_caiji2_Conditions))
call TriggerAddAction(gg_trg_caiji2,function Trig_caiji2_Actions)
endfunction

function Trig_caiji2_Actions takes nothing returns nothing
if(Trig_caiji2_Func001C())then
if(Trig_caiji2_Func001Func001C())then
set udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC生|r|cFFCCFFE6甘|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/7|r"))))
if(Trig_caiji2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC生|r|cFFCCFFE6甘|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_shenggancao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/7|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99生甘草收集完成，回去找谢大夫吧|r")
set udg_SP=GetUnitLoc(gg_unit_npn2_0009)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_caiji2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(7.00)
call CreateItemLoc('rnec',udg_R_shenggancao_p1[GetRandomInt(1,6)])
endfunction

function Trig_caiji2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rnec'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction