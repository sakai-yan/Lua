//=========================================================================== 
// Trigger: gululong1
//=========================================================================== 
function InitTrig_gululong1 takes nothing returns nothing
set gg_trg_gululong1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_gululong1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_gululong1,Condition(function Trig_gululong1_Conditions))
call TriggerAddAction(gg_trg_gululong1,function Trig_gululong1_Actions)
endfunction

function Trig_gululong1_Actions takes nothing returns nothing
if(Trig_gululong1_Func001C())then
if(Trig_gululong1_Func001Func003C())then
set udg_R_gululong1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nftr_0616)
if(Trig_gululong1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF咕噜龙\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死10只咕噜龙\n|r|cFFFFCC00老头：|r|cFFCCFFCC依靠瀑布的草药为生的我们，恐怕要转行了。瀑布下经常会出现一群|r|cFF00FF00咕噜龙|r|cFFCCFFCC，上个月就死了两个人...如果有人能来清理一下这些该死的东西该多好啊！！\n|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shengming6)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_gululong1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rman'))then
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