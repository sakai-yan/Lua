//=========================================================================== 
// Trigger: Z2
//=========================================================================== 
function InitTrig_Z2 takes nothing returns nothing
set gg_trg_Z2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Z2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_Z2,Condition(function Trig_Z2_Conditions))
call TriggerAddAction(gg_trg_Z2,function Trig_Z2_Actions)
endfunction

function Trig_Z2_Actions takes nothing returns nothing
if(Trig_Z2_Func001C())then
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cffff0000"+(I2S(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"hit|R")))
call UnitAddAbilityBJ('A01A',GetTriggerUnit())
call RemoveUnitBuff(GetTriggerUnit(),'A01A',1.5)
set udg_P=GetUnitLoc(GetTriggerUnit())
call PlaySoundAtPointBJ(gg_snd_ImpaleHit,100,udg_P,0)
set udg_PP=PolarProjectionBJ(udg_P,220.00,GetUnitFacing(GetTriggerUnit()))
set udg_GROUP=GetUnitsInRangeOfLocMatching(300.00,udg_PP,Condition(function Trig_Z2_Func001Func010002003))
call ForGroupBJ(udg_GROUP,function Trig_Z2_Func001Func011A)
call CreateNUnitsAtLoc(1,'ehpr',GetOwningPlayer(GetTriggerUnit()),udg_PP,bj_UNIT_FACING)
call SetUnitAnimation(GetLastCreatedUnit(),"Birth")
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_P)
call RemoveLocation(udg_PP)
call DestroyGroup(udg_GROUP)
else
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endif
endfunction

function Trig_Z2_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A015'))then
return false
endif
return true
endfunction

function Trig_Z2_Func001Func010002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction