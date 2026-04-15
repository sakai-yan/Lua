//=========================================================================== 
// Trigger: BUFF
//=========================================================================== 
function InitTrig_BUFF takes nothing returns nothing
set gg_trg_BUFF=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_BUFF,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddAction(gg_trg_BUFF,function Trig_BUFF_Actions)
endfunction

function Trig_BUFF_Actions takes nothing returns nothing          //a buff
if(Trig_BUFF_Func001C())then
set udg_BUFF_F[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=(1.00+(((udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)))/10000.00)+(I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/400.00)))
else
endif
if(Trig_BUFF_Func002C())then
set udg_BUFF_Z[GetConvertedPlayerId(GetOwningPlayer(GetSpellTargetUnit()))]=(1.00+(((udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)))/10000.00)+(I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/400.00)))
else
endif
if(Trig_BUFF_Func003C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'ewsp',GetOwningPlayer(GetTriggerUnit()),udg_SP,bj_UNIT_FACING)
call ShowUnitHide(GetLastCreatedUnit())
call UnitApplyTimedLifeBJ(1.00,'BTLF',GetLastCreatedUnit())
call SetUnitAbilityLevel(GetLastCreatedUnit(),'Ainf',R2I((((udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]/150.00)+(I2R(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])/5.00))+(I2R(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false))/30.00))))
call IssueTargetOrder(GetLastCreatedUnit(),"innerfire",GetSpellTargetUnit())
call RemoveLocation(udg_SP)
else
endif
if(Trig_BUFF_Func004C())then
call SetUnitManaBJ(GetSpellTargetUnit(),(GetUnitStateSwap(UNIT_STATE_MANA,GetSpellTargetUnit())-50.00))
call CreateTextTagUnitBJ("-50",GetTriggerUnit(),90.00,8.00,0.00,10.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
else
endif
endfunction