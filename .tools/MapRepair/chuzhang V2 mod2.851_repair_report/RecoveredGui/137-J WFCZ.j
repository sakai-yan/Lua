//=========================================================================== 
// Trigger: J WFCZ
//=========================================================================== 
function InitTrig_J_WFCZ takes nothing returns nothing
set gg_trg_J_WFCZ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_WFCZ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_WFCZ,Condition(function Trig_J_WFCZ_Conditions))
call TriggerAddAction(gg_trg_J_WFCZ,function Trig_J_WFCZ_Actions)
endfunction

function Trig_J_WFCZ_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=6
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP2=PolarProjectionBJ(GetUnitLoc(GetTriggerUnit()),180.00,(GetUnitFacing(GetTriggerUnit())+(60.00*I2R(GetForLoopIndexA()))))
call AddSpecialEffectLocBJ(udg_SP2,"Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
call RemoveLocation(udg_SP2)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
set udg_GROUP=GetUnitsInRangeOfLocMatching(550.00,udg_SP,Condition(function Trig_J_WFCZ_Func005002003))
call ForGroupBJ(udg_GROUP,function Trig_J_WFCZ_Func006A)
call DestroyGroup(udg_GROUP)
call RemoveLocation(udg_SP)
endfunction

function Trig_J_WFCZ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A046'))then
return false
endif
return true
endfunction

function Trig_J_WFCZ_Func005002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(GetTriggerUnit()))==true)
endfunction