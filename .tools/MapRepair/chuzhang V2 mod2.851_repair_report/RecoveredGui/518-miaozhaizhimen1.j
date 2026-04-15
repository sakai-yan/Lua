//=========================================================================== 
// Trigger: miaozhaizhimen1
//=========================================================================== 
function InitTrig_miaozhaizhimen1 takes nothing returns nothing
set gg_trg_miaozhaizhimen1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_miaozhaizhimen1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_miaozhaizhimen1,Condition(function Trig_miaozhaizhimen1_Conditions))
call TriggerAddAction(gg_trg_miaozhaizhimen1,function Trig_miaozhaizhimen1_Actions)
endfunction

function Trig_miaozhaizhimen1_Actions takes nothing returns nothing
if(Trig_miaozhaizhimen1_Func001C())then
if(Trig_miaozhaizhimen1_Func001Func003C())then
set udg_miaozhaizhimen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
if(Trig_miaozhaizhimen1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF苗寨之门\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00摧毁大门机关\n|r|cFFFFCC00石中保：|r|cFFCCFFCC苗人营地的大门让我们的侦查兵无法探知里面的情况。我们必须破坏他们的大门。|r|cFF00FF00苗寨前面的高山|r|cFFCCFFCC上有他们把守的大山机关，只要把|r|cFF00FF00那机关摧毁|r|cFFCCFFCC掉，他们的大门就永远合不上了，这个任务就交给你了！！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________101)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_miaozhaizhimen1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rre2'))then
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