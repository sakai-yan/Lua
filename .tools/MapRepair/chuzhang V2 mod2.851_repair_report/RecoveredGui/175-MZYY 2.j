//=========================================================================== 
// Trigger: MZYY 2
//=========================================================================== 
function InitTrig_MZYY_2 takes nothing returns nothing
set gg_trg_MZYY_2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_MZYY_2,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_MZYY_2,Condition(function Trig_MZYY_2_Conditions))
call TriggerAddAction(gg_trg_MZYY_2,function Trig_MZYY_2_Actions)
endfunction

function Trig_MZYY_2_Actions takes nothing returns nothing
if(Trig_MZYY_2_Func004C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZYY_2_Func005C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-90.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,20)
else
endif
if(Trig_MZYY_2_Func006C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-90.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,20)
else
endif
if(Trig_MZYY_2_Func007C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
else
endif
if(Trig_MZYY_2_Func008C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-160.00)
else
endif
if(Trig_MZYY_2_Func009C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
else
endif
if(Trig_MZYY_2_Func010C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,105)
else
endif
if(Trig_MZYY_2_Func011C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-135.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,95)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,95)
else
endif
if(Trig_MZYY_2_Func012C())then
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
else
endif
if(Trig_MZYY_2_Func013C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
else
endif
if(Trig_MZYY_2_Func014C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-170.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,70)
else
endif
if(Trig_MZYY_2_Func015C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60)
else
endif
if(Trig_MZYY_2_Func016C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130)
else
endif
if(Trig_MZYY_2_Func017C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
else
endif
if(Trig_MZYY_2_Func018C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
else
endif
endfunction

function Trig_MZYY_2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction