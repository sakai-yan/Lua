//=========================================================================== 
// Trigger: js 2
//=========================================================================== 
function InitTrig_js_2 takes nothing returns nothing
set gg_trg_js_2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_js_2,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_js_2,Condition(function Trig_js_2_Conditions))
call TriggerAddAction(gg_trg_js_2,function Trig_js_2_Actions)
endfunction

function Trig_js_2_Actions takes nothing returns nothing
if(Trig_js_2_Func001C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80)
else
endif
if(Trig_js_2_Func002C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-70)
else
endif
if(Trig_js_2_Func003C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
if(Trig_js_2_Func004C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
if(Trig_js_2_Func005C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
if(Trig_js_2_Func006C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
if(Trig_js_2_Func007C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
else
endif
if(Trig_js_2_Func008C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
else
endif
if(Trig_js_2_Func009C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-70)
else
endif
if(Trig_js_2_Func010C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-90)
else
endif
//+++
if(Trig_js_2_Func011C())then       //hdjj
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60)
else
endif
if(Trig_js_2_Func012C())then      //hdpp
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120)
else
endif
if(Trig_js_2_Func013C())then      //hdpp
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150)
else
endif
if(Trig_js_2_Func014C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100)
else
endif
if(Trig_js_2_Func015C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
if(Trig_js_2_Func016C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120)
else
endif
if(Trig_js_2_Func017C())then
set udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YF_js[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50)
else
endif
//+++
endfunction

function Trig_js_2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction