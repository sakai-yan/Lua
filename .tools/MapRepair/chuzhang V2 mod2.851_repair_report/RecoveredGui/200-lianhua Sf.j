//=========================================================================== 
// Trigger: lianhua Sf
//=========================================================================== 
function InitTrig_lianhua_Sf takes nothing returns nothing
set gg_trg_lianhua_Sf=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_Sf,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_Sf,Condition(function Trig_lianhua_Sf_Conditions))
call TriggerAddAction(gg_trg_lianhua_Sf,function Trig_lianhua_Sf_Actions)
endfunction

function Trig_lianhua_Sf_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_lianhua_Sf_Func003C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssil'))
call UnitAddItemByIdSwapped('I00Y',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sf_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'crys'))
call UnitAddItemByIdSwapped('I00Z',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sf_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brac'))
call UnitAddItemByIdSwapped('I01Z',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Sf_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-2))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'penr'))
call UnitAddItemByIdSwapped('I020',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_lianhua_Sf_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A05D'))then
return false
endif
return true
endfunction