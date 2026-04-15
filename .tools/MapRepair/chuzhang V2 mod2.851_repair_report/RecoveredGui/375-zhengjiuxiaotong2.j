//=========================================================================== 
// Trigger: zhengjiuxiaotong2
//=========================================================================== 
function InitTrig_zhengjiuxiaotong2 takes nothing returns nothing
set gg_trg_zhengjiuxiaotong2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhengjiuxiaotong2,EVENT_PLAYER_UNIT_ATTACKED)
call TriggerAddCondition(gg_trg_zhengjiuxiaotong2,Condition(function Trig_zhengjiuxiaotong2_Conditions))
call TriggerAddAction(gg_trg_zhengjiuxiaotong2,function Trig_zhengjiuxiaotong2_Actions)
endfunction

function Trig_zhengjiuxiaotong2_Actions takes nothing returns nothing
if(Trig_zhengjiuxiaotong2_Func001C())then
set udg_SP=GetRectCenter(gg_rct_xuemi)
call AddSpecialEffectLocBJ(udg_SP,"Abilities\\Spells\\Undead\\RaiseSkeletonWarrior\\RaiseSkeleton.mdl")
call CreateNUnitsAtLoc(1,'ngh2',Player(PLAYER_NEUTRAL_AGGRESSIVE),udg_SP,bj_UNIT_FACING)
call RemoveLocation(udg_SP)
call CameraSetTargetNoiseEx(10,0.1,true)
call DisableTrigger(GetTriggeringTrigger())
call PolledWait(4.00)
call CameraSetTargetNoiseEx(0.00,0.00,true)
else
endif
endfunction

function Trig_zhengjiuxiaotong2_Conditions takes nothing returns boolean
if(not(GetTriggerUnit()==gg_unit_nwc1_0216))then
return false
endif
if(not(udg_R_ZJ_xiaotong1==true))then
return false
endif
return true
endfunction