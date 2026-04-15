//=========================================================================== 
// Trigger: zhoushi8
//=========================================================================== 
function InitTrig_zhoushi8 takes nothing returns nothing
set gg_trg_zhoushi8=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhoushi8,256,gg_unit_nshw_0366)
call TriggerAddCondition(gg_trg_zhoushi8,Condition(function Trig_zhoushi8_Conditions))
call TriggerAddAction(gg_trg_zhoushi8,function Trig_zhoushi8_Actions)
endfunction

function Trig_zhoushi8_Actions takes nothing returns nothing
set udg_MP_zhoushi7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
if(Trig_zhoushi8_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00苑樱师：|r|cFFCCFFCC我已经为你加强了你体内的抗体，你现在已经是一个能随便操纵咒术之人，清心阁的咒师也。日后要谨慎运用你所学之术，万万不可胡来！\n\n|r|cFF00FF00成|r|cFF00FF40功|r|cFF00FF80转|r|cFF00FFBF职|r|cFF00FFFF：|r|cFFFFFF00咒术师|r")
set udg_SP=GetRectCenter(gg_rct_xuesi5)
if(Trig_zhoushi8_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhoushi8_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
call UnitRemoveAbilityBJ('AHhb',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('AIh1',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A003',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02M',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+2)]='Acri'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+3)]='AIh1'
                                                                                              //6
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A003'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='A02M'


call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
endfunction

function Trig_zhoushi8_Conditions takes nothing returns boolean
if(not(udg_MP_zhoushi6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_zhoushi7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction