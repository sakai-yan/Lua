//=========================================================================== 
// Trigger: STR
//=========================================================================== 
function InitTrig_STR takes nothing returns nothing
set gg_trg_STR=CreateTrigger()
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(0),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(1),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(2),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(3),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(4),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(5),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(6),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(7),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(8),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(9),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(10),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_STR,Player(11),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_UP)
call TriggerAddCondition(gg_trg_STR,Condition(function Trig_STR_Conditions))
call TriggerAddAction(gg_trg_STR,function Trig_STR_Actions)
endfunction

function Trig_STR_Actions takes nothing returns nothing
if(Trig_STR_Func002C())then
call ModifyHeroStat(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,10)
set udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]-1)
set udg_P_STR[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_P_STR[GetConvertedPlayerId(GetTriggerPlayer())]+1)
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("你目前筋骨为"+I2S(GetHeroStatBJ(bj_HEROSTAT_STR,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],true))))
else
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,"你没有足够的点数用于分配")
endif
if(Trig_STR_Func003C())then
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call PanCameraToTimedLocForPlayer(GetTriggerPlayer(),udg_SP,0)
call RemoveLocation(udg_SP)
else
call DoNothing()
endif
endfunction

function Trig_STR_Conditions takes nothing returns boolean
if(not(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]!=null))then
return false
endif
return true
endfunction