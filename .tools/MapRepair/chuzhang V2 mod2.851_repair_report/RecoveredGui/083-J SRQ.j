//=========================================================================== 
// Trigger: J SRQ
//=========================================================================== 
function InitTrig_J_SRQ takes nothing returns nothing
set gg_trg_J_SRQ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_SRQ,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_SRQ,Condition(function Trig_J_SRQ_Conditions))
call TriggerAddAction(gg_trg_J_SRQ,function Trig_J_SRQ_Actions)
endfunction

function Trig_J_SRQ_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'edry',GetOwningPlayer(GetTriggerUnit()),udg_SP,GetUnitFacing(GetTriggerUnit()))
call UnitApplyTimedLifeBJ(0.60,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"frostnova",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
if(Trig_J_SRQ_Func006C())then
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetHeroLevel(GetSpellTargetUnit())))
else
set udg_LVsLV=(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))/I2R(GetUnitLevel(GetSpellTargetUnit())))
endif
if(Trig_J_SRQ_Func007C())then
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*udg_LVsLV)*(0.40+(0.06*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
else
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetSpellTargetUnit(),(((I2R(GetHeroInt(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true))+udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])-udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))])*((1.00*udg_LVsLV)*(0.40+(0.06*I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_COLD)
endif
endfunction

function Trig_J_SRQ_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Aslo'))then
return false
endif
return true
endfunction