//=========================================================================== 
// Trigger: J HLSUNIT
//=========================================================================== 
function InitTrig_J_HLSUNIT takes nothing returns nothing
set gg_trg_J_HLSUNIT=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_J_HLSUNIT,EVENT_PLAYER_UNIT_USE_ITEM)
call TriggerAddAction(gg_trg_J_HLSUNIT,function Trig_J_HLSUNIT_Actions)
endfunction

function Trig_J_HLSUNIT_Actions takes nothing returns nothing
if(Trig_J_HLSUNIT_Func001C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='osw1'
call CreateTextTagUnitBJ("火麒麟",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func001Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
endif
if(Trig_J_HLSUNIT_Func002C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='osw2'
call CreateTextTagUnitBJ("|cFFFF9900鹿|r|cFFEEBB44妖|r|cFFDDDD88之|r|cFFCCFFCC魂|r",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func002Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=2
else
endif
if(Trig_J_HLSUNIT_Func003C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='osw3'
call CreateTextTagUnitBJ("|cFFFF6600大|r|cFFEE9944统|r|cFFDDCC88熊|r|cFFCCFFCC妖|r",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func003Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=3
else
endif
if(Trig_J_HLSUNIT_Func004C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='nftt'
call CreateTextTagUnitBJ("|cFFFF6600陵|r|cFFEE9944墓|r|cFFDDCC88骸|r|cFFCCFFCC骨|r",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func004Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=4
else
endif
if(Trig_J_HLSUNIT_Func005C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='nfel'
call CreateTextTagUnitBJ("|cFFFF6600雪|r|cFFEE9944原|r|cFFDDCC88巨|r|cFFCCFFCC人|r",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func005Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=5
else
endif
//////////////////////////////////
if(Trig_J_HLSUNIT_Func006C())then
set udg_J_ls_type[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]='jcsy'
call CreateTextTagUnitBJ("|cFFFF6600剑|r|cFFEE9944齿|r|cFFDDCC88鲨|r|cFFCCFFCC鱼|r",GetTriggerUnit(),90.00,10,100.00,70.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_HLSUNIT_Func006Func007001())then
call PlaySoundBJ(gg_snd_SecretFound)
else
call DoNothing()
endif
set udg_lingshou[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=6
else
endif
////////////////
endfunction