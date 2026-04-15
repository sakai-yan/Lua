//=========================================================================== 
// Trigger: guiyan5
//=========================================================================== 
function InitTrig_guiyan5 takes nothing returns nothing
set gg_trg_guiyan5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_guiyan5,356.00,gg_unit_ncgb_0629)
call TriggerAddCondition(gg_trg_guiyan5,Condition(function Trig_guiyan5_Conditions))
call TriggerAddAction(gg_trg_guiyan5,function Trig_guiyan5_Actions)
endfunction

function Trig_guiyan5_Actions takes nothing returns nothing
set udg_MP_guiyan3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
if(Trig_guiyan5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC别难过，你只是慈悲的方式不同于那些所谓的正道人士而已！鬼门传人从来不在乎他人的眼光！最后一步必须让地灵吸收一个较为强大的元神方能使得地灵完全觉醒。我觉得|r|cFF00FF00黑霸山|r|cFFCCFFCC那小儿的元神修炼得还不错，就让他来祭奠你的地灵吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死黑岗山寨的黑霸山|r")
if(Trig_guiyan5_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_guiyan5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shan_1)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_guiyan5_Conditions takes nothing returns boolean
if(not(udg_MP_guiyan2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_guiyan3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_guiyan_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=50))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction