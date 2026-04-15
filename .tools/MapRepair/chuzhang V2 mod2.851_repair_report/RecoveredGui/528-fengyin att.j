//=========================================================================== 
// Trigger: fengyin att
//=========================================================================== 
function InitTrig_fengyin_att takes nothing returns nothing
set gg_trg_fengyin_att=CreateTrigger()
call DisableTrigger(gg_trg_fengyin_att)
call TriggerRegisterTimerEventPeriodic(gg_trg_fengyin_att,2.00)
call TriggerAddAction(gg_trg_fengyin_att,function Trig_fengyin_att_Actions)
endfunction

function Trig_fengyin_att_Actions takes nothing returns nothing
set udg_SP=GetRectCenter(gg_rct______________114)
call CreateNUnitsAtLoc(1,'nbdw',Player(bj_PLAYER_NEUTRAL_VICTIM),udg_SP,bj_UNIT_FACING)
set udg_SP2=GetUnitLoc(gg_unit_nfpl_0606)
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP2)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
set udg_fengyin_num1=(udg_fengyin_num1+1)
if(Trig_fengyin_att_Func008C())then
call DisableTrigger(GetTriggeringTrigger())
call DisplayTextToForce(GetPlayersAll(),("|cFFFF0000系统提示：|r"+(I2S(udg_fengyin_num2)+("波的妖兽已出，还有"+(I2S((5-udg_fengyin_num2))+"波|R")))))
set udg_SP=GetUnitLoc(gg_unit_nfpl_0606)
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
call RemoveLocation(udg_SP)
set udg_fengyin_num1=0
set udg_fengyin_num2=(udg_fengyin_num2+1)
if(Trig_fengyin_att_Func008Func008C())then
call PolledWait(15.00)
call EnableTrigger(GetTriggeringTrigger())
else
call PolledWait(10.00)
set udg_SP=GetRectCenter(gg_rct______________114)
call CreateNUnitsAtLoc(1,'nbds',Player(bj_PLAYER_NEUTRAL_VICTIM),udg_SP,bj_UNIT_FACING)
set udg_SP2=GetUnitLoc(gg_unit_nfpl_0606)
call IssuePointOrderLoc(GetLastCreatedUnit(),"attack",udg_SP2)
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
call DisplayTextToForce(GetPlayersAll(),"|cFFFF0000系统信息：|r|cFFFFFF99魔君派出了它的使徒|r")
set udg_SP=GetRectCenter(gg_rct______________114)
call PingMinimapLocForForce(GetPlayersAll(),udg_SP,10.00)
call PlaySoundAtPointBJ(gg_snd_ArrangedTeamInvitation,100,udg_SP,0)
call RemoveLocation(udg_SP)
endif
else
endif
endfunction