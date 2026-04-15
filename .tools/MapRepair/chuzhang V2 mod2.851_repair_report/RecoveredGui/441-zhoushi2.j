//=========================================================================== 
// Trigger: zhoushi2
//=========================================================================== 
function InitTrig_zhoushi2 takes nothing returns nothing
set gg_trg_zhoushi2=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhoushi2,356.00,gg_unit_nshw_0366)
call TriggerAddCondition(gg_trg_zhoushi2,Condition(function Trig_zhoushi2_Conditions))
call TriggerAddAction(gg_trg_zhoushi2,function Trig_zhoushi2_Actions)
endfunction

function Trig_zhoushi2_Actions takes nothing returns nothing
set udg_MP_zhoushi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
if(Trig_zhoushi2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00伏樱师：|r|cFFCCFFCC咒术是一门博大精神的武学，也是我们这些医者的战斗必备。练就咒术必须要有|r|cFF00FF005个草齿兽胆囊。|r|cFFCCFFCC用你那瘦小的胳膊去把那些妖兽弄死吧\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示：|r|cFF00FF00消灭5个草齿兽|r")
if(Trig_zhoushi2_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhoushi2_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_zhoushi2_Conditions takes nothing returns boolean
if(not(udg_MP_zhoushi1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_zhoushi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction