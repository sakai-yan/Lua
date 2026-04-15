//=========================================================================== 
// Trigger: C2baoxiang
//=========================================================================== 
function InitTrig_C2baoxiang takes nothing returns nothing
set gg_trg_C2baoxiang=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_C2baoxiang,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddCondition(gg_trg_C2baoxiang,Condition(function Trig_C2baoxiang_Conditions))
call TriggerAddAction(gg_trg_C2baoxiang,function Trig_C2baoxiang_Actions)
endfunction

function Trig_C2baoxiang_Actions takes nothing returns nothing
call RemoveItem(GetManipulatedItem())
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_C2baoxiang_Func003C())then
if(Trig_C2baoxiang_Func003Func002C())then
call CreateItemLoc('bzbe',udg_SP)
else
if(Trig_C2baoxiang_Func003Func002Func001C())then
call CreateItemLoc('sor1',udg_SP)
else
if(Trig_C2baoxiang_Func003Func002Func001Func001C())then
call CreateItemLoc('bzbe',udg_SP)
else
if(Trig_C2baoxiang_Func003Func002Func001Func001Func001C())then
call CreateItemLoc('skrt',udg_SP)
else
if(Trig_C2baoxiang_Func003Func002Func001Func001Func001Func001C())then
call CreateItemLoc('sor1',udg_SP)
else
if(Trig_C2baoxiang_Func003Func002Func001Func001Func001Func001Func001C())then
call CreateItemLoc('engs',udg_SP)
else
call CreateItemLoc('thle',udg_SP)
endif
endif
endif
endif
endif
endif
else
if(Trig_C2baoxiang_Func003Func001C())then
call CreateItemLoc('rat9',udg_SP)
else
if(Trig_C2baoxiang_Func003Func001Func001C())then
call CreateItemLoc('rat6',udg_SP)
else
if(Trig_C2baoxiang_Func003Func001Func001Func001C())then
call CreateItemLoc('rat9',udg_SP)
else
if(Trig_C2baoxiang_Func003Func001Func001Func001Func001C())then
call CreateItemLoc('ratc',udg_SP)
else
if(Trig_C2baoxiang_Func003Func001Func001Func001Func001Func001C())then
call CreateItemLoc('rat6',udg_SP)
else
if(Trig_C2baoxiang_Func003Func001Func001Func001Func001Func001Func001C())then
call CreateItemLoc('ratc',udg_SP)
else
call CreateItemLoc('rat6',udg_SP)
endif
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_C2baoxiang_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rump'))then
return false
endif
return true
endfunction