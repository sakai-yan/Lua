//=========================================================================== 
// Trigger: shiwusucai1
//=========================================================================== 
function InitTrig_shiwusucai1 takes nothing returns nothing
set gg_trg_shiwusucai1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_shiwusucai1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_shiwusucai1,Condition(function Trig_shiwusucai1_Conditions))
call TriggerAddAction(gg_trg_shiwusucai1,function Trig_shiwusucai1_Actions)
endfunction

function Trig_shiwusucai1_Actions takes nothing returns nothing
if(Trig_shiwusucai1_Func001C())then
if(Trig_shiwusucai1_Func001Func003C())then
set udg_shiwusucai1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ndtt_0383)
if(Trig_shiwusucai1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF食物素材\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00到龙泉湖附件收集20份牛肉\n|r|cFFFFCC00陆小丰：|r|cFFCCFFCC本店是全镇最热闹的客栈，人来人往的，那是一个多啊！！但开销也大了，那牛肉没两天都保卖光了！！小兄弟你想赚点小钱吗？帮我去|r|cFF00FF00收集20分牛肉|r|cFFCCFFCC回来吧，我会付钱的。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_hctw_0452)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_shiwusucai1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='silk'))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction