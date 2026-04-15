//=========================================================================== 
// Trigger: TZ2
//=========================================================================== 
function InitTrig_TZ2 takes nothing returns nothing
set gg_trg_TZ2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_TZ2,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_TZ2,Condition(function Trig_TZ2_Conditions))
call TriggerAddAction(gg_trg_TZ2,function Trig_TZ2_Actions)
endfunction

function Trig_TZ2_Actions takes nothing returns nothing
if(Trig_TZ2_Func003C())then
set udg_T_TZ1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05S',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓破晓套装〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func004C())then
set udg_T_TZ2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call UnitRemoveAbilityBJ('A06K',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call UnitRemoveAbilityBJ('A06I',GetTriggerUnit())
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓煞神套装（战）〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func005C())then
set udg_T_TZ3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call UnitRemoveAbilityBJ('A06I',GetTriggerUnit())
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-250.00)
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓梵天套装（法）〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func006C())then
set udg_T_TZ4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call UnitRemoveAbilityBJ('A03Q',GetTriggerUnit())                         // 1
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓青梅竹马〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func007C())then
set udg_T_TZ5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call UnitRemoveAbilityBJ('A06F',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call UnitRemoveAbilityBJ('A03B',GetTriggerUnit())
call UnitRemoveAbilityBJ('A16I',GetTriggerUnit())                                   //   2
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓混沌套装（战）〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func008C())then
set udg_T_TZ6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-300.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-250.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call UnitRemoveAbilityBJ('A059',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
call UnitRemoveAbilityBJ('AImb',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call UnitRemoveAbilityBJ('A03G',GetTriggerUnit())
call UnitRemoveAbilityBJ('A16I',GetTriggerUnit())                               //  3
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓混沌套装（法）〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func009C())then
set udg_T_TZ7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-55.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,55)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,55)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,55)
call UnitRemoveAbilityBJ('A040',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓琊谷套装〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func010C())then
set udg_T_TZ8[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2000.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2000.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+2000.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call UnitRemoveAbilityBJ('A03F',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓永远的鬼姬〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func011C())then
set udg_T_TZ9[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false

set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call UnitRemoveAbilityBJ('A03F',GetTriggerUnit())
call UnitRemoveAbilityBJ('AImb',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05K',GetTriggerUnit())    //60
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓白虎小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func012C())then
set udg_T_TZ10[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('A040',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓亡灵小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func013C())then
set udg_T_TZ11[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call UnitRemoveAbilityBJ('A053',GetTriggerUnit())
call UnitRemoveAbilityBJ('AImZ',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓血海小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func014C())then
set udg_T_TZ14[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-800.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,400)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,400)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,400)
call UnitRemoveAbilityBJ('pf01',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())                            //  4
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF00CC〓神怒套装〓|r|cFFFF00CC取消|r")
else
endif
if(Trig_TZ2_Func015C())then
set udg_T_TZ15[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call UnitRemoveAbilityBJ('A03F',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05K',GetTriggerUnit())    //60
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓卓越白虎小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func016C())then
set udg_T_TZ16[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('A040',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓卓越亡灵小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func017C())then
set udg_T_TZ17[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-140.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('AImZ',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓卓越银冰小套〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func018C())then
set udg_T_TZ18[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-400.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-600.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,380)
call UnitRemoveAbilityBJ('A06V',GetTriggerUnit())
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓传说燕殇套装〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func019C())then
set udg_T_TZ19[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call UnitRemoveAbilityBJ('A03F',GetTriggerUnit())
call UnitRemoveAbilityBJ('AImb',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00〓初章之传说〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func020C())then
set udg_T_TZ20[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call UnitRemoveAbilityBJ('A06K',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓北周之纠结（战）〓|r|cFF00FF00取消|r")
else
endif
if(Trig_TZ2_Func021C())then
set udg_T_TZ21[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05O',GetTriggerUnit())
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-250.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓北周之麻木（法）〓|r|cFF00FF02取消|r")
else
endif
if(Trig_TZ2_Func022C())then
set udg_T_TZ22[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=false
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,200)
call UnitRemoveAbilityBJ('A05N',GetTriggerUnit())
call UnitRemoveAbilityBJ('A05P',GetTriggerUnit())
call UnitRemoveAbilityBJ('A06V',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓亡灵之喜悦〓|r|cFF00FF00取消|r")
else
endif
endfunction

function Trig_TZ2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction