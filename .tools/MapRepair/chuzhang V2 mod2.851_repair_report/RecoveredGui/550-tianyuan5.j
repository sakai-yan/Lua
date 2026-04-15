//=========================================================================== 
// Trigger: tianyuan5
//=========================================================================== 
function InitTrig_tianyuan5 takes nothing returns nothing
set gg_trg_tianyuan5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan5,356.00,gg_unit_nftk_0733)
call TriggerAddCondition(gg_trg_tianyuan5,Condition(function Trig_tianyuan5_Conditions))
call TriggerAddAction(gg_trg_tianyuan5,function Trig_tianyuan5_Actions)
endfunction

function Trig_tianyuan5_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00天策乾坤：|r|cFFCCFFCC如今武林浩荡，明争暗斗，却不知暗涌绵绵，可悲啊。大侠到此寻求灭魔圣器，乃有缘人也。仙魔相克，灭魔圣器其实便是仙物。凡间能勉强称为仙物者，于我所见，需要利用|r|cFF00FF00圣器|r|cFFCCFFCC融合|r|cFF00FF00四象|r|cFFCCFFCC和|r|cFF00FF00四方|r|cFFCCFFCC之力，辅以|r|cFF00FF00仙物|r|cFFCCFFCC方能制造。我会逐步指引你去制作此物。这是第一个步骤的材料，你去收集回来吧。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00制作圣器，然后回来找天策乾坤|r")
if(Trig_tianyuan5_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan5_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call UnitAddItemByIdSwapped('I01G',GetTriggerUnit())
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan5_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==4))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction