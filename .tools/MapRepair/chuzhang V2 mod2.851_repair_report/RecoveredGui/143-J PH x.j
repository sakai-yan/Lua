//=========================================================================== 
// Trigger: J PH x
//=========================================================================== 
function InitTrig_J_PH_x takes nothing returns nothing
set gg_trg_J_PH_x=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_PH_x,0.05)
call TriggerAddAction(gg_trg_J_PH_x,function Trig_J_PH_x_Actions)
endfunction

function Trig_J_PH_x_Actions takes nothing returns nothing
set udg_J_HP=1
loop
exitwhen udg_J_HP>12
if(Trig_J_PH_x_Func001Func001C())then
if(Trig_J_PH_x_Func001Func001Func002C())then
set udg_J_PH_N[udg_J_HP]=(udg_J_PH_N[udg_J_HP]+1)
set udg_J_PH_distance2[udg_J_HP]=(udg_J_PH_distance[udg_J_HP]-(50.00*I2R(udg_J_PH_N[udg_J_HP])))
set udg_SP_PH[udg_J_HP]=PolarProjectionBJ(udg_J_PH_POINT[udg_J_HP],udg_J_PH_distance2[udg_J_HP],udg_J_PH_Degree[udg_J_HP])
set udg_SP_PH2[udg_J_HP]=PolarProjectionBJ(udg_J_PH_POINT[udg_J_HP],(udg_J_PH_distance2[udg_J_HP]+50.00),udg_J_PH_Degree[udg_J_HP])
call SetUnitPositionLoc(udg_J_PH_unit[udg_J_HP],udg_SP_PH[udg_J_HP])
call CreateNUnitsAtLoc(1,'nscb',ConvertedPlayer(udg_J_HP),udg_SP_PH2[udg_J_HP],(180.00+udg_J_PH_Degree[udg_J_HP]))
call SetUnitVertexColorBJ(GetLastCreatedUnit(),100,100,100,80.00)
call UnitApplyTimedLifeBJ(0.15,'BTLF',GetLastCreatedUnit())
call RemoveLocation(udg_SP_PH[udg_J_HP])
call RemoveLocation(udg_SP_PH2[udg_J_HP])
else
set udg_SP_PH[udg_J_HP]=GetUnitLoc(udg_J_PH_unit[udg_J_HP])
call CreateNUnitsAtLoc(1,'e001',GetOwningPlayer(udg_J_PH_unit[udg_J_HP]),udg_SP_PH[udg_J_HP],(180.00+udg_J_HP_Degree))
call SetUnitAbilityLevelSwapped('AOw2',GetLastCreatedUnit(),(R2I(udg_J_PH_distance[udg_J_HP])/100))
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call IssueTargetOrder(GetLastCreatedUnit(),"creepthunderbolt",udg_J_PH_unit2[udg_J_HP])
if(Trig_J_PH_x_Func001Func001Func002Func006C())then
call UnitDamageTargetBJ(udg_HERO[udg_J_HP],udg_J_PH_unit2[udg_J_HP],((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[udg_J_HP],false))+udg_GX[udg_J_HP])*(udg_BUFF_Z[udg_J_HP]*(0.80+(0.02*I2R(udg_GX_lv[udg_J_HP]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
else
call UnitDamageTargetBJ(udg_HERO[udg_J_HP],udg_J_PH_unit2[udg_J_HP],((I2R(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[udg_J_HP],false))+udg_GX[udg_J_HP])*(1.00*(0.80+(0.02*I2R(udg_GX_lv[udg_J_HP]))))),ATTACK_TYPE_CHAOS,DAMAGE_TYPE_NORMAL)
endif
call RemoveLocation(udg_SP_PH[udg_J_HP])
set udg_J_PH_TRUE[udg_J_HP]=false
endif
else
call DoNothing()
endif
set udg_J_HP=udg_J_HP+1
endloop
endfunction