//=========================================================================== 
// Trigger: J TXDH
//=========================================================================== 
function InitTrig_J_TXDH takes nothing returns nothing
set gg_trg_J_TXDH=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_TXDH,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_J_TXDH,Condition(function Trig_J_TXDH_Conditions))
call TriggerAddAction(gg_trg_J_TXDH,function Trig_J_TXDH_Actions)
endfunction

function Trig_J_TXDH_Actions takes nothing returns nothing
if(Trig_J_TXDH_Func001C())then
if(Trig_J_TXDH_Func001Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'e001',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call SetUnitAbilityLevel(GetLastCreatedUnit(),'Aenr',R2I((((udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)))+(I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*2.00))/25.00)))
call IssueTargetOrder(GetLastCreatedUnit(),"entanglingroots",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
call CreateTextTagUnitBJ("施法失败",GetSpellTargetUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_TXDH_Func001Func001Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
else
if(Trig_J_TXDH_Func001Func002C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'e001',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call SetUnitAbilityLevel(GetLastCreatedUnit(),'Aenr',R2I((((udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)))+(I2R(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*2.00))/25.00)))
call IssueTargetOrder(GetLastCreatedUnit(),"entanglingroots",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
call CreateTextTagUnitBJ("施法失败",GetSpellTargetUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_TXDH_Func001Func002Func006001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endif
endfunction

function Trig_J_TXDH_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='AEer'))then
return false
endif
return true
endfunction