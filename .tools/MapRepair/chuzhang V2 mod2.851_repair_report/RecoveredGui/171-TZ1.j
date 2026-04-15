//=========================================================================== 
// Trigger: TZ1
//=========================================================================== 
function InitTrig_TZ1 takes nothing returns nothing
set gg_trg_TZ1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_TZ1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_TZ1,Condition(function Trig_TZ1_Conditions))
call TriggerAddAction(gg_trg_TZ1,function Trig_TZ1_Actions)
endfunction

function Trig_TZ1_Actions takes nothing returns nothing
if(Trig_TZ1_Func003C())then
set udg_T_TZ1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('A05P',GetTriggerUnit())
call UnitAddAbilityBJ('A05S',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05S')
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓破晓套装〓|r|cFF00FF00达成\n全系+200\n全属+200\n生命上限+800\n法力上限+300\n物理攻击+640\n|r")
else
endif
if(Trig_TZ1_Func004C())then
set udg_T_TZ2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call UnitAddAbilityBJ('A06K',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A06I',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06K')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06I')
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=2
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓煞神套装（战）〓|r|cFF00FF00达成\n战斗类系+150\n筋骨+150\n身法+80\n生命上限+1200\n生命恢复+10\n物理攻击+1500\n|r")
else
endif
if(Trig_TZ1_Func005C())then
set udg_T_TZ3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('A05P',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A06I',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06I')
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+250.00)
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓梵天套装（法）〓|r|cFF00FF00达成\n法术类系+150\n内力+150\n生命上限+800\n法力上限+300\n生命恢复+10\n物理攻击+1500\n法术抵抗+250\n|r")
else
endif
if(Trig_TZ1_Func006C())then
set udg_T_TZ4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call UnitAddAbilityBJ('A03Q',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03Q')
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓青梅竹马〓|r|cFF00FF00达成\n全系+40\n全属+30\n移动+35\n|r")
else
endif
if(Trig_TZ1_Func007C())then
set udg_T_TZ5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call UnitAddAbilityBJ('A06F',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A03B',GetTriggerUnit())
call UnitAddAbilityBJ('A16I',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06F')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03B')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A16I')                           //2   //
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓混沌套装（战）〓|r|cFF00FF00达成\n战斗类系+200\n筋骨+200\n身法+120\n生命上限+1400\n生命恢复+12\n物理攻击+1850\n|r")
else
endif
if(Trig_TZ1_Func008C())then
set udg_T_TZ6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+300.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+250.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call UnitAddAbilityBJ('A05P',GetTriggerUnit())
call UnitAddAbilityBJ('AImb',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A03G',GetTriggerUnit())
call UnitAddAbilityBJ('A16I',GetTriggerUnit())                                       //3
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'AImb')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03G')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A16I')
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓混沌套装（法）〓|r|cFF00FF00达成\n法术类系+250\n内力+200\n法力上限+780\n生命恢复+13\n物理攻击+1850\n法术抵抗+300n|r")
else
endif
if(Trig_TZ1_Func009C())then
set udg_T_TZ7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+55.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,55)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,55)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,55)
call UnitAddAbilityBJ('A040',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A040')  //6
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓琊谷套装〓|r|cFF00FF00达成\n全系+55\n全属+55\n生命恢复+6\n|r")
else
endif
if(Trig_TZ1_Func010C())then
set udg_T_TZ8[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-2000.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-2000.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-2000.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call UnitAddAbilityBJ('A03F',GetTriggerUnit())
call UnitAddAbilityBJ('A05P',GetTriggerUnit())       //5
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03F')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
set udg_T_TZ_PL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=2
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓永远的鬼姬〓|r|cFF00FF00达成\n拳系+200\n其他??2000\n筋骨+150\n身法+80\n内力+80\n生命上限+700\n法力上限+300\n|r")
else
endif
if(Trig_TZ1_Func011C())then
set udg_T_TZ9[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call UnitAddAbilityBJ('A03F',GetTriggerUnit())
call UnitAddAbilityBJ('AImb',GetTriggerUnit())
call UnitAddAbilityBJ('A05K',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03F')//   700                  //6
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'AImb')//   +180
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05K')    //+60
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓白虎小套〓|r|cFF00FF00达成\n全系+100\n全属+80\n生命上限+700\n法力上限+180\n移动+60\n|r")
else
endif
if(Trig_TZ1_Func012C())then
set udg_T_TZ10[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('A040',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')//   800                  //7
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A040')    //+6
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓亡灵小套〓|r|cFF00FF00达成\n全系+120\n全属+100\n生命上限+800\n生命恢复+6\n|r")
else
endif
if(Trig_TZ1_Func013C())then
set udg_T_TZ11[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call UnitAddAbilityBJ('A053',GetTriggerUnit())
call UnitAddAbilityBJ('AImz',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A053')//   900                  //8
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'AImz')//   +80
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓血海小套〓|r|cFF00FF00达成\n全系+140\n全属+120\n生命上限+900\n法力上限+80\n|r")
else
endif
if(Trig_TZ1_Func0014C())then
set udg_T_TZ14[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,400)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,400)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,400)
call UnitAddAbilityBJ('pf01',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'pf01') //mp                    //4
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')  //180
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF00CC〓神怒套装〓|r|cFFFF00CC达成\n全系+800\n全属+400\n生命上限+1500\n生命恢复+20\n|r")
else
endif
if(Trig_TZ1_Func015C())then
set udg_T_TZ15[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call UnitAddAbilityBJ('A03F',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitAddAbilityBJ('A05K',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03F')//   700                  //6
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')//   +180
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05K')    //+60
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00[卓越]||cFF99CC00〓白虎小套〓|r|cFF00FF00达成\n全系+100\n全属+80\n生命上限+700\n生命恢复+10\n移动+60\n|r")
else
endif
if(Trig_TZ1_Func016C())then
set udg_T_TZ16[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('A040',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')//   800                  //7
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A040')    //+6
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00[卓越]||cFF99CC00〓亡灵小套〓|r|cFF00FF00达成\n全系+140\n全属+120\n生命上限+900\n法力上限+80\n|r")
else
endif
if(Trig_TZ1_Func017C())then
set udg_T_TZ17[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+140.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('AImz',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')//   900                  //8
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'AImz')//   +80
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00[卓越]||cFF99CC00〓银冰小套〓|r|cFF00FF00达成\n全系+140\n全属+120\n生命上限+800\n法力上限+80\n|r")
else
endif
if(Trig_TZ1_Func018C())then
set udg_T_TZ18[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+400.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+600.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,100)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,380)
call UnitAddAbilityBJ('A06V',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06V')
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00[传说]||cFF99CC00〓燕殇套〓|r|cFF00FF00达成\n法系+400\n医系+600\n战系+200\n身法+100\n内力+380\n移动速度+120\n|r")
else
endif
if(Trig_TZ1_Func019C())then
set udg_T_TZ19[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call UnitAddAbilityBJ('A03F',GetTriggerUnit())
call UnitAddAbilityBJ('AImb',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A03F') //mp                    //4
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'AImb')  //180
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF00[传说]||cFF99CC00〓初章〓|r|cFF00FF00达成\n全系+80\n全属+80\n生命上限+700\n法力上限+180\n|r")
else
endif
if(Trig_TZ1_Func020C())then
set udg_T_TZ20[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call UnitAddAbilityBJ('A06K',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06K')
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓北周之纠结（战）〓|r|cFF00FF00达成\n战斗类系+150\n筋骨+150\n生命上限+1200\n|r")
else
endif
if(Trig_TZ1_Func021C())then
set udg_T_TZ21[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call UnitAddAbilityBJ('A05P',GetTriggerUnit())
call UnitAddAbilityBJ('A05O',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05O')
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+250.00)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓北周之麻木（法）〓|r|cFF00FF00达成\n法术类系+150\n内力+150\n法力上限+300\n生命恢复+10\n法术抵抗+250\n|r")
else
endif
if(Trig_TZ1_Func022C())then
set udg_T_TZ22[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,200)
call UnitAddAbilityBJ('A05N',GetTriggerUnit())
call UnitAddAbilityBJ('A05P',GetTriggerUnit())
call UnitAddAbilityBJ('A06V',GetTriggerUnit())
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05N')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A05P')
call UnitMakeAbilityPermanent(GetTriggerUnit(),true,'A06V')
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF99CC00〓亡灵之喜悦〓|r|cFF00FF00达成\n全系+200\n全属+200\n生命上限+800\n法力上限+300\n移速+120\n|r")
else
endif
endfunction

function Trig_TZ1_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction