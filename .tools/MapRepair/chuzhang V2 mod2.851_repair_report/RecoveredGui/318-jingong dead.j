//=========================================================================== 
// Trigger: jingong dead
//=========================================================================== 
function InitTrig_jingong_dead takes nothing returns nothing
set gg_trg_jingong_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_jingong_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_jingong_dead,function Trig_jingong_dead_Actions)
endfunction

function Trig_jingong_dead_Actions takes nothing returns nothing
if(Trig_jingong_dead_Func001C())then
set udg_R_FS_hanwei_num2=10
call DisplayTextToForce(GetPlayersAll(),"|cFFFFFF99成功瓦解了山猪的进攻了，找张凡谈谈吧|r")
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
call PingMinimapLocForForce(GetPlayersAll(),udg_SP,10.00)
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
call RemoveLocation(udg_SP)
else
endif
if(Trig_jingong_dead_Func002C())then
call ForForce(GetPlayersAll(),function Trig_jingong_dead_Func002Func001A)
else
endif
endfunction