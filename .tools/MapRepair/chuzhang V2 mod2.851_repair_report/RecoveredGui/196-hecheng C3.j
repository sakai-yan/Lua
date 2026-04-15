//=========================================================================== 
// Trigger: hecheng C3
//=========================================================================== 
function InitTrig_hecheng_C3 takes nothing returns nothing
set gg_trg_hecheng_C3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hecheng_C3,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_hecheng_C3,Condition(function Trig_hecheng_C3_Conditions))
call TriggerAddAction(gg_trg_hecheng_C3,function Trig_hecheng_C3_Actions)
endfunction

function Trig_hecheng_C3_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_hecheng_C3_Func003C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-1))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tlum'))
call UnitAddItemByIdSwapped('stpg',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C3_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'shrs'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'shrs'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'shea'))
call UnitAddItemByIdSwapped('anfg',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C3_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01G'))
call UnitAddItemByIdSwapped('I01H',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_hecheng_C3_Conditions takes nothing returns boolean
if(not Trig_hecheng_C3_Func007C())then
return false
endif
return true
endfunction