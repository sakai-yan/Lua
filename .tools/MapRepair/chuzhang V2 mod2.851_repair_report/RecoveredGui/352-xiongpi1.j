//=========================================================================== 
// Trigger: xiongpi1
//=========================================================================== 
function InitTrig_xiongpi1 takes nothing returns nothing
set gg_trg_xiongpi1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiongpi1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xiongpi1,Condition(function Trig_xiongpi1_Conditions))
call TriggerAddAction(gg_trg_xiongpi1,function Trig_xiongpi1_Actions)
endfunction

function Trig_xiongpi1_Actions takes nothing returns nothing
if(Trig_xiongpi1_Func001C())then
if(Trig_xiongpi1_Func001Func001C())then
set udg_R_xiongpi1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz4_0179)
if(Trig_xiongpi1_Func001Func001Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF熊皮生意（1）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00剥得10张熊皮\n|r|cFFFFCC00张业：|r|cFFCCFFCC要入秋了，现在大量收购熊皮，你去帮我|r|cFF00FF00杀10张熊皮|r|cFFCCFFCC回来，我给你报酬如何？|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_tamu_p1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
if(Trig_xiongpi1_Func001Func001Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张业：|r|cFF00FF00熊|r|cFFCCFFCC就在过桥后的小山丘上，去那里|r|cFF00FF00杀10张熊皮|r|cFFCCFFCC吧|r")
set udg_SP=GetRectCenter(gg_rct_tamu_p1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
call RemoveLocation(udg_SP)
else
if(Trig_xiongpi1_Func001Func001Func001Func003C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00张业：|r|cFFCCFFCC我现在需要的是|r|cFF00FF0010条熊骨|r|cFFCCFFCC了，你再帮我一次吧|r")
set udg_SP=GetUnitLoc(gg_unit_ncnt_0088)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
call RemoveLocation(udg_SP)
else
endif
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_xiongpi1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='hlst'))then
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