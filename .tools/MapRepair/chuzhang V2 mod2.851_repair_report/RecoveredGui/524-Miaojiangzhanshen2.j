//=========================================================================== 
// Trigger: Miaojiangzhanshen2
//=========================================================================== 
function InitTrig_Miaojiangzhanshen2 takes nothing returns nothing
set gg_trg_Miaojiangzhanshen2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_Miaojiangzhanshen2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_Miaojiangzhanshen2,Condition(function Trig_Miaojiangzhanshen2_Conditions))
call TriggerAddAction(gg_trg_Miaojiangzhanshen2,function Trig_Miaojiangzhanshen2_Actions)
endfunction

function Trig_Miaojiangzhanshen2_Actions takes nothing returns nothing
set udg_Miaojiangzhanshen2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_Miaojiangzhanshen2_Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00战神已倒，回去找石龙保吧|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_Miaojiangzhanshen2_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nbdo'))then
return false
endif
if(not(udg_Miaojiangzhanshen1[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==true))then
return false
endif
if(not(udg_Miaojiangzhanshen2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]==false))then
return false
endif
return true
endfunction