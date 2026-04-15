//=========================================================================== 
// Trigger: lianhua shuoming2
//=========================================================================== 
function InitTrig_lianhua_shuoming2 takes nothing returns nothing
set gg_trg_lianhua_shuoming2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_lianhua_shuoming2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_lianhua_shuoming2,Condition(function Trig_lianhua_shuoming2_Conditions))
call TriggerAddAction(gg_trg_lianhua_shuoming2,function Trig_lianhua_shuoming2_Actions)
endfunction

function Trig_lianhua_shuoming2_Actions takes nothing returns nothing
if(Trig_lianhua_shuoming2_Func002C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00印戒锁甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming2_Func003C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00归一战甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming2_Func004C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00回天战甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*1，碎晶石*2|r")
else
endif
if(Trig_lianhua_shuoming2_Func005C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00浣火铠甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming2_Func006C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00逢天软胄|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming2_Func007C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00圣贤麻衣|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*1，纯玉*2，碎晶石*4|r")
else
endif
if(Trig_lianhua_shuoming2_Func008C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00金鳞铠甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming2_Func009C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFFFFCC00道境法袍|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，碎晶石*6|r")
else
endif
if(Trig_lianhua_shuoming2_Func010C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFF00FFFF凤羽布褂|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，红玉*3|r")
else
endif
if(Trig_lianhua_shuoming2_Func011C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFF00FFFF别炎化衣|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，纯玉*3，红玉*3|r")
else
endif
if(Trig_lianhua_shuoming2_Func012C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFF00FFFF王陵链甲|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，晶魂*2，玄金*2|r")
else
endif
if(Trig_lianhua_shuoming2_Func013C())then
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|cFFCCFFFF强化|r|cFF00FFFF王陵羽纱|r|cFFCCFFFF所需材料：|r|cFF00FF00千年炼珠*2，晶魂*2，玄金*2|r")
else
endif
endfunction

function Trig_lianhua_shuoming2_Conditions takes nothing returns boolean
if(not Trig_lianhua_shuoming2_Func001C())then
return false
endif
return true
endfunction