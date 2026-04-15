//=========================================================================== 
// Trigger: tiaocha4
//=========================================================================== 
function InitTrig_tiaocha4 takes nothing returns nothing
set gg_trg_tiaocha4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tiaocha4,256,gg_unit_hctw_0452)
call TriggerAddCondition(gg_trg_tiaocha4,Condition(function Trig_tiaocha4_Conditions))
call TriggerAddAction(gg_trg_tiaocha4,function Trig_tiaocha4_Actions)
endfunction

function Trig_tiaocha4_Actions takes nothing returns nothing
if(Trig_tiaocha4_Func001C())then
call DoNothing()
else
set udg_tiaocha4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死苗寨投毒者|r")
set udg_SP=GetUnitLoc(gg_unit_hctw_0452)
call CreateNUnitsAtLoc(1,'ndrd',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP,bj_UNIT_FACING)
if(Trig_tiaocha4_Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
endfunction

function Trig_tiaocha4_Conditions takes nothing returns boolean
if(not(udg_tiaocha3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_tiaocha4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction