//=========================================================================== 
// Trigger: guiyan1
//=========================================================================== 
function InitTrig_guiyan1 takes nothing returns nothing
set gg_trg_guiyan1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_guiyan1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_guiyan1,Condition(function Trig_guiyan1_Conditions))
call TriggerAddAction(gg_trg_guiyan1,function Trig_guiyan1_Actions)
endfunction

function Trig_guiyan1_Actions takes nothing returns nothing
if(Trig_guiyan1_Func001C())then
if(Trig_guiyan1_Func001Func002C())then
if(Trig_guiyan1_Func001Func002Func003C())then
set udg_MP_guiyan1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncgb_0629)
if(Trig_guiyan1_Func001Func002Func003Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF地灵之束\n|r|cFFFFCC00半蓑人：|r|cFFCCFFCC你跟随我漂泊多年，是时候让你独挡一面了。和你一直以来相伴的地灵鬼阎，是超脱五行六界的能量体，想要发挥它更强大的力量，必须要先锻炼自己的能力。去|r|cFF00FF00收拾20只草齿兽|r|cFFCCFFCC来热下身吧,去吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死20只草齿兽|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_npng_0321)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
if(Trig_guiyan1_Func001Func002Func003Func001C())then
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC别忘记了自己的使命,去吧！|r")
else
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC你的历练还不够，20级后再来找我吧·|r")
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00半蓑人：|r|cFFCCFFCC滚开，要知道我杀你如同捏死小虫一样简单！|r")
endif
endfunction

function Trig_guiyan1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rsps'))then
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