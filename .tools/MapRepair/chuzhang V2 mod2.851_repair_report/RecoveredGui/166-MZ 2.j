//=========================================================================== 
// Trigger: MZ 2
//=========================================================================== 
function InitTrig_MZ_2 takes nothing returns nothing
set gg_trg_MZ_2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_MZ_2,EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddCondition(gg_trg_MZ_2,Condition(function Trig_MZ_2_Conditions))
call TriggerAddAction(gg_trg_MZ_2,function Trig_MZ_2_Actions)
endfunction

function Trig_MZ_2_Actions takes nothing returns nothing
if(Trig_MZ_2_Func003C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-5.00)
else
endif
if(Trig_MZ_2_Func004C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-5.00)
else
endif
if(Trig_MZ_2_Func005C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10.00)
else
endif
if(Trig_MZ_2_Func006C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-12.00)
else
endif
if(Trig_MZ_2_Func007C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-8.00)
else
endif
if(Trig_MZ_2_Func008C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10.00)
else
endif
if(Trig_MZ_2_Func009C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-10.00)
else
endif
if(Trig_MZ_2_Func010C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-15.00)
else
endif
if(Trig_MZ_2_Func011C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-25.00)
else
endif
if(Trig_MZ_2_Func012C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20.00)
else
endif
if(Trig_MZ_2_Func013C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
else
endif
if(Trig_MZ_2_Func014C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,7)
else
endif
if(Trig_MZ_2_Func015C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-20.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
else
endif
if(Trig_MZ_2_Func016C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-25.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
else
endif
if(Trig_MZ_2_Func017C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-30.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,8)
else
endif
if(Trig_MZ_2_Func018C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,5)
else
endif
if(Trig_MZ_2_Func019C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZ_2_Func020C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
else
endif
if(Trig_MZ_2_Func021C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-45.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZ_2_Func022C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-45.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZ_2_Func023C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
else
endif
if(Trig_MZ_2_Func024C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-85.00)
else
endif
if(Trig_MZ_2_Func025C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,8)
else
endif
if(Trig_MZ_2_Func026C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
else
endif
if(Trig_MZ_2_Func027C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-60.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-40.00)
else
endif
if(Trig_MZ_2_Func028C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
else
endif
if(Trig_MZ_2_Func029C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,45)
else
endif
if(Trig_MZ_2_Func030C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-90.00)
else
endif
if(Trig_MZ_2_Func031C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,20)
else
endif
if(Trig_MZ_2_Func032C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
else
endif
if(Trig_MZ_2_Func033C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
else
endif
if(Trig_MZ_2_Func034C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
else
endif
if(Trig_MZ_2_Func035C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
else
endif
if(Trig_MZ_2_Func036C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
else
endif
if(Trig_MZ_2_Func037C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
else
endif
if(Trig_MZ_2_Func038C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
else
endif
if(Trig_MZ_2_Func039C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
else
endif
if(Trig_MZ_2_Func040C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
else
endif
if(Trig_MZ_2_Func041C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
else
endif
if(Trig_MZ_2_Func042C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
else
endif
if(Trig_MZ_2_Func043C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
else
endif
if(Trig_MZ_2_Func044C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
else
endif
if(Trig_MZ_2_Func045C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-160.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
else
endif

//+++
if(Trig_MZ_2_Func046C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,30)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZ_2_Func047C())then                         //hdgz
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
else
endif
if(Trig_MZ_2_Func048C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,130)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,130)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,130)
else
endif
if(Trig_MZ_2_Func049C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-180.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
else
endif
if(Trig_MZ_2_Func050C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-160.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,80)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,50)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
else
endif

if(Trig_MZ_2_Func051C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,10)
else
endif
if(Trig_MZ_2_Func052C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,15)
else
endif
if(Trig_MZ_2_Func053C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,25)
else
endif
if(Trig_MZ_2_Func054C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,300)
else
endif
if(Trig_MZ_2_Func055C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-400.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-400.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-450.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,350)
else
endif
if(Trig_MZ_2_Func056C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,70)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,130)
else
endif
if(Trig_MZ_2_Func057C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-200.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,150)
else
endif
if(Trig_MZ_2_Func058C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,45)
else
endif
if(Trig_MZ_2_Func059C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-120.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,35)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,60)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,45)
else
endif
if(Trig_MZ_2_Func060C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-130.00)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,120)
else
endif
if(Trig_MZ_2_Func061C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
set udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
set udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
set udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-50.00)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,40)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,55)
else
endif
if(Trig_MZ_2_Func062C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-100.00)
set udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
set udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-80.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,70)
else
endif
if(Trig_MZ_2_Func063C())then
set udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]-150.00)
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,60)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,60)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,60)
else
endif
if(Trig_MZ_2_Func064C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,500)
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,1000)
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],bj_MODIFYMETHOD_SUB,500)
else
endif


//+++
endfunction

function Trig_MZ_2_Conditions takes nothing returns boolean
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction