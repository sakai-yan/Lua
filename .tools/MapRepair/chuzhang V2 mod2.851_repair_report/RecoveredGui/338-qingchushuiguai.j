//=========================================================================== 
// Trigger: qingchushuiguai
//=========================================================================== 
function InitTrig_qingchushuiguai takes nothing returns nothing
set gg_trg_qingchushuiguai=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qingchushuiguai,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_qingchushuiguai,Condition(function Trig_qingchushuiguai_Conditions))
call TriggerAddAction(gg_trg_qingchushuiguai,function Trig_qingchushuiguai_Actions)
endfunction

function Trig_qingchushuiguai_Actions takes nothing returns nothing
if(Trig_qingchushuiguai_Func001C())then
if(Trig_qingchushuiguai_Func001Func001C())then
set udg_R_qingchushuiguai1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngzd_0001)
if(Trig_qingchushuiguai_Func001Func001Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF清除水怪\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00猎杀30只巨钳蟹\n|r|cFFFFCC00秦奋：|r|cFFCCFFCC潮汐带来的水怪让我们这些渔夫很是头疼啊，船都被钳破了。没错，就是那些|r|cFF00FF00巨钳蟹|r|cFFCCFFCC，大侠也来帮忙清理吧，你如果|r|cFF00FF00猎杀够30个|r|cFFCCFFCC，我们会给你铜钱的。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_yaohua1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00秦奋：|r|cFFCCFFCC你杀够30只巨钳蟹了吗？|r")
set udg_SP=GetRectCenter(gg_rct_yaohua1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_qingchushuiguai_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='pomn'))then
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