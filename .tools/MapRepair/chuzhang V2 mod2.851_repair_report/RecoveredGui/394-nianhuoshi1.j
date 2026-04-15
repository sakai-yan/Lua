//=========================================================================== 
// Trigger: nianhuoshi1
//=========================================================================== 
function InitTrig_nianhuoshi1 takes nothing returns nothing
set gg_trg_nianhuoshi1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_nianhuoshi1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_nianhuoshi1,Condition(function Trig_nianhuoshi1_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi1,function Trig_nianhuoshi1_Actions)
endfunction

function Trig_nianhuoshi1_Actions takes nothing returns nothing
if(Trig_nianhuoshi1_Func001C())then
if(Trig_nianhuoshi1_Func001Func002C())then
if(Trig_nianhuoshi1_Func001Func002Func003C())then
call UnitAddItemByIdSwapped('fgdg',GetTriggerUnit())
set udg_MP_nianhuoshi1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
if(Trig_nianhuoshi1_Func001Func002Func003Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF火之试炼\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集5个火种\n|r|cFFFFCC00胡絮：|r|cFFCCFFCC想成为一个合格的念火师，就要能随意操纵五行之火。而修炼念火有一个非常有效的方法，那就是利用天地火种。拿这个|r|cFF00FF00集火容器|r|cFFCCFFCC，去|r|cFF00FF00收集5个火种|r|cFFCCFFCC回来吧。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0301)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0320)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0322)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0323)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig_nianhuoshi1_Func001Func002Func003Func002C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC你收集够5个火种了吗？|r")
set udg_SP=GetUnitLoc(gg_unit_npng_0301)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0320)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0322)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0323)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC法魂门是不会外传武学的，你尽快离开吧！|r")
endif
endfunction

function Trig_nianhuoshi1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='sror'))then
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