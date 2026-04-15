//=========================================================================== 
// Trigger: exp and gold
//=========================================================================== 
function InitTrig_exp_and_gold takes nothing returns nothing
set gg_trg_exp_and_gold=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_exp_and_gold,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(gg_trg_exp_and_gold,Condition(function Trig_exp_and_gold_Conditions))
call TriggerAddAction(gg_trg_exp_and_gold,function Trig_exp_and_gold_Actions)
endfunction

function Trig_exp_and_gold_Actions takes nothing returns nothing           //a   ?
if(Trig_exp_and_gold_Func001C())then
if(Trig_exp_and_gold_Func001Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_SP2=GetUnitLoc(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
if(Trig_exp_and_gold_Func001Func001Func006C())then        //a 1
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+(GetUnitPointValue(GetTriggerUnit())/2))
set udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+(GetUnitPointValue(GetTriggerUnit())/2)+50)
else
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+GetUnitPointValue(GetTriggerUnit()))
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],true)
call SetHeroXP(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],true)
call AdjustPlayerStateBJ(R2I((I2R(GetUnitPointValue(GetTriggerUnit()))*0.50)),GetOwningPlayer(GetKillingUnitBJ()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+R2I((I2R(GetUnitPointValue(GetTriggerUnit()))*0.50)))
call CreateTextTagUnitBJ(("+"+I2S((GetUnitPointValue(GetTriggerUnit())*1))),GetTriggerUnit(),90.00,10,100.00,100.00,0.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),1.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),0.50)
else
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_SP2=GetUnitLoc(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
if(Trig_exp_and_gold_Func001Func001Func003C())then                    //a 2
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=R2I((I2R(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+((I2R(GetUnitPointValue(GetTriggerUnit()))*0.50)/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))-I2R(GetUnitLevel(GetTriggerUnit()))))))
set udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=R2I((I2R(udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+((I2R(GetUnitPointValue(GetTriggerUnit()))*0.50)/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))-I2R(GetUnitLevel(GetTriggerUnit()))))))
else
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=R2I((I2R(udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])+((I2R(GetUnitPointValue(GetTriggerUnit()))*1.00)/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))-I2R(GetUnitLevel(GetTriggerUnit()))))))
endif
call SetHeroXP(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],true)
call SetHeroXP(udg_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],true)
call AdjustPlayerStateBJ(R2I((I2R(GetUnitPointValue(GetTriggerUnit()))*(1/(I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))-I2R(GetUnitLevel(GetTriggerUnit())))))),GetOwningPlayer(GetKillingUnitBJ()),PLAYER_STATE_RESOURCE_GOLD)
set udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=(udg_GOLD[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]+R2I((I2R(GetUnitPointValue(GetTriggerUnit()))*(I2R(GetUnitLevel(GetTriggerUnit()))/I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))))))
call CreateTextTagUnitBJ(("+"+I2S(R2I((I2R(GetUnitPointValue(GetTriggerUnit()))*(I2R(GetUnitLevel(GetTriggerUnit()))/I2R(GetHeroLevel(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]))))))),GetTriggerUnit(),90.00,10,100.00,100.00,0.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),1.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),0.50)
endif
if(Trig_exp_and_gold_Func001Func002C())then
set udg_EXP_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=656260
else
endif
if(Trig_exp_and_gold_Func001Func003C())then
set udg_EXP_HERO_BB[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=656260
else
endif
else
set udg_K=1
loop
exitwhen udg_K>12
if(Trig_exp_and_gold_Func001Func004Func001C())then
set udg_SP=GetUnitLoc(GetKillingUnitBJ())
set udg_SP2=GetUnitLoc(udg_HERO[udg_K])
set udg_SP3=GetUnitLoc(udg_HERO_BB[udg_K])
if(Trig_exp_and_gold_Func001Func004Func001Func004C())then
if(Trig_exp_and_gold_Func001Func004Func001Func004Func001C())then
set udg_EXP=R2I(((I2R(GetUnitPointValue(GetTriggerUnit()))*1.00)*((1+(0.40*I2R(CountPlayersInForceBJ(GetPlayersMatching(Condition(function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func002002001003001003003001001001))))))/I2R(CountPlayersInForceBJ(GetPlayersMatching(Condition(function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func002002001003003001001001)))))))
else
set udg_EXP=R2I(((I2R(GetUnitPointValue(GetTriggerUnit()))*(1/(I2R(GetHeroLevel(udg_HERO[udg_K]))-I2R(GetUnitLevel(GetTriggerUnit())))))*((1+(0.40*I2R(CountPlayersInForceBJ(GetPlayersMatching(Condition(function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func001002001003001003003001001001))))))/I2R(CountPlayersInForceBJ(GetPlayersMatching(Condition(function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func001002001003003001001001)))))))
endif
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002C())then
call DoNothing()
else
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001C())then
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func005001())then
set udg_EXP_HERO[udg_K]=(udg_EXP_HERO[udg_K]+(udg_EXP/2))
else
call DoNothing()
endif                                                  //a  3
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func006001())then
set udg_EXP_HERO_BB[udg_K]=(udg_EXP_HERO_BB[udg_K]+(udg_EXP/2))
else
call DoNothing()
endif
call SetHeroXP(udg_HERO[udg_K],udg_EXP_HERO[udg_K],true)
call SetHeroXP(udg_HERO_BB[udg_K],udg_EXP_HERO_BB[udg_K],true)
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func009001())then
call AdjustPlayerStateBJ(udg_EXP,ConvertedPlayer(udg_K),PLAYER_STATE_RESOURCE_GOLD)
else
call DoNothing()
endif
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func010001())then
set udg_GOLD[udg_K]=(udg_GOLD[udg_K]+udg_EXP)
else
call DoNothing()
endif
else
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func001001())then
set udg_EXP_HERO[udg_K]=(udg_EXP_HERO[udg_K]+udg_EXP)
else
call DoNothing()
endif
call SetHeroXP(udg_HERO[udg_K],udg_EXP_HERO[udg_K],true)
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func003001())then
call AdjustPlayerStateBJ(udg_EXP,ConvertedPlayer(udg_K),PLAYER_STATE_RESOURCE_GOLD)
else
call DoNothing()
endif
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func001Func004001())then
set udg_GOLD[udg_K]=(udg_GOLD[udg_K]+udg_EXP)
else
call DoNothing()
endif
endif
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func002C())then
set udg_EXP_HERO[udg_K]=656260
else
endif
if(Trig_exp_and_gold_Func001Func004Func001Func004Func002Func003C())then
set udg_EXP_HERO_BB[udg_K]=656260
else
endif
endif
call CreateTextTagUnitBJ(("+"+I2S(udg_EXP)),udg_HERO[udg_K],90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),1.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),0.50)
else
endif
call RemoveLocation(udg_SP)
call RemoveLocation(udg_SP2)
else
endif
set udg_K=udg_K+1
endloop
endif
endfunction

function Trig_exp_and_gold_Conditions takes nothing returns boolean
if(not(GetPlayerController(GetOwningPlayer(GetKillingUnitBJ()))==MAP_CONTROL_USER))then
return false
endif
if(not(GetPlayerController(GetOwningPlayer(GetTriggerUnit()))!=MAP_CONTROL_USER))then
return false
endif
return true
endfunction

function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func002002001003001003003001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
endfunction

function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func002002001003003001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
endfunction

function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func001002001003001003003001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
endfunction

function Trig_exp_and_gold_Func001Func004Func001Func004Func001Func001002001003003001001001 takes nothing returns boolean
return(udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetFilterPlayer())]==udg_PLAY_GROUP_NO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
endfunction