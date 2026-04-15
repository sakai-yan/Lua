//=========================================================================== 
// Trigger: AGI
//=========================================================================== 
function InitTrig_AGI takes nothing returns nothing
set gg_trg_AGI=CreateTrigger()
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(0),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(1),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(3),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(2),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(4),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(6),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(5),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(7),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(8),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(9),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(10),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_AGI,Player(11),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_LEFT)
call TriggerAddCondition(gg_trg_AGI,Condition(function Trig_AGI_Conditions))
call TriggerAddAction(gg_trg_AGI,function Trig_AGI_Actions)
endfunction

function Trig_AGI_Actions takes nothing returns nothing
if(Trig_AGI_Func014C())then
call ModifyHeroStat(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],bj_MODIFYMETHOD_ADD,10)
set udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]-1)
set udg_P_AGI[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_P_AGI[GetConvertedPlayerId(GetTriggerPlayer())]+1)
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("你目前的身法为"+I2S(GetHeroStatBJ(bj_HEROSTAT_AGI,udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],true))))
if(Trig_AGI_Func014Func006C())then
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

function Trig_AGI_Conditions takes nothing returns boolean
if(not(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]!=null))then
return false
endif
return true
endfunction