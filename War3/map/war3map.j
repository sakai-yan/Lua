//===========================================================================
//*
//*  Global variables
//*
//===========================================================================
#define USE_BJ_ANTI_LEAK
#include <YDTrigger/Import.h>
#include <YDTrigger/YDTrigger.h>
#include <YDTrigger/ImportSaveLoadSystem.h>
#include <YDTrigger/Hash.h>
globals
	trigger gg_trg_start = null
	trigger gg_trg_main_lua = null
	trigger gg_trg_blizzard_lua = null
	trigger gg_trg____________________001 = null
	trigger gg_trg____________________001_______u = null
	trigger gg_trg____________________001________2 = null
	trigger gg_trg____________________001________2_______u = null
	trigger gg_trg____________________002 = null
	trigger gg_trg____________________003 = null
	trigger gg_trg____________________004 = null
	trigger gg_trg____________________006 = null
	trigger gg_trg____________________005 = null
	trigger gg_trg____________________007 = null
	unit gg_unit_HR00_0008 = null
	item gg_item_ratf_0016 = null
#include <YDTrigger/Globals.h>
endglobals
#include <YDTrigger/Function.h>
function InitGlobals takes nothing returns nothing
	local integer i = 0
endfunction

function InitRandomGroups takes nothing returns nothing
	local integer curset
endfunction

function InitSounds takes nothing returns nothing
endfunction
function CreateDestructables takes nothing returns nothing
	local destructable d
	local trigger t
	local real life
endfunction
function CreateItems takes nothing returns nothing
	local integer itemID
	call CreateItem('penr',689.2,1491.5)
	call CreateItem('ratf',738.6,1256.8)
	call CreateItem('ratf',689.7,1174.3)
	set gg_item_ratf_0016 = CreateItem('ratf',544.1,863.5)
	call CreateItem('bspd',465.1,1212.0)
	call CreateItem('tstr',496.8,1486.3)
	call CreateItem('tstr',522.3,1441.5)
	call CreateItem('phea',463.4,1347.6)
endfunction
function CreateUnits takes nothing returns nothing
	local unit u
	local integer unitID
	local trigger t
	local real life
	set u = CreateUnit(Player(0),'Hamg',618.8,1598.4,209.9)
	set u = CreateUnit(Player(0),'HR00',584.8,1289.4,97.4)
	set gg_unit_HR00_0008 = u
	call SelectHeroSkill(u, 'AHfs')
	call SelectHeroSkill(u, 'A001')
	set u = CreateUnit(Player(0),'hfoo',322.0,1263.4,42.5)
	set u = CreateUnit(Player(0),'hvlt',256.0,1600.0,270.0)
endfunction
function CreateRegions takes nothing returns nothing
	local weathereffect we

endfunction
function CreateCameras takes nothing returns nothing
endfunction
//TESH.scrollpos=0
//TESH.alwaysfold=0

//#include "Lua/slkimport.j"
#include "Lua/Init.j"


//#include "../MyFuc/MyFuc_init.j"

//===========================================================================
// Trigger: start
//===========================================================================
function Trig_startActions takes nothing returns nothing
	call Cheat( "exec-lua:\"main\"")
endfunction

//===========================================================================
function InitTrig_start takes nothing returns nothing
	set gg_trg_start = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_start,"start")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg_start, Player(0), "start", true)
	call TriggerAddAction(gg_trg_start, function Trig_startActions)
endfunction

//===========================================================================
// Trigger: 未命名触发器 001
//===========================================================================
function Trig____________________001Actions takes nothing returns nothing
	call MHUnit_SetMoveSpeedLimit( gg_unit_HR00_0008, 999.00)
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( GetUnitMoveSpeed( gg_unit_HR00_0008)))
	call SetUnitMoveSpeed( gg_unit_HR00_0008, 300.00)
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( GetUnitMoveSpeed( gg_unit_HR00_0008)))
	call MHUnit_SetData( gg_unit_HR00_0008, UNIT_DATA_BONUS_MOVESPEED, 3.00)
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( GetUnitMoveSpeed( gg_unit_HR00_0008)))
	call SetUnitMoveSpeed( gg_unit_HR00_0008, 400.00)
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( MHUnit_GetData( gg_unit_HR00_0008, UNIT_DATA_BONUS_MOVESPEED)))
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( GetUnitMoveSpeed( gg_unit_HR00_0008)))
	call MHUnit_SetData( gg_unit_HR00_0008, UNIT_DATA_BONUS_MOVESPEED, 2.00)
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( GetUnitMoveSpeed( gg_unit_HR00_0008)))
	call DisplayTextToPlayer( Player(0), 0, 0, R2S( MHUnit_GetData( gg_unit_HR00_0008, UNIT_DATA_BONUS_MOVESPEED)))
endfunction

//===========================================================================
function InitTrig____________________001 takes nothing returns nothing
	set gg_trg____________________001 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________001,"未命名触发器 001")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________001, Player(0), "1", true)
	call TriggerAddAction(gg_trg____________________001, function Trig____________________001Actions)
endfunction

//===========================================================================
// Trigger: 未命名触发器 001 复制
//===========================================================================
function Trig____________________001_______uActions takes nothing returns nothing
	call IncUnitAbilityLevel( gg_unit_HR00_0008, 'A001')
endfunction

//===========================================================================
function InitTrig____________________001_______u takes nothing returns nothing
	set gg_trg____________________001_______u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________001_______u,"未命名触发器 001 复制")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________001_______u, Player(0), "2", true)
	call TriggerAddAction(gg_trg____________________001_______u, function Trig____________________001_______uActions)
endfunction

//===========================================================================
// Trigger: 未命名触发器 001 复制 2
//===========================================================================
function Trig____________________001________2Actions takes nothing returns nothing
	call MHAbility_SetTargetAllow( gg_unit_HR00_0008, 'A001', MHConvertTargetAllow( TARGET_ALLOW_SELF))
	call MHAbility_SetCooldown( GetTriggerUnit(), 'AHtb', 114514)
endfunction

//===========================================================================
function InitTrig____________________001________2 takes nothing returns nothing
	set gg_trg____________________001________2 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________001________2,"未命名触发器 001 复制 2")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________001________2, Player(0), "3", true)
	call TriggerAddAction(gg_trg____________________001________2, function Trig____________________001________2Actions)
endfunction

//TESH.scrollpos=0
//TESH.alwaysfold=0
//===========================================================================
// Trigger: 未命名触发器 001 复制 2 复制
//===========================================================================
function Trig____________________001________2_______uActions takes nothing returns nothing
	local item wp
	local integer ct
    local ability abil
    local integer cast
	set wp = gg_item_ratf_0016
    set abil = MHItem_GetAbility(wp, 1)
	set ct = MHAbility_GetAbilityCastType( abil)
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( ct ))
	set ct = MHMath_RemoveBit( ct, MHConvertCastType( ABILITY_CAST_TYPE_NONTARGET))
	set ct = MHMath_AddBit( ct, MHConvertCastType( ABILITY_CAST_TYPE_POINT))
	call MHAbility_SetAbilityCastType( abil, ct)
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( GetHandleId( abil)))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHAbility_GetAbilityCastType( abil) ))
endfunction

//===========================================================================
function InitTrig____________________001________2_______u takes nothing returns nothing
	set gg_trg____________________001________2_______u = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________001________2_______u,"未命名触发器 001 复制 2 复制")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________001________2_______u, Player(0), "12", true)
	call TriggerAddAction(gg_trg____________________001________2_______u, function Trig____________________001________2_______uActions)
endfunction


//===========================================================================
// Trigger: 未命名触发器 002
//===========================================================================
function Trig____________________002Actions takes nothing returns nothing
	local integer j
	local integer ct
	local string kk
	set j = YDWEConverAbilcodeToInt( 'AHtb')
	call MHUnit_AddAbility( gg_unit_HR00_0008, j, false)
	set ct = MHAbility_GetCastType( gg_unit_HR00_0008, j)
	set ct = MHMath_RemoveBit( ct, ct)
	call MHAbility_SetCastType( gg_unit_HR00_0008, j, ct)
	call MHAbility_FlagOperator( gg_unit_HR00_0008, j, FLAG_OPERATOR_ADD, ABILITY_FLAG_ON_CAST)
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHAbility_GetCastType( gg_unit_HR00_0008, j)))
	set kk = MHUnit_GetDefDataStr( 'hfoo', UNIT_DEF_DATA_MODEL)
	call MHUnit_SetData( gg_unit_HR00_0008, UNIT_DATA_MAX_LIFE, 10000.00)
	set kk = null
endfunction

//===========================================================================
function InitTrig____________________002 takes nothing returns nothing
	set gg_trg____________________002 = CreateTrigger()
	call DisableTrigger(gg_trg____________________002)
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________002,"未命名触发器 002")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________002, Player(0), "4", true)
	call TriggerAddAction(gg_trg____________________002, function Trig____________________002Actions)
endfunction

//TESH.scrollpos=0
//TESH.alwaysfold=0
//===========================================================================
// Trigger: 未命名触发器 004
//===========================================================================
function Trig____________________004Actions takes nothing returns nothing
	call MHUnit_AddAbility( gg_unit_HR00_0008, 'AHtb', false)
	//call MHAbility_SetCustomDataInt( gg_unit_HR00_0008, 'AHtb', ABILITY_DEF_DATA_BUTTON_X, 2)
	//call MHAbility_SetCustomDataInt( gg_unit_HR00_0008, 'AHtb', ABILITY_DEF_DATA_BUTTON_Y, 2)
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHAbility_GetCustomDataInt( gg_unit_HR00_0008, 'AHtb', ABILITY_DEF_DATA_BUTTON_X)))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHAbility_GetCustomDataInt( gg_unit_HR00_0008, 'AHtb', ABILITY_DEF_DATA_BUTTON_Y)))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( 'ANsb'))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, GetAbilityName( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 2))))
	call MHUnit_UpdateInfoBar( gg_unit_HR00_0008)
endfunction

//===========================================================================
function InitTrig____________________004 takes nothing returns nothing
	set gg_trg____________________004 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________004,"未命名触发器 004")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________004, Player(0), "5", true)
	call TriggerAddAction(gg_trg____________________004, function Trig____________________004Actions)
endfunction


//TESH.scrollpos=0
//TESH.alwaysfold=0
//===========================================================================
// Trigger: 未命名触发器 006
//===========================================================================
function Trig____________________006Actions takes nothing returns nothing
call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 0, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 1, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 2, 2))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 0))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButtonEx( 3, 2))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( 2222))
    
    
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 1))))
	call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 2))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 3))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 4))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 5))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 6))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 7))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 8))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 9))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 10))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 11))))
    call DisplayTextToPlayer( Player(0), 0, 0, I2S( MHUIData_GetCommandButtonAbility( MHUI_GetSkillBarButton( 12))))
endfunction

//===========================================================================
function InitTrig____________________006 takes nothing returns nothing
	set gg_trg____________________006 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________006,"未命名触发器 006")
#endif
	call TriggerRegisterPlayerChatEvent(gg_trg____________________006, Player(0), "7", true)
	call TriggerAddAction(gg_trg____________________006, function Trig____________________006Actions)
endfunction


//===========================================================================
// Trigger: 未命名触发器 007
//===========================================================================
function Trig____________________007Actions takes nothing returns nothing
	local integer ui
	call MHFrame_LoadTOC( "ui\\duihuakuang.toc")
	set ui = MHFrame_CreateSimple( "", MHUI_GetGameUI(), 0)
	call MHFrame_SetTexture( ui, "ReplaceableTextures\\CommandButtons\\BTNStormBolt.blp", false)
	call MHFrame_SetAbsolutePoint( ui, ANCHOR_CENTER, 0.4, 0.3)
	call MHFrame_SetSize( ui, 0.30, 0.30)
endfunction

//===========================================================================
function InitTrig____________________007 takes nothing returns nothing
	set gg_trg____________________007 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________007,"未命名触发器 007")
#endif
	call TriggerRegisterTimerEventSingle(gg_trg____________________007, 0.00)
	call TriggerAddAction(gg_trg____________________007, function Trig____________________007Actions)
endfunction

//===========================================================================
function InitCustomTriggers takes nothing returns nothing
	call InitTrig_start()
	call InitTrig____________________001()
	call InitTrig____________________001_______u()
	call InitTrig____________________001________2()
	call InitTrig____________________001________2_______u()
	call InitTrig____________________002()
	call InitTrig____________________004()
	call InitTrig____________________006()
	call InitTrig____________________007()
endfunction
//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
endfunction
function InitCustomPlayerSlots takes nothing returns nothing
	call SetPlayerStartLocation(Player(0), 0)
	call SetPlayerColor(Player(0), ConvertPlayerColor(0))
	call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
	call SetPlayerRaceSelectable(Player(0), false)
	call SetPlayerController(Player(0), MAP_CONTROL_USER)

	call SetPlayerStartLocation(Player(1), 1)
	call SetPlayerColor(Player(1), ConvertPlayerColor(1))
	call SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
	call SetPlayerRaceSelectable(Player(1), false)
	call SetPlayerController(Player(1), MAP_CONTROL_USER)

endfunction

function InitCustomTeams takes nothing returns nothing
	// Force: TRIGSTR_002
	call SetPlayerTeam(Player(0), 0)
	call SetPlayerTeam(Player(1), 0)

endfunction
function InitAllyPriorities takes nothing returns nothing
	call SetStartLocPrioCount(0, 1)
	call SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
	call SetStartLocPrioCount(1, 1)
	call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
endfunction
//===========================================================================
//*
//*  Main Initialization
//*
//===========================================================================
function main takes nothing returns nothing
	call SetCameraBounds(-3328.000000 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.000000 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.000000 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.000000 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.000000 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.000000 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.000000 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.000000 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
	call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
	call NewSoundEnvironment("Default")
	call SetAmbientDaySound("LordaeronSummerDay")
	call SetAmbientNightSound("LordaeronSummerNight")
	call SetMapMusic("Music", true, 0)
	call InitSounds()
	call InitRandomGroups()
	call CreateRegions()
	call CreateCameras()
	call CreateDestructables()
	call CreateItems()
	call CreateUnits()
	call InitBlizzard()
	call InitGlobals()
	call InitCustomTriggers()
	call RunInitializationTriggers()
endfunction
//===========================================================================
//*
//*  Map Configuration
//*
//===========================================================================
function config takes nothing returns nothing
	call SetMapName("计时器的使用演示")
	call SetMapDescription("没有说明")
	call SetPlayers(2)
	call SetTeams(2)
	call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)

	call DefineStartLocation(1, 320.000000, 2240.000000)
	call DefineStartLocation(0, 1024.000000, 1600.000000)

	call InitCustomPlayerSlots()
	call InitCustomTeams()
	call InitAllyPriorities()
endfunction
