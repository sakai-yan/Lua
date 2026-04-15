//=========================================================================== 
// Trigger: beidaogongju1
//=========================================================================== 
function InitTrig_beidaogongju1 takes nothing returns nothing
set gg_trg_beidaogongju1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_beidaogongju1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_beidaogongju1,Condition(function Trig_beidaogongju1_Conditions))
call TriggerAddAction(gg_trg_beidaogongju1,function Trig_beidaogongju1_Actions)
endfunction

function Trig_beidaogongju1_Actions takes nothing returns nothing
if(Trig_beidaogongju1_Func001C())then
if(Trig_beidaogongju1_Func001Func003C())then
set udg_R_CJ_gongju1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_npnw_0364)
if(Trig_beidaogongju1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF被盗的工具\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00拿回一箱工具\n|r|cFFFFCC00鲁右佻：|r|cFFCCFFCC昨天晚上我被什么声音惊醒时，看到了几黑影串逃而出。后来发现是新铸的新|r|cFF00FF00工具|r|cFFCCFFCC不见了！那些山贼真是无所不贪啊。大侠如果能帮我找回来，我便送你一份好东西。那些山贼就在这|r|cFF00FF00北边的高山|r|cFFCCFFCC上。|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________088)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_beidaogongju1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='rej1'))then
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