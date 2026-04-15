//=========================================================================== 
// Trigger: herotili
//=========================================================================== 
function InitTrig_herotili takes nothing returns nothing
set gg_trg_herotili=CreateTrigger()
call TriggerAddAction(gg_trg_herotili,function Trig_herotili_Actions)
endfunction

function Trig_herotili_Actions takes nothing returns nothing
set udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]=1
loop
exitwhen udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]>(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])-1)
if(Trig_herotili_Func001Func001C())then
call UnitAddItemByIdSwapped('manh',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_herotili_Func001Func001Func002C())then
call UnitAddItemByIdSwapped('gomn',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_herotili_Func001Func001Func002Func002C())then
call UnitAddItemByIdSwapped('tst2',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
endif
endif
endif
set udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]=udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
set udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]=1
loop
exitwhen udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]>udg_TIli_point[GetConvertedPlayerId(GetTriggerPlayer())]
if(Trig_herotili_Func002Func001C())then
call UnitAddItemByIdSwapped('manh',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_herotili_Func002Func001Func002C())then
call UnitAddItemByIdSwapped('gomn',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
if(Trig_herotili_Func002Func001Func002Func002C())then
call UnitAddItemByIdSwapped('tst2',udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
else
endif
endif
endif
set udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]=udg_lv_num[GetConvertedPlayerId(GetTriggerPlayer())]+1
endloop
endfunction