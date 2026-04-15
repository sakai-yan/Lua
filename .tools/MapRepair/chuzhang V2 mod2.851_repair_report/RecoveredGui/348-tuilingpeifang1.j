//=========================================================================== 
// Trigger: tuilingpeifang1
//=========================================================================== 
function InitTrig_tuilingpeifang1 takes nothing returns nothing
set gg_trg_tuilingpeifang1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tuilingpeifang1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tuilingpeifang1,Condition(function Trig_tuilingpeifang1_Conditions))
call TriggerAddAction(gg_trg_tuilingpeifang1,function Trig_tuilingpeifang1_Actions)
endfunction

function Trig_tuilingpeifang1_Actions takes nothing returns nothing
if(Trig_tuilingpeifang1_Func001C())then
if(Trig_tuilingpeifang1_Func001Func003C())then
set udg_R_CJ_tuiling1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_tuilingpeifang1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF退灵配方\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集沉石之灰，萍水之蓝，藤木之绿各一份\n|r|cFFFFCC00陆容大夫：|r|cFFCCFFCC想要让那笄花退去妖化之气，必须用到自然灵物的精华。这些灵物分别是|r|cFF00FF00沉石之灰|r|cFFCCFFCC，|r|cFF00FF00萍水之蓝|r|cFFCCFFCC和|r|cFF00FF00藤木之绿|r|cFFCCFFCC三种，你去采点回来吧，尽快哦。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_tuiling_p1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_tuiling_p2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_tuiling_p3)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_tuilingpeifang1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='mnst'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction