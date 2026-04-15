//=========================================================================== 
// Trigger: SET 3
//=========================================================================== 
function InitTrig_SET_3 takes nothing returns nothing
set gg_trg_SET_3=CreateTrigger()
call TriggerAddAction(gg_trg_SET_3,function Trig_SET_3_Actions)
endfunction

function Trig_SET_3_Actions takes nothing returns nothing
call DoNotSaveReplay()
call CinematicModeBJ(true,GetPlayersAll())
call TransmissionFromUnitWithNameBJ(GetPlayersAll(),null,"系统提示",null,"初始化数据，请等待几秒......",bj_TIMETYPE_ADD,4.00,true)
call CinematicModeBJ(false,GetPlayersAll())
endfunction