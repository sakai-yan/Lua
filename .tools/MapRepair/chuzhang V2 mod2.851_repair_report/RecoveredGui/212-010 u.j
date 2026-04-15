//=========================================================================== 
// Trigger: 010 u
//=========================================================================== 
function InitTrig____________________010_______u takes nothing returns nothing
set gg_trg____________________010_______u=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________010_______u,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddCondition(gg_trg____________________010_______u,Condition(function Trig____________________010_______u_Conditions))
call TriggerAddAction(gg_trg____________________010_______u,function Trig____________________010_______u_Actions)
endfunction

function Trig____________________010_______u_Actions takes nothing returns nothing
if(Trig____________________010_______u_Func001C())then
if(Trig____________________010_______u_Func001Func001C())then
call UnitAddItemByIdSwapped('I03C',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func001Func002C())then
call UnitAddItemByIdSwapped('I03C',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func002C())then
if(Trig____________________010_______u_Func002Func001C())then
call UnitAddItemByIdSwapped('I03B',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func002Func002C())then
call UnitAddItemByIdSwapped('I03B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func003C())then
if(Trig____________________010_______u_Func003Func001C())then
call UnitAddItemByIdSwapped('I03A',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func003Func002C())then
call UnitAddItemByIdSwapped('I03A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func004C())then
if(Trig____________________010_______u_Func004Func001C())then
call UnitAddItemByIdSwapped('I03E',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func004Func002C())then
call UnitAddItemByIdSwapped('I03E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func005C())then
if(Trig____________________010_______u_Func005Func001C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func005Func002C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func006C())then
if(Trig____________________010_______u_Func006Func001C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func006Func002C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func007C())then
if(Trig____________________010_______u_Func007Func001C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func007Func002C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
if(Trig____________________010_______u_Func008C())then
if(Trig____________________010_______u_Func008Func001C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig____________________010_______u_Func008Func002C())then
call UnitAddItemByIdSwapped('I03F',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
else
endif
endfunction

function Trig____________________010_______u_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction