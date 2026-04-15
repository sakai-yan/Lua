//=========================================================================== 
// Trigger: jianhao3
//=========================================================================== 
function InitTrig_jianhao3 takes nothing returns nothing
set gg_trg_jianhao3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianhao3,356.00,gg_unit_ngnh_0123)
call TriggerAddCondition(gg_trg_jianhao3,Condition(function Trig_jianhao3_Conditions))
call TriggerAddAction(gg_trg_jianhao3,function Trig_jianhao3_Actions)
endfunction

function Trig_jianhao3_Actions takes nothing returns nothing
set udg_MP_jianhao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
if(Trig_jianhao3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00扬清：|r|cFFCCFFCC你能坚持到现在确实不容易，但考验才刚开始。继续用|r|cFF00FF00信念之剑|r|cFFCCFFCC去收拾那些|r|cFF00FF00草齿兽|r|cFFCCFFCC，它们的牙齿是很脆弱的，收集|r|cFF00FF0016份|r|cFFCCFFCC完整的|r|cFF00FF00草齿兽之牙|r|cFFCCFFCC回来证明你的实力吧。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀草齿兽收集16分草齿兽之牙|r")
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
if(Trig_jianhao3_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianhao3_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_jianhao3_Func012001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
endfunction

function Trig_jianhao3_Conditions takes nothing returns boolean
if(not(udg_MP_jianhao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianhao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
return true
endfunction