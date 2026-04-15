//=========================================================================== 
// Trigger: lianhua Cf
//=========================================================================== 
function InitTrig_lianhua_Cf takes nothing returns nothing
set gg_trg_lianhua_Cf=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_Cf,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_Cf,Condition(function Trig_lianhua_Cf_Conditions))
call TriggerAddAction(gg_trg_lianhua_Cf,function Trig_lianhua_Cf_Actions)
endfunction

function Trig_lianhua_Cf_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_lianhua_Cf_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'clsd')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('I007',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rlif')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('I008',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-2))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ward')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('I009',GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat9'))
call UnitAddItemByIdSwapped('I00C',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat6'))
call UnitAddItemByIdSwapped('I00B',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-4))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ratc'))
call UnitAddItemByIdSwapped('I00A',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rin1'))
call UnitAddItemByIdSwapped('I00J',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_lianhua_Cf_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor4'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'lgdh'))
call UnitAddItemByIdSwapped('I00K',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00炼化成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_lianhua_Cf_Conditions takes nothing returns boolean
if(not Trig_lianhua_Cf_Func003C())then
return false
endif
return true
endfunction