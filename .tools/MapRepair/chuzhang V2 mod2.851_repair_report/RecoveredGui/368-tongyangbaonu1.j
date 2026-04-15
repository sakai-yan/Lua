//=========================================================================== 
// Trigger: tongyangbaonu1
//=========================================================================== 
function InitTrig_tongyangbaonu1 takes nothing returns nothing
set gg_trg_tongyangbaonu1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tongyangbaonu1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tongyangbaonu1,Condition(function Trig_tongyangbaonu1_Conditions))
call TriggerAddAction(gg_trg_tongyangbaonu1,function Trig_tongyangbaonu1_Actions)
endfunction

function Trig_tongyangbaonu1_Actions takes nothing returns nothing
if(Trig_tongyangbaonu1_Func001C())then
if(Trig_tongyangbaonu1_Func001Func003C())then
set udg_tongyangbaonu1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nlv3_0350)
if(Trig_tongyangbaonu1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF同样的暴怒\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死10头暴怒鹿妖\n|r|cFFFFCC00李达：|r|cFFCCFFCC我很恼火，多得那些可恶的妖兽，我的表弟被他们杀死了！永远的死了！！谁要能|r|cFF00FF00杀死10头暴怒鹿妖|r|cFFCCFFCC，我重赏！！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xuesi1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_tongyangbaonu1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='iwbr'))then
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