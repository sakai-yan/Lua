//=========================================================================== 
// Trigger: FX
//=========================================================================== 
function InitTrig_FX takes nothing returns nothing
set gg_trg_FX=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_FX,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_FX,Condition(function Trig_FX_Conditions))
call TriggerAddAction(gg_trg_FX,function Trig_FX_Actions)
endfunction

function Trig_FX_Actions takes nothing returns nothing
if(Trig_FX_Func003C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+10.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
else
endif
if(Trig_FX_Func004C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+95.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+105.00)
else
endif
if(Trig_FX_Func005C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+185.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+178.00)
else
endif
if(Trig_FX_Func006C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+215.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+285.00)
else
endif
if(Trig_FX_Func007C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+310.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
else
endif
if(Trig_FX_Func008C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+450.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+440.00)
else
endif
if(Trig_FX_Func009C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+540.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+535.00)
else
endif
if(Trig_FX_Func010C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+210.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+585.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+600.00)
else
endif
if(Trig_FX_Func011C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+250.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+665.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+654.00)
else
endif
if(Trig_FX_Func012C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+310.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+756.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+740.00)
else
endif
if(Trig_FX_Func013C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+350.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+840.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+835.00)
else
endif
if(Trig_FX_Func014C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+430.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+980.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+910.00)
else
endif
if(Trig_FX_Func015C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+490.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1020.00)
else
endif
if(Trig_FX_Func016C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+600.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1300.00)
else
endif
if(Trig_FX_Func017C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+660.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1350.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1420.00)
else
endif
if(Trig_FX_Func018C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+750.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1550.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1500.00)
else
endif
if(Trig_FX_Func019C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+820.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1650.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1670.00)
else
endif
if(Trig_FX_Func020C())then
set udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_ZX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+960.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1330.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1330.00)
else
endif
endfunction

function Trig_FX_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction