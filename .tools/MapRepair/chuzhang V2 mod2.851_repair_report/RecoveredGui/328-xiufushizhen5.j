//=========================================================================== 
// Trigger: xiufushizhen5
//=========================================================================== 
function InitTrig_xiufushizhen5 takes nothing returns nothing
set gg_trg_xiufushizhen5=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiufushizhen5,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xiufushizhen5,Condition(function Trig_xiufushizhen5_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen5,function Trig_xiufushizhen5_Actions)
endfunction

function Trig_xiufushizhen5_Actions takes nothing returns nothing
if(Trig_xiufushizhen5_Func001C())then
if(Trig_xiufushizhen5_Func001Func001C())then
set udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC石|r|cFFCCFFFF料|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
if(Trig_xiufushizhen5_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
else
set udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC石|r|cFFCCFFFF料|r"+(" |cFFFFFF00"+(I2S(udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
if(Trig_xiufushizhen5_Func001Func001Func003C())then
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：|r|cFFFFFF00燃火精髓|r|cFFFFFF99和|r|cFFFFFF00石料|r|cFFFFFF99已经全部到手，回去找阿亥吧。|r")
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_xiufushizhen5_Func001Func001Func003Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：|r|cFFFFFF00石料|r|cFFFFFF99已经收集完成，尽快把|r|cFFFFFF00燃火精髓|r|cFFFFFF99抢到手吧。|r")
if(Trig_xiufushizhen5_Func001Func001Func003Func002001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
endif
endif
else
endif
call TriggerSleepAction(15.00)
call CreateItemLoc('sman',udg_R_xiufushizhen_p1[GetRandomInt(1,7)])
endfunction

function Trig_xiufushizhen5_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='sman'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction