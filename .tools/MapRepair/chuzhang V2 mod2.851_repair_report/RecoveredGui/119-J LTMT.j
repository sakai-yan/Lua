//=========================================================================== 
// Trigger: J LTMT
//=========================================================================== 
function InitTrig_J_LTMT takes nothing returns nothing
set gg_trg_J_LTMT=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_LTMT,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_LTMT,Condition(function Trig_J_LTMT_Conditions))
call TriggerAddAction(gg_trg_J_LTMT,function Trig_J_LTMT_Actions)
endfunction

function Trig_J_LTMT_Actions takes nothing returns nothing
if(Trig_J_LTMT_Func001C())then
call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Undead\\VampiricAura\\VampiricAuraTarget.mdl",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],"chest"))
call SetUnitLifeBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],(GetUnitStateSwap(UNIT_STATE_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])+(GetUnitStateSwap(UNIT_STATE_MAX_LIFE,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])*0.01)))
else
endif
endfunction

function Trig_J_LTMT_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetAttacker())==udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))then
return false
endif
if(not(GetUnitAbilityLevelSwapped('A04C',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])==1))then
return false
endif
if(not(IsUnitEnemy(GetAttacker(),GetOwningPlayer(GetAttackedUnitBJ()))==true))then
return false
endif
return true
endfunction