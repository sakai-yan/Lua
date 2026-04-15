//=========================================================================== 
// Trigger: nianhuoshi6
//=========================================================================== 
function InitTrig_nianhuoshi6 takes nothing returns nothing
set gg_trg_nianhuoshi6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_nianhuoshi6,356.00,gg_unit_nsce_0324)
call TriggerAddCondition(gg_trg_nianhuoshi6,Condition(function Trig_nianhuoshi6_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi6,function Trig_nianhuoshi6_Actions)
endfunction

function Trig_nianhuoshi6_Actions takes nothing returns nothing
if(Trig_nianhuoshi6_Func001C())then
set udg_MP_nianhuoshi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
if(Trig_nianhuoshi6_Func001Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡絮：|r|cFFCCFFCC不亏是我法魂弟子，这么快就收集够了树灵。我这就帮你打通火行经脉......\n|r|cFFC0C0C0片刻\n|r")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡絮：|r|cFFCCFFCC经脉已经打通，你回去找胡不留吧。\n|r")
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,20.00)
if(Trig_nianhuoshi6_Func001Func013001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_nianhuoshi6_Func001Func014001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
else
set udg_SP=GetRectCenter(gg_rct_xiongcan)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡絮：|r|cFF00FF00树灵|r|cFFCCFFCC可以通过杀死|r|cFF00FF00塔木森林|r|cFFCCFFCC的|r|cFF00FF00暴怒鹿妖|r|cFFCCFFCC获得，但不是每次都能成功。|r")
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endif
endfunction

function Trig_nianhuoshi6_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_nianhuoshi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_nianhuoshi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction