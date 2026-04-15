//=========================================================================== 
// Trigger: zhoushi5
//=========================================================================== 
function InitTrig_zhoushi5 takes nothing returns nothing
set gg_trg_zhoushi5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhoushi5,256,gg_unit_ngza_0168)
call TriggerAddCondition(gg_trg_zhoushi5,Condition(function Trig_zhoushi5_Conditions))
call TriggerAddAction(gg_trg_zhoushi5,function Trig_zhoushi5_Actions)
endfunction

function Trig_zhoushi5_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sor5')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('sor6',GetTriggerUnit())
set udg_MP_zhoushi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
if(Trig_zhoushi5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00陆容大夫：|r|cFFCCFFCC苑樱师总喜欢炼制这些恶心的东西，拿这|r|cFF00FF00精制毒素|r|cFFCCFFCC回去找|r|cFF00FF00伏樱师，|r|cFFCCFFCC下次最好还是别烦我了···\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把精制毒素交给苑樱师|r")
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
if(Trig_zhoushi5_Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhoushi5_Func011001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_zhoushi5_Conditions takes nothing returns boolean
if(not(udg_MP_zhoushi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_zhoushi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sor5')==true))then
return false
endif
return true
endfunction