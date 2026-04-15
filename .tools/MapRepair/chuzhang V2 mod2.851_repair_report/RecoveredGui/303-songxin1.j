//=========================================================================== 
// Trigger: songxin1
//=========================================================================== 
function InitTrig_songxin1 takes nothing returns nothing
set gg_trg_songxin1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_songxin1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_songxin1,Condition(function Trig_songxin1_Conditions))
call TriggerAddAction(gg_trg_songxin1,function Trig_songxin1_Actions)
endfunction

function Trig_songxin1_Actions takes nothing returns nothing
if(Trig_songxin1_Func001C())then
set udg_R_SX_CZ1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
if(Trig_songxin1_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,15.00,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF送信\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00把信交给谢大夫\n|r|cFFFFCC00老村长：|r|cFFCCFFCC年轻人，帮我把这信送到那个有围墙的那个院里，交给|r|cFF00FF00谢大夫|r|cFFCCFFCC吧。|r")

call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,15.00,"|cFFFF6600存|r|cFFFF8C26档|r|cFFFFB24C转换|r|cFFFFD973完毕|r|cFFFFFF99：|r|cFF00FFFF欢迎来到 贰群 773786\n|r|cFFFF6600新mod版|r|cFFFF8C26测试|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npn2_0009)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
call UnitAddItemByIdSwapped('tcas',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])


//set udg_V_00[GetConvertedPlayerId(GetTriggerPlayer())]=9

else
endif
endfunction

function Trig_songxin1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='plcl'))then
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