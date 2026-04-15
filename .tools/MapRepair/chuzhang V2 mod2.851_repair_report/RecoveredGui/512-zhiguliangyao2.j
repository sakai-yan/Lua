//=========================================================================== 
// Trigger: zhiguliangyao2
//=========================================================================== 
function InitTrig_zhiguliangyao2 takes nothing returns nothing
set gg_trg_zhiguliangyao2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhiguliangyao2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_zhiguliangyao2,Condition(function Trig_zhiguliangyao2_Conditions))
call TriggerAddAction(gg_trg_zhiguliangyao2,function Trig_zhiguliangyao2_Actions)
endfunction

function Trig_zhiguliangyao2_Actions takes nothing returns nothing
if(Trig_zhiguliangyao2_Func001C())then
if(Trig_zhiguliangyao2_Func001Func001C())then
set udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC百|r|cFFCCFFE6合|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
if(Trig_zhiguliangyao2_Func001Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC百|r|cFFCCFFE6合|r|cFFCCFFFF草|r"+(" |cFFFFFF00"+(I2S(udg_zhigu_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99百合草收集完成，回去找伊不活吧|r")
set udg_SP=GetUnitLoc(gg_unit_ndrp_0299)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,20.00)
if(Trig_zhiguliangyao2_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(15.00)
call CreateItemLoc('klmm',udg_R_zhigu_p1[GetRandomInt(1,5)])
endfunction

function Trig_zhiguliangyao2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='klmm'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction