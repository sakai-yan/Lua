//=========================================================================== 
// Trigger: tianyuan6
//=========================================================================== 
function InitTrig_tianyuan6 takes nothing returns nothing
set gg_trg_tianyuan6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan6,356.00,gg_unit_nftk_0733)
call TriggerAddCondition(gg_trg_tianyuan6,Condition(function Trig_tianyuan6_Conditions))
call TriggerAddAction(gg_trg_tianyuan6,function Trig_tianyuan6_Actions)
endfunction

function Trig_tianyuan6_Actions takes nothing returns nothing
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01H'))
call UnitAddItemByIdSwapped('I01I',GetTriggerUnit())
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=6
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00天策乾坤：|r|cFFCCFFCC没料到你居然这么快就制出了|r|cFF00FF00圣器|r|cFFCCFFCC，真是了不起啊！接下来，需要去收集四象和四方之力。我们先从四象开始吧。四象乃|r|cFF00FF00青龙，白虎，朱雀，玄武|r|cFFCCFFCC四灵之力，需要从相应的神兽体内获得。你去把这四种素材找齐后，便来找我吧。\n我这里有一宝物，或许对你以后有所帮助。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00收集青龙内核，白虎内核，朱雀内核和玄武内核后来找天策乾坤|r")
if(Trig_tianyuan6_Func006001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan6_Func007001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan6_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==5))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'I01H')==true))then
return false
endif
return true
endfunction