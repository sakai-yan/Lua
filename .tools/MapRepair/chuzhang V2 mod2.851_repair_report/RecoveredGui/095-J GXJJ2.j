//=========================================================================== 
// Trigger: J GXJJ2
//=========================================================================== 
function InitTrig_J_GXJJ2 takes nothing returns nothing
set gg_trg_J_GXJJ2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_GXJJ2,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_J_GXJJ2,Condition(function Trig_J_GXJJ2_Conditions))
call TriggerAddAction(gg_trg_J_GXJJ2,function Trig_J_GXJJ2_Actions)
endfunction

function Trig_J_GXJJ2_Actions takes nothing returns nothing
if(Trig_J_GXJJ2_Func002C())then
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])
call CreateNUnitsAtLoc(1,'nfpc',GetOwningPlayer(GetAttacker()),udg_SP,GetUnitFacing(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))
call UnitAddAbilityBJ('A049',GetLastCreatedUnit())
call UnitAddAbilityBJ('A04O',GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(2.00,'BTLF',GetLastCreatedUnit())
call SetUnitVertexColorBJ(GetLastCreatedUnit(),0.00,0.00,100,75.00)
call RemoveLocation(udg_SP)
else
if(Trig_J_GXJJ2_Func002Func001C())then
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])
call CreateNUnitsAtLoc(1,'n00J',GetOwningPlayer(GetAttacker()),udg_SP,GetUnitFacing(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))
call UnitAddAbilityBJ('A049',GetLastCreatedUnit())
call UnitAddAbilityBJ('A04O',GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(2.00,'BTLF',GetLastCreatedUnit())
call SetUnitVertexColorBJ(GetLastCreatedUnit(),0.00,0.00,100,75.00)
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))])
call CreateNUnitsAtLoc(1,'nfps',GetOwningPlayer(GetAttacker()),udg_SP,GetUnitFacing(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))
call UnitAddAbilityBJ('A049',GetLastCreatedUnit())
call UnitAddAbilityBJ('A04O',GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(2.00,'BTLF',GetLastCreatedUnit())
call SetUnitVertexColorBJ(GetLastCreatedUnit(),0.00,0.00,100,75.00)
call RemoveLocation(udg_SP)
endif
endif
endfunction

function Trig_J_GXJJ2_Conditions takes nothing returns boolean
if(not(GetAttacker()==udg_FY_J_GXJJ_UNIT[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))then
return false
endif
return true
endfunction