//=========================================================================== 
// Trigger: C1baoxiang
//=========================================================================== 
function InitTrig_C1baoxiang takes nothing returns nothing
set gg_trg_C1baoxiang=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_C1baoxiang,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddCondition(gg_trg_C1baoxiang,Condition(function Trig_C1baoxiang_Conditions))
call TriggerAddAction(gg_trg_C1baoxiang,function Trig_C1baoxiang_Actions)
endfunction

function Trig_C1baoxiang_Actions takes nothing returns nothing
call RemoveItem(GetManipulatedItem())
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_C1baoxiang_Func003C())then
if(Trig_C1baoxiang_Func003Func002C())then
call CreateItemLoc('jpnt',udg_SP)
else
if(Trig_C1baoxiang_Func003Func002Func001C())then
call CreateItemLoc('cnhn',udg_SP)
else
if(Trig_C1baoxiang_Func003Func002Func001Func001C())then
call CreateItemLoc('jpnt',udg_SP)
else
if(Trig_C1baoxiang_Func003Func002Func001Func001Func001C())then
call CreateItemLoc('dphe',udg_SP)
else
if(Trig_C1baoxiang_Func003Func002Func001Func001Func001Func001C())then
call CreateItemLoc('cnhn',udg_SP)
else
if(Trig_C1baoxiang_Func003Func002Func001Func001Func001Func001Func001C())then
call CreateItemLoc('dkfw',udg_SP)
else
call CreateItemLoc('dthb',udg_SP)
endif
endif
endif
endif
endif
endif
else
if(Trig_C1baoxiang_Func003Func001C())then
call CreateItemLoc('ward',udg_SP)
else
if(Trig_C1baoxiang_Func003Func001Func001C())then
call CreateItemLoc('rlif',udg_SP)
else
if(Trig_C1baoxiang_Func003Func001Func001Func001C())then
call CreateItemLoc('ward',udg_SP)
else
if(Trig_C1baoxiang_Func003Func001Func001Func001Func001C())then
call CreateItemLoc('clsd',udg_SP)
else
if(Trig_C1baoxiang_Func003Func001Func001Func001Func001Func001C())then
call CreateItemLoc('rlif',udg_SP)
else
if(Trig_C1baoxiang_Func003Func001Func001Func001Func001Func001Func001C())then
call CreateItemLoc('clsd',udg_SP)
else
call CreateItemLoc('rlif',udg_SP)
endif
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_C1baoxiang_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='guvi'))then
return false
endif
return true
endfunction