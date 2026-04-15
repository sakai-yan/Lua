//=========================================================================== 
// Trigger: DB lv1
//=========================================================================== 
function InitTrig_DB_lv1 takes nothing returns nothing
set gg_trg_DB_lv1=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_DB_lv1,EVENT_PLAYER_UNIT_DEATH)
call TriggerRegisterAnyUnitEventBJ(gg_trg_DB_lv1,EVENT_PLAYER_UNIT_CHANGE_OWNER)
call TriggerAddCondition(gg_trg_DB_lv1,Condition(function Trig_DB_lv1_Conditions))
call TriggerAddAction(gg_trg_DB_lv1,function Trig_DB_lv1_Actions)
endfunction

function Trig_DB_lv1_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_DB_lv1_Func006C())then
if(Trig_DB_lv1_Func006Func001001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func007C())then
if(Trig_DB_lv1_Func007Func001001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func007Func002001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func008C())then
if(Trig_DB_lv1_Func008Func001001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func008Func002001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func009C())then
if(Trig_DB_lv1_Func009Func001001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func009Func002001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func009Func003001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func010C())then
if(Trig_DB_lv1_Func010Func001001())then
call CreateItemLoc('oflg',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func010Func002001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func011C())then
if(Trig_DB_lv1_Func011Func001001())then
call CreateItemLoc('rej5',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func012C())then
if(Trig_DB_lv1_Func012Func001001())then
call CreateItemLoc('oflg',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func012Func002001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func013C())then
if(Trig_DB_lv1_Func013Func002001())then
call CreateItemLoc('schl',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func013Func003001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func014C())then
if(Trig_DB_lv1_Func014Func001001())then
call CreateItemLoc('oflg',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func014Func002001())then
call CreateItemLoc('schl',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func014Func003001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func015C())then
if(Trig_DB_lv1_Func015Func001001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func015Func002001())then
call CreateItemLoc('schl',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func015Func003001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func016C())then
if(Trig_DB_lv1_Func016Func001001())then
call CreateItemLoc('sor2',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func016Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func016Func003001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func017C())then
if(Trig_DB_lv1_Func017Func001001())then
call CreateItemLoc('schl',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func017Func002001())then
call CreateItemLoc('oflg',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func018C())then
if(Trig_DB_lv1_Func018Func001001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func018Func002001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func018Func003001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func019C())then
if(Trig_DB_lv1_Func019Func001001())then
call CreateItemLoc('tmmt',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func020C())then
if(Trig_DB_lv1_Func020Func001001())then
call CreateItemLoc('tmmt',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func021C())then
if(Trig_DB_lv1_Func021Func001001())then
call CreateItemLoc('fwss',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func021Func002001())then
call CreateItemLoc('tmmt',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func022C())then
if(Trig_DB_lv1_Func022Func001001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func022Func002001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func023C())then
if(Trig_DB_lv1_Func023Func001001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func023Func002001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func024C())then
if(Trig_DB_lv1_Func024Func001001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func024Func002001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func024Func003001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func025C())then
if(Trig_DB_lv1_Func025Func001001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func025Func002001())then
call CreateItemLoc('sor2',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func025Func003001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func026C())then
if(Trig_DB_lv1_Func026Func001001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func027C())then
if(Trig_DB_lv1_Func027Func001001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func027Func002001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func028C())then
if(Trig_DB_lv1_Func028Func001001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func028Func002001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func029C())then
if(Trig_DB_lv1_Func029Func001001())then
call CreateItemLoc('tels',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func029Func002001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func029Func003001())then
call CreateItemLoc('tbsm',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func030C())then
if(Trig_DB_lv1_Func030Func001001())then
call CreateItemLoc('sor4',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func030Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func031C())then
if(Trig_DB_lv1_Func031Func001001())then
call CreateItemLoc('sor2',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func031Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func032C())then
if(Trig_DB_lv1_Func032Func001001())then
call CreateItemLoc('hbth',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func032Func002001())then
call CreateItemLoc('tbsm',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func032Func003001())then
call CreateItemLoc('tbak',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func033C())then
if(Trig_DB_lv1_Func033Func001001())then
call CreateItemLoc('brag',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func033Func002001())then
call CreateItemLoc('rat3',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func033Func003001())then
call CreateItemLoc('tbak',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func034C())then
if(Trig_DB_lv1_Func034Func001001())then
call CreateItemLoc('tbak',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func035C())then
if(Trig_DB_lv1_Func035Func001001())then
call CreateItemLoc('tmmt',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func036C())then
if(Trig_DB_lv1_Func036Func001001())then
call CreateItemLoc('tbsm',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func037C())then
if(Trig_DB_lv1_Func037Func001001())then
call CreateItemLoc('sor2',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func037Func002001())then
call CreateItemLoc('hbth',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func038C())then
if(Trig_DB_lv1_Func038Func001001())then
call CreateItemLoc('shrs',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func038Func002001())then
call CreateItemLoc('ram1',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func039C())then
if(Trig_DB_lv1_Func039Func001001())then
call CreateItemLoc('shrs',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func039Func002001())then
call CreateItemLoc('fgun',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func040C())then
if(Trig_DB_lv1_Func040Func001001())then
call CreateItemLoc('shrs',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func040Func002001())then
call CreateItemLoc('axas',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func041C())then
if(Trig_DB_lv1_Func041Func001001())then
call CreateItemLoc('shrs',udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func041Func002001())then
call CreateItemLoc('shea',udg_SP)
else
call DoNothing()
endif
else
endif
//f2
if(Trig_DB_lv1_Func042C())then
if(Trig_DB_lv1_Func042Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,6)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func042Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(11,19)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func043C())then
if(Trig_DB_lv1_Func043Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,6)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func043Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(11,19)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func044C())then
if(Trig_DB_lv1_Func044Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,6)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func044Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(11,19)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func045C())then
if(Trig_DB_lv1_Func045Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,6)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func045Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(11,19)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func046C())then
if(Trig_DB_lv1_Func046Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(1,6)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func046Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(11,19)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func047C())then
if(Trig_DB_lv1_Func047Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func047Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func048C())then
if(Trig_DB_lv1_Func048Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func048Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func049C())then
if(Trig_DB_lv1_Func049Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func049Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func050C())then
if(Trig_DB_lv1_Func050Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func050Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func051C())then
if(Trig_DB_lv1_Func051Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func051Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func052C())then
if(Trig_DB_lv1_Func052Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func052Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func053C())then
if(Trig_DB_lv1_Func053Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func053Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(41,47)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func054C())then
if(Trig_DB_lv1_Func054Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func054Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func055C())then
if(Trig_DB_lv1_Func055Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func055Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func056C())then
if(Trig_DB_lv1_Func056Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func056Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func057C())then
if(Trig_DB_lv1_Func057Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func057Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func058C())then
if(Trig_DB_lv1_Func058Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func058Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func059C())then
if(Trig_DB_lv1_Func059Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func059Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(51,59)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func060C())then
if(Trig_DB_lv1_Func060Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func060Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(51,59)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func061C())then
if(Trig_DB_lv1_Func061Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func061Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(51,59)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func062C())then
if(Trig_DB_lv1_Func062Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func062Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(51,59)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func063C())then
if(Trig_DB_lv1_Func063Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func063Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(71,78)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func064C())then
if(Trig_DB_lv1_Func064Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func064Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(71,78)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func065C())then
if(Trig_DB_lv1_Func065Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func065Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(71,78)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func066C())then
if(Trig_DB_lv1_Func066Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func066Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(71,78)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func067C())then
if(Trig_DB_lv1_Func067Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(21,34)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(61,70)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func067Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(71,78)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func068C())then
if(Trig_DB_lv1_Func068Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(91,95)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func068Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(81,88)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(101,118)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func069C())then
if(Trig_DB_lv1_Func069Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(91,95)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func069Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(81,88)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(101,118)],udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_DB_lv1_Func070C())then
if(Trig_DB_lv1_Func070Func001001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(91,95)],udg_SP)
else
call DoNothing()
endif
if(Trig_DB_lv1_Func070Func002001())then
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(81,88)],udg_SP)
call CreateItemLoc(udg_LOST_ITEM[GetRandomInt(101,118)],udg_SP)
else
call DoNothing()
endif
else
endif
//f2
call RemoveLocation(udg_SP)
call StoreInteger(udg_Cache,I2S(H2I(GetLastCreatedItem())),"掉落物品",600)
endfunction

function Trig_DB_lv1_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not Trig_DB_lv1_Func002C())then
return false
endif
return true
endfunction