//=========================================================================== 
// Trigger: tailuo3
//=========================================================================== 
function InitTrig_tailuo3 takes nothing returns nothing
set gg_trg_tailuo3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tailuo3,356.00,gg_unit_nwen_0519)
call TriggerAddCondition(gg_trg_tailuo3,Condition(function Trig_tailuo3_Conditions))
call TriggerAddAction(gg_trg_tailuo3,function Trig_tailuo3_Actions)
endfunction

function Trig_tailuo3_Actions takes nothing returns nothing
set udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nwen_0519)
if(Trig_tailuo3_Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智明大师：|r|cFFCCFFCC我为苍生感到欣慰，又一个佛圣门的禅师出现了。快下山去吧！记住，佛与魔之间只有一线之差，切记切记~~~~~\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00太罗\n|r")
if(Trig_tailuo3_Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tailuo3_Func011001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('Afzy',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Atau',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='Afzy'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='A04F'
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_tailuo3_Conditions takes nothing returns boolean
if(not(udg_MP_tailuo1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
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