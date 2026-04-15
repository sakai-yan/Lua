//=========================================================================== 
// Trigger: yaohua1
//=========================================================================== 
function InitTrig_yaohua1 takes nothing returns nothing
set gg_trg_yaohua1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_yaohua1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_yaohua1,Condition(function Trig_yaohua1_Conditions))
call TriggerAddAction(gg_trg_yaohua1,function Trig_yaohua1_Actions)
endfunction

function Trig_yaohua1_Actions takes nothing returns nothing
if(Trig_yaohua1_Func001C())then
if(Trig_yaohua1_Func001Func003C())then
set udg_R_CJ_yaohua1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngz3_0167)
if(Trig_yaohua1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF奇怪的妖花\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集10朵笄花\n|r|cFFFFCC00阿达：|r|cFFCCFFCC许诺给朝廷|r|cFF00FF0010朵笄花|r|cFFCCFFCC作为贡品，无奈笄花居然出现了妖化的迹象，我差点连命都没了~~~没有花要是朝廷降罪~~~那该如何是好？\n|r|cFFFFCC00你：|r|cFFCCFFCC哦？还有这事？那你等会，我去去便来。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_yaohua1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_yaohua1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='woms'))then
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