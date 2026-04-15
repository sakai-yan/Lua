//=========================================================================== 
// Trigger: J ZZKLMR2
//=========================================================================== 
function InitTrig_J_ZZKLMR2 takes nothing returns nothing
set gg_trg_J_ZZKLMR2=CreateTrigger()
call TriggerRegisterEnterRectSimple(gg_trg_J_ZZKLMR2,GetCurrentCameraBoundsMapRectBJ())
call TriggerAddCondition(gg_trg_J_ZZKLMR2,Condition(function Trig_J_ZZKLMR2_Conditions))
call TriggerAddAction(gg_trg_J_ZZKLMR2,function Trig_J_ZZKLMR2_Actions)
endfunction

function Trig_J_ZZKLMR2_Actions takes nothing returns nothing
if(Trig_J_ZZKLMR2_Func001C())then
call SetItemCharges(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'fgun'),(GetItemCharges(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'fgun'))-1))
call SetItemCharges(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'tmmt'),(GetItemCharges(GetItemOfTypeFromUnitBJ(udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],'tmmt'))-1))
call SetUnitAbilityLevelSwapped('A005',GetTriggerUnit(),udg_zhizao_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
call UnitAddAbilityBJ('A00X',GetTriggerUnit())
if(Trig_J_ZZKLMR2_Func001Func014C())then
call SetUnitAbilityLevelSwapped('A00X',GetTriggerUnit(),(((GetHeroStatBJ(bj_HEROSTAT_INT,udg_HERO[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))],false)*2)+((udg_FX_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]*3)+R2I(udg_FX[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])))/100))
else
call SetUnitAbilityLevelSwapped('A00X',GetTriggerUnit(),1)
endif
call UnitRemoveAbilityBJ('A00X',GetTriggerUnit())
else
call KillUnit(GetTriggerUnit())
call CreateTextTagUnitBJ("材料不足",GetTriggerUnit(),90.00,10,50.00,50.00,50.00,0)
call SetTextTagPermanent(GetLastCreatedTextTag(),false)
call SetTextTagLifespan(GetLastCreatedTextTag(),2.00)
call SetTextTagVelocityBJ(GetLastCreatedTextTag(),64,90)
call SetTextTagFadepoint(GetLastCreatedTextTag(),2.00)
if(Trig_J_ZZKLMR2_Func001Func009001())then
call PlaySoundBJ(gg_snd_QuestLog)
else
call DoNothing()
endif
endif
endfunction

function Trig_J_ZZKLMR2_Conditions takes nothing returns boolean
if(not(GetUnitTypeId(GetTriggerUnit())=='nsoc'))then
return false
endif
return true
endfunction