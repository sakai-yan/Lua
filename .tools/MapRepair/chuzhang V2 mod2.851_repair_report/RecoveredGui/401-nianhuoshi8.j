//=========================================================================== 
// Trigger: nianhuoshi8
//=========================================================================== 
function InitTrig_nianhuoshi8 takes nothing returns nothing
set gg_trg_nianhuoshi8=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_nianhuoshi8,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_nianhuoshi8,Condition(function Trig_nianhuoshi8_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi8,function Trig_nianhuoshi8_Actions)
endfunction

function Trig_nianhuoshi8_Actions takes nothing returns nothing
if(Trig_nianhuoshi8_Func001C())then
set udg_MP_nianhuoshi6[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
call UnitAddItemByIdSwapped('pnvu',GetKillingUnitBJ())
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
call RemoveLocation(udg_SP)
if(Trig_nianhuoshi8_Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：遗失铁环掉落！拿回去交给胡不留吧！|r")
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_nianhuoshi8_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetUnitTypeId(GetTriggerUnit())=='nsth'))then
return false
endif
if(not(udg_MP_nianhuoshi5[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==true))then
return false
endif
if(not(udg_MP_nianhuoshi6[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==false))then
return false
endif
return true
endfunction