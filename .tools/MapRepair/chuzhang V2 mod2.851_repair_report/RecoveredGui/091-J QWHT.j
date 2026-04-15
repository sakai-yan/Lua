//=========================================================================== 
// Trigger: J QWHT
//=========================================================================== 
function InitTrig_J_QWHT takes nothing returns nothing
set gg_trg_J_QWHT=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_QWHT,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_QWHT,Condition(function Trig_J_QWHT_Conditions))
call TriggerAddAction(gg_trg_J_QWHT,function Trig_J_QWHT_Actions)
endfunction

function Trig_J_QWHT_Actions takes nothing returns nothing
if(Trig_J_QWHT_Func001C())then
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())-(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*0.10)))
call SetUnitLifeBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetSpellTargetUnit())+(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetSpellTargetUnit())*0.20)))
call SetUnitManaBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())+(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetSpellTargetUnit())*0.20)))
else
call CreateTextTagUnitBJ("体力不足",GetTriggerUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_QWHT_Func001Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endfunction

function Trig_J_QWHT_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AOhw'))then
return false
endif
return true
endfunction