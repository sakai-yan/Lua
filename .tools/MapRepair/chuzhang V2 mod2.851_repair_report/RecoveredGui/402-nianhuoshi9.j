//=========================================================================== 
// Trigger: nianhuoshi9
//=========================================================================== 
function InitTrig_nianhuoshi9 takes nothing returns nothing
set gg_trg_nianhuoshi9=CreateTrigger()
call TriggerRegisterUnitInRangeSimple(gg_trg_nianhuoshi9,356.00,gg_unit_nfr2_0125)
call TriggerAddCondition(gg_trg_nianhuoshi9,Condition(function Trig_nianhuoshi9_Conditions))
call TriggerAddAction(gg_trg_nianhuoshi9,function Trig_nianhuoshi9_Actions)
endfunction

function Trig_nianhuoshi9_Actions takes nothing returns nothing
if(Trig_nianhuoshi9_Func001C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'pnvu')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_MP_nianhuoshi7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=true
set udg_SP=GetUnitLoc(gg_unit_nfr2_0125)
if(Trig_nianhuoshi9_Func001Func010001())then
call PlaySoundAtPointBJ(gg_snd_QuestCompleted,100,udg_SP,0)
else
call DoNothing()
endif
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC恭喜你成为了真正的念火师，用火的炙热来烧尽世间一切丑恶吧！\n|r|cFFFF9900完|r|cFFFFB226成|r|cFFFFCC4C任|r|cFFFFE673务|r|cFFFFFF99：|r|cFF00FFFF火之试炼\n\n|r|cFF00FF00成|r|cFF00FF55功|r|cFF00FFAA转|r|cFF00FFFF职|r|cFFCCFFCC?")
if(Trig_nianhuoshi9_Func001Func012001())then
call PlaySoundAtPointBJ(gg_snd_ArrangedTeamInvitation,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
call UnitRemoveAbilityBJ('AUfn',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A004',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A08A',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('ANab',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+2)]='A004'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+3)]='A08A'

set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+5)]='A002'
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+6)]='ANab'      //1


call UnitRemoveAbilityBJ('A027',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A02S',udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
set udg_skill[(((GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))-1)*7)+4)]='A02S'
set udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=1
else
call DisplayTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,"|cFFFFCC00胡不留：|r|cFFCCFFCC到龙骨瀑布顶部寻找到|r|cFF00FF00遗失铁环|r|cFFCCFFCC，它应该被藏在某个|r|cFF00FF00龙骨守护者|r|cFFCCFFCC的身上。|r")
set udg_SP=GetRectCenter(gg_rct_longgu_mdd)
call PingMinimapLocForForce(udg_player[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],udg_SP,10.00)
if(Trig_nianhuoshi9_Func001Func004001())then
call PlaySoundAtPointBJ(gg_snd_SecretFound,100,udg_SP,0)
else
call DoNothing()
endif
call RemoveLocation(udg_SP)
endif
endfunction

function Trig_nianhuoshi9_Conditions takes nothing returns boolean
if(not(udg_MP_nianhuoshi6[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==true))then
return false
endif
if(not(udg_MP_nianhuoshi7[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==false))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_HERO)==true))then
return false
endif
if(not(IsUnitType(GetTriggerUnit(),UNIT_TYPE_TAUREN)==false))then
return false
endif
if(not(udg_ZZ_1[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]==0))then
return false
endif
return true
endfunction