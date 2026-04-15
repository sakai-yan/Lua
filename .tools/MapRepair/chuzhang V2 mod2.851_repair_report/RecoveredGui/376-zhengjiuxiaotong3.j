//=========================================================================== 
// Trigger: zhengjiuxiaotong3
//=========================================================================== 
function InitTrig_zhengjiuxiaotong3 takes nothing returns nothing
set gg_trg_zhengjiuxiaotong3=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_zhengjiuxiaotong3,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_zhengjiuxiaotong3,function Trig_zhengjiuxiaotong3_Actions)
endfunction

function Trig_zhengjiuxiaotong3_Actions takes nothing returns nothing
if(Trig_zhengjiuxiaotong3_Func001C())then
set udg_SP=GetUnitLoc(GetTriggerUnit())
call CreateNUnitsAtLoc(1,'nvlk',GetOwningPlayer(GetKillingUnitBJ()),udg_SP,bj_UNIT_FACING)
call UnitAddAbilityBJ('Sca4',GetLastCreatedUnit())
if(Trig_zhengjiuxiaotong3_Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call CreateTextTagUnitBJ("|cFFCCFFFF不要吃我，我要回家！！！|r",GetLastCreatedUnit(),140.00,10,100.00,100.00,100.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),3.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),40.00,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
set udg_SP2=GetUnitLoc(gg_unit_ncg1_0205)
call IssuePointOrderLoc(GetLastCreatedUnit(),"move",udg_SP2)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP2,10.00)
call RemoveLocation(udg_SP2)
else
endif
if(Trig_zhengjiuxiaotong3_Func002C())then
call ForForce(GetPlayersAll(),function Trig_zhengjiuxiaotong3_Func002Func001A)
else
endif
endfunction