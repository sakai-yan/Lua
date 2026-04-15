//=========================================================================== 
// Trigger: shengming6
//=========================================================================== 
function InitTrig_shengming6 takes nothing returns nothing
set gg_trg_shengming6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shengming6,356.00,gg_unit_Nalm_0345)
call TriggerAddCondition(gg_trg_shengming6,Condition(function Trig_shengming6_Conditions))
call TriggerAddAction(gg_trg_shengming6,function Trig_shengming6_Actions)
endfunction

function Trig_shengming6_Actions takes nothing returns nothing
set udg_MP_shengming_hero[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=null
set udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'oslo')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddItemByIdSwapped('dust',GetTriggerUnit())
set udg_SP=GetUnitLoc(gg_unit_Nalm_0345)
if(Trig_shengming6_Func007001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00彤子商：|r|cFFCCFFCC先生一直都是用这种方法来考验我们。你把这|r|cFF00FF00信|r|cFFCCFFCC拿回去吧，先生看了就知道你已经通过考验了。\n|r|cFF00FFFF提示：|r|cFFFFFF00把信拿给白鹿先生|r")
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_shengming6_Func011001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shengming6_Func012001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_shengming6_Conditions takes nothing returns boolean
if(not(udg_MP_shengming3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'oslo')==true))then
return false
endif
return true
endfunction