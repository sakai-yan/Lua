//=========================================================================== 
// Trigger: Z0
//=========================================================================== 
function InitTrig_Z0 takes nothing returns nothing
set gg_trg_Z0=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Z0,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_Z0,Condition(function Trig_Z0_Conditions))
call TriggerAddAction(gg_trg_Z0,function Trig_Z0_Actions)
endfunction

function Trig_Z0_Actions takes nothing returns nothing
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cffff0000"+(I2S(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"hit|R")))
call UnitAddAbilityBJ('A01B',GetTriggerUnit())
call RemoveUnitBuff(GetTriggerUnit(),'A01B',1.5)
set udg_P=GetUnitLoc(GetTriggerUnit())
set udg_PP=PolarProjectionBJ(udg_P,200.00,GetUnitFacing(GetTriggerUnit()))
set udg_GROUP=GetUnitsInRangeOfLocMatching(50.00,udg_PP,Condition(function Trig_Z0_Func009002003))
call ForGroupBJ(udg_GROUP,function Trig_Z0_Func010A)
call CreateNUnitsAtLoc(1,'ebal',GetOwningPlayer(GetTriggerUnit()),udg_PP,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_P)
call RemoveLocation(udg_PP)
call DestroyGroup(udg_GROUP)
endfunction

function Trig_Z0_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A013'))then
return false
endif
return true
endfunction

function Trig_Z0_Func009002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction