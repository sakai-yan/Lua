//=========================================================================== 
// Trigger: daokuang1
//=========================================================================== 
function InitTrig_daokuang1 takes nothing returns nothing
set gg_trg_daokuang1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_daokuang1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_daokuang1,Condition(function Trig_daokuang1_Conditions))
call TriggerAddAction(gg_trg_daokuang1,function Trig_daokuang1_Actions)
endfunction

function Trig_daokuang1_Actions takes nothing returns nothing
if(Trig_daokuang1_Func001C())then
if(Trig_daokuang1_Func001Func002C())then
if(Trig_daokuang1_Func001Func002Func003C())then
set udg_MP_daokuang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
if(Trig_daokuang1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF刀之狂野\n|r|cFFFFCC00卯人敌：|r|cFFCCFFCC刀狂，最重要的气质就是无畏！你觉得自己能做到么？那么就去塔木森林轰轰烈烈地杀|r|cFF00FF0015|r|cFFCCFFCC只|r|cFF00FF00暴怒鹿妖|r|cFFCCFFCC试试吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死15只暴怒鹿妖|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xuesi1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_daokuang1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC拿你的菜刀砍除这个世间的孽瘴去吧！|r")
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卯人敌：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
endfunction

function Trig_daokuang1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rma2'))then
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