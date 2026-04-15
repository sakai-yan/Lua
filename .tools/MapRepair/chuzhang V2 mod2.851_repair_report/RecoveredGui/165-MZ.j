//=========================================================================== 
// Trigger: MZ
//=========================================================================== 
function InitTrig_MZ takes nothing returns nothing
set gg_trg_MZ=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_MZ,EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddCondition(gg_trg_MZ,Condition(function Trig_MZ_Conditions))
call TriggerAddAction(gg_trg_MZ,function Trig_MZ_Actions)
endfunction

function Trig_MZ_Actions takes nothing returns nothing
if(Trig_MZ_Func003C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+5.00)
else
endif
if(Trig_MZ_Func004C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+5.00)
else
endif
if(Trig_MZ_Func005C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+10.00)
else
endif
if(Trig_MZ_Func006C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+12.00)
else
endif
if(Trig_MZ_Func007C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+8.00)
else
endif
if(Trig_MZ_Func008C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+10.00)
else
endif
if(Trig_MZ_Func009C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+10.00)
else
endif
if(Trig_MZ_Func010C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+15.00)
else
endif
if(Trig_MZ_Func011C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+25.00)
else
endif
if(Trig_MZ_Func012C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
else
endif
if(Trig_MZ_Func013C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
else
endif
if(Trig_MZ_Func014C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,7)
else
endif
if(Trig_MZ_Func015C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+20.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
else
endif
if(Trig_MZ_Func016C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+25.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
else
endif
if(Trig_MZ_Func017C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+30.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,8)
else
endif
if(Trig_MZ_Func018C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,5)
else
endif
if(Trig_MZ_Func019C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
else
endif
if(Trig_MZ_Func020C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,40)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,40)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,40)
else
endif
if(Trig_MZ_Func021C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+45.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
else
endif
if(Trig_MZ_Func022C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+45.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
else
endif
if(Trig_MZ_Func023C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
else
endif
if(Trig_MZ_Func024C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+85.00)
else
endif
if(Trig_MZ_Func025C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,8)
else
endif
if(Trig_MZ_Func026C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+60.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,15)
else
endif
if(Trig_MZ_Func027C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+60.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+40.00)
else
endif
if(Trig_MZ_Func028C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,35)
else
endif
if(Trig_MZ_Func029C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,45)
else
endif
if(Trig_MZ_Func030C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+90.00)
else
endif
if(Trig_MZ_Func031C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,20)
else
endif
if(Trig_MZ_Func032C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
else
endif
if(Trig_MZ_Func033C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
else
endif
if(Trig_MZ_Func034C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
else
endif
if(Trig_MZ_Func035C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,25)
else
endif
if(Trig_MZ_Func036C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,25)
else
endif
if(Trig_MZ_Func037C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
else
endif
if(Trig_MZ_Func038C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
else
endif
if(Trig_MZ_Func039C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
else
endif
if(Trig_MZ_Func040C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,40)
else
endif
if(Trig_MZ_Func041C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
else
endif
if(Trig_MZ_Func042C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
else
endif
if(Trig_MZ_Func043C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
else
endif
if(Trig_MZ_Func044C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
else
endif
if(Trig_MZ_Func045C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+160.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,15)
else
endif
//+++
if(Trig_MZ_Func046C())then      //hdzj
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
else
endif
if(Trig_MZ_Func047C())then    //hdgz
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
else
endif
if(Trig_MZ_Func048C())then    //hlzx
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,130)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,130)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,130)
else
endif
if(Trig_MZ_Func049C())then       //I211
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+180.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
else
endif
if(Trig_MZ_Func050C())then       //wltj
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+160.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,80)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
else
endif

if(Trig_MZ_Func051C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,10)
else
endif
if(Trig_MZ_Func052C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,15)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,15)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,15)
else
endif
if(Trig_MZ_Func053C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,25)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,25)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,25)
else
endif
if(Trig_MZ_Func054C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,300)
else
endif
if(Trig_MZ_Func055C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+400.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+400.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+450.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,350)
else
endif
if(Trig_MZ_Func056C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,70)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,130)
else
endif
if(Trig_MZ_Func057C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,150)
else
endif
if(Trig_MZ_Func058C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,35)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,35)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,45)
else
endif
if(Trig_MZ_Func059C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+120.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,35)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,60)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,45)
else
endif
if(Trig_MZ_Func060C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+130.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,120)
else
endif
if(Trig_MZ_Func061C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+50.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,40)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,55)
else
endif
if(Trig_MZ_Func062C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+100.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+80.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,70)
else
endif
if(Trig_MZ_Func063C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,60)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,60)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,60)
else
endif
if(Trig_MZ_Func064C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,500)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,1000)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_ADD,500)
else
endif


endfunction

function Trig_MZ_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction