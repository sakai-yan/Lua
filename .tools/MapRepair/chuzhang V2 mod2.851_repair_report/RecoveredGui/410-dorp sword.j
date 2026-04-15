//=========================================================================== 
// Trigger: dorp sword
//=========================================================================== 
function InitTrig_dorp_sword takes nothing returns nothing
set gg_trg_dorp_sword=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_dorp_sword,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_dorp_sword,Condition(function Trig_dorp_sword_Conditions))
call TriggerAddAction(gg_trg_dorp_sword,function Trig_dorp_sword_Actions)
endfunction

function Trig_dorp_sword_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetManipulatedItem()
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
if(Trig_dorp_sword_Func003C())then
call DisableTrigger(GetTriggeringTrigger())
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+78.00)
set udg_MP_jianhao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_jianhao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_jianhao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_jianhao4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_jianhao5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_MP_jianhao_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_dorp_sword_Func003Func014001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000系统信息：|r|cFFFF6600信念之剑脱手了，任务失败。若想继续进行任务，请重新接任务|r")
call SetPlayerAbilityAvailableBJ(true,'AOmi',GetOwningPlayer(GetTriggerUnit()))
call RemoveLocation(udg_SP)
call EnableTrigger(GetTriggeringTrigger())
else
endif
endfunction

function Trig_dorp_sword_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='sehr'))then
return false
endif
return true
endfunction