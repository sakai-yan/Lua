//=========================================================================== 
// Trigger: xuedao3
//=========================================================================== 
function InitTrig_xuedao3 takes nothing returns nothing
set gg_trg_xuedao3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xuedao3,356.00,gg_unit_nwwg_0719)
call TriggerAddCondition(gg_trg_xuedao3,Condition(function Trig_xuedao3_Conditions))
call TriggerAddAction(gg_trg_xuedao3,function Trig_xuedao3_Actions)
endfunction

function Trig_xuedao3_Actions takes nothing returns nothing
set udg_MP_xuedao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nwwg_0719)
if(Trig_xuedao3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC恩，纯阴之气让你的血源开始逐渐和你的刀结合到一起了。但要能够运用起血源，你还必须熟悉掌握。这样吧，去龙骨瀑布上挑战|r|cFF00FF00龙骨守护者|r|cFFCCFFCC，好好观察他们血源的使用，或许是个不错的捷径。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死10个龙骨守护者|r")
if(Trig_xuedao3_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_xuedao3_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_longgu_mdd)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_xuedao3_Conditions takes nothing returns boolean
if(not(udg_MP_xuedao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_xuedao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_xuedao_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=15))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction