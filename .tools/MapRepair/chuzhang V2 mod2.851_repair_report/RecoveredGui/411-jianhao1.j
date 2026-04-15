//=========================================================================== 
// Trigger: jianhao1
//=========================================================================== 
function InitTrig_jianhao1 takes nothing returns nothing
set gg_trg_jianhao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jianhao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_jianhao1,Condition(function Trig_jianhao1_Conditions))
call TriggerAddAction(gg_trg_jianhao1,function Trig_jianhao1_Actions)
endfunction

function Trig_jianhao1_Actions takes nothing returns nothing
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgsk'))
if(Trig_jianhao1_Func002C())then
if(Trig_jianhao1_Func002Func002C())then
if(Trig_jianhao1_Func002Func002Func003C())then
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=6
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_jianhao1_Func002Func002Func003Func001Func001C())then
call UnitRemoveItemSwapped(UnitItemInSlotBJ(GetTriggerUnit(),GetForLoopIndexA()),GetTriggerUnit())
else
call DoNothing()
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call UnitAddItemByIdSwapped('sehr',GetTriggerUnit())
set udg_MP_jianhao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
if(Trig_jianhao1_Func002Func002Func003Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF剑的抉择\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死10只蔷树精\n         信念之剑不能脱手\n|r|cFFFFCC00扬清：|r|cFFCCFFCC你对剑有多信赖?剑只是一把利器，人能将它发挥到什么程度？你见识过孤星剑绝阵就知道了。修剑必须修心，只有人剑合一方能将剑发挥到至极。拿着这把|r|cFF00FF00信念之剑|r|cFFCCFFCC，去|r|cFF00FF00杀10只蔷树精|r|cFFCCFFCC吧。记住，|r|cFF00FF00剑不能离手|r|cFFCCFFCC！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0320)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
call SetPlayerAbilityAvailableBJ(false,'AOmi',GetOwningPlayer(GetTriggerUnit()))
else
if(Trig_jianhao1_Func002Func002Func003Func003C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00扬清：|r|cFFCCFFCC你杀够10棵蔷树精了吗？记住剑不要脱手哦！|r")
set udg_SP=GetUnitLoc(gg_unit_npng_0320)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00扬清：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00扬清：|r|cFFCCFFCC御剑门是不会外传武学的，你尽快离开吧！|r")
endif
endfunction

function Trig_jianhao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='fgsk'))then
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