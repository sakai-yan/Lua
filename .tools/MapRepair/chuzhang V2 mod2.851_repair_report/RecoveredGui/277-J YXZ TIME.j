//=========================================================================== 
// Trigger: J YXZ TIME
//=========================================================================== 
function InitTrig_J_YXZ_TIME takes nothing returns nothing
set gg_trg_J_YXZ_TIME=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_YXZ_TIME,0.25)
call TriggerAddAction(gg_trg_J_YXZ_TIME,function Trig_J_YXZ_TIME_Actions)
endfunction

function Trig_J_YXZ_TIME_Actions takes nothing returns nothing
set udg_J_YXZ=1
loop
exitwhen udg_J_YXZ>12
if(Trig_J_YXZ_TIME_Func001Func001C())then
set udg_SP=GetUnitLoc(udg_J_YXZ_UNIT[udg_J_YXZ])
if(Trig_J_YXZ_TIME_Func001Func001Func002C())then
call SetUnitPositionLoc(udg_J_YXZ_UNIT2[udg_J_YXZ],udg_SP)
else
call KillUnit(udg_J_YXZ_UNIT[udg_J_YXZ])
endif
set udg_GROUP=GetUnitsInRangeOfLocMatching(150.00,udg_SP,Condition(function Trig_J_YXZ_TIME_Func001Func001Func003002003))
call ForGroupBJ(udg_GROUP,function Trig_J_YXZ_TIME_Func001Func001Func004A)
call DestroyGroup(udg_GROUP)
else
endif
set udg_J_YXZ=udg_J_YXZ+1
endloop
endfunction

function Trig_J_YXZ_TIME_Func001Func001Func003002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_YXZ_TIME_Func001Func001Func003002003001(),Trig_J_YXZ_TIME_Func001Func001Func003002003002())
endfunction