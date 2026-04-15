//=========================================================================== 
// Trigger: J PH
//=========================================================================== 
function InitTrig_J_PH takes nothing returns nothing
set gg_trg_J_PH=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_PH,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_PH,Condition(function Trig_J_PH_Conditions))
call TriggerAddAction(gg_trg_J_PH,function Trig_J_PH_Actions)
endfunction

function Trig_J_PH_Actions takes nothing returns nothing
set udg_J_PH_unit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetTriggerUnit()
set udg_J_PH_unit2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetSpellTargetUnit()
set udg_SP_PH[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetUnitLoc(GetTriggerUnit())
set udg_J_PH_POINT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetUnitLoc(GetSpellTargetUnit())
set udg_J_PH_distance[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=DistanceBetweenPoints(udg_J_PH_POINT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_PH[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_PH_distance2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=DistanceBetweenPoints(udg_J_PH_POINT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_PH[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_J_PH_N[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_J_PH_Degree[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=AngleBetweenPoints(udg_J_PH_POINT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP_PH[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
if(Trig_J_PH_Func009C())then
set udg_J_PH_TRUE[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
else
call CreateTextTagUnitBJ("距离太近了",GetSpellTargetUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_PH_Func009Func005001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
call RemoveLocation(udg_SP_PH[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_J_PH_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='ACcl'))then
return false
endif
return true
endfunction