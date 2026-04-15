//=========================================================================== 
// Trigger: xiongcanluyao2
//=========================================================================== 
function InitTrig_xiongcanluyao2 takes nothing returns nothing
set gg_trg_xiongcanluyao2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiongcanluyao2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_xiongcanluyao2,function Trig_xiongcanluyao2_Actions)
endfunction

function Trig_xiongcanluyao2_Actions takes nothing returns nothing
if(Trig_xiongcanluyao2_Func001C())then
set udg_R_xiongcan2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncg1_0205)
if(Trig_xiongcanluyao2_Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFFFF99提示：成功除掉残凶鹿妖，回去营地找阿飞吧！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nqb3_0248)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
endfunction