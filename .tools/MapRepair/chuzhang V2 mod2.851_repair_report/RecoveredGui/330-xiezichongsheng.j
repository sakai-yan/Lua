//=========================================================================== 
// Trigger: xiezichongsheng
//=========================================================================== 
function InitTrig_xiezichongsheng takes nothing returns nothing
set gg_trg_xiezichongsheng=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiezichongsheng,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xiezichongsheng,Condition(function Trig_xiezichongsheng_Conditions))
call TriggerAddAction(gg_trg_xiezichongsheng,function Trig_xiezichongsheng_Actions)
endfunction

function Trig_xiezichongsheng_Actions takes nothing returns nothing
if(Trig_xiezichongsheng_Func001C())then
if(Trig_xiezichongsheng_Func001Func001C())then
set udg_R_xiezicongsheng1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nshf_0235)
if(Trig_xiezichongsheng_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF蝎子丛生\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死20只毒蝎\n|r|cFFFFCC00葛一风：|r|cFFCCFFCC东边河岸草丛的|r|cFF00FF00毒蝎|r|cFFCCFFCC越来越多了，我早上起床居然发现山脚的有一只。是时候清理下了，你去杀死|r|cFF00FF0020只|r|cFFCCFFCC毒蝎来吧！我会给你报酬的。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________087)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_xiezichongsheng_Func001Func001Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00葛一风：|r|cFF00FF00毒蝎|r|cFFCCFFCC就在东边的河边啊|r")
set udg_SP=GetRectCenter(gg_rct______________087)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_xiezichongsheng_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='frhg'))then
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