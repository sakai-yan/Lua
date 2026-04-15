//=========================================================================== 
// Trigger: hanweicunzhuang1
//=========================================================================== 
function InitTrig_hanweicunzhuang1 takes nothing returns nothing
set gg_trg_hanweicunzhuang1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hanweicunzhuang1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_hanweicunzhuang1,Condition(function Trig_hanweicunzhuang1_Conditions))
call TriggerAddAction(gg_trg_hanweicunzhuang1,function Trig_hanweicunzhuang1_Actions)
endfunction

function Trig_hanweicunzhuang1_Actions takes nothing returns nothing
if(Trig_hanweicunzhuang1_Func001C())then
if(Trig_hanweicunzhuang1_Func001Func002C())then
set udg_R_FS_hanwei=true
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
if(Trig_hanweicunzhuang1_Func001Func002Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFFFF0000捍卫村庄（主线）\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00防守山猪人的10波进攻\n|r|cFFFF6600失|r|cFFFF8C26败|r|cFFFFB24C条|r|cFFFFCC99件：|r|cFF00FF00村长死亡\n\n|r|cFFFFCC99张凡：|r|cFFCCFFCC北方一个山头出现了一群山猪人 ，一直企图占领我们的村子来做为他们的大本营。经过长期的准备，看来他们马上要发动进攻了，大侠务必救救我们村子！！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct______________016)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
call EnableTrigger(gg_trg_jingong1)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_hanweicunzhuang1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='tsct'))then
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