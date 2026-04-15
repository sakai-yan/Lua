//=========================================================================== 
// Trigger: herospN
//=========================================================================== 
function InitTrig_herospN takes nothing returns nothing
set gg_trg_herospN=CreateTrigger()
call TriggerAddAction(gg_trg_herospN,function Trig_herospN_Actions)
endfunction

function Trig_herospN_Actions takes nothing returns nothing
if(Trig_herospN_Func002C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________081________3)
else
if(Trig_herospN_Func002Func001C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________081_______u)
else
if(Trig_herospN_Func002Func001Func001C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________081)
else
if(Trig_herospN_Func002Func001Func001Func001C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________081________2)
else
if(Trig_herospN_Func002Func001Func001Func001Func001C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________100)
else
if(Trig_herospN_Func002Func001Func001Func001Func001Func001C())then
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________135)
else
set udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())]=GetRectCenter(gg_rct______________081________3)
endif
endif
endif
endif
endif
endif
call SetUnitPositionLoc(udg_HERO[GetConvertedPlayerId(GetTriggerPlayer())],udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())])
call PanCameraToTimedLocForPlayer(GetTriggerPlayer(),udg_hero_SP[GetConvertedPlayerId(GetTriggerPlayer())],0)
if(Trig_herospN_Func006C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='osw1'               //a ??
else
endif
if(Trig_herospN_Func007C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='osw2'
else
endif
if(Trig_herospN_Func008C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='osw3'
else
endif
if(Trig_herospN_Func009C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='nftt'
else
endif
if(Trig_herospN_Func010C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='nfel'
else
endif
if(Trig_herospN_Func011C())then
set udg_J_ls_type[GetConvertedPlayerId(GetTriggerPlayer())]='jcsy'
else
endif
//---

endfunction