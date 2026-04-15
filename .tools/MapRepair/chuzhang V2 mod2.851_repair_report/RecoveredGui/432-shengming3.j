//=========================================================================== 
// Trigger: shengming3
//=========================================================================== 
function InitTrig_shengming3 takes nothing returns nothing
set gg_trg_shengming3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shengming3,356.00,gg_unit_nfh1_0124)
call TriggerAddCondition(gg_trg_shengming3,Condition(function Trig_shengming3_Conditions))
call TriggerAddAction(gg_trg_shengming3,function Trig_shengming3_Actions)
endfunction

function Trig_shengming3_Actions takes nothing returns nothing
set udg_MP_shengming2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_shengming3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC亥什草的获得是不是很容易，接下来要采集的材料才是真正难采的。|r|cFF00FF00血丝草|r|cFFCCFFCC是一种喜阴植物，生在在野兽蛮横的|r|cFF00FF00塔木森林深处，|r|cFFCCFFCC你再去|r|cFF00FF00收集20棵血丝草|r|cFFCCFFCC回来吧，路上小心，实在不行就放弃吧\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到塔木森林收集20棵血丝草|r")
set udg_SP=GetRectCenter(gg_rct_xuesi4)
if(Trig_shengming3_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shengming3_Func008001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shengming3_Conditions takes nothing returns boolean
if(not(udg_MP_shengming1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shengming2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_shengming_NUM1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
return true
endfunction