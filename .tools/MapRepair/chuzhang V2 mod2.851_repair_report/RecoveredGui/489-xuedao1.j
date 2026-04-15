//=========================================================================== 
// Trigger: xuedao1
//=========================================================================== 
function InitTrig_xuedao1 takes nothing returns nothing
set gg_trg_xuedao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xuedao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xuedao1,Condition(function Trig_xuedao1_Conditions))
call TriggerAddAction(gg_trg_xuedao1,function Trig_xuedao1_Actions)
endfunction

function Trig_xuedao1_Actions takes nothing returns nothing
if(Trig_xuedao1_Func001C())then
if(Trig_xuedao1_Func001Func002C())then
if(Trig_xuedao1_Func001Func002Func003C())then
set udg_MP_xuedao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nwwg_0719)
if(Trig_xuedao1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF刀之觉悟\n|r|cFFFFCC00卯人敌：|r|cFFCCFFCC血刀者，必须血源与武器相连。而血源引导必须依靠至纯至阴的灵气。拥有此等灵气者，乃|r|cFF00FF00咕噜龙|r|cFFCCFFCC不可。去魂山下杀咕噜龙，|r|cFF00FF00收集15份纯阴之气|r|cFFCCFFCC回来吧。\n\n任务提示：|r|cFF00FF00杀咕噜龙收集15份纯阴之气|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________090)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_xuedao1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC拿你的菜刀砍除这个世间的孽瘴去吧！|r")
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
endfunction

function Trig_xuedao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='wneg'))then
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