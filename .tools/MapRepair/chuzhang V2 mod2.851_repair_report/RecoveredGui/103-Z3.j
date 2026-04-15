//=========================================================================== 
// Trigger: Z3
//=========================================================================== 
function InitTrig_Z3 takes nothing returns nothing
set gg_trg_Z3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Z3,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_Z3,Condition(function Trig_Z3_Conditions))
call TriggerAddAction(gg_trg_Z3,function Trig_Z3_Actions)
endfunction

function Trig_Z3_Actions takes nothing returns nothing
if(Trig_Z3_Func001C())then
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cffff0000"+(I2S(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"hit|R")))
call UnitAddAbilityBJ('A019',GetTriggerUnit())
call RemoveUnitBuff(GetTriggerUnit(),'A019',1.5)
set udg_P=GetUnitLoc(GetTriggerUnit())
call PlaySoundAtPointBJ(gg_snd_ImpaleHit,100,udg_P,0)
set udg_SP=PolarProjectionBJ(udg_P,300.00,GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,'edry',GetOwningPlayer(GetTriggerUnit()),udg_P,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssuePointOrderLoc(GetLastCreatedUnit(),"impale",udg_SP)
set udg_GROUP=GetUnitsInRangeOfLocMatching(300.00,udg_SP,Condition(function Trig_Z3_Func001Func013002003))
call ForGroupBJ(udg_GROUP,function Trig_Z3_Func001Func014A)
call RemoveLocation(udg_P)
call RemoveLocation(udg_SP)
call DestroyGroup(udg_GROUP)
else
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endif
endfunction

function Trig_Z3_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A016'))then
return false
endif
return true
endfunction

function Trig_Z3_Func001Func013002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction