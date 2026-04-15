//=========================================================================== 
// Trigger: hecheng S1
//=========================================================================== 
function InitTrig_hecheng_S1 takes nothing returns nothing
set gg_trg_hecheng_S1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_hecheng_S1,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_hecheng_S1,Condition(function Trig_hecheng_S1_Conditions))
call TriggerAddAction(gg_trg_hecheng_S1,function Trig_hecheng_S1_Actions)
endfunction

function Trig_hecheng_S1_Actions takes nothing returns nothing
call PlaySoundOnUnitBJ(gg_snd_MetalLightSliceFlesh3,100,GetTriggerUnit())
call PlaySoundOnUnitBJ(gg_snd_MetalLightChopMetal2,100,GetTriggerUnit())
if(Trig_hecheng_S1_Func003C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmsc'))
call UnitAddItemByIdSwapped('nspi',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func004C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'gobm'))
call UnitAddItemByIdSwapped('sksh',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func005C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'uflg'))
call UnitAddItemByIdSwapped('lnrn',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func006C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'gldo'))
call UnitAddItemByIdSwapped('stre',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func007C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'cosl'))
call UnitAddItemByIdSwapped('oli2',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func008C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor2'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tmmt'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej4'))
call UnitAddItemByIdSwapped('crys',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func009C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'axas'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hbth'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fwss'))-6))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rde0'))
call UnitAddItemByIdSwapped('ssil',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func010C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-12))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I021'))
call UnitAddItemByIdSwapped('I01U',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func011C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-12))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I023'))
call UnitAddItemByIdSwapped('I01V',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func012C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'thdm'))-8))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'brag'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I024'))
call UnitAddItemByIdSwapped('I01W',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func013C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej5'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej5'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I025'))
call UnitAddItemByIdSwapped('I01X',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func014C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'asbl'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'tels'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I026'))
call UnitAddItemByIdSwapped('I01Y',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func015C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'))-20))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01U'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03L'))
call UnitAddItemByIdSwapped('I03G',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func016C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'))-20))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01V'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03M'))
call UnitAddItemByIdSwapped('I03J',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func017C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'))-20))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01W'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03S'))
call UnitAddItemByIdSwapped('I03I',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func018C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03P'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03P'))-20))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01Y'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03N'))
call UnitAddItemByIdSwapped('I03H',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func019C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03P'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03P'))-20))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01X'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03R'))
call UnitAddItemByIdSwapped('I03K',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
//+++
if(Trig_hecheng_S1_Func020C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I00T'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kgmx'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I049'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I13N'))
call UnitAddItemByIdSwapped('bnzd',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif

if(Trig_hecheng_S1_Func021C())then          //hlzx
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hcun'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I047'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ciri'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01T'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'olig'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I210'))
call UnitAddItemByIdSwapped('hlzx',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func022C())then          //��ͥ
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04C'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I200'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I201'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I207'))
call UnitAddItemByIdSwapped('I05F',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func023C())then          //�ظ�
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rej6'))-10))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04C'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I200'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I201'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I206'))
call UnitAddItemByIdSwapped('I05E',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func024C())then          //����
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I200'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I202'))
call UnitAddItemByIdSwapped('I049',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func025C())then         //ѩ��
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I022'))-25))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-7))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-10))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I205'))
call UnitAddItemByIdSwapped('I211',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func026C())then         //�Ǽ�
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01Z'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I204'))
call UnitAddItemByIdSwapped('I04K',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func027C())then        //����
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I020'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03T'))-30))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I203'))
call UnitAddItemByIdSwapped('I04J',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func028C())then         //hdjj
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04K'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04C'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I201'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I209'))
call UnitAddItemByIdSwapped('hdjj',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func029C())then        //hdpp
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04J'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I04C'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I200'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I208'))
call UnitAddItemByIdSwapped('hdpp',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func030C())then          //���黤��
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01E'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03O'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03Q'))-5))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02K'))-3))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hlzx'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I212'))
call UnitAddItemByIdSwapped('hlhj',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif

if(Trig_hecheng_S1_Func047C())then          //  wltj
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hval'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rwiz'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'evtl'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bspd'))
call UnitAddItemByIdSwapped('wltj',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func048C())then          // b
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I047'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02P'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02Q'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01T'))
call UnitAddItemByIdSwapped(udg_LOST_ITEM[GetRandomInt(251,255)],GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func049C())then          // c
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sprn'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'shtm'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'arsh'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'shhn'))
call UnitAddItemByIdSwapped(udg_LOST_ITEM[GetRandomInt(256,259)],GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func050C())then          // c
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I027'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I028'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I029'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02D'))
call UnitAddItemByIdSwapped('I05Q',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func051C())then          // a
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h007'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h008'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h009'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h010'))
call UnitAddItemByIdSwapped('hll1',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00神怒垂饰制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif
if(Trig_hecheng_S1_Func052C())then          // a
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h010'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h011'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h012'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'h013'))
call UnitAddItemByIdSwapped('slsl',GetTriggerUnit())
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,10.00,"|Cff00ff00神怒指环制作成功|R")
call TriggerExecute(gg_trg_shanchu)
else
endif


endfunction

function Trig_hecheng_S1_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A04Y'))then
return false
endif
return true
endfunction