//=========================================================================== 
// Trigger: LiQi spell
//=========================================================================== 
function InitTrig_LiQi_spell takes nothing returns nothing
set gg_trg_LiQi_spell=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_LiQi_spell,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_LiQi_spell,Condition(function Trig_LiQi_spell_Conditions))
call TriggerAddAction(gg_trg_LiQi_spell,function Trig_LiQi_spell_Actions)
endfunction

function Trig_LiQi_spell_Actions takes nothing returns nothing
if(Trig_LiQi_spell_Func001C())then
set udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+3)
else
endif
if(Trig_LiQi_spell_Func002C())then
if(Trig_LiQi_spell_Func002Func001C())then
call DisplayTextToForce(GetPlayersAll(),(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))+"|cFFFF0000终于压不住魔性了！！|r"))
call StartTimerBJ(udg_HERO_MO_TIME[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false,(SquareRoot(I2R(udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))*0.30))
call CreateTimerDialogBJ(GetLastCreatedTimerBJ(),(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))+"入魔"))
set udg_HERO_MO_TIMEWIN[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedTimerDialogBJ()
call SetUnitOwner(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],Player(PLAYER_NEUTRAL_AGGRESSIVE),true)
set udg_HREO_MO_TURE[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
else
endif
else
endif
endfunction

function Trig_LiQi_spell_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()!='A02F'))then
return false
endif
if(not(GetSpellAbilityId()!='A009'))then
return false
endif
if(not(GetSpellAbilityId()!='A00Z'))then
return false
endif
if(not(GetSpellAbilityId()!='A00Y'))then
return false
endif
if(not(GetSpellAbilityId()!='AIil'))then
return false
endif
if(not(GetSpellAbilityId()!='AIpr'))then
return false
endif
if(not(GetSpellAbilityId()!='AIrl'))then
return false
endif
if(not(GetSpellAbilityId()!='A05X'))then
return false
endif
if(not(GetSpellAbilityId()!='AIpl'))then
return false
endif
if(not(GetSpellAbilityId()!='A05Y'))then
return false
endif
if(not(GetSpellAbilityId()!='Acht'))then
return false
endif
if(not(GetSpellAbilityId()!='A000'))then
return false
endif
if(not(GetSpellAbilityId()!='A04Y'))then
return false
endif
if(not(GetSpellAbilityId()!='A029'))then
return false
endif
if(not(GetSpellAbilityId()!='A02O'))then
return false
endif
if(not(GetSpellAbilityId()!='A03N'))then
return false
endif
if(not(GetSpellAbilityId()!='AIh2'))then
return false
endif
if(not(GetSpellAbilityId()!='AIm2'))then
return false
endif
if(not(GetSpellAbilityId()!='AIm2'))then
return false
endif
if(not(GetSpellAbilityId()!='A05D'))then
return false
endif
if(not(GetSpellAbilityId()!='A05E'))then
return false
endif
if(not(GetSpellAbilityId()!='A06N'))then
return false
endif
return true
endfunction