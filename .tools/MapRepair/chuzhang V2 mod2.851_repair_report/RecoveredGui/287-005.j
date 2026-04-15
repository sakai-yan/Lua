//=========================================================================== 
// Trigger: 005
//=========================================================================== 
function InitTrig____________________005 takes nothing returns nothing
set gg_trg____________________005=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________005,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg____________________005,Condition(function Trig____________________005_Conditions))
call TriggerAddAction(gg_trg____________________005,function Trig____________________005_Actions)
endfunction

function Trig____________________005_Actions takes nothing returns nothing
if(Trig____________________005_Func002C())then
call ShowUnitShow(gg_unit_nsko_0711)
set udg_fuben2=(udg_fuben2+1)
call DisplayTextToForce(GetPlayersAll(),"|cFF00FF00!!貌似有一具火焰被点燃了|r")
else
if(Trig____________________005_Func002Func001C())then
call ShowUnitShow(gg_unit_nsko_0710)
set udg_fuben2=(udg_fuben2+1)
call DisplayTextToForce(GetPlayersAll(),"|cFF00FF00!!貌似有一具火焰被点燃了|r")
else
if(Trig____________________005_Func002Func001Func001C())then
call ShowUnitShow(gg_unit_nsko_0709)
set udg_fuben2=(udg_fuben2+1)
call DisplayTextToForce(GetPlayersAll(),"|cFF00FF00!!貌似有一具火焰被点燃了|r")
else
if(Trig____________________005_Func002Func001Func001Func001C())then
call ShowUnitShow(gg_unit_nsko_0712)
set udg_fuben2=(udg_fuben2+1)
call DisplayTextToForce(GetPlayersAll(),"|cFF00FF00!!貌似有一具火焰被点燃了|r")
else
endif
endif
endif
endif
if(Trig____________________005_Func003C())then
call WaygateActivateBJ(true,gg_unit_nwgt_0491)
call SetUnitAnimation(gg_unit_nwgt_0491,"stand Alternate")
call DisableTrigger(GetTriggeringTrigger())
else
endif
endfunction

function Trig____________________005_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nstl'))then
return false
endif
return true
endfunction