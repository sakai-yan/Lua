//=========================================================================== 
// Trigger: qiaomu
//=========================================================================== 
function InitTrig_qiaomu takes nothing returns nothing
set gg_trg_qiaomu=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qiaomu,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_qiaomu,Condition(function Trig_qiaomu_Conditions))
call TriggerAddAction(gg_trg_qiaomu,function Trig_qiaomu_Actions)
endfunction

function Trig_qiaomu_Actions takes nothing returns nothing
if(Trig_qiaomu_Func001C())then
if(Trig_qiaomu_Func001Func002C())then
if(Trig_qiaomu_Func001Func002Func003C())then
set udg_MP_qiaomu1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npn5_0261)
if(Trig_qiaomu_Func001Func002Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF巧手认证\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00制造铸流雕像\n|r|cFFFFCC00鲁叔祖：|r|cFFCCFFCC我们巧木坊的铸流匠都是制造装备和木器制造文明的。要证明一个工匠的能力，让它制作东西是最好不过的了。巧木坊历年的考试都很简单，那就是制作我们给出来的图纸上的东西。你照这这张图纸做出成品后再来找我吧。|r")
call RemoveLocation(udg_SP)
if(Trig_qiaomu_Func001Func002Func003Func006C())then
call UnitAddItemByIdSwapped('rej2',GetTriggerUnit())
set udg_MP_qiaomu_zhu[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
else
call UnitAddItemByIdSwapped('vddl',GetTriggerUnit())
set udg_MP_qiaomu_niao[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
endif
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁叔祖：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁叔祖：|r|cFFCCFFCC你想买点什么吗？我们作坊无所不造。|r")
endif
endfunction

function Trig_qiaomu_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='nflg'))then
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