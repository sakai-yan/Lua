//=========================================================================== 
// Trigger: J KF
//=========================================================================== 
function InitTrig_J_KF takes nothing returns nothing
set gg_trg_J_KF=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_KF,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_KF,Condition(function Trig_J_KF_Conditions))
call TriggerAddAction(gg_trg_J_KF,function Trig_J_KF_Actions)
endfunction

function Trig_J_KF_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=10
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_SP2=PolarProjectionBJ(udg_SP,(100.00+(50.00*I2R(GetForLoopIndexA()))),GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,'e003',GetOwningPlayer(GetTriggerUnit()),udg_SP2,bj_UNIT_FACING)
call UnitApplyTimedLifeBJ((0.00+(0.04*I2R(GetForLoopIndexA()))),'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP2)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
set udg_SP3=PolarProjectionBJ(udg_SP,256,GetUnitFacing(GetTriggerUnit()))
set udg_GROUP=GetUnitsInRangeOfLocMatching(256.00,udg_SP3,Condition(function Trig_J_KF_Func004002003))
call ForGroupBJ(udg_GROUP,function Trig_J_KF_Func005A)
set udg_SP4=PolarProjectionBJ(udg_SP,500.00,GetUnitFacing(GetTriggerUnit()))
set udg_GROUP2=GetUnitsInRangeOfLocMatching(200.00,udg_SP4,Condition(function Trig_J_KF_Func007002003))
call ForGroupBJ(udg_GROUP2,function Trig_J_KF_Func008A)
call DestroyGroup(udg_GROUP)
call DestroyGroup(udg_GROUP2)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
call RemoveLocation(udg_SP3)
call RemoveLocation(udg_SP4)
call GroupClear(udg_GROUP_KF[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endfunction

function Trig_J_KF_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A04B'))then
return false
endif
return true
endfunction

function Trig_J_KF_Func004002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_KF_Func004002003001(),Trig_J_KF_Func004002003002())
endfunction

function Trig_J_KF_Func007002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_KF_Func007002003001(),Trig_J_KF_Func007002003002())
endfunction