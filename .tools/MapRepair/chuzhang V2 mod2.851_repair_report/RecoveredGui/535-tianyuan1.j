//=========================================================================== 
// Trigger: tianyuan1
//=========================================================================== 
function InitTrig_tianyuan1 takes nothing returns nothing
set gg_trg_tianyuan1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tianyuan1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tianyuan1,Condition(function Trig_tianyuan1_Conditions))
call TriggerAddAction(gg_trg_tianyuan1,function Trig_tianyuan1_Actions)
endfunction

function Trig_tianyuan1_Actions takes nothing returns nothing
if(Trig_tianyuan1_Func001C())then
if(Trig_tianyuan1_Func001Func003C())then
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
set udg_SP=GetUnitLoc(gg_unit_ngz1_0002)
if(Trig_tianyuan1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF窃天之缘\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00追查白发男子\n\n|r|cFFFFCC00老村长：|r|cFFCCFFCC我活了将近200岁了，但都从来没见过这么让我觉得可怕的人~~~前几天一位|r|cFF00FF00头发雪白|r|cFFCCFFCC的|r|cFF00FF00男子|r|cFFCCFFCC来我们村子借宿。我只与他相视了一眼，我浑身上下都不自觉地冒出了冷汗，发起颤抖~~~我的祖辈告诉过我，我族拥有窃天之眼，但凡看到灭世之人便会发抖冒汗。\n\n如果祖先遗言成真，那么此灭世之人恐怕不得留也~~~老夫年迈无力，而大侠来自武林名门，此事只有交托于您了。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________121)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_tianyuan1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='I01F'))then
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