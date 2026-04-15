//=========================================================================== 
// Trigger: miaozhaizhimen5
//=========================================================================== 
function InitTrig_miaozhaizhimen5 takes nothing returns nothing
set gg_trg_miaozhaizhimen5=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_miaozhaizhimen5,256,gg_unit_nanm_0508)
call TriggerAddCondition(gg_trg_miaozhaizhimen5,Condition(function Trig_miaozhaizhimen5_Conditions))
call TriggerAddAction(gg_trg_miaozhaizhimen5,function Trig_miaozhaizhimen5_Actions)
endfunction

function Trig_miaozhaizhimen5_Actions takes nothing returns nothing
set udg_miaozhaizhimen4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nanm_0508)
if(Trig_miaozhaizhimen5_Func003001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call CreateTextTagUnitBJ("|cFFFFCC00+|r|cFFFFD41A15|r|cFFFFDD330|r|cFFFFE64C0|r|cFFFFEE66铜|r|cFFFFFF99钱|r",GetTriggerUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call AdjustPlayerStateBJ(1500,GetOwningPlayer(GetTriggerUnit()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1500)
set udg_EXP=R2I(((5.00/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]))-22.00))*800.00))
call CreateTextTagUnitBJ(("|cFF00FF00经验+"+(I2S(udg_EXP)+"|r")),GetTriggerUnit(),80.00,10,100.00,100.00,100.00,0)
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+udg_EXP)
if(Trig_miaozhaizhimen5_Func014C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=656260
else
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],true)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
if(Trig_miaozhaizhimen5_Func020C())then
call UnitAddItemByIdSwapped('k3m2',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_miaozhaizhimen5_Func020Func002C())then
call UnitAddItemByIdSwapped('ktrm',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_miaozhaizhimen5_Func020Func002Func001C())then
call UnitAddItemByIdSwapped('k3m2',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_miaozhaizhimen5_Func020Func002Func001Func001C())then
call UnitAddItemByIdSwapped('shwd',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_miaozhaizhimen5_Func020Func002Func001Func001Func001C())then
call UnitAddItemByIdSwapped('sclp',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
if(Trig_miaozhaizhimen5_Func020Func002Func001Func001Func001Func001C())then
call UnitAddItemByIdSwapped('ktrm',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
call UnitAddItemByIdSwapped('bzbf',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
endif
endif
endif
endif
endif
endif
call CreateTextTagUnitBJ("|CFF00FF00材料|R",udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],20.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),1.00)
call RemoveLocation(udg_SP)
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFF6600完|r|cFFFF8C26成|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF苗寨之门\n|r|cFFFFCC00石中保：|r|cFFCCFFCC近日有目一睹大侠武功真是老夫的福气啊，小人无以回报，这东西 你就拿去吧。|r")
endfunction

function Trig_miaozhaizhimen5_Conditions takes nothing returns boolean
if(not(udg_miaozhaizhimen4[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_miaozhaizhimen_num1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(udg_miaozhaizhimen_num2[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=10))then
return false
endif
if(not(udg_miaozhaizhimen_num3[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]>=5))then
return false
endif
return true
endfunction