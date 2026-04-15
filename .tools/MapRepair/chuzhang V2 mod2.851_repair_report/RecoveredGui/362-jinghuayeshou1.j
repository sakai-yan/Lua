//=========================================================================== 
// Trigger: jinghuayeshou1
//=========================================================================== 
function InitTrig_jinghuayeshou1 takes nothing returns nothing
set gg_trg_jinghuayeshou1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jinghuayeshou1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_jinghuayeshou1,Condition(function Trig_jinghuayeshou1_Conditions))
call TriggerAddAction(gg_trg_jinghuayeshou1,function Trig_jinghuayeshou1_Actions)
endfunction

function Trig_jinghuayeshou1_Actions takes nothing returns nothing
if(Trig_jinghuayeshou1_Func001C())then
if(Trig_jinghuayeshou1_Func001Func003C())then
set udg_R_jinghua1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetRectCenter(gg_rct______________008)
if(Trig_jinghuayeshou1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF净化野兽（1）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00净化15头羚鹿         \n|r|cFFFFCC00塔木村长：|r|cFFCCFFCC羚鹿过去是多么的温顺，但受到妖气影响，脾气变得暴躁凶残，经常袭击我们的猎人和柴夫~~~用这个|r|cFF00FF00退灵散|r|cFFCCFFCC来|r|cFF00FF00净化|r|cFFCCFFCC它们吧！虽然麻烦，但总比杀死好~~~|r")
call UnitAddItemByIdSwapped('will',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________008)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_jinghuayeshou1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='fgrg'))then
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