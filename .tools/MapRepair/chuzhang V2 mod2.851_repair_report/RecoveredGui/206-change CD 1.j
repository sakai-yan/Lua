//=========================================================================== 
// Trigger: change CD 1
//=========================================================================== 
function InitTrig_change_CD_1 takes nothing returns nothing
set gg_trg_change_CD_1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_change_CD_1,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_change_CD_1,Condition(function Trig_change_CD_1_Conditions))
call TriggerAddAction(gg_trg_change_CD_1,function Trig_change_CD_1_Actions)
endfunction

function Trig_change_CD_1_Actions takes nothing returns nothing
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=40
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
if(Trig_change_CD_1_Func003Func001C())then
call SetUnitAbilityLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SKILL_f[GetForLoopIndexA()],1)
else
if(Trig_change_CD_1_Func003Func001Func001C())then
call SetUnitAbilityLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SKILL_f[GetForLoopIndexA()],1)
else
if(Trig_change_CD_1_Func003Func001Func001Func001C())then
call SetUnitAbilityLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SKILL_f[GetForLoopIndexA()],1)
else
if(Trig_change_CD_1_Func003Func001Func001Func001Func001C())then
call SetUnitAbilityLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SKILL_f[GetForLoopIndexA()],1)
else
endif
endif
endif
endif
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
endfunction

function Trig_change_CD_1_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction