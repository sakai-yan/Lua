//=========================================================================== 
// Trigger: hecheng C2
//=========================================================================== 
function InitTrig_hecheng_C2 takes nothing returns nothing
set gg_trg_hecheng_C2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hecheng_C2,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_hecheng_C2,Condition(function Trig_hecheng_C2_Conditions))
call TriggerAddAction(gg_trg_hecheng_C2,function Trig_hecheng_C2_Actions)
endfunction

function Trig_hecheng_C2_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_hecheng_C2_Func003C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'stwa'))
call UnitAddItemByIdSwapped('bzbe',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'dtsb'))
call UnitAddItemByIdSwapped('sor1',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-2))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mnsf'))
call UnitAddItemByIdSwapped('thle',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'schl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'schl'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'btst'))
call UnitAddItemByIdSwapped('skrt',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'lure'))
call UnitAddItemByIdSwapped('engs',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rres'))
call UnitAddItemByIdSwapped('kygh',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tgxp'))
call UnitAddItemByIdSwapped('mgtk',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-9))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sneg'))
call UnitAddItemByIdSwapped('kybl',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbsm'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-4))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-6))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rspd'))
call UnitAddItemByIdSwapped('frgd',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_C2_Func012C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'schl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'schl'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tbak'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'oflg'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rat3'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-7))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bfhr'))
call UnitAddItemByIdSwapped('bfhr',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
endfunction

function Trig_hecheng_C2_Conditions takes nothing returns boolean
if(not Trig_hecheng_C2_Func014C())then
return false
endif
return true
endfunction