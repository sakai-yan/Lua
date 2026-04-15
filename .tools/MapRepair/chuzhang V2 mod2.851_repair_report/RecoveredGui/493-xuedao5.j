//=========================================================================== 
// Trigger: xuedao5
//=========================================================================== 
function InitTrig_xuedao5 takes nothing returns nothing
set gg_trg_xuedao5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xuedao5,356.00,gg_unit_nwwg_0719)
call TriggerAddCondition(gg_trg_xuedao5,Condition(function Trig_xuedao5_Conditions))
call TriggerAddAction(gg_trg_xuedao5,function Trig_xuedao5_Actions)
endfunction

function Trig_xuedao5_Actions takes nothing returns nothing
set udg_MP_xuedao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_zcso_0720)
if(Trig_xuedao5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00丁宁：|r|cFFCCFFCC果然是个资质深厚的天才啊，但要成为血刀，必须|r|cFF00FF00战胜残凶鹿妖|r|cFFCCFFCC，这个是我们月刀门历来考核弟子的标准，去吧！\n\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C提|r|cFFFFD973示|r|cFFFFFF99：|r|cFF00FF00杀死残凶鹿妖|r")
if(Trig_xuedao5_Func005001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_xuedao5_Func006001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
set udg_SP=GetRectCenter(gg_rct_xiongcan)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
endfunction

function Trig_xuedao5_Conditions takes nothing returns boolean
if(not(udg_MP_xuedao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_xuedao3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_MP_xuedao_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction