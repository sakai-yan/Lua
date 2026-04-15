//=========================================================================== 
// Trigger: guimei7
//=========================================================================== 
function InitTrig_guimei7 takes nothing returns nothing
set gg_trg_guimei7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_guimei7,356.00,gg_unit_ncgb_0629)
call TriggerAddCondition(gg_trg_guimei7,Condition(function Trig_guimei7_Conditions))
call TriggerAddAction(gg_trg_guimei7,function Trig_guimei7_Actions)
endfunction

function Trig_guimei7_Actions takes nothing returns nothing
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
if(Trig_guimei7_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC提起精神，江湖比你现在做得要更加血腥！去吧！\n\n|r|cFF00FF00成|r|cFF33FF40功|r|cFF66FF80转|r|cFF99FFBF职|r|cFFCCFFFF：|r|cFFFFFF00鬼阎\n|r")
call RemoveLocation(udg_SP)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A016'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='A017'
call UnitAddAbilityBJ('A016',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A017',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A016',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A017',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
endfunction

function Trig_guimei7_Conditions takes nothing returns boolean
if(not(udg_MP_guiyan4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
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