//=========================================================================== 
// Trigger: qingzao3
//=========================================================================== 
function InitTrig_qingzao3 takes nothing returns nothing
set gg_trg_qingzao3=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_qingzao3,256,gg_unit_nqb1_0093)
call TriggerAddCondition(gg_trg_qingzao3,Condition(function Trig_qingzao3_Conditions))
call TriggerAddAction(gg_trg_qingzao3,function Trig_qingzao3_Actions)
endfunction

function Trig_qingzao3_Actions takes nothing returns nothing
set udg_R_CJ_qingzao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nqb1_0093)
if(Trig_qingzao3_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A5|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(500,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+500)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-3.00))*65.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_qingzao3_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,5.00,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF甜美的青枣|r")
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00阿苟姑娘：|r|cFFCCFFCC谢谢您，我还有个不情之请，就是我那在五石阵的|r|cFF00FF00哥哥|r|cFFCCFFCC...他常年守在那石阵很辛苦的，你能帮我把这剩余的青枣送到他那吗？从|r|cFF00FF00村子东边|r|cFFCCFFCC沿着路一直走就能看到五石阵了。\n|r|cFFFF6600任|r|cFFFF8026务|r|cFFFF994C提|r|cFFFFB273示|r|cFFFFCC99：|r|cFF00FF00把一袋青枣带给阿亥|r")
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
call RemoveLocation(udg_SP)
call UnitAddItemByIdSwapped('ssan',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call PolledWait(0.50)
set udg_SP=GetUnitLoc(gg_unit_nqb1_0093)
if(Trig_qingzao3_Func029001())then
call PlaySoundAtPointBJ(gg_snd_QuestActivateWhat1,100,udg_SP,0)
else
call DoNothing()
endif
if(Trig_qingzao3_Func030001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endfunction

function Trig_qingzao3_Conditions takes nothing returns boolean
if(not(udg_R_CJ_qingzao1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_CJ_qingzao2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(udg_R_CJ_qingzao_num[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=20))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
return true
endfunction