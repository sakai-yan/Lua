//=========================================================================== 
// Trigger: g1
//=========================================================================== 
function InitTrig_g1 takes nothing returns nothing
set gg_trg_g1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_g1,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddAction(gg_trg_g1,function Trig_g1_Actions)
endfunction

function Trig_g1_Actions takes nothing returns nothing
if(Trig_g1_Func001C())then
if(Trig_g1_Func001Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((200.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
if(Trig_g1_Func001Func001Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((250.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
if(Trig_g1_Func001Func001Func001Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((320.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
if(Trig_g1_Func001Func001Func001Func001Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((400.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
endif
endif
endif
endif
else
endif
if(Trig_g1_Func002C())then
if(Trig_g1_Func002Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((700.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
endif
else
endif
if(Trig_g1_Func003C())then
if(Trig_g1_Func003Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetSpellTargetUnit(),((1000.00-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*10.00),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
else
endif
else
endif
endfunction