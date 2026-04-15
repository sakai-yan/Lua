//=========================================================================== 
// Trigger: zhoushi7
//=========================================================================== 
function InitTrig_zhoushi7 takes nothing returns nothing
set gg_trg_zhoushi7=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhoushi7,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_zhoushi7,function Trig_zhoushi7_Actions)
endfunction

function Trig_zhoushi7_Actions takes nothing returns nothing
if(Trig_zhoushi7_Func001C())then
set udg_MP_zhoushi6[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
if(Trig_zhoushi7_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：成功拿到涉毒之心，回去找苑樱师吧！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endfunction