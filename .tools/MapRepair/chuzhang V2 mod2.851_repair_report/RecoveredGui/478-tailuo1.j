//=========================================================================== 
// Trigger: tailuo1
//=========================================================================== 
function InitTrig_tailuo1 takes nothing returns nothing
set gg_trg_tailuo1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tailuo1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tailuo1,Condition(function Trig_tailuo1_Conditions))
call TriggerAddAction(gg_trg_tailuo1,function Trig_tailuo1_Actions)
endfunction

function Trig_tailuo1_Actions takes nothing returns nothing
if(Trig_tailuo1_Func001C())then
if(Trig_tailuo1_Func001Func002C())then
if(Trig_tailuo1_Func001Func002Func003C())then
set udg_MP_tailuo1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_MP_jingang1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_SP=GetUnitLoc(gg_unit_nwen_0519)
if(Trig_tailuo1_Func001Func002Func003Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF太罗禅师\n|r|cFFFFCC00智慈大师：|r|cFFCCFFCC太罗禅师和金刚武僧是我们佛圣门两宗的救世先锋，我也希望能够更多加入这个队伍中去。只是没有足够的实力，降妖伏魔等同飞蛾扑火。你如能进入铜人巷|r|cFF00FF00打败|r|cFFCCFFCC考验你的|r|cFF00FF0018铜人|r|cFFCCFFCC，我便赋予你禅师的法称。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00打败18铜人|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________123)
call SetUnitPositionLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_tailuo1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智明大师：|r|cFFCCFFCC你的能力超群，日后多多行善救人，以传达我佛济世为怀之心。|r")
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智明大师：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00智明大师：|r|cFFCCFFCC天下苍生正值水深火热之际，但愿各位英雄豪侠多出援手。|r")
endif
endfunction

function Trig_tailuo1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='tret'))then
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