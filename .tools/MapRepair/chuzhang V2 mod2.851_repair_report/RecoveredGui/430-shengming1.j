//=========================================================================== 
// Trigger: shengming1
//=========================================================================== 
function InitTrig_shengming1 takes nothing returns nothing
set gg_trg_shengming1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shengming1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shengming1,Condition(function Trig_shengming1_Conditions))
call TriggerAddAction(gg_trg_shengming1,function Trig_shengming1_Actions)
endfunction

function Trig_shengming1_Actions takes nothing returns nothing
if(Trig_shengming1_Func001C())then
if(Trig_shengming1_Func001Func002C())then
if(Trig_shengming1_Func001Func002Func003C())then
set udg_MP_shengming1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_shengming1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF苍生之源\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集20棵亥什草\n|r|cFFFFCC00白鹿先生：|r|cFFCCFFCC想救人就必须有为他人冒险的心。|r|cFF00FF00亥什草|r|cFFCCFFCC是一种救人良药，生在在|r|cFF00FF00龙骨瀑布下|r|cFFCCFFCC，你去收集|r|cFF00FF0020棵|r|cFFCCFFCC回来吧|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shengming1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig_shengming1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC亥什草就长在龙骨瀑布附近。|r")
set udg_SP=GetRectCenter(gg_rct_shengming1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC欢迎来到清心阁，请问你哪里不舒服吗？|r")
endif
endfunction

function Trig_shengming1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='pdiv'))then
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