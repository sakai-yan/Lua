//=========================================================================== 
// Trigger: jingtou1
//=========================================================================== 
function InitTrig_jingtou1 takes nothing returns nothing
set gg_trg_jingtou1=CreateTrigger()
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(0),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(1),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(2),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(3),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(4),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(5),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(6),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(7),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(8),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(9),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(10),"镜头模式",true)
call TriggerRegisterPlayerChatEvent(gg_trg_jingtou1,Player(11),"镜头模式",true)
call TriggerAddAction(gg_trg_jingtou1,function Trig_jingtou1_Actions)
endfunction

function Trig_jingtou1_Actions takes nothing returns nothing
set udg_SP=GetUnitLoc(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())])
call CreateNUnitsAtLoc(1,'nalb',GetTriggerPlayer(),udg_SP,bj_UNIT_FACING)
call SetUnitVertexColorBJ(GetLastCreatedUnit(),100,100,100,100.00)
set udg_CCC[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedUnit()
call RemoveLocation(udg_SP)
if(Trig_jingtou1_Func006C())then
call SetCameraTargetControllerNoZForPlayer(GetTriggerPlayer(),udg_CCC[GetConvertedPlayerId(GetTriggerPlayer())],0,0,false)
set udg_camera_T[GetConvertedPlayerId(GetTriggerPlayer())]=true
else
call ResetToGameCameraForPlayer(GetTriggerPlayer(),0)
set udg_camera_T[GetConvertedPlayerId(GetTriggerPlayer())]=false
endif
endfunction