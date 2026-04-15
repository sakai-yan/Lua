//=========================================================================== 
// Trigger: J TSJ
//=========================================================================== 
function InitTrig_J_TSJ takes nothing returns nothing
set gg_trg_J_TSJ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_TSJ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_TSJ,Condition(function Trig_J_TSJ_Conditions))
call TriggerAddAction(gg_trg_J_TSJ,function Trig_J_TSJ_Actions)
endfunction

function Trig_J_TSJ_Actions takes nothing returns nothing
if(Trig_J_TSJ_Func001C())then
if(Trig_J_TSJ_Func001Func001C())then
call SetUnitLifeBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())+((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*(1.00+(0.02*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))))))
else
call SetUnitLifeBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())+((I2R(GetHeroStatBJ(bj_HEROSTAT_INT,GetTriggerUnit(),true))+udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(1.00*(1.00+(0.02*I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))))))
endif
else
endif
endfunction

function Trig_J_TSJ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Aspl'))then
return false
endif
return true
endfunction