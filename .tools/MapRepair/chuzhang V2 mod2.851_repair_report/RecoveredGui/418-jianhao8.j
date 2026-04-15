//=========================================================================== 
// Trigger: jianhao8
//=========================================================================== 
function InitTrig_jianhao8 takes nothing returns nothing
set gg_trg_jianhao8=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianhao8,356.00,gg_unit_nlv2_0262)
call TriggerAddCondition(gg_trg_jianhao8,Condition(function Trig_jianhao8_Conditions))
call TriggerAddAction(gg_trg_jianhao8,function Trig_jianhao8_Actions)
endfunction

function Trig_jianhao8_Actions takes nothing returns nothing
set udg_MP_jianhao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nlv2_0262)
if(Trig_jianhao8_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00蔡景阳：|r|cFFCCFFCC御剑门能有你这种出类拔萃的弟子，我感到非常的欣慰。拿好你的剑，在江湖斩妖除魔，行侠仗义吧!|r\n\n|cFF00FF00成|r|cFF00FF55功|r|cFF00FFAA转|r|cFF00FFFF职|r|cFFCCFFCC：|r|cFFFFFF00剑豪|r")
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('A04O',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A048',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])


                                                                           //3

set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A04O'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='A048'




call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_jianhao8_Conditions takes nothing returns boolean
if(not(udg_MP_jianhao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_jianhao_NUM3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=5))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
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