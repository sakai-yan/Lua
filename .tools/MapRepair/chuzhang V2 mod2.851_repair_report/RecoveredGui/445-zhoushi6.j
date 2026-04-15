//=========================================================================== 
// Trigger: zhoushi6
//=========================================================================== 
function InitTrig_zhoushi6 takes nothing returns nothing
set gg_trg_zhoushi6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_zhoushi6,256,gg_unit_nshw_0366)
call TriggerAddCondition(gg_trg_zhoushi6,Condition(function Trig_zhoushi6_Conditions))
call TriggerAddAction(gg_trg_zhoushi6,function Trig_zhoushi6_Actions)
endfunction

function Trig_zhoushi6_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sor6')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_zhoushi5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nshw_0366)
if(Trig_zhoushi6_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00苑樱师：|r|cFFCCFFCC这毒素就是你必须每天面对的东西，你以后需要经常用到它。为了不反被自己的毒素所伤，你必须具有良好的抗体。到塔木森林里找到一种叫|r|cFF00FF00涉毒鹿妖|r|cFFCCFFCC的妖物，取下|r|cFF00FF001颗涉毒之心|r|cFFCCFFCC，拿回来给我吧\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00前往塔木森林消灭一只涉毒鹿妖|r")
set udg_SP=GetRectCenter(gg_rct_xuesi5)
if(Trig_zhoushi6_Func009001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_zhoushi6_Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_zhoushi6_Conditions takes nothing returns boolean
if(not(udg_MP_zhoushi4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_zhoushi5[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sor6')==true))then
return false
endif
return true
endfunction