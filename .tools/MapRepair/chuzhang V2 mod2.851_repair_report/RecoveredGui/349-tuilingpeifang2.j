//=========================================================================== 
// Trigger: tuilingpeifang2
//=========================================================================== 
function InitTrig_tuilingpeifang2 takes nothing returns nothing
set gg_trg_tuilingpeifang2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tuilingpeifang2,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_tuilingpeifang2,Condition(function Trig_tuilingpeifang2_Conditions))
call TriggerAddAction(gg_trg_tuilingpeifang2,function Trig_tuilingpeifang2_Actions)
endfunction

function Trig_tuilingpeifang2_Actions takes nothing returns nothing
if(Trig_tuilingpeifang2_Func001C())then
if(Trig_tuilingpeifang2_Func001Func001C())then
if(Trig_tuilingpeifang2_Func001Func001Func001C())then
set udg_R_CJ_tuiling_a1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC藤|r|cFFCCFFDD木|r|cFFCCFFEE之|r|cFFCCFFFF绿|r"+(" |cFFFFFF00"+("1"+"|R|cFF00FF00/1|r"))))
if(Trig_tuilingpeifang2_Func001Func001Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tuilingpeifang2_Func001Func001Func001Func005C())then
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_tuilingpeifang2_Func001Func001Func001Func005Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99你已经集齐了退灵的配方，快回去找陆容大夫吧！|r")
else
endif
else
call DoNothing()
endif
else
endif
call PolledWait(25.00)
set udg_SP=GetRectCenter(gg_rct_tuiling_p1)
call CreateItemLoc('wcyc',udg_SP)
call RemoveLocation(udg_SP)
else
endif
if(Trig_tuilingpeifang2_Func002C())then
if(Trig_tuilingpeifang2_Func002Func001C())then
if(Trig_tuilingpeifang2_Func002Func001Func001C())then
set udg_R_CJ_tuiling_a2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC萍|r|cFFCCFFDD水|r|cFFCCFFEE之|r|cFFCCFFFF蓝|r"+(" |cFFFFFF00"+("1"+"|R|cFF00FF00/1|r"))))
if(Trig_tuilingpeifang2_Func002Func001Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tuilingpeifang2_Func002Func001Func001Func005C())then
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_tuilingpeifang2_Func002Func001Func001Func005Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99你已经集齐了退灵的配方，快回去找陆容大夫吧！|r")
else
endif
else
call DoNothing()
endif
else
endif
call PolledWait(25.00)
set udg_SP=GetRectCenter(gg_rct_tuiling_p2)
call CreateItemLoc('fgfh',udg_SP)
call RemoveLocation(udg_SP)
else
endif
if(Trig_tuilingpeifang2_Func003C())then
if(Trig_tuilingpeifang2_Func003Func001C())then
if(Trig_tuilingpeifang2_Func003Func001Func001C())then
set udg_R_CJ_tuiling_a3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCCFFCC沉|r|cFFCCFFDD石|r|cFFCCFFEE之|r|cFFCCFFFF灰|r"+(" |cFFFFFF00"+("1"+"|R|cFF00FF00/1|r"))))
if(Trig_tuilingpeifang2_Func003Func001Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_GoodJob,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tuilingpeifang2_Func003Func001Func001Func005C())then
set udg_SP=GetUnitLoc(gg_unit_ngza_0168)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,4.00)
if(Trig_tuilingpeifang2_Func003Func001Func001Func005Func003001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99你已经集齐了退灵的配方，快回去找陆容大夫吧！|r")
else
endif
else
call DoNothing()
endif
else
endif
call PolledWait(25.00)
set udg_SP=GetRectCenter(gg_rct_tuiling_p3)
call CreateItemLoc('wlsd',udg_SP)
call RemoveLocation(udg_SP)
else
endif
endfunction

function Trig_tuilingpeifang2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction