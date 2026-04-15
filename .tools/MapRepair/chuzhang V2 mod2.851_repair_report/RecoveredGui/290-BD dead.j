//=========================================================================== 
// Trigger: BD dead
//=========================================================================== 
function InitTrig_BD_dead takes nothing returns nothing
set gg_trg_BD_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_BD_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerRegisterAnyUnitEventBJ(gg_trg_BD_dead,EVENT_PLAYER_UNIT_CHANGE_OWNER)
call TriggerAddCondition(gg_trg_BD_dead,Condition(function Trig_BD_dead_Conditions))
call TriggerAddAction(gg_trg_BD_dead,function Trig_BD_dead_Actions)
endfunction

function Trig_BD_dead_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(GetTriggerUnit())
if(Trig_BD_dead_Func004C())then
if(Trig_BD_dead_Func004Func001001())then
call CreateItemLoc('I00I',udg_SP)
else
call DoNothing()
endif
if(Trig_BD_dead_Func004Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_BD_dead_Func005C())then
if(Trig_BD_dead_Func005Func001001())then
call CreateItemLoc('ram3',udg_SP)
else
call DoNothing()
endif
if(Trig_BD_dead_Func005Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
call DoNothing()
endif
else
endif
if(Trig_BD_dead_Func006C())then
if(Trig_BD_dead_Func006Func001C())then             //����
call CreateItemLoc('sorf',udg_SP)
else
if(Trig_BD_dead_Func006Func001Func001C())then
call CreateItemLoc('kysn',udg_SP)
else
if(Trig_BD_dead_Func006Func001Func001Func001C())then
call CreateItemLoc('phlt',udg_SP)
else
if(Trig_BD_dead_Func006Func001Func001Func001Func001C())then
call CreateItemLoc('k3m2',udg_SP)
else
if(Trig_BD_dead_Func006Func001Func001Func001Func001Func001C())then
call CreateItemLoc('wtlg',udg_SP)
else
endif
endif
endif
endif
endif
if(Trig_BD_dead_Func006Func002001())then
call CreateItemLoc('sor3',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func007C())then         //����
call CreateItemLoc('czd2',udg_SP)
if(Trig_BD_dead_Func007Func001C())then
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func008C())then         //����
if(Trig_BD_dead_Func008Func001C())then
call CreateItemLoc('rots',udg_SP)
else
endif
if(Trig_BD_dead_Func008Func002C())then
call CreateItemLoc('sor2',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func009C())then    //ս��
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
if(Trig_BD_dead_Func009Func001C())then
call CreateItemLoc('czc1',udg_SP)
call CreateItemLoc('czc1',udg_SP)
else
endif
if(Trig_BD_dead_Func009Func002C())then
call CreateItemLoc('czd3',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func010C())then     // �̻�
call CreateItemLoc('guvi',udg_SP)
call CreateItemLoc('sor3',udg_SP)
if(Trig_BD_dead_Func010Func001C())then
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('czc1',udg_SP)
else
endif
if(Trig_BD_dead_Func010Func002C())then
call CreateItemLoc('czd1',udg_SP)
call CreateItemLoc('czd1',udg_SP)
call CreateItemLoc('guvi',udg_SP)
call CreateItemLoc('guvi',udg_SP)
call CreateItemLoc('sor3',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func011C())then         //б��
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('sor3',udg_SP)
call CreateItemLoc('czc6',udg_SP)
call CreateItemLoc('shea',udg_SP)
call CreateItemLoc('czc2',udg_SP)
if(Trig_BD_dead_Func011Func001C())then
call CreateItemLoc('czd5',udg_SP)
call CreateItemLoc('czc4',udg_SP)
else
endif
if(Trig_BD_dead_Func011Func002C())then
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('sor3',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc6',udg_SP)
call CreateItemLoc('shea',udg_SP)
call CreateItemLoc('czc2',udg_SP)
else
endif
if(Trig_BD_dead_Func011Func003C())then
call CreateItemLoc('sor3',udg_SP)
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('clc1',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc6',udg_SP)
call CreateItemLoc('shea',udg_SP)
call CreateItemLoc('czc2',udg_SP)
else
endif
else
endif
if(Trig_BD_dead_Func012C())then       //czcs
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('I050',udg_SP)
call CreateItemLoc('rugt',udg_SP)
if(Trig_BD_dead_Func012Func001C())then
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc5',udg_SP)
else
endif
if(Trig_BD_dead_Func012Func002C())then
call CreateItemLoc('clc4',udg_SP)
call CreateItemLoc('clc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc4',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('czc5',udg_SP)
call CreateItemLoc('I050',udg_SP)
call CreateItemLoc('rugt',udg_SP)
else
endif
else
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_BD_dead_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not Trig_BD_dead_Func002C())then
return false
endif
return true
endfunction