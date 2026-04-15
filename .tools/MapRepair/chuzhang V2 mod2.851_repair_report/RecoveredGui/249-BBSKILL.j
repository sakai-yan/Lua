//=========================================================================== 
// Trigger: BBSKILL
//=========================================================================== 
function InitTrig_BBSKILL takes nothing returns nothing
set gg_trg_BBSKILL=CreateTrigger()
call TriggerAddAction(gg_trg_BBSKILL,function Trig_BBSKILL_Actions)
endfunction

function Trig_BBSKILL_Actions takes nothing returns nothing
set udg_BB_SKILL1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,2))
set udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),3,4))
set udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),5,6))
set udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=S2I(SubStringBJ(I2S(udg_BB_SKILL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),7,8))
call UnitAddAbilityBJ(udg_BB_skill[udg_BB_SKILL1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])

                                                //c
if(Trig_BBSKILL_Func006C())then
call UnitAddAbilityBJ('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func006Func003C())then
call UnitAddAbilityBJ('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func006Func003Func001C())then
call UnitAddAbilityBJ('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_Func006Func003Func001Func001C())then
call UnitAddAbilityBJ('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
call UnitAddAbilityBJ(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],S2I(SubStringBJ(I2S(udg_BB_SKILL2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2)))
endif
endif
endif
endif
if(Trig_BBSKILL_Func007001())then
call DoNothing()
else
return
endif                                        //c
if(Trig_BBSKILL_Func008C())then
call UnitAddAbilityBJ('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func008Func003C())then
call UnitAddAbilityBJ('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func008Func003Func001C())then
call UnitAddAbilityBJ('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_Func008Func003Func001Func001C())then
call UnitAddAbilityBJ('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
call UnitAddAbilityBJ(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2)))
endif
endif
endif
endif
if(Trig_BBSKILL_Func009001())then
call DoNothing()
else
return                                         //c
endif
if(Trig_BBSKILL_Func010C())then
call UnitAddAbilityBJ('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07A',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07D',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func010Func003C())then
call UnitAddAbilityBJ('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07B',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+1))
call UnitRemoveAbilityBJ('A07E',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_BBSKILL_Func010Func003Func001C())then
call UnitAddAbilityBJ('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('Agyb',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A07G',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
if(Trig_BBSKILL_Func010Func003Func001Func001C())then
call UnitAddAbilityBJ('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('A079',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
call UnitAddAbilityBJ('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped('AIrm',udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],(S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2))+0))
else
call UnitAddAbilityBJ(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetUnitAbilityLevelSwapped(udg_BB_skill[S2I(SubStringBJ(I2S(udg_BB_SKILL3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),1,1))],udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],S2I(SubStringBJ(I2S(udg_BB_SKILL4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]),2,2)))
endif
endif
endif
endif
endfunction