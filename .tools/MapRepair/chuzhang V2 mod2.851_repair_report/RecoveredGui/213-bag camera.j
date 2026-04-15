//=========================================================================== 
// Trigger: bag camera
//=========================================================================== 
function InitTrig_bag_camera takes nothing returns nothing
set gg_trg_bag_camera=CreateTrigger()
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0039,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0071,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0075,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0059,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0063,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0079,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0047,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0058,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0067,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0043,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0083,EVENT_UNIT_SELECTED)
call TriggerRegisterUnitEvent(gg_trg_bag_camera,gg_unit_hpea_0051,EVENT_UNIT_SELECTED)
call TriggerAddAction(gg_trg_bag_camera,function Trig_bag_camera_Actions)
endfunction

function Trig_bag_camera_Actions takes nothing returns nothing
if(Trig_bag_camera_Func001C())then
if(Trig_bag_camera_Func001Func001C())then
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call PanCameraToTimedLocForPlayer(GetTriggerPlayer(),udg_SP,0)
call RemoveLocation(udg_SP)
else
set udg_SP=GetUnitLoc(udg_zuoqi[GetConvertedPlayerId(GetTriggerPlayer())])
call PanCameraToTimedLocForPlayer(GetTriggerPlayer(),udg_SP,0)
call RemoveLocation(udg_SP)
endif
else
call DoNothing()
endif
endfunction