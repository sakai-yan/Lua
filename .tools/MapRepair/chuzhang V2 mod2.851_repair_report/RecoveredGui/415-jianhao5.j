//=========================================================================== 
// Trigger: jianhao5
//=========================================================================== 
function InitTrig_jianhao5 takes nothing returns nothing
set gg_trg_jianhao5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_jianhao5,356.00,gg_unit_ngnh_0123)
call TriggerAddCondition(gg_trg_jianhao5,Condition(function Trig_jianhao5_Conditions))
call TriggerAddAction(gg_trg_jianhao5,function Trig_jianhao5_Actions)
endfunction

function Trig_jianhao5_Actions takes nothing returns nothing
set udg_MP_jianhao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
call RemoveItem(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'sehr'))
call SetPlayerAbilityAvailableBJ(true,'AOmi',GetOwningPlayer(GetTriggerUnit()))
call UnitAddItemByIdSwapped('cnob',GetTriggerUnit())
set udg_SP=GetUnitLoc(gg_unit_ngnh_0123)
if(Trig_jianhao5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00扬清：|r|cFFCCFFCC干得不错，剑豪要的就是最大限度地利用手中的剑，哪怕它只是一把很普通的剑。拿着这个|r|cFF00FF00令牌|r|cFFCCFFCC去找我们的掌门|r|cFF00FF00蔡景阳|r|cFFCCFFCC吧，通过他的考验是成为剑豪所必须的。|r")
if(Trig_jianhao5_Func008001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_jianhao5_Func009001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nlv2_0262)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_jianhao5_Conditions takes nothing returns boolean
if(not(udg_MP_jianhao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_jianhao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_jianhao_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=16))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'sehr')==true))then
return false
endif
return true
endfunction