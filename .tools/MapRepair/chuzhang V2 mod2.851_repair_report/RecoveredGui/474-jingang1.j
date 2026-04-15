//=========================================================================== 
// Trigger: jingang1
//=========================================================================== 
function InitTrig_jingang1 takes nothing returns nothing
set gg_trg_jingang1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jingang1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_jingang1,Condition(function Trig_jingang1_Conditions))
call TriggerAddAction(gg_trg_jingang1,function Trig_jingang1_Actions)
endfunction

function Trig_jingang1_Actions takes nothing returns nothing
if(Trig_jingang1_Func001C())then
if(Trig_jingang1_Func001Func002C())then
if(Trig_jingang1_Func001Func002Func003C())then
set udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_MP_tailuo1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_SP=GetUnitLoc(gg_unit_nwnr_0520)
if(Trig_jingang1_Func001Func002Func003Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF金刚武僧\n|r|cFFFFCC00智慈大师：|r|cFFCCFFCC哦？你想出山吗？佛圣门有规定，若想成为独立僧游走于俗尘世间，必须|r|cFF00FF00打败|r|cFFCCFFCC我佛的|r|cFF00FF0018铜人|r|cFFCCFFCC，而且你必须一次通过考验，否则下次再来吧。你准备一下，然后进入我们的铜人巷吧。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00一次过挑战18铜人|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________123)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call SetUnitPositionLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP)
call RemoveLocation(udg_SP)
else
if(Trig_jingang1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智慈大师：|r|cFFCCFFCC你的能力超群，日后多多行善救人，以传达我佛济世为怀之心。|r")
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智慈大师：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智慈大师：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
endfunction

function Trig_jingang1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='lmbr'))then
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