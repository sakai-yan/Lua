//=========================================================================== 
// Trigger: J HLS
//=========================================================================== 
function InitTrig_J_HLS takes nothing returns nothing
set gg_trg_J_HLS=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_HLS,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_HLS,Condition(function Trig_J_HLS_Conditions))
call TriggerAddAction(gg_trg_J_HLS,function Trig_J_HLS_Actions)
endfunction

function Trig_J_HLS_Actions takes nothing returns nothing
if(Trig_J_HLS_Func001C())then
call CreateTextTagUnitBJ("没有系灵",GetTriggerUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLS_Func001Func013001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
else
set udg_SP=GetUnitLoc(GetTriggerUnit())
set udg_SP2=PolarProjectionBJ(udg_SP,50.00,GetUnitFacing(GetTriggerUnit()))
call CreateNUnitsAtLoc(1,udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],GetOwningPlayer(GetTriggerUnit()),udg_SP2,GetUnitFacing(GetTriggerUnit()))
set udg_J_ls_unit[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetLastCreatedUnit()
if(Trig_J_HLS_Func001Func005C())then
call SetUnitAbilityLevelSwapped('AIsr',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*2)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/76))
call SetUnitAbilityLevelSwapped('A005',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*2)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/76))
call UnitAddAbilityBJ('A00X',GetLastCreatedUnit())
if(Trig_J_HLS_Func001Func005Func006C())then
call SetUnitAbilityLevelSwapped('A00X',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*3)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/76))
else
call SetUnitAbilityLevelSwapped('A00X',GetLastCreatedUnit(),1)
endif
call UnitRemoveAbilityBJ('A00X',GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(140.00,'BTLF',GetLastCreatedUnit())
else
call SetUnitAbilityLevelSwapped('AIsr',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*2)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/100))
call SetUnitAbilityLevelSwapped('A005',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*2)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/100))
call UnitAddAbilityBJ('A00X',GetLastCreatedUnit())
if(Trig_J_HLS_Func001Func005Func010C())then
call SetUnitAbilityLevelSwapped('A00X',GetLastCreatedUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*3)+R2I(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/100))
else
call SetUnitAbilityLevelSwapped('A00X',GetLastCreatedUnit(),1)
endif
call UnitRemoveAbilityBJ('A00X',GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(100.00,'BTLF',GetLastCreatedUnit())
endif
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
endif
endfunction

function Trig_J_HLS_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AOsf'))then
return false
endif
return true
endfunction