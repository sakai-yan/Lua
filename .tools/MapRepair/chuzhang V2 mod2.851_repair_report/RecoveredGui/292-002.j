//=========================================================================== 
// Trigger: 002
//=========================================================================== 
function InitTrig____________________002 takes nothing returns nothing
set gg_trg____________________002=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________002,EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
call TriggerAddCondition(gg_trg____________________002,Condition(function Trig____________________002_Conditions))
call TriggerAddAction(gg_trg____________________002,function Trig____________________002_Actions)
endfunction

function Trig____________________002_Actions takes nothing returns nothing
if(Trig____________________002_Func001C())then
call SetCameraFieldForPlayer(GetOwningPlayer(GetTriggerUnit()),CAMERA_FIELD_TARGET_DISTANCE,2300.00,0)
else
call SetCameraFieldForPlayer(GetOwningPlayer(GetTriggerUnit()),CAMERA_FIELD_TARGET_DISTANCE,1900.00,0)
endif
endfunction

function Trig____________________002_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(udg_camera_T[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
return true
endfunction