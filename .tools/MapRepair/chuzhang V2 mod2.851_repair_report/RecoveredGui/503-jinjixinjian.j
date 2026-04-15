//=========================================================================== 
// Trigger: jinjixinjian
//=========================================================================== 
function InitTrig_jinjixinjian takes nothing returns nothing
set gg_trg_jinjixinjian=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jinjixinjian,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_jinjixinjian,Condition(function Trig_jinjixinjian_Conditions))
call TriggerAddAction(gg_trg_jinjixinjian,function Trig_jinjixinjian_Actions)
endfunction

function Trig_jinjixinjian_Actions takes nothing returns nothing
if(Trig_jinjixinjian_Func001C())then
if(Trig_jinjixinjian_Func001Func002C())then
set udg_jinjixinjian1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndtb_0417)
if(Trig_jinjixinjian_Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,15.00,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF紧急信件\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把信交给龙泉镇太守石龙保\n|r|cFFFFCC00孙末肖：|r|cFFCCFFCC苗寨的军队貌似有所行动，大有入侵边境的企图。大侠可否为老夫将此消息带到|r|cFF00FF00龙泉镇的太守石龙保|r|cFFCCFFCC那里？这是我的信件，他看了会知道一切的了。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
call UnitAddItemByIdSwapped('pgin',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_jinjixinjian_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='envl'))then
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