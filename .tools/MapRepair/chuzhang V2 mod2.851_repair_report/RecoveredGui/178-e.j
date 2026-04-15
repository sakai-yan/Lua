//=========================================================================== 
// Trigger: e
//=========================================================================== 
function InitTrig_e takes nothing returns nothing
set gg_trg_e=CreateTrigger()
call TriggerAddCondition(gg_trg_e,Condition(function Trig_e_Conditions))
call TriggerAddAction(gg_trg_e,function Trig_e_Actions)
endfunction

function Trig_e_Actions takes nothing returns nothing
call DisableTrigger(GetTriggeringTrigger())
if(Trig_e_Func005C())then
if(Trig_e_Func005Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.10),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*10.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func006C())then
if(Trig_e_Func006Func002C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.15),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*15.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func007C())then
if(Trig_e_Func007Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.07),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*7.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func008C())then
if(Trig_e_Func008Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.05),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*5.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func009C())then
if(Trig_e_Func009Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.07),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*7.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func010C())then
call SetUnitLifeBJ(GetTriggerUnit(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetTriggerUnit())+50.00))
else
endif
if(Trig_e_Func012C())then
call SetUnitManaBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_MANA,GetEventDamageSource())+4.00))
else
endif
if(Trig_e_Func013C())then
call SetUnitManaBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_MANA,GetEventDamageSource())+3.00))
else
endif
if(Trig_e_Func014C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+30.00))
else
endif
if(Trig_e_Func015C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+40.00))
else
endif
if(Trig_e_Func016C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+50.00))
else
endif
if(Trig_e_Func017C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+100.00))
else
endif
if(Trig_e_Func018C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+100.00))
//call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*15.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
endif
if(Trig_e_Func019C())then
set udg_SP=GetUnitLoc(GetEventDamageSource())
call CreateNUnitsAtLoc(1,'e001',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"frostnova",GetEventDamageSource())
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetEventDamageSource(),(100.00*I2R(GetUnitLevel(GetEventDamageSource()))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
call RemoveLocation(udg_SP)
else
endif
if(Trig_e_Func020C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+120.00))
else
endif
if(Trig_e_Func021C())then
call SetUnitLifeBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_LIFE,GetEventDamageSource())+50.00))
else
endif
if(Trig_e_Func022C())then
if(Trig_e_Func022Func001C())then
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*0.08),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
else
call UnitDamageTargetBJ(GetTriggerUnit(),GetEventDamageSource(),(GetEventDamage()*8.00),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_DEMOLITION)
endif
else
endif
if(Trig_e_Func023C())then
set udg_SP=GetUnitLoc(GetEventDamageSource())
call CreateNUnitsAtLoc(1,'e001',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"frostnova",GetEventDamageSource())
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetEventDamageSource(),(200.00*I2R(GetUnitLevel(GetEventDamageSource()))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
call RemoveLocation(udg_SP)
else
endif
if(Trig_e_Func024C())then
call SetUnitManaBJ(GetEventDamageSource(),(GetUnitStateSwap(UNIT_STATE_MANA,GetEventDamageSource())+3.00))
else
endif
if(Trig_e_Func025C())then
set udg_SP=GetUnitLoc(GetEventDamageSource())
call CreateNUnitsAtLoc(1,'e001',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"frostnova",GetEventDamageSource())
call UnitDamageTargetBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetEventDamageSource(),(300.00*I2R(GetUnitLevel(GetEventDamageSource()))),ATTACK_TYPE_NORMAL,DAMAGE_TYPE_FIRE)
call RemoveLocation(udg_SP)
else
endif

//+++
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function Trig_e_Conditions takes nothing returns boolean
if(not(GetEventDamage()>0.00))then
return false
endif
return true
endfunction