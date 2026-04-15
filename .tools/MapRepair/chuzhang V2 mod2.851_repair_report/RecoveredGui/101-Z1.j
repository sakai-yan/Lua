//=========================================================================== 
// Trigger: Z1
//=========================================================================== 
function InitTrig_Z1 takes nothing returns nothing
set gg_trg_Z1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Z1,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_Z1,Condition(function Trig_Z1_Conditions))
call TriggerAddAction(gg_trg_Z1,function Trig_Z1_Actions)
endfunction

function Trig_Z1_Actions takes nothing returns nothing
if(Trig_Z1_Func001C())then
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cffff0000"+(I2S(udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"hit|R")))
call UnitAddAbilityBJ('A01C',GetTriggerUnit())
call RemoveUnitBuff(GetTriggerUnit(),'A01C',1.5)
set udg_P=GetUnitLoc(GetTriggerUnit())
call PlaySoundAtPointBJ(gg_snd_ImpaleHit,100,udg_P,0)
set udg_GROUP=GetUnitsInRangeOfLocMatching(280.00,udg_P,Condition(function Trig_Z1_Func001Func009002003))
call ForGroupBJ(udg_GROUP,function Trig_Z1_Func001Func010A)
call RemoveLocation(udg_P)
call DestroyGroup(udg_GROUP)
else
set udg_LIAN_JI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
endif
endfunction

function Trig_Z1_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A014'))then
return false
endif
return true
endfunction

function Trig_Z1_Func001Func009002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction