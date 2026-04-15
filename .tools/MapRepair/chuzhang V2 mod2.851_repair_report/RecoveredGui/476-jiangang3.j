//=========================================================================== 
// Trigger: jiangang3
//=========================================================================== 
function InitTrig_jiangang3 takes nothing returns nothing
set gg_trg_jiangang3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jiangang3,356.00,gg_unit_nwnr_0520)
call TriggerAddCondition(gg_trg_jiangang3,Condition(function Trig_jiangang3_Conditions))
call TriggerAddAction(gg_trg_jiangang3,function Trig_jiangang3_Actions)
endfunction

function Trig_jiangang3_Actions takes nothing returns nothing
set udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nwnr_0520)
if(Trig_jiangang3_Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智慈大师：|r|cFFCCFFCC看你从正门走出来，虽然满身伤痕，但我必须恭喜你。你可以以金刚之名出山了。弘扬佛道，拯救苍生去吧！\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00金刚\n|r")
if(Trig_jiangang3_Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jiangang3_Func011001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('Atru',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AOre',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='Atru'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='AOre'


                                                               //99

call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_jiangang3_Conditions takes nothing returns boolean
if(not(udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jingang_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=18))then
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