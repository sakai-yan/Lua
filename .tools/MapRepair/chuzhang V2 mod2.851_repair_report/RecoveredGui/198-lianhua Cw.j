//=========================================================================== 
// Trigger: lianhua Cw
//=========================================================================== 
function InitTrig_lianhua_Cw takes nothing returns nothing
set gg_trg_lianhua_Cw=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_Cw,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_Cw,Condition(function Trig_lianhua_Cw_Conditions))
call TriggerAddAction(gg_trg_lianhua_Cw,function Trig_lianhua_Cw_Actions)
endfunction

function Trig_lianhua_Cw_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_lianhua_Cw_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'cnhn'))
call UnitAddItemByIdSwapped('I000',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'dthb'))
call UnitAddItemByIdSwapped('I001',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'dphe'))
call UnitAddItemByIdSwapped('I003',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'jpnt'))
call UnitAddItemByIdSwapped('I004',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'dkfw'))
call UnitAddItemByIdSwapped('I005',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'engs'))
call UnitAddItemByIdSwapped('I00E',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kybl'))
call UnitAddItemByIdSwapped('I00O',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor1'))
call UnitAddItemByIdSwapped('I00D',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func012C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thle'))
call UnitAddItemByIdSwapped('I00F',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func013C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kygh'))
call UnitAddItemByIdSwapped('I00M',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func014C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'skrt'))
call UnitAddItemByIdSwapped('I00G',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func015C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bfhr'))
call UnitAddItemByIdSwapped('I00N',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func016C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bzbe'))
call UnitAddItemByIdSwapped('I00H',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func017C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'frgd'))
call UnitAddItemByIdSwapped('I00P',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cw_Func018C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mgtk'))
call UnitAddItemByIdSwapped('I00L',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_lianhua_Cw_Conditions takes nothing returns boolean
if(not Trig_lianhua_Cw_Func003C())then
return false
endif
return true
endfunction