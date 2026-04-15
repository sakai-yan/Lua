//=========================================================================== 
// Trigger: qiaomu2
//=========================================================================== 
function InitTrig_qiaomu2 takes nothing returns nothing
set gg_trg_qiaomu2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qiaomu2,356.00,gg_unit_npn5_0261)
call TriggerAddCondition(gg_trg_qiaomu2,Condition(function Trig_qiaomu2_Conditions))
call TriggerAddAction(gg_trg_qiaomu2,function Trig_qiaomu2_Actions)
endfunction

function Trig_qiaomu2_Actions takes nothing returns nothing
if(Trig_qiaomu2_Func001C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'tbar')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn5_0261)
if(Trig_qiaomu2_Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁叔祖：|r|cFFCCFFCC恩，手工还可以，考试就通过吧！要记住，日后多多勤加观察和制作，别把巧木坊的招牌给摸黑了。巧木作坊，天下第一坊！\n\n|r|cFF00FF00成|r|cFF00FF55功|r|cFF00FFAA转|r|cFF00FFFF职|r|cFFCCFFCC：|r|cFFFFFF00铸流匠")
call RemoveLocation(udg_SP)
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A029',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AHwe',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
//55555555555555555555555555555555555555555555555555
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A029'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='AHwe'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
endif
if(Trig_qiaomu2_Func002C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sor7')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn5_0261)
if(Trig_qiaomu2_Func002Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁叔祖：|r|cFFCCFFCC恩，手工还可以，考试就通过吧！要记住，日后多多勤加观察和制作，别把巧木坊的招牌给摸黑了。巧木作坊，天下第一坊！\n\n|r|cFF00FF00成|r|cFF00FF55功|r|cFF00FFAA转|r|cFF00FFFF职|r|cFFCCFFCC：|r|cFFFFFF00铸流匠")
call RemoveLocation(udg_SP)
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A029',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AHwe',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A029'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='AHwe'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
endif
endfunction

function Trig_qiaomu2_Conditions takes nothing returns boolean
if(not(udg_MP_qiaomu1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qiaomu4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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