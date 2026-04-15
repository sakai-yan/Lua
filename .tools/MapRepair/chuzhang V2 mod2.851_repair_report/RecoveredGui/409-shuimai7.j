//=========================================================================== 
// Trigger: shuimai7
//=========================================================================== 
function InitTrig_shuimai7 takes nothing returns nothing
set gg_trg_shuimai7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shuimai7,356.00,gg_unit_nsha_0367)
call TriggerAddCondition(gg_trg_shuimai7,Condition(function Trig_shuimai7_Conditions))
call TriggerAddAction(gg_trg_shuimai7,function Trig_shuimai7_Actions)
endfunction

function Trig_shuimai7_Actions takes nothing returns nothing
set udg_MP_shuimai4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsha_0367)
if(Trig_shuimai7_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC我很佩服你的能力，更佩服你的勇气，你是真正的水脉师。紧握你的侠义之道，撰写你新的历程吧！\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00水脉师|r")
call UnitRemoveAbilityBJ('A002',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Aslo',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A011',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A089',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+2)]='A011'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+3)]='AUfn'
                                                                                                  //2
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='Aslo'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='A089'



call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_shuimai7_Conditions takes nothing returns boolean
if(not(udg_MP_shuimai3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shuimai4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_shuimai_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=7))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction