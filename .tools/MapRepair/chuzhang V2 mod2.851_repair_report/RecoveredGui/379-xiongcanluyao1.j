//=========================================================================== 
// Trigger: xiongcanluyao1
//=========================================================================== 
function InitTrig_xiongcanluyao1 takes nothing returns nothing
set gg_trg_xiongcanluyao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_xiongcanluyao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_xiongcanluyao1,Condition(function Trig_xiongcanluyao1_Conditions))
call TriggerAddAction(gg_trg_xiongcanluyao1,function Trig_xiongcanluyao1_Actions)
endfunction

function Trig_xiongcanluyao1_Actions takes nothing returns nothing
if(Trig_xiongcanluyao1_Func001C())then
if(Trig_xiongcanluyao1_Func001Func003C())then
set udg_R_xiongcan1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncg1_0205)
if(Trig_xiongcanluyao1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF凶残的鹿妖\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死残凶鹿妖    \n    \n|r|cFFFFCC00猎人阿飞：|r|cFFCCFFCC森林里有一头严重妖化的鹿，我们已经有好几个猎人死在它的手里了，大侠的身手应该能够战胜它，一切拜托了！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xiongcan)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_xiongcanluyao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='sres'))then
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