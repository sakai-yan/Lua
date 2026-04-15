//=========================================================================== 
// Trigger: hero chose3
//=========================================================================== 
function InitTrig_hero_chose3 takes nothing returns nothing
set gg_trg_hero_chose3=CreateTrigger()
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[1])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[2])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[3])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[4])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[5])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[6])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[7])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[8])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[9])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[10])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[11])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose3,udg_MDX_SET[12])
call TriggerAddAction(gg_trg_hero_chose3,function Trig_hero_chose3_Actions)
endfunction

function Trig_hero_chose3_Actions takes nothing returns nothing
set udg_PLAY_NUM=(udg_PLAY_NUM+1)
set udg_V_00[GetConvertedPlayerId(GetTriggerPlayer())]=11
set udg_SP=GetRectCenter(gg_rct______________032)
if(Trig_hero_chose3_Func004C())then
call CreateNUnitsAtLoc(1,'Otch',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002C())then
call CreateNUnitsAtLoc(1,'Ewar',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001C())then
call CreateNUnitsAtLoc(1,'Udre',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001C())then
call CreateNUnitsAtLoc(1,'Udea',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001Func001C())then
call CreateNUnitsAtLoc(1,'Hmkg',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
if(Trig_hero_chose3_Func004Func002Func001Func001Func002C())then
call CreateNUnitsAtLoc(1,'Hamg',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func001C())then
call CreateNUnitsAtLoc(1,'Hblm',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002C())then
call CreateNUnitsAtLoc(1,'Hpal',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001C())then
call CreateNUnitsAtLoc(1,'Obla',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001Func001C())then
call CreateNUnitsAtLoc(1,'Ucrl',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001Func002C())then
call CreateNUnitsAtLoc(1,'Doud',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001Func001Func001C())then
call CreateNUnitsAtLoc(1,'Tufu',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001Func001Func002C())then
call CreateNUnitsAtLoc(1,'Emoo',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
if(Trig_hero_chose3_Func004Func002Func001Func001Func002Func002Func001Func001Func001Func001C())then
call CreateNUnitsAtLoc(1,'Ljh1',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
else
endif
endif
endif
endif
endif
endif
endif
endif
endif
set udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedUnit()
if(Trig_hero_chose3_Func006C())then
call UnitAddAbilityBJ('A00W',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('Absk',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AOmi',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='A00W'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='Absk'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='AOmi'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001C())then
call UnitAddAbilityBJ('AOw2',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('Atau',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A00E',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='AOw2'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='Atau'   //  ���ټӹ�
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='A00E'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001Func001C())then
call UnitAddAbilityBJ('mt02',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AHhb',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('Acri',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddItemByIdSwapped('h003',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddItemByIdSwapped('czd1',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='mt02'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='AHhb'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='Acri'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001Func001Func001C())then
call UnitAddAbilityBJ('A04J',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A01D',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('Aimp',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='A04J'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='A01D'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='Aimp'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001Func001Func001Func001C())then
call UnitAddAbilityBJ('AIm1',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A002',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AUfn',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='AIm1'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='A002'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='AUfn'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001Func001Func001Func001Func002C())then
call UnitAddItemByIdSwapped('I002',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AEer',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('mt21',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AOsf',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='AEer'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='mt21'   //
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='AOsf'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
if(Trig_hero_chose3_Func006Func001Func001Func001Func001Func002Func002C())then
call UnitAddAbilityBJ('A013',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A014',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A015',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='A013'    //
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='A014'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='A015'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'

//                   save   hc    hl            c   c    c     s      s    s
//                   A02F  A03H  A072         A000 A029  A020 A04Y  A05E  A05D      A0gz  A1gz  A2gz

else
if(Trig_hero_chose3_Func006Func001Func001Func001Func001Func002Func002Func001C())then
call UnitAddAbilityBJ('A000',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('AHtc',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('Acht',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call UnitAddAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+1)]='A000'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+2)]='Acht'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+3)]='AHtc'
set udg_skill[(((GetConvertedPlayerId(GetTriggerPlayer())-1)*7)+4)]='A027'
else
endif
endif
endif
endif
endif
endif
endif
endif
call RemoveLocation(udg_SP)
set udg_Save[GetConvertedPlayerId(GetTriggerPlayer())]=true
endfunction