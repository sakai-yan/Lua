//=========================================================================== 
// Trigger: jianxuan other
//=========================================================================== 
function InitTrig_jianxuan_other takes nothing returns nothing
set gg_trg_jianxuan_other=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan_other,556.00,gg_unit_nftr_0616)
call TriggerAddCondition(gg_trg_jianxuan_other,Condition(function Trig_jianxuan_other_Conditions))
call TriggerAddAction(gg_trg_jianxuan_other,function Trig_jianxuan_other_Actions)
endfunction

function Trig_jianxuan_other_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(gg_unit_nftr_0616)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00老头：|r|cFFCCFFCC咦？过去我看到都是一个白头发的人来帮村民消灭妖魔的，这次怎么是你啊？小兄弟。\n|r")
if(Trig_jianxuan_other_Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan_other_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
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