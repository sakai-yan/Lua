//=========================================================================== 
// Trigger: jingong1
//=========================================================================== 
function InitTrig_jingong1 takes nothing returns nothing
set gg_trg_jingong1=CreateTrigger()
call DisableTrigger(gg_trg_jingong1)
call TriggerRegisterTimerEventPeriodic(gg_trg_jingong1,2.00)
call TriggerAddAction(gg_trg_jingong1,function Trig_jingong1_Actions)
endfunction

function Trig_jingong1_Actions takes nothing returns nothing
set udg_SP=GetRectCenter(gg_rct______________016)
call CreateNUnitsAtLoc(1,udg_R_FS_hanwei_type[udg_R_FS_hanwei_num2],Player(bj_PLAYER_NEUTRAL_VICTIM),udg_SP,bj_UNIT_FACING)
set udg_SP2=GetUnitLoc(gg_unit_ngz1_0002)
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP2)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
set udg_R_FS_hanwei_num1=(udg_R_FS_hanwei_num1+1)
if(Trig_jingong1_Func008C())then
call DisableTrigger(GetTriggeringTrigger())
call DisplayTextToForce(GetPlayersAll(),("|cFFFFCC00张凡：|r|cFFFFFF99第"+(I2S(udg_R_FS_hanwei_num2)+("波的进攻全出了，还有"+(I2S((9-udg_R_FS_hanwei_num2))+"波，坚持住！！|R")))))
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
call RemoveLocation(udg_SP)
set udg_R_FS_hanwei_num1=0
set udg_R_FS_hanwei_num2=(udg_R_FS_hanwei_num2+1)
if(Trig_jingong1_Func008Func008C())then
call PolledWait(30.00)
call EnableTrigger(GetTriggeringTrigger())
else
call PolledWait(10.00)
set udg_SP=GetRectCenter(gg_rct______________016)
call CreateNUnitsAtLoc(1,'nrzg',Player(bj_PLAYER_NEUTRAL_VICTIM),udg_SP,bj_UNIT_FACING)
set udg_SP2=GetUnitLoc(gg_unit_ngz1_0002)
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP2)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
call DisplayTextToForce(GetPlayersAll(),"|cFFFFFF99张凡：山猪的大王抽刀杀来了！！大家挺住！！|r")
set udg_SP=GetUnitLoc(gg_unit_ngz2_0015)
call PingMinimapLocForForce(GetPlayersAll(),udg_SP,10.00)
call PlaySoundAtPointBJ(gg_snd_ArrangedTeamInvitation,100,udg_SP,0)
call RemoveLocation(udg_SP)
endif
else
endif
endfunction