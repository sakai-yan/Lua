//=========================================================================== 
// Trigger: jianxuan1
//=========================================================================== 
function InitTrig_jianxuan1 takes nothing returns nothing
set gg_trg_jianxuan1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianxuan1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_jianxuan1,Condition(function Trig_jianxuan1_Conditions))
call TriggerAddAction(gg_trg_jianxuan1,function Trig_jianxuan1_Actions)
endfunction

function Trig_jianxuan1_Actions takes nothing returns nothing
if(Trig_jianxuan1_Func001C())then
if(Trig_jianxuan1_Func001Func002C())then
if(Trig_jianxuan1_Func001Func002Func002C())then
if(Trig_jianxuan1_Func001Func002Func002Func003C())then
set udg_MP_jianxuan_unit=GetTriggerUnit()
set udg_MP_jianxuan1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
if(Trig_jianxuan1_Func001Func002Func002Func003Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF遗忘之章\n|r|cFFFFCC00岩青：|r|cFFCCFFCC有件成为了太虚门禁提的事情，是时候告诉你了。太虚门曾经有位百年难得一见的天才弟子，才德兼备，名叫|r|cFF00FF00尹月行|r|cFFCCFFCC。他是师傅最喜欢的弟子，也是太虚未来的希望。无奈他因偷修炼禁术而不知悔改，最终被逐出师门，你去江湖探查下有没他的下落，然后回来汇报吧。\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00寻找尹月行|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_jianxuan1_Func001Func002Func002Func003Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00岩青：|r|cFF00FF00尹月行|r|cFFCCFFCC因为修炼禁术，头发已经雪白，穿着一身黑色的道袍，在江湖上应该不难找的。|r")
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00岩青：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00岩青：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000提示：该任务只允许一人进行，请等待任务完成或另建游戏|r")
endif
endfunction

function Trig_jianxuan1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rre1'))then
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