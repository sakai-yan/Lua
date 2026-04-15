//=========================================================================== 
// Trigger: J JLLB X
//=========================================================================== 
function InitTrig_J_JLLB_X takes nothing returns nothing
set gg_trg_J_JLLB_X=CreateTrigger()
call TriggerRegisterTimerEventPeriodic(gg_trg_J_JLLB_X,1.00)
call TriggerAddAction(gg_trg_J_JLLB_X,function Trig_J_JLLB_X_Actions)
endfunction

function Trig_J_JLLB_X_Actions takes nothing returns nothing
set udg_JLLB=1
loop
exitwhen udg_JLLB>11
if(Trig_J_JLLB_X_Func001Func001C())then
set udg_J_JL_NUM[udg_JLLB]=(udg_J_JL_NUM[udg_JLLB]+1)
set udg_J_JL_group[udg_JLLB]=GetUnitsInRangeOfLocMatching(370.00,udg_J_JL_SP[udg_JLLB],Condition(function Trig_J_JLLB_X_Func001Func001Func004002003))
call ForGroupBJ(udg_J_JL_group[udg_JLLB],function Trig_J_JLLB_X_Func001Func001Func005A)
call DestroyGroup(udg_J_JL_group[udg_JLLB])
set udg_J_JL_group[udg_JLLB]=CreateGroup()
else
call DoNothing()
call RemoveLocation(udg_J_JL_SP[udg_JLLB])
endif
set udg_JLLB=udg_JLLB+1
endloop
endfunction

function Trig_J_JLLB_X_Func001Func001Func004002003 takes nothing returns boolean
return(IsUnitEnemy(GetFilterUnit(),GetOwningPlayer(udg_HERO[udg_JLLB]))==true)
endfunction