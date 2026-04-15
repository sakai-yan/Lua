//=========================================================================== 
// Trigger: shanchu
//=========================================================================== 
function InitTrig_shanchu takes nothing returns nothing
set gg_trg_shanchu=CreateTrigger()
call TriggerAddAction(gg_trg_shanchu,function Trig_shanchu_Actions)
endfunction

function Trig_shanchu_Actions takes nothing returns nothing
if(Trig_shanchu_Func001C())then
set udg_Exp_zhizuo_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_Exp_zhizuo_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
if(Trig_shanchu_Func001Func002C())then
set udg_Exp_zhizuo_skill[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=0
set udg_zhizao_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=(udg_zhizao_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]+1)
call DisplayTimedTextToPlayer(GetOwningPlayer(GetTriggerUnit()),0,0,30,("你的制造熟练度达到了"+(I2S(udg_zhizao_lv[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])+"级")))
call AddSpecialEffectTargetUnitBJ("origin",GetSpellAbilityUnit(),"Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl")
call DestroyEffect(GetLastCreatedEffectBJ())
return
else
call DoNothing()
endif
else
endif
if(Trig_shanchu_Func002C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fgun')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func003C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'ram1')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func004C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'fwss')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func005C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tels')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func006C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'oflg')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func007C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'axas')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func008C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'asbl')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func009C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'amrc')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func010C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tmmt')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func011C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'schl')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func012C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'sor4')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func013C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'sor2')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func014C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'sor3')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func015C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tbak')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func016C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'tbsm')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func017C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'hbth')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func018C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'shrs')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func019C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'thdm')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func020C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'rej6')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
if(Trig_shanchu_Func021C())then
set udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))]=GetItemOfTypeFromUnitBJ(GetSpellTargetUnit(),'I01E')
call Removeitem2(udg_tempitem[GetConvertedPlayerId(GetOwningPlayer(GetTriggerUnit()))])
else
endif
endfunction