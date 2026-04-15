//=========================================================================== 
// Trigger: tianyuan43
//=========================================================================== 
function InitTrig_tianyuan43 takes nothing returns nothing
set gg_trg_tianyuan43=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_tianyuan43,356.00,gg_unit_npn5_0261)
call TriggerAddCondition(gg_trg_tianyuan43,Condition(function Trig_tianyuan43_Conditions))
call TriggerAddAction(gg_trg_tianyuan43,function Trig_tianyuan43_Actions)
endfunction

function Trig_tianyuan43_Actions takes nothing returns nothing
set udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=4
set udg_SP=GetUnitLoc(GetTriggerUnit())
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00鲁叔祖：|r|cFFCCFFCC灭魔圣器的铸造已经超脱了常理，就算是巧木坊当年也是在高人的协助之下才能完成。如今高人离去，我坊恐有心无力啊。此高人名叫|r|cFF00FF00天策乾坤|r|cFFCCFFCC，传闻现在居住在|r|cFF00FF00东海群岛|r|cFFCCFFCC，你不妨去那里找找看，相信也之有他能够回答你的疑问了。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00寻找天策乾坤|r")
if(Trig_tianyuan43_Func004001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_tianyuan43_Func005001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_nftk_0733)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_tianyuan43_Conditions takes nothing returns boolean
if(not(udg_ZZ_TY[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==3))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not Trig_tianyuan43_Func013C())then
return false
endif
return true
endfunction