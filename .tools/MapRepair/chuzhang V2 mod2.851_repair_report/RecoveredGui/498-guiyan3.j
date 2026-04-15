//=========================================================================== 
// Trigger: guiyan3
//=========================================================================== 
function InitTrig_guiyan3 takes nothing returns nothing
set gg_trg_guiyan3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_guiyan3,356.00,gg_unit_ncgb_0629)
call TriggerAddCondition(gg_trg_guiyan3,Condition(function Trig_guiyan3_Conditions))
call TriggerAddAction(gg_trg_guiyan3,function Trig_guiyan3_Actions)
endfunction

function Trig_guiyan3_Actions takes nothing returns nothing
set udg_MP_guiyan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
if(Trig_guiyan3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC我知道你不喜欢杀人，但你如果想救更多的人，那么你就必须杀人，道理我不再多说。地灵需要吸收更多凡人的鲜血，去|r|cFF00FF00黑岗山寨|r|cFFCCFFCC吧！你下不了手的时候，你就想下那些山贼平时杀了多人吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到黑岗山寨杀50人|r")
if(Trig_guiyan3_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_guiyan3_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shan3)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_guiyan3_Conditions takes nothing returns boolean
if(not(udg_MP_guiyan1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_guiyan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_guiyan_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction