//=========================================================================== 
// Trigger: zhiguliangyao
//=========================================================================== 
function InitTrig_zhiguliangyao takes nothing returns nothing
set gg_trg_zhiguliangyao=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhiguliangyao,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_zhiguliangyao,Condition(function Trig_zhiguliangyao_Conditions))
call TriggerAddAction(gg_trg_zhiguliangyao,function Trig_zhiguliangyao_Actions)
endfunction

function Trig_zhiguliangyao_Actions takes nothing returns nothing
if(Trig_zhiguliangyao_Func001C())then
if(Trig_zhiguliangyao_Func001Func003C())then
set udg_zhiguliangyao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndrp_0299)
if(Trig_zhiguliangyao_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF治蛊良药\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集10棵百合草\n|r|cFFFFCC00伊不活：|r|cFFCCFFCC从苗疆那回来的几个士兵中了点蛊毒，这些蛊毒并不难治，只需要点天然的草药即可。大侠如果|r|cFF00FF00百合草|r|cFFCCFFCC的话，帮我拿|r|cFF00FF0010棵|r|cFFCCFFCC回来吧，谢谢了！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_baihecao4)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_zhiguliangyao_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='spsh'))then
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