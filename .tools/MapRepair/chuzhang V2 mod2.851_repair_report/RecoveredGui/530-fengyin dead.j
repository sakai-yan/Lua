//=========================================================================== 
// Trigger: fengyin dead
//=========================================================================== 
function InitTrig_fengyin_dead takes nothing returns nothing
set gg_trg_fengyin_dead=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_fengyin_dead,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_fengyin_dead,function Trig_fengyin_dead_Actions)
endfunction

function Trig_fengyin_dead_Actions takes nothing returns nothing
if(Trig_fengyin_dead_Func001C())then
set udg_fengyin2=true
call DisplayTextToForce(GetPlayersAll(),"|cFFFFCC00司徒西风：|r|cFFCCFFCC得于几位大侠的鼎立相助，封印仪式完成了！|r")
set udg_SP=GetUnitLoc(gg_unit_nfpl_0606)
call PingMinimapLocForForce(GetPlayersAll(),udg_SP,10.00)
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
call RemoveLocation(udg_SP)
else
endif
if(Trig_fengyin_dead_Func002C())then
call ForForce(GetPlayersAll(),function Trig_fengyin_dead_Func002Func001A)
else
endif
endfunction