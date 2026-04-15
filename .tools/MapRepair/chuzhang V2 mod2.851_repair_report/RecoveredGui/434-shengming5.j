//=========================================================================== 
// Trigger: shengming5
//=========================================================================== 
function InitTrig_shengming5 takes nothing returns nothing
set gg_trg_shengming5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_shengming5,356.00,gg_unit_nfh1_0124)
call TriggerAddCondition(gg_trg_shengming5,Condition(function Trig_shengming5_Conditions))
call TriggerAddAction(gg_trg_shengming5,function Trig_shengming5_Actions)
endfunction

function Trig_shengming5_Actions takes nothing returns nothing
if(Trig_shengming5_Func001C())then
set udg_SP=GetUnitLoc(gg_unit_nfh1_0124)
if(Trig_shengming5_Func001Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC不亏是我清心阁弟子，有着舍身成仁的信念。但想成为芙医还需要最后一步，就是服下我这|r|cFF00FF00溃血蛊|r|cFFCCFFCC，然后把这药罐送到|r|cFF00FF00留驻御剑门|r|cFFCCFFCC的|r|cFF00FF00彤子丹|r|cFFCCFFCC那里。记住别把罐子打破了。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00把罐子送到御剑门\n|r")
call UnitAddItemByIdSwapped('oslo',GetTriggerUnit())
set udg_SP=GetUnitLoc(gg_unit_Nalm_0345)
if(Trig_shengming5_Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shengming5_Func001Func011001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
set udg_MP_shengming_hero[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]
else
if(Trig_shengming5_Func001Func001C())then
call UnitAddItemByIdSwapped('oslo',GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC失败了么？那就再重新来一次吧！|R")
set udg_SP=GetUnitLoc(gg_unit_Nalm_0345)
if(Trig_shengming5_Func001Func001Func011001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shengming5_Func001Func001Func012001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00白鹿先生：|r|cFFCCFFCC尽快吧药罐送到御剑门的彤子丹那吧！在你还清醒前。|R")
set udg_SP=GetUnitLoc(gg_unit_Nalm_0345)
if(Trig_shengming5_Func001Func001Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_shengming5_Func001Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
endif
endif
endfunction

function Trig_shengming5_Conditions takes nothing returns boolean
if(not(udg_MP_shengming2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_MP_shengming_NUM2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
if(not(udg_MP_shengming4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(UnitHasItemOfTypeBJ(GetTriggerUnit(),'oslo')==false))then
return false
endif
return true
endfunction