//=========================================================================== 
// Trigger: quntijitui
//=========================================================================== 
function InitTrig_quntijitui takes nothing returns nothing
set gg_trg_quntijitui=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_quntijitui,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_quntijitui,Condition(function Trig_quntijitui_Conditions))
call TriggerAddAction(gg_trg_quntijitui,function Trig_quntijitui_Actions)
endfunction

function Trig_quntijitui_Actions takes nothing returns nothing
set udg_jituipoint=GetUnitLoc(GetTriggerUnit())
set udg_jiduishuzi=0
set udg_jituijiaodu2=40.
set udg_jituidanweizu=GetUnitsInRangeOfLocMatching(400.,udg_jituipoint,Condition(function Trig_quntijitui_Func004002003))

call UnitDamagePointLoc( GetTriggerUnit(), 0, 500, udg_jituipoint,((I2R(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))+udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*((1*1)*(0.70+(0.02*I2R(udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))), ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL )

call ForGroupBJ(udg_jituidanweizu,function Trig_quntijitui_Func005A)
call EnableTrigger(gg_trg_shijian)
call PolledWait(1.5)
call DisableTrigger(gg_trg_shijian)
call DestroyGroup(udg_jituidanweizu)
call RemoveLocation(udg_jituipoint)
endfunction

function Trig_quntijitui_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='qtjt'))then
return false
endif
return true
endfunction

function Trig_quntijitui_Func004002003 takes nothing returns boolean
return GetBooleanAnd(Trig_quntijitui_Func004002003001(),Trig_quntijitui_Func004002003002())
endfunction