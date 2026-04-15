//=========================================================================== 
// Trigger: shudao7
//=========================================================================== 
function InitTrig_shudao7 takes nothing returns nothing
set gg_trg_shudao7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shudao7,356.00,gg_unit_ngza_0168)
call TriggerAddCondition(gg_trg_shudao7,Condition(function Trig_shudao7_Conditions))
call TriggerAddAction(gg_trg_shudao7,function Trig_shudao7_Actions)
endfunction

function Trig_shudao7_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rdis')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_shudao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_shudao7_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00陆容大夫：|r|cFFCCFFCC太好了，很大的一份雀丹素。大侠稍等片刻~~~好了，这分雀红散你拿去吧\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回去找张真人\n|r")
if(Trig_shudao7_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shudao7_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ners_0599)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shudao7_Conditions takes nothing returns boolean
if(not(udg_MP_shudao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_shudao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'rdis')==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction