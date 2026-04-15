//=========================================================================== 
// Trigger: J XR
//=========================================================================== 
function InitTrig_J_XR takes nothing returns nothing
set gg_trg_J_XR=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_XR,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_XR,Condition(function Trig_J_XR_Conditions))
call TriggerAddAction(gg_trg_J_XR,function Trig_J_XR_Actions)
endfunction

function Trig_J_XR_Actions takes nothing returns nothing
if(Trig_J_XR_Func001C())then
if(Trig_J_XR_Func001Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'ewsp',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call SetUnitAbilityLevel(GetLastCreatedUnit(),'ACcr',R2I((((udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]/150.00)+(I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/5.00))+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))/30.00))))
call IssueTargetOrder(GetLastCreatedUnit(),"cripple",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
call CreateTextTagUnitBJ("施法失败",GetSpellTargetUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_XR_Func001Func001Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
else
if(Trig_J_XR_Func001Func002C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'ewsp',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call SetUnitAbilityLevel(GetLastCreatedUnit(),'ACcr',R2I((((udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]/150.00)+(I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/5.00))+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))/30.00))))
call IssueTargetOrder(GetLastCreatedUnit(),"cripple",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
call CreateTextTagUnitBJ("施法失败",GetSpellTargetUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_XR_Func001Func002Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endif
endfunction

function Trig_J_XR_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='Acri'))then
return false
endif
return true
endfunction