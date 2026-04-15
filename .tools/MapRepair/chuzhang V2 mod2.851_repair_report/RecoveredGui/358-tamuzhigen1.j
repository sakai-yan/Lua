//=========================================================================== 
// Trigger: tamuzhigen1
//=========================================================================== 
function InitTrig_tamuzhigen1 takes nothing returns nothing
set gg_trg_tamuzhigen1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tamuzhigen1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tamuzhigen1,Condition(function Trig_tamuzhigen1_Conditions))
call TriggerAddAction(gg_trg_tamuzhigen1,function Trig_tamuzhigen1_Actions)
endfunction

function Trig_tamuzhigen1_Actions takes nothing returns nothing
if(Trig_tamuzhigen1_Func001C())then
if(Trig_tamuzhigen1_Func001Func003C())then
set udg_R_tamuzhigen1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetRectCenter(gg_rct_tamu_p1)
if(Trig_tamuzhigen1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF塔木之根\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集20棵塔木幼苗\n|r|cFFFFCC00童无欺：|r|cFFCCFFCC塔树是我们塔木村赖以生存的资源，这些树苗非常适合在高地生长，那些树木的|r|cFF00FF00幼苗|r|cFFCCFFCC我都放到南边的高地上了，你帮我去|r|cFF00FF00收集20株|r|cFFCCFFCC回来吧|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_tamu_p4)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_tamuzhigen1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='wswd'))then
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