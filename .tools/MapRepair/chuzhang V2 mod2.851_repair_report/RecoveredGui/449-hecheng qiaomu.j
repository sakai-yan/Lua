//=========================================================================== 
// Trigger: hecheng qiaomu
//=========================================================================== 
function InitTrig_hecheng_qiaomu takes nothing returns nothing
set gg_trg_hecheng_qiaomu=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hecheng_qiaomu,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_hecheng_qiaomu,Condition(function Trig_hecheng_qiaomu_Conditions))
call TriggerAddAction(gg_trg_hecheng_qiaomu,function Trig_hecheng_qiaomu_Actions)
endfunction

function Trig_hecheng_qiaomu_Actions takes nothing returns nothing
if(Trig_hecheng_qiaomu_Func001C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fgun'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tmmt'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'amrc'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'ram1'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'ram1'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tels'))-10))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'vddl')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('tbar',GetSpellTargetUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
else
endif
if(Trig_hecheng_qiaomu_Func002C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fgun'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'asbl'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fwss'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'axas'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'axas'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tels'))-10))
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'rej2')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('sor7',GetSpellTargetUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
else
endif
endfunction

function Trig_hecheng_qiaomu_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A000'))then
return false
endif
return true
endfunction