//=========================================================================== 
// Trigger: qijian4
//=========================================================================== 
function InitTrig_qijian4 takes nothing returns nothing
set gg_trg_qijian4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qijian4,356.00,gg_unit_ndh1_0368)
call TriggerAddCondition(gg_trg_qijian4,Condition(function Trig_qijian4_Conditions))
call TriggerAddAction(gg_trg_qijian4,function Trig_qijian4_Actions)
endfunction

function Trig_qijian4_Actions takes nothing returns nothing
set udg_MP_qijian3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndh1_0368)
if(Trig_qijian4_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00卓腾云：|r|cFFCCFFCC谢谢你把我妹妹带回来。我们说回正题吧，你有修炼气剑系的良好条件，这个凭你大老远就能轻松带我妹妹回来就看出了。不过我还是需要考验一下你。魂山附近的|r|cFF00FF00咕噜龙|r|cFFCCFFCC身上有一种|r|cFF00FF00鸟龙鳞|r|cFFCCFFCC，需要用剑加以柔劲才能剥下，你去|r|cFF00FF00收集20个|r|cFFCCFFCC回来吧\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00消灭咕噜龙收集20份鸟龙鳞|r")
if(Trig_qijian4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_qijian4_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________090)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_qijian4_Conditions takes nothing returns boolean
if(not(udg_MP_qijian2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_qijian3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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