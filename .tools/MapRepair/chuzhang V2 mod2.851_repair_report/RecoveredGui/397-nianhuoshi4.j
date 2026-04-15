//=========================================================================== 
// Trigger: nianhuoshi4
//=========================================================================== 
function InitTrig_nianhuoshi4 takes nothing returns nothing
set gg_trg_nianhuoshi4=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_nianhuoshi4,356.00,gg_unit_nsce_0324)
call TriggerAddCondition(gg_trg_nianhuoshi4,Condition(function Trig_nianhuoshi4_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi4,function Trig_nianhuoshi4_Actions)
endfunction

function Trig_nianhuoshi4_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sand')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_nianhuoshi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nsce_0324)
if(Trig_nianhuoshi4_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡絮：|r|cFFCCFFCC五行相生相克，生火靠木，要打通人身上的火行经脉，需要有木的辅助。|r|cFF00FF00塔木森林|r|cFFCCFFCC拥有强大的树灵，杀死|r|cFF00FF00暴怒鹿妖|r|cFFCCFFCC就可获得。你去收集|r|cFF00FF0010份树灵|r|cFFCCFFCC回来给我，我会助你打通经脉。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00到塔木森林杀暴怒鹿妖收集10分树灵|r")
set udg_SP=GetRectCenter(gg_rct_xiongcan)
if(Trig_nianhuoshi4_Func009001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_nianhuoshi4_Func010001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_nianhuoshi4_Conditions takes nothing returns boolean
if(not(udg_MP_nianhuoshi2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_nianhuoshi3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sand')==true))then
return false
endif
return true
endfunction