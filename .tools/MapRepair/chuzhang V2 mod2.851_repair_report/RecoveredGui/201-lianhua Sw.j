//=========================================================================== 
// Trigger: lianhua Sw
//=========================================================================== 
function InitTrig_lianhua_Sw takes nothing returns nothing
set gg_trg_lianhua_Sw=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_Sw,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_Sw,Condition(function Trig_lianhua_Sw_Conditions))
call TriggerAddAction(gg_trg_lianhua_Sw,function Trig_lianhua_Sw_Actions)
endfunction

function Trig_lianhua_Sw_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_lianhua_Sw_Func003C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'stre'))
call UnitAddItemByIdSwapped('I010',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'lnrn'))
call UnitAddItemByIdSwapped('I011',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'nspi'))
call UnitAddItemByIdSwapped('I013',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sksh'))
call UnitAddItemByIdSwapped('I012',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oli2'))
call UnitAddItemByIdSwapped('I014',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'afac'))
call UnitAddItemByIdSwapped('I01A',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'lhst'))
call UnitAddItemByIdSwapped('I01B',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'skul'))
call UnitAddItemByIdSwapped('I01C',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sbok'))
call UnitAddItemByIdSwapped('I019',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sw_Func012C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rst1'))
call UnitAddItemByIdSwapped('I01D',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_lianhua_Sw_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A05E'))then
return false
endif
return true
endfunction