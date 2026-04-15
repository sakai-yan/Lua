//=========================================================================== 
// Trigger: J XTH X
//=========================================================================== 
function InitTrig_J_XTH_X takes nothing returns nothing
set gg_trg_J_XTH_X=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_XTH_X,1.00)
call TriggerAddAction(gg_trg_J_XTH_X,function Trig_J_XTH_X_Actions)
endfunction

function Trig_J_XTH_X_Actions takes nothing returns nothing
set udg_XTH=1
loop
exitwhen udg_XTH>12
if(Trig_J_XTH_X_Func001Func001C())then
set udg_J_XT_NUM[udg_XTH]=(udg_J_XT_NUM[udg_XTH]+1)
set udg_J_XT_group[udg_XTH]=GetUnitsInRangeOfLocMatching(300.00,udg_J_XT_SP[udg_XTH],Condition(function Trig_J_XTH_X_Func001Func001Func004002003))
call ForGroupBJ(udg_J_XT_group[udg_XTH],function Trig_J_XTH_X_Func001Func001Func005A)
call DestroyGroup(udg_J_XT_group[udg_XTH])
set udg_J_XT_group[udg_XTH]=CreateGroup()
else
call DoNothing()
call RemoveLocation(udg_J_XT_SP[udg_XTH])
endif
set udg_XTH=udg_XTH+1
endloop
endfunction

function Trig_J_XTH_X_Func001Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_HERO[udg_XTH]))==true)
endfunction