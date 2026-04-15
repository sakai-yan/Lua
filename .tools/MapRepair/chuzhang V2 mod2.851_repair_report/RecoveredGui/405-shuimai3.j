//=========================================================================== 
// Trigger: shuimai3
//=========================================================================== 
function InitTrig_shuimai3 takes nothing returns nothing
set gg_trg_shuimai3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shuimai3,256,gg_unit_nsha_0367)
call TriggerAddCondition(gg_trg_shuimai3,Condition(function Trig_shuimai3_Conditions))
call TriggerAddAction(gg_trg_shuimai3,function Trig_shuimai3_Actions)
endfunction

function Trig_shuimai3_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'tfar')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_shuimai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
if(Trig_shuimai3_Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00水无名：|r|cFFCCFFCC拿到这瓶水不容易吧？服下这瓶水吧。现在你的冷气脉已经被打通了。要练习水系的法术，就要找法抗较强的妖兽。到魂山附近有许多咕噜龙，你去|r|cFF00FF00干掉10只咕噜龙|r|cFFCCFFCC吧，一路小心。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死10只咕噜龙|r")
set udg_SP=GetRectCenter(gg_rct______________090)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shuimai3_Conditions takes nothing returns boolean
if(not(udg_MP_shuimai1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shuimai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'tfar')==true))then
return false
endif
return true
endfunction