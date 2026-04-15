//=========================================================================== 
// Trigger: YF 2
//=========================================================================== 
function InitTrig_YF_2 takes nothing returns nothing
set gg_trg_YF_2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_YF_2,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_YF_2,Condition(function Trig_YF_2_Conditions))
call TriggerAddAction(gg_trg_YF_2,function Trig_YF_2_Actions)
endfunction

function Trig_YF_2_Actions takes nothing returns nothing
if(Trig_YF_2_Func003C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,8)
else
endif
if(Trig_YF_2_Func004C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_YF_2_Func005C())then
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
else
endif
if(Trig_YF_2_Func006C())then
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,8)
else
endif
if(Trig_YF_2_Func007C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_YF_2_Func008C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,12)
else
endif
if(Trig_YF_2_Func009C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
else
endif
if(Trig_YF_2_Func010C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,16)
else
endif
if(Trig_YF_2_Func011C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,20)
else
endif
if(Trig_YF_2_Func012C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,22)
else
endif
if(Trig_YF_2_Func013C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
else
endif
if(Trig_YF_2_Func014C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60.00)
else
endif
if(Trig_YF_2_Func015C())then
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
else
endif
if(Trig_YF_2_Func016C())then
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
else
endif
if(Trig_YF_2_Func017C())then
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-250.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,75)
else
endif
if(Trig_YF_2_Func018C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
else
endif
//+++
if(Trig_YF_2_Func019C())then           //hdjj
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,90)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
else
endif
if(Trig_YF_2_Func020C())then         //hdpp
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-300.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
else
endif
//+++
endfunction

function Trig_YF_2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction