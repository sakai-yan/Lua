//=========================================================================== 
// Trigger: 004
//=========================================================================== 
function InitTrig____________________004 takes nothing returns nothing
set gg_trg____________________004=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg____________________004,gg_rct______________122)
call TriggerAddCondition(gg_trg____________________004,Condition(function Trig____________________004_Conditions))
call TriggerAddAction(gg_trg____________________004,function Trig____________________004_Actions)
endfunction

function Trig____________________004_Actions takes nothing returns nothing
call PauseTimer(udg_MP_jianxuan_time)
call DestroyTimerDialog(udg_MP_jianxuan_win)
set udg_MP_jianxuan6[GetConvertedPlayerId(GetOwningPlayer(udg_MP_jianxuan_unit))]=false
set udg_MP_jianxuan5[GetConvertedPlayerId(GetOwningPlayer(udg_MP_jianxuan_unit))]=false
call DisableTrigger(gg_trg_jianxuannpc)
call ShowUnitHide(gg_unit_ndqn_0615)
call SetUnitPositionLoc(gg_unit_ndqn_0615,GetRectCenter(gg_rct______________120))
call PauseUnitBJ(true,gg_unit_ndqn_0615)
call ShowUnitShow(gg_unit_nfor_0612)
call SetUnitPositionLocFacingBJ(gg_unit_nfor_0612,GetRectCenter(gg_rct______________121),bj_UNIT_FACING)
call DisplayTextToPlayer(GetOwningPlayer(udg_MP_jianxuan_unit),0,0,"|cFFFF0000系统提示：你无法阻止妖魔进村，任务失败。\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFFCCFFCC回去找张业，重新再来一次吧|r")
if(Trig____________________004_Func012001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
endfunction

function Trig____________________004_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='ndqn'))then
return false
endif
return true
endfunction