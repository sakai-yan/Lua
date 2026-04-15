//=========================================================================== 
// Trigger: Miaojiangzhanshen1
//=========================================================================== 
function InitTrig_Miaojiangzhanshen1 takes nothing returns nothing
set gg_trg_Miaojiangzhanshen1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Miaojiangzhanshen1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_Miaojiangzhanshen1,Condition(function Trig_Miaojiangzhanshen1_Conditions))
call TriggerAddAction(gg_trg_Miaojiangzhanshen1,function Trig_Miaojiangzhanshen1_Actions)
endfunction

function Trig_Miaojiangzhanshen1_Actions takes nothing returns nothing
if(Trig_Miaojiangzhanshen1_Func001C())then
if(Trig_Miaojiangzhanshen1_Func001Func003C())then
set udg_Miaojiangzhanshen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nbdo_0507)
if(Trig_Miaojiangzhanshen1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF苗疆战神\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死楼骨达\n|r|cFFFFCC00石龙保：|r|cFFCCFFCC苗人军队士气高昂，全因为他们的战争领袖---苗疆战神！！那个恐怖的男人曾经单人杀死我们的一个军队，他已经不是我们这些凡人所能对抗的了。他的名字叫|r|cFF00FF00楼骨达|r|cFFCCFFCC，只有打败他，才能真正打消苗人的入侵念头。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________103)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_Miaojiangzhanshen1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rhe1'))then
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