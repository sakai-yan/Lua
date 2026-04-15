//=========================================================================== 
// Trigger: xiufushizhen6
//=========================================================================== 
function InitTrig_xiufushizhen6 takes nothing returns nothing
set gg_trg_xiufushizhen6=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_xiufushizhen6,256,gg_unit_ngzc_0094)
call TriggerAddCondition(gg_trg_xiufushizhen6,Condition(function Trig_xiufushizhen6_Conditions))
call TriggerAddAction(gg_trg_xiufushizhen6,function Trig_xiufushizhen6_Actions)
endfunction

function Trig_xiufushizhen6_Actions takes nothing returns nothing
set udg_R_xiufushizhen3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_ngzc_0094)
if(Trig_xiufushizhen6_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A8|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(800,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+800)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-4.00))*100.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_xiufushizhen6_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call UnitAddItemByIdSwapped('rde4',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFDD33螺|r|cFFFFFF99帽|r",GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF修复石阵（2）\n|r|cFFFFCC00阿亥：|r|cFFCCFFCC幸得大侠（女侠）帮忙啊~~~我现在马上就去修复石阵。|r")
endfunction

function Trig_xiufushizhen6_Conditions takes nothing returns boolean
if(not(udg_R_xiufushizhen2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_R_xiufushizhen3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_R_xiufushizhen_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(udg_R_xiufushizhen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
return true
endfunction