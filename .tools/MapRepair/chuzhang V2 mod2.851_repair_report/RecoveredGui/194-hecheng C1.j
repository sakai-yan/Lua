//=========================================================================== 
// Trigger: hecheng C1
//=========================================================================== 
function InitTrig_hecheng_C1 takes nothing returns nothing
set gg_trg_hecheng_C1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hecheng_C1,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_hecheng_C1,Condition(function Trig_hecheng_C1_Conditions))
call TriggerAddAction(gg_trg_hecheng_C1,function Trig_hecheng_C1_Actions)
endfunction

function Trig_hecheng_C1_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_hecheng_C1_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-4))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram4')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('clsd',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-4))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram2')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('rlif',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram3'))
call UnitAddItemByIdSwapped('ward',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'srtl'))
call UnitAddItemByIdSwapped('ratc',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'grsl'))
call UnitAddItemByIdSwapped('rat6',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'gsou'))
call UnitAddItemByIdSwapped('rat9',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej5'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej5'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tint'))
call UnitAddItemByIdSwapped('rin1',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C1_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ram1'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tdex'))
call UnitAddItemByIdSwapped('lgdh',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_hecheng_C1_Conditions takes nothing returns boolean
if(not Trig_hecheng_C1_Func003C())then
return false
endif
return true
endfunction