//=========================================================================== 
// Trigger: BBSKILL 2
//=========================================================================== 
function InitTrig_BBSKILL_2 takes nothing returns nothing
set gg_trg_BBSKILL_2=CreateTrigger()
call TriggerAddAction(gg_trg_BBSKILL_2,function Trig_BBSKILL_2_Actions)
endfunction

function Trig_BBSKILL_2_Actions takes nothing returns nothing
set udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),3,4))
set udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),5,6))
set udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),7,8))
set udg_BB_STR[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),5,5))
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,R2I((I2R(udg_BB_STR[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(I2R(udg_BB_LV[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*0.10))))
set udg_BB_AGI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),6,6))
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,R2I((I2R(udg_BB_AGI[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(I2R(udg_BB_LV[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*0.10))))
set udg_BB_INT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),7,7))
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,R2I((I2R(udg_BB_INT[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*(I2R(udg_BB_LV[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])*0.10))))
if(Trig_BBSKILL_2_Func010C())then
call UnitAddAbilityBJ('A07D',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07D',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func010Func001C())then
call UnitAddAbilityBJ('A07E',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07E',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func010Func001Func001C())then
call UnitAddAbilityBJ('A07G',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07G',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func010Func001Func001Func001C())then
call UnitAddAbilityBJ('AIrm',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('AIrm',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func010Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07H',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07H',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func010Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07M',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07M',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func010Func001Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07L',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07L',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
endif
endif
endif
endif
endif
endif
endif
if(Trig_BBSKILL_2_Func011001())then
call DoNothing()
else
return
endif
if(Trig_BBSKILL_2_Func012C())then
call UnitAddAbilityBJ('A07D',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07D',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func012Func001C())then
call UnitAddAbilityBJ('A07E',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07E',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func012Func001Func001C())then
call UnitAddAbilityBJ('A07G',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07G',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func012Func001Func001Func001C())then
call UnitAddAbilityBJ('AIrm',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('AIrm',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func012Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07H',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07H',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func012Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07M',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07M',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func012Func001Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07L',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07L',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
endif
endif
endif
endif
endif
endif
endif
if(Trig_BBSKILL_2_Func013001())then
call DoNothing()
else
return
endif
if(Trig_BBSKILL_2_Func014C())then
call UnitAddAbilityBJ('A07D',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07D',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func014Func001C())then
call UnitAddAbilityBJ('A07E',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07E',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',GetTriggerUnit())
else
if(Trig_BBSKILL_2_Func014Func001Func001C())then
call UnitAddAbilityBJ('A07G',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07G',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func014Func001Func001Func001C())then
call UnitAddAbilityBJ('AIrm',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('AIrm',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func014Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07H',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07H',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func014Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07M',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07M',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_2_Func014Func001Func001Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('A07L',GetTriggerUnit())
call SetUnitAbilityLevelSwapped('A07L',GetTriggerUnit(),(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
endif
endif
endif
endif
endif
endif
endif
endfunction