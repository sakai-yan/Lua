//=========================================================================== 
// Trigger: yaohua2
//=========================================================================== 
function InitTrig_yaohua2 takes nothing returns nothing
set gg_trg_yaohua2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yaohua2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yaohua2,Condition(function Trig_yaohua2_Conditions))
call TriggerAddAction(gg_trg_yaohua2,function Trig_yaohua2_Actions)
endfunction

function Trig_yaohua2_Actions takes nothing returns nothing
if(Trig_yaohua2_Func001C())then
if(Trig_yaohua2_Func001Func001C())then
set udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC笄|r|cFFCCFFFF花|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
if(Trig_yaohua2_Func001Func001Func016001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,180.00,GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,'nenc',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(15.00,'BEfn',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
else
set udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC笄|r|cFFCCFFFF花|r"+(" |cFFFFFF00"+(I2S(udg_R_CJ_yaohua_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"|R|cFF00FF00/10|r"))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99笄花收集完成，回去找阿达吧|r")
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,180.00,GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,'nenc',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP2,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(15.00,'BEfn',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
set udg_SP=GetUnitLoc(gg_unit_ngz3_0167)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_yaohua2_Func001Func001Func012001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
else
endif
call TriggerSleepAction(20.00)
call CreateItemLoc('shar',udg_R_yaohua_p1[GetRandomInt(1,4)])
endfunction

function Trig_yaohua2_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='shar'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction