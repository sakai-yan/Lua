//=========================================================================== 
// Trigger: daokuang7
//=========================================================================== 
function InitTrig_daokuang7 takes nothing returns nothing
set gg_trg_daokuang7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_daokuang7,356.00,gg_unit_zcso_0720)
call TriggerAddCondition(gg_trg_daokuang7,Condition(function Trig_daokuang7_Conditions))
call TriggerAddAction(gg_trg_daokuang7,function Trig_daokuang7_Actions)
endfunction

function Trig_daokuang7_Actions takes nothing returns nothing
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
if(Trig_daokuang7_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC我们又多了一名潇洒的刀狂，很好！！但凡事疯狂也要有个度，哪怕你不畏惧死亡。\n\n|r|cFF00FF00成|r|cFF33FF40功|r|cFF66FF80转|r|cFF99FFBF职|r|cFFCCFFFF：|r|cFFFFFF00刀狂\n|r")
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('AOcr',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Aflk',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='AOcr'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='Aflk'
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
endfunction

function Trig_daokuang7_Conditions takes nothing returns boolean
if(not(udg_MP_daokuang4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction