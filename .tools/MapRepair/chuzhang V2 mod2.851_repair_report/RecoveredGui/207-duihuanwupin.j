//=========================================================================== 
// Trigger: duihuanwupin
//=========================================================================== 
function InitTrig_duihuanwupin takes nothing returns nothing
set gg_trg_duihuanwupin=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_duihuanwupin,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_duihuanwupin,Condition(function Trig_duihuanwupin_Conditions))
call TriggerAddAction(gg_trg_duihuanwupin,function Trig_duihuanwupin_Actions)
endfunction

function Trig_duihuanwupin_Actions takes nothing returns nothing
if(Trig_duihuanwupin_Func001C())then
if(Trig_duihuanwupin_Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rwat'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I00V'))
call UnitAddItemByIdSwapped('I00T',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func002C())then
if(Trig_duihuanwupin_Func002Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I00T'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01I'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I01L'))
call UnitAddItemByIdSwapped('I01J',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+350000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func003C())then
if(Trig_duihuanwupin_Func003Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'mgtk'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'))-30))
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
call UnitAddItemByIdSwapped('I03X',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func004C())then
if(Trig_duihuanwupin_Func004Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'kygh'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'))-30))
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
call UnitAddItemByIdSwapped('I041',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func005C())then
if(Trig_duihuanwupin_Func005Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'frgd'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'))-30))
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
call UnitAddItemByIdSwapped('I03Y',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func006C())then
if(Trig_duihuanwupin_Func006Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03I'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'))-30))
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
call UnitAddItemByIdSwapped('wnwq',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func007C())then
if(Trig_duihuanwupin_Func007Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'bfhr'))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'sor3'))-15))
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I03W'))-30))
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
call UnitAddItemByIdSwapped('I03Z',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func008C())then
if(Trig_duihuanwupin_Func008Func001C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'fgun'))-5))
call UnitAddItemByIdSwapped('I03O',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif
if(Trig_duihuanwupin_Func009C())then
if(Trig_duihuanwupin_Func009Func001C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'amrc'))-5))
call UnitAddItemByIdSwapped('I03Q',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50000)
call SetPlayerStateBJ(GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD,udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
else
endif

////////////////////////
if(Trig_duihuanwupin_Func010C())then
if(Trig_duihuanwupin_Func010Func001C())then
if(Trig_duihuanwupin_Func010Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzcn'))   //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-2)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='nzl0'       //��ѧ��
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func011C())then
if(Trig_duihuanwupin_Func011Func001C())then
if(Trig_duihuanwupin_Func011Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzdn'))     //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='pwp0'     // ���߾�
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func012C())then
if(Trig_duihuanwupin_Func012Func001C())then
if(Trig_duihuanwupin_Func012Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzsl'))   //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='bf61'      //��������
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func013C())then
if(Trig_duihuanwupin_Func013Func001C())then
if(Trig_duihuanwupin_Func013Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzyj'))    //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='slt1'      //���׼�
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func014C())then
if(Trig_duihuanwupin_Func014Func001C())then
if(Trig_duihuanwupin_Func014Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzyj'))  //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='bf60'      //������
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func015C())then
if(Trig_duihuanwupin_Func015Func001C())then
if(Trig_duihuanwupin_Func015Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pztx'))  //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='bf63'      //������
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func016C())then
if(Trig_duihuanwupin_Func016Func001C())then
if(Trig_duihuanwupin_Func016Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzfh'))  //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='bf67'      //������
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
if(Trig_duihuanwupin_Func017C())then
if(Trig_duihuanwupin_Func017Func001C())then
if(Trig_duihuanwupin_Func017Func001Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pzyd'))  //
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20)
//set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+7)]='bf67'      //�µ�
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
else
endif
//////////////////////////
if(Trig_duihuanwupin_Func018C())then
if(Trig_duihuanwupin_Func018Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A14Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func019C())then
if(Trig_duihuanwupin_Func019Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A24Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func020C())then
if(Trig_duihuanwupin_Func020Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A34Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func021C())then
if(Trig_duihuanwupin_Func021Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A44Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func022C())then
if(Trig_duihuanwupin_Func022Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A54Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func023C())then
if(Trig_duihuanwupin_Func023Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A64Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func024C())then
if(Trig_duihuanwupin_Func024Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A74Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func025C())then
if(Trig_duihuanwupin_Func025Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A84Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func026C())then
if(Trig_duihuanwupin_Func026Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A94Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif

if(Trig_duihuanwupin_Func027C())then
if(Trig_duihuanwupin_Func027Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A64Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func028C())then
if(Trig_duihuanwupin_Func028Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A74Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func029C())then
if(Trig_duihuanwupin_Func029Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A84Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
if(Trig_duihuanwupin_Func030C())then
if(Trig_duihuanwupin_Func030Func001C())then
set udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10)
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A94Z'      //book
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")    //�һ����ϲ���
endif
else
endif
////////////////////////////////////////////////
if(Trig_duihuanwupin_Func031C())then
if(Trig_duihuanwupin_Func031Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'rots'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'stpg'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc01'))
call UnitAddItemByIdSwapped('h001',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func032C())then
if(Trig_duihuanwupin_Func032Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'anfg'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I052'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc02'))
call UnitAddItemByIdSwapped('h002',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func033C())then
if(Trig_duihuanwupin_Func033Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I053'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I054'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc03'))
call UnitAddItemByIdSwapped('h003',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func034C())then
if(Trig_duihuanwupin_Func034Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdjj'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdgz'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdzj'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc04'))
call UnitAddItemByIdSwapped('h004',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func035C())then
if(Trig_duihuanwupin_Func035Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdpp'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdgz'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hdzj'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc05'))
call UnitAddItemByIdSwapped('h005',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func036C())then
if(Trig_duihuanwupin_Func036Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I018'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I028'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I029'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc06'))
call UnitAddItemByIdSwapped('h006',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func037C())then
if(Trig_duihuanwupin_Func037Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I027'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I028'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I029'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc07'))
call UnitAddItemByIdSwapped('h007',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func038C())then
if(Trig_duihuanwupin_Func038Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02A'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I02B'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc08'))
call UnitAddItemByIdSwapped('h008',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func039C())then
if(Trig_duihuanwupin_Func039Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I12B'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05N'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc09'))
call UnitAddItemByIdSwapped('h009',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func040C())then
if(Trig_duihuanwupin_Func040Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I12Q'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I05Q'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc10'))
call UnitAddItemByIdSwapped('h010',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func041C())then
if(Trig_duihuanwupin_Func041Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'Imna'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'prvt'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc11'))
call UnitAddItemByIdSwapped('h011',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func042C())then
if(Trig_duihuanwupin_Func042Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'pmna'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'Irvt'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc12'))
call UnitAddItemByIdSwapped('h012',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func043C())then
if(Trig_duihuanwupin_Func043Func001C())then
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hcun'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'I048'))
call RemoveItem(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'hc13'))
call UnitAddItemByIdSwapped('h013',GetTriggerUnit())
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif



if(Trig_duihuanwupin_Func050C())then
if(Trig_duihuanwupin_Func050Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ������
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(800,809)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func051C())then
if(Trig_duihuanwupin_Func051Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ̫��
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(810,819)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func052C())then
if(Trig_duihuanwupin_Func052Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ����
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(820,829)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func053C())then
if(Trig_duihuanwupin_Func053Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ����
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(830,839)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func054C())then
if(Trig_duihuanwupin_Func054Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  �µ�
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(840,849)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func055C())then
if(Trig_duihuanwupin_Func055Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ���ĸ�
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(850,857)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func056C())then
if(Trig_duihuanwupin_Func056Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ����
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(860,869)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func057C())then
if(Trig_duihuanwupin_Func057Func001C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A14Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A24Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A34Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A44Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A54Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A64Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A74Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A84Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitRemoveAbilityBJ('A94Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
                                              //  ����
call UnitAddAbilityBJ(udg_LOST_ITEM[GetRandomInt(860,869)],udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call SetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'),(GetItemCharges(GetItemOfTypeFromUnitBJ(GetTriggerUnit(),'ssjj'))-1))
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF0000兑换材料不足|r")
endif
else
endif
if(Trig_duihuanwupin_Func058C())then
set udg_ZZ_0[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1        // ȡ��
call UnitAddAbilityBJ('A04Z',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
endfunction

function Trig_duihuanwupin_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
return true
endfunction