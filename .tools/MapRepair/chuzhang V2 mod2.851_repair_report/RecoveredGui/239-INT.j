//=========================================================================== 
// Trigger: INT
//=========================================================================== 
function InitTrig_INT takes nothing returns nothing
set gg_trg_INT=CreateTrigger()
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(0),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(1),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(2),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(3),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(4),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(6),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(5),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(7),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(8),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(9),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(10),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_INT,Player(11),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_RIGHT)
call TriggerAddCondition(gg_trg_INT,Condition(function Trig_INT_Conditions))
call TriggerAddAction(gg_trg_INT,function Trig_INT_Actions)
endfunction

function Trig_INT_Actions takes nothing returns nothing
if(Trig_INT_Func014C())then
call ModifyHeroStat(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,10)
set udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]-1)
set udg_P_INT[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_P_INT[GetConvertedPlayerId(GetTriggerPlayer())]+1)
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("你目前内力为"+I2S(GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],true))))
if(Trig_INT_Func014Func006C())then
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call PanCameraToTimedLocForPlayer(GetTriggerPlayer(),udg_SP,0)
call RemoveLocation(udg_SP)
else
call DoNothing()
endif
else
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,"你没有足够的点数用于分配")
endif
endfunction

function Trig_INT_Conditions takes nothing returns boolean
if(not(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]!=null))then
return false
endif
return true
endfunction