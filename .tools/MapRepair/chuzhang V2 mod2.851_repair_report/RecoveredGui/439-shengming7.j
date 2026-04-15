//=========================================================================== 
// Trigger: shengming7
//=========================================================================== 
function InitTrig_shengming7 takes nothing returns nothing
set gg_trg_shengming7=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shengming7,356.00,gg_unit_nfh1_0124)
call TriggerAddCondition(gg_trg_shengming7,Condition(function Trig_shengming7_Conditions))
call TriggerAddAction(gg_trg_shengming7,function Trig_shengming7_Actions)
endfunction

function Trig_shengming7_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'dust')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_shengming5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_shengming7_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC恭喜你成功度过难关，通过了考验。你是真正的清心阁芙医，以后要负起拯救苍生的责任。\n\n|r|cFF00FF00成|r|cFF00FF55功|r|cFF00FFAA转|r|cFF00FFFF职|r|cFFCCFFCC：|r|cFFFFFF00芙医|r")
call RemoveLocation(udg_SP)
call UnitAddAbilityBJ('AUfa',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('Aadm',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='AUfa'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='Aadm'

                                                                               //5


call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_shengming7_Conditions takes nothing returns boolean
if(not(udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shengming5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'dust')==true))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction