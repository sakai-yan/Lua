//=========================================================================== 
// Trigger: SET
//=========================================================================== 
function InitTrig_SET takes nothing returns nothing
set gg_trg_SET=CreateTrigger()
call TriggerRegisterTimerEventSingle(gg_trg_SET,5.00)
call TriggerAddAction(gg_trg_SET,function Trig_SET_Actions)
endfunction

function Trig_SET_Actions takes nothing returns nothing
call Cheat("greedisgood 999999")
call SetMapFlag(MAP_FOG_MAP_EXPLORED,true)
call RemoveW3v()
call FlushGameCache(InitGameCache("Cache"))
call InitGameCacheBJ("Cache")
set udg_Cache=GetLastCreatedGameCacheBJ()
if SaveGameCache(udg_Cache)then
call EndGame(false)
endif
set udg_w3v=udg_Cache
set udg_FileName="\\\\save\\\\xzty.mod2851"           //tt
call SetTimeOfDay(12.00)
call UseTimeOfDayBJ(false)
call SetMapFlag(MAP_LOCK_RANDOM_SEED,false)
call SetForceAllianceStateBJ(GetPlayersMatching(Condition(function Trig_SET_Func020001001)),GetPlayersMatching(Condition(function Trig_SET_Func020002001)),bj_ALLIANCE_ALLIED_VISION)
call SetCreepCampFilterState(false)
call EnableMinimapFilterButtons(true,false)
call FogEnable(false)
call FogMaskEnableOff()
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=11
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
call CreateFogModifierRectBJ(true,ConvertedPlayer(GetForLoopIndexA()),FOG_OF_WAR_VISIBLE,GetPlayableMapRect())
call ForceAddPlayerSimple(ConvertedPlayer(GetForLoopIndexA()),udg_player[GetForLoopIndexA()])
call SetPlayerAllianceStateBJ(Player(bj_PLAYER_NEUTRAL_VICTIM),ConvertedPlayer(GetForLoopIndexA()),bj_ALLIANCE_UNALLIED)
call SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()),Player(bj_PLAYER_NEUTRAL_VICTIM),bj_ALLIANCE_UNALLIED)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call SetPlayerAllianceStateBJ(Player(bj_PLAYER_NEUTRAL_VICTIM),Player(PLAYER_NEUTRAL_PASSIVE),bj_ALLIANCE_UNALLIED)
call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_PASSIVE),Player(bj_PLAYER_NEUTRAL_VICTIM),bj_ALLIANCE_UNALLIED)
call SetPlayerAllianceStateBJ(Player(11),Player(PLAYER_NEUTRAL_PASSIVE),bj_ALLIANCE_UNALLIED)
call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_PASSIVE),Player(11),bj_ALLIANCE_UNALLIED)
call ExecuteFunc("PlayerLoadEsc")
call PolledWait(10.00)
call SetUnitAnimation(gg_unit_ngsp_0145,"death")
endfunction

function Trig_SET_Func020001001 takes nothing returns boolean
return(GetPlayerController(GetFilterPlayer())==MAP_CONTROL_USER)
endfunction

function Trig_SET_Func020002001 takes nothing returns boolean
return(GetPlayerController(GetFilterPlayer())==MAP_CONTROL_USER)
endfunction

function PlayerLoadEsc takes nothing returns nothing
local integer i=0
local trigger t=null
set udg_War3Path[GetPlayerId(GetLocalPlayer())]=""
loop
exitwhen i>11
if IsPlayerOnGame(Player(i))then
call CreateFolder(udg_War3Path[i]+"\\save",i,GetPlayerId(GetLocalPlayer()))
set t=CreateTrigger()
call TriggerRegisterPlayerEvent(t,Player(i),EVENT_PLAYER_END_CINEMATIC)
call StoreInteger(udg_Cache,"CachePlayerLoadEsc"+I2S(i),H2S(t),H2I(TriggerAddAction(t,function PlayerLoadEscAct)))
if GetLocalPlayer()==Player(i)then
call ForceUICancel()
endif
endif
set i=i+1
endloop
set t=null
endfunction

function PlayerLoadEscAct takes nothing returns nothing
local integer id=GetPlayerId(GetTriggerPlayer())
local integer i=GetStoredInteger(udg_Cache,"CachePlayerLoadEsc"+I2S(id),H2S(GetTriggeringTrigger()))
local string listfile
local string m=null
local string v
local string s
local integer k
call DisableTrigger(GetTriggeringTrigger())
call DisplayTimedTextToPlayer(Player(id),0.52,-1.00,60.0,"|cffffcc00正在分析数据...请等待...这可能需要一定的时间!|r")
call DisplayTimedTextToPlayer(Player(id),0.51,-1.00,60.0,"|cffffcc00再分析期间你可以选择英雄,假设你无存档你也可以选择英雄!|r")
call ExecuteFunc("FuncName")
loop
exitwhen HaveStoredBoolean(udg_Cache,"GetFileNameId",I2S(id))
call TriggerSleepAction(0.01)
endloop
set k=GetStoredInteger(udg_Cache,"CacheListFile"+I2S(id),"Nubmer")
if k>0 then
call LoadFile(id)
else
if GetLocalPlayer()==Player(id)then
call ClearTextMessages()
endif
call DisplayTimedTextToPlayer(Player(id),0.52,-1.00,3.0,"|cffffcc00无存档|r")
call TriggerExecute(gg_trg_hero_chose1)
endif
call TriggerRemoveAction(GetTriggeringTrigger(),I2TA(i))
call FlushStoredMission(udg_Cache,"CachePlayerLoadEsc"+I2S(id))
call DestroyTrigger(GetTriggeringTrigger())
endfunction

function FuncName takes nothing returns nothing
local integer id=GetPlayerId(GetTriggerPlayer())
local string s
local integer i=1
local integer j=0
local boolean k=false
local string v=""
local integer n=0
set s=IniReadString(udg_War3Path[id]+udg_FileName,"FileName","ListFile"," ",id,GetPlayerId(GetLocalPlayer()))
call AnalyzeList(s,id)
call TriggerSleepAction(1.0)
call StoreBoolean(udg_Cache,"GetFileNameId",I2S(id),true)
endfunction