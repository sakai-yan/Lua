//=========================================================================== 
// Trigger: LiQi at
//=========================================================================== 
function InitTrig_LiQi_at takes nothing returns nothing
set gg_trg_LiQi_at=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_LiQi_at,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddAction(gg_trg_LiQi_at,function Trig_LiQi_at_Actions)
endfunction

function Trig_LiQi_at_Actions takes nothing returns nothing
if(Trig_LiQi_at_Func001C())then
if(Trig_LiQi_at_Func001Func001C())then
call DisplayTextToForce(GetPlayersAll(),(GetPlayerName(GetOwningPlayer(GetAttacker()))+"|cFFFF0000终于压不住魔性了！！|r"))
call StartTimerBJ(udg_HERO_MO_TIME[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],false,(SquareRoot(I2R(udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]))*0.30))
call CreateTimerDialogBJ(GetLastCreatedTimerBJ(),(GetPlayerName(GetOwningPlayer(GetAttacker()))+"入魔"))
set udg_HERO_MO_TIMEWIN[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]=GetLastCreatedTimerDialogBJ()
call SetUnitOwner(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))],Player(PLAYER_NEUTRAL_AGGRESSIVE),true)
set udg_HREO_MO_TURE[GetConvertedPlayerId(GetOwningPlayer(GetAttacker()))]=true
else
endif
else
endif
endfunction