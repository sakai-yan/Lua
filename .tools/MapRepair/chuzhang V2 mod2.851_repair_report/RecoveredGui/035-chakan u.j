//=========================================================================== 
// Trigger: chakan u
//=========================================================================== 
function InitTrig_chakan_______u takes nothing returns nothing
set gg_trg_chakan_______u=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_chakan_______u,EVENT_PLAYER_UNIT_SPELL_EFFECT)
call TriggerAddCondition(gg_trg_chakan_______u,Condition(function Trig_chakan_______u_Conditions))
call TriggerAddAction(gg_trg_chakan_______u,function Trig_chakan_______u_Actions)
endfunction

function Trig_chakan_______u_Actions takes nothing returns nothing
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00剑|r|cFFFF8855系|r|cFFFF44AA数|r|cFFFF00FF：|r"+R2S(udg_JX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00刀|r|cFFFF8855系|r|cFFFF44AA数|r|cFFFF00FF：|r"+R2S(udg_DX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00法|r|cFFFF8855系|r|cFFFF44AA数|r|cFFFF00FF：|r"+R2S(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00医|r|cFFFF8855系|r|cFFFF44AA数|r|cFFFF00FF：|r"+R2S(udg_YX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00长|r|cFFFF9940柄|r|cFFFF6680系|r|cFFFF33BF数|r|cFFFF00FF：|r"+R2S(udg_GX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFFFCC00拳|r|cFFFF9940爪|r|cFFFF6680系|r|cFFFF33BF数|r|cFFFF00FF：|r"+R2S(udg_QX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FF00剑|r|cFF33FF00系|r|cFF66FF00熟|r|cFF99FF00练|r|cFFCCFF00度|r|cFFFFFF00：|r"+(I2S(udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+(",还需经验"+I2S((udg_Skillup_JX[udg_JX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]]-udg_Exp_JX_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FF00刀|r|cFF33FF00系|r|cFF66FF00熟|r|cFF99FF00练|r|cFFCCFF00度|r|cFFFFFF00：|r"+(I2S(udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+(",还需经验"+I2S((udg_Skillup_DX[udg_DX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]]-udg_Exp_DX_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FF00法|r|cFF33FF00系|r|cFF66FF00熟|r|cFF99FF00练|r|cFFCCFF00度|r|cFFFFFF00：|r"+(I2S(udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+(",还需经验"+I2S((udg_Skillup_FX[udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]]-udg_Exp_FX_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FF00长|r|cFF33FF00柄|r|cFF66FF00熟|r|cFF99FF00练|r|cFFCCFF00度|r|cFFFFFF00：|r"+(I2S(udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+(",还需经验"+I2S((udg_Skillup_GX[udg_GX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]]-udg_Exp_GX_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF00FF00拳|r|cFF33FF00爪|r|cFF66FF00熟|r|cFF99FF00练|r|cFFCCFF00度|r|cFFFFFF00：|r"+(I2S(udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+(",还需经验"+I2S((udg_Skillup_QX[udg_QX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]]-udg_Exp_QX_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFF99CC00法|r|cFFB2D900术|r|cFFCCE600抵|r|cFFE6F200抗|r|cFFFFFF00：|r"+R2S(udg_FK[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCC99FF侠义值：|r"+R2S(I2R(udg_XIA[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCC99FF狩猎值：|r"+R2S(I2R(udg_SL[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,("|cFFCC99FF戾气值：|r"+R2S(I2R(udg_LiQi[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))))
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFF00FF00成功保存游戏......|r")
call TriggerExecute(gg_trg_save)
endfunction

function Trig_chakan_______u_Conditions takes nothing returns boolean
if(not(GetSpellAbilityId()=='A02F'))then
return false
endif
return true
endfunction