//=========================================================================== 
// Trigger: nianhuoshi7
//=========================================================================== 
function InitTrig_nianhuoshi7 takes nothing returns nothing
set gg_trg_nianhuoshi7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_nianhuoshi7,356.00,gg_unit_nfr2_0125)
call TriggerAddCondition(gg_trg_nianhuoshi7,Condition(function Trig_nianhuoshi7_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi7,function Trig_nianhuoshi7_Actions)
endfunction

function Trig_nianhuoshi7_Actions takes nothing returns nothing
set udg_MP_nianhuoshi5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
if(Trig_nianhuoshi7_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC你已经被打通了火行经脉，但要证实你是否真的有能力成为念火，还需要接受最后一步的考验。到龙骨瀑布顶部寻找到|r|cFF00FF00遗失铁环|r|cFFCCFFCC，它应该被藏在某个|r|cFF00FF00龙骨守护者|r|cFFCCFFCC的身上。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00从龙骨瀑布的龙骨守护者身上找寻遗失铁环|r")
set udg_SP=GetRectCenter(gg_rct_longgu_mdd)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_nianhuoshi7_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_nianhuoshi7_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_nianhuoshi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_nianhuoshi5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction