//=========================================================================== 
// Trigger: miaozhaizhimen2
//=========================================================================== 
function InitTrig_miaozhaizhimen2 takes nothing returns nothing
set gg_trg_miaozhaizhimen2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_miaozhaizhimen2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_miaozhaizhimen2,Condition(function Trig_miaozhaizhimen2_Conditions))
call TriggerAddAction(gg_trg_miaozhaizhimen2,function Trig_miaozhaizhimen2_Actions)
endfunction

function Trig_miaozhaizhimen2_Actions takes nothing returns nothing
call SetDestructableInvulnerable(gg_dest_LTrc_6606,false)
if(Trig_miaozhaizhimen2_Func002C())then
set udg_miaozhaizhimen2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_miaozhaizhimen2_Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00回去找石中保|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
call PolledWait(60.00)
call CreateNUnitsAtLoc(1,'nbnb',Player(PLAYER_NEUTRAL_PASSIVE),GetRectCenter(gg_rct______________101),bj_UNIT_FACING)
endfunction

function Trig_miaozhaizhimen2_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nbnb'))then
return false
endif
return true
endfunction