//=========================================================================== 
// Trigger: niudangzhiyou1
//=========================================================================== 
function InitTrig_niudangzhiyou1 takes nothing returns nothing
set gg_trg_niudangzhiyou1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_niudangzhiyou1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_niudangzhiyou1,Condition(function Trig_niudangzhiyou1_Conditions))
call TriggerAddAction(gg_trg_niudangzhiyou1,function Trig_niudangzhiyou1_Actions)
endfunction

function Trig_niudangzhiyou1_Actions takes nothing returns nothing
if(Trig_niudangzhiyou1_Func001C())then
if(Trig_niudangzhiyou1_Func001Func003C())then
set udg_niudangzhiyou1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_narg_0714)
if(Trig_niudangzhiyou1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF牛党之忧\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00杀死20只牛妖\n\n|r|cFFFFCC00邓功名：|r|cFFCCFFCC牛党虽然作为妖怪，但长期并没有和人类做过多的接触，也算良性种族。但最近完全变样了，牛妖霸占了我们的山头河道，还杀死了我们派去交涉的村民！大侠务必帮我们做主啊！\n|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________137)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_niudangzhiyou1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='tdx2'))then
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