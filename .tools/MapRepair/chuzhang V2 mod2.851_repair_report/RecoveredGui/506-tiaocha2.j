//=========================================================================== 
// Trigger: tiaocha2
//=========================================================================== 
function InitTrig_tiaocha2 takes nothing returns nothing
set gg_trg_tiaocha2=CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(gg_trg_tiaocha2,EVENT_PLAYER_UNIT_DEATH)
call TriggerAddAction(gg_trg_tiaocha2,function Trig_tiaocha2_Actions)
endfunction

function Trig_tiaocha2_Actions takes nothing returns nothing
if(Trig_tiaocha2_Func001C())then
if(Trig_tiaocha2_Func001Func001C())then
call UnitAddItemByIdSwapped('shcw',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))])
set udg_tiaocha2[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))]=true
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
if(Trig_tiaocha2_Func001Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetKillingUnitBJ()),0,0,"|cFFFF6600接|r|cFFFF8C26受|r|cFFFFB24C任|r|cFFFFD973务|r|cFFFFFF99：|r|cFF00FFFF调查苗寨\n|r|cFFFF6600任|r|cFFFF8C26务|r|cFFFFB24C要|r|cFFFFD973求|r|cFFFFFF99：|r|cFF00FF00从某个巡逻的苗民身上找线索\n\n|r|cFFFFCC00石中保：|r|cFFCCFFCC我派出去的探子都无功而返，苗人的行踪是在诡异啊。这让我连睡觉都合不上眼睛。大侠务必帮助我们龙泉镇。以你的能力，大可直接找个苗人来质问细节的，快去吧！|r")
call RemoveLocation(udg_SP)
set udg_SP=GetUnitLoc(gg_unit_ncnk_0296)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetKillingUnitBJ()))],udg_SP,30.00)
call RemoveLocation(udg_SP)
else
endif
else
endif
endfunction