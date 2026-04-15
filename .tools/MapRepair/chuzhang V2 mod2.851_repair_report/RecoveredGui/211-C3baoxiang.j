//=========================================================================== 
// Trigger: C3baoxiang
//=========================================================================== 
function InitTrig_C3baoxiang takes nothing returns nothing
set gg_trg_C3baoxiang=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_C3baoxiang,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddCondition(gg_trg_C3baoxiang,Condition(function Trig_C3baoxiang_Conditions))
call TriggerAddAction(gg_trg_C3baoxiang,function Trig_C3baoxiang_Actions)
endfunction

function Trig_C3baoxiang_Actions takes nothing returns nothing
call RemoveItem(GetManipulatedItem())
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_C3baoxiang_Func003C())then
if(Trig_C3baoxiang_Func003Func002C())then
call CreateItemLoc('frgd',udg_SP)
else
if(Trig_C3baoxiang_Func003Func002Func001C())then
call CreateItemLoc('mgtk',udg_SP)
else
if(Trig_C3baoxiang_Func003Func002Func001Func001C())then
call CreateItemLoc('frgd',udg_SP)
else
if(Trig_C3baoxiang_Func003Func002Func001Func001Func001C())then
call CreateItemLoc('bfhr',udg_SP)
else
if(Trig_C3baoxiang_Func003Func002Func001Func001Func001Func001C())then
call CreateItemLoc('mgtk',udg_SP)
else
if(Trig_C3baoxiang_Func003Func002Func001Func001Func001Func001Func001C())then
call CreateItemLoc('kybl',udg_SP)
else
call CreateItemLoc('kygh',udg_SP)
endif
endif
endif
endif
endif
endif
else
if(Trig_C3baoxiang_Func003Func001C())then
call CreateItemLoc('lgdh',udg_SP)
else
if(Trig_C3baoxiang_Func003Func001Func001C())then
call CreateItemLoc('rin1',udg_SP)
else
if(Trig_C3baoxiang_Func003Func001Func001Func001C())then
call CreateItemLoc('lgdh',udg_SP)
else
if(Trig_C3baoxiang_Func003Func001Func001Func001Func001C())then
call CreateItemLoc('rin1',udg_SP)
else
if(Trig_C3baoxiang_Func003Func001Func001Func001Func001Func001C())then
call CreateItemLoc('rin1',udg_SP)
else
if(Trig_C3baoxiang_Func003Func001Func001Func001Func001Func001Func001C())then
call CreateItemLoc('rin1',udg_SP)
else
call CreateItemLoc('rin1',udg_SP)
endif
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_C3baoxiang_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rugt'))then
return false
endif
return true
endfunction