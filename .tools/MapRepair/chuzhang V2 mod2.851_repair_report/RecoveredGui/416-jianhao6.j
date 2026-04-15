//=========================================================================== 
// Trigger: jianhao6
//=========================================================================== 
function InitTrig_jianhao6 takes nothing returns nothing
set gg_trg_jianhao6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianhao6,356.00,gg_unit_nlv2_0262)
call TriggerAddCondition(gg_trg_jianhao6,Condition(function Trig_jianhao6_Conditions))
call TriggerAddAction(gg_trg_jianhao6,function Trig_jianhao6_Actions)
endfunction

function Trig_jianhao6_Actions takes nothing returns nothing
call RemoveItem(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'cnob'))
set udg_MP_jianhao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nlv2_0262)
if(Trig_jianhao6_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00蔡景阳：|r|cFFCCFFCC看来你已经获得了扬清的认可，那么我也敢于给你艰巨的考验了。|r|cFF00FF00黑岗山寨|r|cFFCCFFCC，一群危害江南百姓的山贼恶棍，你要为民除害，|r|cFF00FF00消灭|r|cFFCCFFCC他们的|r|cFF00FF005个山贼队长|r|cFFCCFFCC，这样一来黑岗山寨也没那么嚣张了。\n\n任务提示：|r|cFF00FF00到黑岗山寨消灭5个山贼队长|r")
if(Trig_jianhao6_Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianhao6_Func007001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shan_1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianhao6_Conditions takes nothing returns boolean
if(not(udg_MP_jianhao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianhao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'cnob')==true))then
return false
endif
return true
endfunction