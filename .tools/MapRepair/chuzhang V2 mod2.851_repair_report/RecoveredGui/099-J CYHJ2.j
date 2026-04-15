//=========================================================================== 
// Trigger: J CYHJ2
//=========================================================================== 
function InitTrig_J_CYHJ2 takes nothing returns nothing
set gg_trg_J_CYHJ2=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_CYHJ2,0.03)
call TriggerAddAction(gg_trg_J_CYHJ2,function Trig_J_CYHJ2_Actions)
endfunction

function Trig_J_CYHJ2_Actions takes nothing returns nothing
set udg_CY=1
loop
exitwhen udg_CY>12
if(Trig_J_CYHJ2_Func001Func001C())then
if(Trig_J_CYHJ2_Func001Func001Func002C())then
set udg_J_CY_N[udg_CY]=(udg_J_CY_N[udg_CY]+1)
set udg_J_d2[udg_CY]=(udg_J_d[udg_CY]-(50.00*I2R(udg_J_CY_N[udg_CY])))
set udg_SP_CY[udg_CY]=PolarProjectionBJ(udg_J_CY_P[udg_CY],udg_J_d2[udg_CY],udg_J_D[udg_CY])
set udg_SP_CY2[udg_CY]=PolarProjectionBJ(udg_J_CY_P[udg_CY],(udg_J_d2[udg_CY]+50.00),udg_J_D[udg_CY])
call SetUnitPositionLoc(udg_J_CY_unit[udg_CY],udg_SP_CY[udg_CY])
set udg_GROUP=GetUnitsInRangeOfLocMatching(200.00,udg_SP_CY[udg_CY],Condition(function Trig_J_CYHJ2_Func001Func001Func002Func014002003))
call ForGroupBJ(udg_GROUP,function Trig_J_CYHJ2_Func001Func001Func002Func015A)
if(Trig_J_CYHJ2_Func001Func001Func002Func016C())then
call CreateNUnitsAtLoc(1,'nfpc',ConvertedPlayer(udg_CY),udg_SP_CY2[udg_CY],GetUnitFacing(udg_HERO[udg_CY]))
else
if(Trig_J_CYHJ2_Func001Func001Func002Func016Func001C())then
call CreateNUnitsAtLoc(1,'n00J',ConvertedPlayer(udg_CY),udg_SP_CY2[udg_CY],GetUnitFacing(udg_HERO[udg_CY]))
else
call CreateNUnitsAtLoc(1,'nfps',ConvertedPlayer(udg_CY),udg_SP_CY2[udg_CY],GetUnitFacing(udg_HERO[udg_CY]))
endif
endif
call SetUnitVertexColorBJ(GetLastCreatedUnit(),100,100,0.00,50.00)
call UnitApplyTimedLifeBJ(0.20,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP_CY[udg_CY])
call RemoveLocation(udg_SP_CY2[udg_CY])
else
set udg_J_CY_TRUE[udg_CY]=false
set udg_SP_CY[udg_CY]=GetUnitLoc(udg_J_CY_unit[udg_CY])
call SetUnitPositionLoc(udg_J_CY_unit[udg_CY],udg_SP_CY_UNMOOV[udg_CY])
call RemoveLocation(udg_SP_CY[udg_CY])
call RemoveLocation(udg_SP_CY_UNMOOV[udg_CY])
set udg_J_CY_TRUE[udg_CY]=false
call GroupClear(udg_GROUP_CY[udg_CY])
call UnitRemoveAbilityBJ('A02K',udg_HERO[udg_CY])
endif
else
call DoNothing()
endif
set udg_CY=udg_CY+1
endloop
endfunction

function Trig_J_CYHJ2_Func001Func001Func002Func014002003 takes nothing returns boolean
return GetBooleanAnd(Trig_J_CYHJ2_Func001Func001Func002Func014002003001(),Trig_J_CYHJ2_Func001Func001Func002Func014002003002())
endfunction