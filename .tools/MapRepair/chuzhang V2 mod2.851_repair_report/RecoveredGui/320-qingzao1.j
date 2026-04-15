//=========================================================================== 
// Trigger: qingzao1
//=========================================================================== 
function InitTrig_qingzao1 takes nothing returns nothing
set gg_trg_qingzao1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_qingzao1,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_qingzao1,Condition(function Trig_qingzao1_Conditions))
call TriggerAddAction(gg_trg_qingzao1,function Trig_qingzao1_Actions)
endfunction

function Trig_qingzao1_Actions takes nothing returns nothing
if(Trig_qingzao1_Func001C())then
if(Trig_qingzao1_Func001Func003C())then
set udg_R_CJ_qingzao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nqb1_0093)
if(Trig_qingzao1_Func001Func003Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestNew,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF甜美的青枣\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00收集20颗青枣\n|r|cFFFFCC00阿苟：|r|cFFCCFFCC这个季节的|r|cFF00FF00青枣|r|cFFCCFFCC应该都成熟了，但我害怕田里的那些凶恶的野猪...我出钱买你的青枣吧，你去摘点回来？|r|cFF00FF0020颗|r|cFFCCFFCC，恩，20颗就好:)|r")
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_shenggancao5)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
endif
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000条件不符|r")
endif
endfunction

function Trig_qingzao1_Conditions takes nothing returns boolean
if(not(GetItemTypeId(GetManipulatedItem())=='shas'))then
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