//=========================================================================== 
// Trigger: shudao1
//=========================================================================== 
function InitTrig_shudao1 takes nothing returns nothing
set gg_trg_shudao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shudao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shudao1,Condition(function Trig_shudao1_Conditions))
call TriggerAddAction(gg_trg_shudao1,function Trig_shudao1_Actions)
endfunction

function Trig_shudao1_Actions takes nothing returns nothing
if(Trig_shudao1_Func001C())then
if(Trig_shudao1_Func001Func002C())then
if(Trig_shudao1_Func001Func002Func003C())then
set udg_MP_shudao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
if(Trig_shudao1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF大义之章\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00找张真人谈谈\n|r|cFFFFCC00宋江山：|r|cFFCCFFCC魔界裂缝已开许久，天下大乱，修道之人当以拯救苍生为己任。你的修为达到了一个新的阶段，是时候到混乱的尘间绽放你的血与汗了。找我们的掌门张真人谈谈，他会指引你的道路的。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_shudao1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00宋江山：|r|cFFCCFFCC掌门正在大殿休息呢，你快去找他吧。|r")
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00宋江山：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00宋江山：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
endfunction

function Trig_shudao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='stwp'))then
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