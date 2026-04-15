//=========================================================================== 
// Trigger: 009 u
//=========================================================================== 
function InitTrig____________________009_____________________u takes nothing returns nothing
set gg_trg____________________009_____________________u=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg____________________009_____________________u,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg____________________009_____________________u,Condition(function Trig____________________009_____________________u_Conditions))
call TriggerAddAction(gg_trg____________________009_____________________u,function Trig____________________009_____________________u_Actions)
endfunction

function Trig____________________009_____________________u_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_GROUP=GetUnitsInRangeOfLocMatching(500.00,udg_SP,Condition(function Trig____________________009_____________________u_Func002002003))
call ForGroupBJ(udg_GROUP,function Trig____________________009_____________________u_Func003A)
call DestroyGroup(udg_GROUP)
call DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Other\\Incinerate\\FireLordDeathExplode.mdl",udg_SP))
set udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
loop
exitwhen udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>72
set udg_SP2=PolarProjectionBJ(udg_SP,(7.00*I2R(udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])),(0.00+(I2R(udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*10.00)))
call DestroyEffect(AddSpecialEffectLoc("Environment\\NightElfBuildingFire\\ElfLargeBuildingFire1.mdl",udg_SP2))
call RemoveLocation(udg_SP2)
set udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=udg_BLSY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1
endloop
call RemoveLocation(udg_SP)
endfunction

function Trig____________________009_____________________u_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A08A'))then
return false
endif
return true
endfunction

function Trig____________________009_____________________u_Func002002003 takes nothing returns boolean
return GetBooleanAnd(Trig____________________009_____________________u_Func002002003001(),Trig____________________009_____________________u_Func002002003002())
endfunction