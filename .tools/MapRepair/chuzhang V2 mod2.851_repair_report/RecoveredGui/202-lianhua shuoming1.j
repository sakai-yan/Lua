//=========================================================================== 
// Trigger: lianhua shuoming1
//=========================================================================== 
function InitTrig_lianhua_shuoming1 takes nothing returns nothing
set gg_trg_lianhua_shuoming1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_shuoming1,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_shuoming1,Condition(function Trig_lianhua_shuoming1_Conditions))
call TriggerAddAction(gg_trg_lianhua_shuoming1,function Trig_lianhua_shuoming1_Actions)
endfunction

function Trig_lianhua_shuoming1_Actions takes nothing returns nothing
if(Trig_lianhua_shuoming1_Func002C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00碎梦刀|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func003C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00天怜剑|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func004C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00钩镰|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func005C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00穿云枪|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func006C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00天羽木条|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func007C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00鬼鸣剑|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming1_Func008C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00龙骨刀|r|cFFCCFFFF所需材料：|r|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming1_Func009C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00蟒鳞拳套|r|cFFCCFFFF所需材料：|r|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming1_Func010C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00神荒法杖|r|cFFCCFFFF所需材料：|r|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming1_Func011C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00八荒长戟|r|cFFCCFFFF所需材料：|r|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming1_Func012C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00紫涛剑|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming1_Func013C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00虚空杖|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming1_Func014C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00袭风戟|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming1_Func015C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00命逝钩|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming1_Func016C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00月牙刀|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming1_Func017C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00B1武器|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，玄金*2|r")
else
endif
if(Trig_lianhua_shuoming1_Func018C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00B2武器|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*4，纯玉*5，玄金*3，龙胆石*5，晶魂*3|r")
else
endif
endfunction

function Trig_lianhua_shuoming1_Conditions takes nothing returns boolean
if(not Trig_lianhua_shuoming1_Func001C())then
return false
endif
return true
endfunction