//=========================================================================== 
// Trigger: CON
//=========================================================================== 
function InitTrig_CON takes nothing returns nothing
set gg_trg_CON=CreateTrigger()
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(0),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(1),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(2),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(3),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(4),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(5),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(6),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(7),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(8),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(9),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(10),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerRegisterPlayerKeyEventBJ(gg_trg_CON,Player(11),bj_KEYEVENTTYPE_DEPRESS,bj_KEYEVENTKEY_DOWN)
call TriggerAddCondition(gg_trg_CON,Condition(function Trig_CON_Conditions))
call TriggerAddAction(gg_trg_CON,function Trig_CON_Actions)
endfunction

function Trig_CON_Actions takes nothing returns nothing
if(Trig_CON_Func001C())then
set udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_hero_point[GetConvertedPlayerId(GetTriggerPlayer())]-1)
set udg_TIli_point[GetConvertedPlayerId(GetTriggerPlayer())]=(udg_TIli_point[GetConvertedPlayerId(GetTriggerPlayer())]+1)
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("你目前的体魄"+I2S(udg_TIli_point[GetConvertedPlayerId(GetTriggerPlayer())])))
if(Trig_CON_Func001Func005C())then
call UnitAddItemByIdSwapped('manh',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_CON_Func001Func005Func002C())then
call UnitAddItemByIdSwapped('gomn',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_CON_Func001Func005Func002Func002C())then
call UnitAddItemByIdSwapped('tst2',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
endif
endif
endif
else
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,"你没有足够的点数用于分配")
endif
endfunction

function Trig_CON_Conditions takes nothing returns boolean
if(not(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())]!=null))then
return false
endif
return true
endfunction