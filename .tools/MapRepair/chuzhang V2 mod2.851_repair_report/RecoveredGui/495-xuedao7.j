//=========================================================================== 
// Trigger: xuedao7
//=========================================================================== 
function InitTrig_xuedao7 takes nothing returns nothing
set gg_trg_xuedao7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xuedao7,356.00,gg_unit_nwwg_0719)
call TriggerAddCondition(gg_trg_xuedao7,Condition(function Trig_xuedao7_Conditions))
call TriggerAddAction(gg_trg_xuedao7,function Trig_xuedao7_Actions)
endfunction

function Trig_xuedao7_Actions takes nothing returns nothing
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
set udg_SP=GetUnitLoc(gg_unit_nwwg_0719)
if(Trig_xuedao7_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC你通过了，我现在传授你两招血刀招式，看好了！！\n\n|r|cFF00FF00成|r|cFF33FF40功|r|cFF66FF80转|r|cFF99FFBF职|r|cFFCCFFFF：|r|cFFFFFF00血刀\n|r")
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('AOcl',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AIpv',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='AOcl'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='AIpv'
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
endfunction

function Trig_xuedao7_Conditions takes nothing returns boolean
if(not(udg_MP_xuedao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction