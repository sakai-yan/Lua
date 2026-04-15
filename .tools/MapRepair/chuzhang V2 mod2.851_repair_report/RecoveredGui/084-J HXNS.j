//=========================================================================== 
// Trigger: J HXNS
//=========================================================================== 
function InitTrig_J_HXNS takes nothing returns nothing
set gg_trg_J_HXNS=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_HXNS,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_HXNS,Condition(function Trig_J_HXNS_Conditions))
call TriggerAddAction(gg_trg_J_HXNS,function Trig_J_HXNS_Actions)
endfunction

function Trig_J_HXNS_Actions takes nothing returns nothing
if(Trig_J_HXNS_Func001C())then
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())-(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,GetTriggerUnit())*0.10)))
call SetUnitManaBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetTriggerUnit())+(GetUnitStateSwap(UNIT_STATE_MAX_MANA,GetTriggerUnit())*0.15)))
else
call CreateTextTagUnitBJ("体力不足",GetTriggerUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HXNS_Func001Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endfunction

function Trig_J_HXNS_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AIm1'))then
return false
endif
return true
endfunction