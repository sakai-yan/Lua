//=========================================================================== 
// Trigger: caiji
//=========================================================================== 
function InitTrig_caiji takes nothing returns nothing
set gg_trg_caiji=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_caiji,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_caiji,Condition(function Trig_caiji_Conditions))
call TriggerAddAction(gg_trg_caiji,function Trig_caiji_Actions)
endfunction

function Trig_caiji_Actions takes nothing returns nothing
if(Trig_caiji_Func001C())then
if(Trig_caiji_Func001Func003C())then
set udg_R_CJ_shenggancao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn2_0009)
if(Trig_caiji_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF采集生甘草\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集7棵生甘草\n|r|cFFFFCC00谢大夫：|r|cFFCCFFCC医治蛇毒的材料用得差不多了，你帮我采点材料回来吧，病人多得我没办法抽身。只要|r|cFF00FF007棵生甘草|r|cFFCCFFCC就够了。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________009)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_caiji_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='tgrh'))then
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