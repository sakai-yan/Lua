//=========================================================================== 
// Trigger: Z4
//=========================================================================== 
function InitTrig_Z4 takes nothing returns nothing
set gg_trg_Z4=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Z4,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_Z4,Condition(function Trig_Z4_Conditions))
call TriggerAddAction(gg_trg_Z4,function Trig_Z4_Actions)
endfunction

function Trig_Z4_Actions takes nothing returns nothing
if(Trig_Z4_Func001C())then
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cffff0000"+(I2S(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"hit|R")))
call UnitAddAbilityBJ('A018',GetTriggerUnit())
call RemoveUnitBuff(GetTriggerUnit(),'A018',1.5)
set udg_P=GetUnitLoc(GetTriggerUnit())
set udg_GROUP=GetUnitsInRangeOfLocMatching(320.00,udg_P,Condition(function Trig_Z4_Func001Func008002003))
call ForGroupBJ(udg_GROUP,function Trig_Z4_Func001Func009A)
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=16
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP=PolarProjectionBJ(udg_P,180.00,(20.00*I2R(GetForLoopIndexA())))
call CreateNUnitsAtLoc(1,'ebal',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call PolledWait(0.10)
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=16
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP=PolarProjectionBJ(udg_P,280.00,(20.00*I2R(GetForLoopIndexA())))
call CreateNUnitsAtLoc(1,'ebal',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call RemoveLocation(udg_P)
call DestroyGroup(udg_GROUP)
else
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endif
endfunction

function Trig_Z4_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A017'))then
return false
endif
return true
endfunction

function Trig_Z4_Func001Func008002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction