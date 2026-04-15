//=========================================================================== 
// Trigger: join
//=========================================================================== 
function InitTrig_join takes nothing returns nothing
set gg_trg_join=CreateTrigger()
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[1])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[2])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[3])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[4])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[5])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[6])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[7])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[8])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[9])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[10])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[11])
call TriggerRegisterDialogEventBJ(gg_trg_join,udg_PLAY_GROUP[12])
call TriggerAddAction(gg_trg_join,function Trig_join_Actions)
endfunction

function Trig_join_Actions takes nothing returns nothing
call SetMapFlag(MAP_LOCK_ALLIANCE_CHANGES,true)
call SetMapFlag(MAP_ALLIANCE_CHANGES_HIDDEN,true)
if(Trig_join_Func003C())then
if(Trig_join_Func003Func001C())then
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("|cFFFF0000系统信息：|r"+("|cffffff00"+"在城里无法组队")))
if(Trig_join_Func003Func001Func002001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]=null
else
if(Trig_join_Func003Func001Func005C())then
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetTriggerPlayer())]=GetConvertedPlayerId(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]))
call DisplayTextToPlayer(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]),0,0,("|cFFFF0000系统信息：|r"+("|cFF00FF00"+(GetPlayerName(GetTriggerPlayer())+"|R加入了你的队伍"))))
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("|cFFFF0000系统信息：|r"+("你加入了|CFF00FF00"+(GetPlayerName(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]))+"|R的队伍"))))
if(Trig_join_Func003Func001Func005Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
if(Trig_join_Func003Func001Func005Func008001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
call ForForce(GetPlayersMatching(Condition(function Trig_join_Func003Func001Func005Func009001001)),function Trig_join_Func003Func001Func005Func009A)
else
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]=null
if(Trig_join_Func003Func001Func005Func002001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetTriggerPlayer(),0,0,("|cFFFF0000系统信息：|r"+("|cffffff00"+(GetPlayerName(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]))+"|R目前无法组队"))))
endif
endif
else
call DisplayTextToPlayer(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]),0,0,("|cFFFF0000系统信息：|r"+("|cFF00FF00"+(GetPlayerName(GetTriggerPlayer())+"|R拒绝了你的组队邀请"))))
if(Trig_join_Func003Func003001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
if(Trig_join_Func003Func004C())then
set udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]))]=0
else
endif
set udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())]=null
endif
call SetMapFlag(MAP_LOCK_ALLIANCE_CHANGES,true)
call SetMapFlag(MAP_ALLIANCE_CHANGES_HIDDEN,true)
endfunction

function Trig_join_Func003Func001Func005Func009001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==GetConvertedPlayerId(GetOwningPlayer(udg_PLAY_GROUP_leader[GetConvertedPlayerId(GetTriggerPlayer())])))
endfunction