//=========================================================================== 
// Trigger: jianxuan9
//=========================================================================== 
function InitTrig_jianxuan9 takes nothing returns nothing
set gg_trg_jianxuan9=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianxuan9,356.00,gg_unit_nfor_0612)
call TriggerAddCondition(gg_trg_jianxuan9,Condition(function Trig_jianxuan9_Conditions))
call TriggerAddAction(gg_trg_jianxuan9,function Trig_jianxuan9_Actions)
endfunction

function Trig_jianxuan9_Actions takes nothing returns nothing
set udg_MP_jianxuan9[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfor_0612)
if(Trig_jianxuan9_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00尹月行：|r|cFFCCFFCC小兄弟你果真还是来了，但以你现在的修为连我的衣服都碰不到。但如果你能去把龙骨瀑布的|r|cFF00FF0010个龙骨守护者|r|cFFCCFFCC杀死，我可以跟你回去。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00去龙骨瀑布杀10个龙骨守护者|r")
if(Trig_jianxuan9_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianxuan9_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_longgu_mdd)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianxuan9_Conditions takes nothing returns boolean
if(not(udg_MP_jianxuan8[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianxuan9[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
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