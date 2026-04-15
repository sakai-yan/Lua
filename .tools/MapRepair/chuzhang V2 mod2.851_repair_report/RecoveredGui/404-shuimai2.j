//=========================================================================== 
// Trigger: shuimai2
//=========================================================================== 
function InitTrig_shuimai2 takes nothing returns nothing
set gg_trg_shuimai2=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_shuimai2,gg_rct______________089)
call TriggerAddCondition(gg_trg_shuimai2,Condition(function Trig_shuimai2_Conditions))
call TriggerAddAction(gg_trg_shuimai2,function Trig_shuimai2_Actions)
endfunction

function Trig_shuimai2_Actions takes nothing returns nothing
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sor9')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('tfar',GetTriggerUnit())
if(Trig_shuimai2_Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFFF99提示：已经装满了天泉水，回去找水无名吧！|r")
set udg_SP=GetUnitLoc(gg_unit_nsha_0367)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shuimai2_Conditions takes nothing returns boolean
if(not(udg_MP_shuimai1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shuimai2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sor9')==true))then
return false
endif
return true
endfunction