//=========================================================================== 
// Trigger: shuimai1
//=========================================================================== 
function InitTrig_shuimai1 takes nothing returns nothing
set gg_trg_shuimai1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shuimai1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shuimai1,Condition(function Trig_shuimai1_Conditions))
call TriggerAddAction(gg_trg_shuimai1,function Trig_shuimai1_Actions)
endfunction

function Trig_shuimai1_Actions takes nothing returns nothing
if(Trig_shuimai1_Func001C())then
if(Trig_shuimai1_Func001Func002C())then
if(Trig_shuimai1_Func001Func002Func003C())then
call UnitAddItemByIdSwapped('sor9',GetTriggerUnit())
set udg_MP_shuimai1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsha_0367)
if(Trig_shuimai1_Func001Func002Func003Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF水之试炼\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00带回装满水的瓶子\n\n|r|cFFFFCC00水无名：|r|cFFCCFFCC水脉师要练成五行中阴性较重的水系法术，需要用至阴的天地元素辅助。|r|cFF00FF00塔木森林|r|cFFCCFFCC内部的|r|cFF00FF00天泉井|r|cFFCCFFCC是一种至阴至寒的水，你去提点回来吧|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________089)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_shuimai1_Func001Func002Func003Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC天泉水就在塔木森林深处的瀑布下|r")
set udg_SP=GetRectCenter(gg_rct______________089)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC法魂门是不会外传武学的，你尽快离开吧！|r")
endif
endfunction

function Trig_shuimai1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='pams'))then
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