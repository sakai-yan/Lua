//=========================================================================== 
// Trigger: J SYX X
//=========================================================================== 
function InitTrig_J_SYX_X takes nothing returns nothing
set gg_trg_J_SYX_X=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_SYX_X,0.30)
call TriggerAddAction(gg_trg_J_SYX_X,function Trig_J_SYX_X_Actions)
endfunction

function Trig_J_SYX_X_Actions takes nothing returns nothing
set udg_SYX2=1
loop
exitwhen udg_SYX2>12
if(Trig_J_SYX_X_Func001Func001C())then
set udg_J_SY_SP[udg_SYX2]=GetUnitLoc(udg_HERO[udg_SYX2])
call CreateNUnitsAtLoc(1,'echm',GetOwningPlayer(udg_HERO[udg_SYX2]),udg_J_SY_SP[udg_SYX2],bj_UNIT_FACING)
call UnitApplyTimedLife(GetLastCreatedUnit(),'BHwe',1.00)
set udg_J_SY_NUM[udg_SYX2]=(udg_J_SY_NUM[udg_SYX2]+1)
set udg_J_SY_group[udg_SYX2]=GetUnitsInRangeOfLocMatching(300.00,udg_J_SY_SP[udg_SYX2],Condition(function Trig_J_SYX_X_Func001Func001Func006002003))
call ForGroupBJ(udg_J_SY_group[udg_SYX2],function Trig_J_SYX_X_Func001Func001Func007A)
call DestroyGroup(udg_J_SY_group[udg_SYX2])
set udg_J_SY_group[udg_SYX2]=CreateGroup()
else
call RemoveLocation(udg_J_SY_SP[udg_SYX2])
endif
set udg_SYX2=udg_SYX2+1
endloop
endfunction

function Trig_J_SYX_X_Func001Func001Func006002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_HERO[udg_SYX2]))==true)
endfunction