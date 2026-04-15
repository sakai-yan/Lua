//=========================================================================== 
// Trigger: J ZBZ X
//=========================================================================== 
function InitTrig_J_ZBZ_X takes nothing returns nothing
set gg_trg_J_ZBZ_X=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_ZBZ_X,1.00)
call TriggerAddAction(gg_trg_J_ZBZ_X,function Trig_J_ZBZ_X_Actions)
endfunction

function Trig_J_ZBZ_X_Actions takes nothing returns nothing
set udg_ZBZ=1
loop
exitwhen udg_ZBZ>12
if(Trig_J_ZBZ_X_Func001Func001C())then
set udg_J_ZB_NUM[udg_ZBZ]=(udg_J_ZB_NUM[udg_ZBZ]+1)
set udg_J_ZB_group[udg_ZBZ]=GetUnitsInRangeOfLocMatching(350.00,udg_J_ZB_SP[udg_ZBZ],Condition(function Trig_J_ZBZ_X_Func001Func001Func004002003))
call ForGroupBJ(udg_J_ZB_group[udg_ZBZ],function Trig_J_ZBZ_X_Func001Func001Func005A)
call DestroyGroup(udg_J_ZB_group[udg_ZBZ])
set udg_J_ZB_group[udg_ZBZ]=CreateGroup()
else
call DoNothing()
call RemoveLocation(udg_J_ZB_SP[udg_ZBZ])
endif
set udg_ZBZ=udg_ZBZ+1
endloop
endfunction

function Trig_J_ZBZ_X_Func001Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_HERO[udg_ZBZ]))==true)
endfunction