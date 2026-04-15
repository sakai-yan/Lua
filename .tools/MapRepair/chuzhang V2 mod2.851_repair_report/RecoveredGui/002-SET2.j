//=========================================================================== 
// Trigger: SET2
//=========================================================================== 
function InitTrig_SET2 takes nothing returns nothing
set gg_trg_SET2=CreateTrigger()
call TriggerRegisterTimerEventSingle(gg_trg_SET2,6.00)
call TriggerAddAction(gg_trg_SET2,function Trig_SET2_Actions)
endfunction

function Trig_SET2_Actions takes nothing returns nothing
call TriggerExecute(gg_trg_P)
call SetSkyModel("Environment\\Sky\\BlizzardSky\\BlizzardSky.mdl")
call StopMusic(true)
call ClearMapMusic()
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=11
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set bj_forLoopBIndex=1
set bj_forLoopBIndexEnd=11
loop
exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
call SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexA()),ConvertedPlayer(GetForLoopIndexB()),bj_ALLIANCE_ALLIED)
call SetPlayerAllianceStateBJ(ConvertedPlayer(GetForLoopIndexB()),ConvertedPlayer(GetForLoopIndexA()),bj_ALLIANCE_ALLIED)
set bj_forLoopBIndex=bj_forLoopBIndex+1
endloop
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
call ForForce(GetPlayersAll(),function Trig_SET2_Func006A)
call EnableTrigger(gg_trg_set_goldandwood)
call AddItemToStockBJ('drph',gg_unit_nbsw_0359,1,1)
call AddItemToStockBJ('drph',gg_unit_nbsw_0362,1,1)
call AddItemToStockBJ('drph',gg_unit_nbsw_0360,1,1)
call AddItemToStockBJ('drph',gg_unit_nbsw_0361,1,1)
call AddItemToStockBJ('drph',gg_unit_nbsw_0476,1,1)
call AddItemToStockBJ('drph',gg_unit_nbsw_0713,1,1)
call AddItemToStockBJ('pnvl',gg_unit_npfm_0604,1,1)
call AddItemToStockBJ('moon',gg_unit_npfm_0604,1,1)
call AddItemToStockBJ('moon',gg_unit_npfm_0603,1,1)
call AddItemToStockBJ('vamp',gg_unit_npfm_0603,1,1)
call AddItemToStockBJ('vamp',gg_unit_npfm_0249,1,1)
call AddItemToStockBJ('pnvl',gg_unit_npfm_0249,1,1)
call AddItemToStockBJ('hslv',gg_unit_nfpl_0606,1,1)
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ncnk_0296,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nanm_0508,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ndrp_0299,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ndtt_0383,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nlv3_0350,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nwnr_0520,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nwen_0519,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nsel_0597,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nelb_0598,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_narg_0714,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nwwg_0719,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_zcso_0720,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ncgb_0629,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call SetUnitInvulnerable(gg_unit_nwc1_0216,true)
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngz1_0002,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_npn2_0009,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nmh0_0012,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngz2_0015,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nqb1_0093,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngzc_0094,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_npn6_0144,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngzd_0001,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngz3_0167,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngza_0168,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ncg1_0205,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nqb3_0248,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ncg3_0189,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ngnh_0123,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nfr2_0125,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nsha_0367,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_nshf_0235,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_npnw_0364,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call AddSpecialEffectTargetUnitBJ("overhead",gg_unit_ndh1_0368,"Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl")
call SetDestructableInvulnerable(gg_dest_LTrc_6606,true)
call SetDestructableInvulnerable(gg_dest_ZTsx_9678,true)
call WaygateActivateBJ(false,gg_unit_nwgt_0491)
set udg_SP3=GetRandomLocInRect(gg_rct______________104)
call IssuePointOrderLoc(gg_unit_nsc3_0506,"patrol",GetRectCenter(gg_rct______________104))
call ShowUnitHide(gg_unit_ndqn_0615)
call ShowUnitHide(gg_unit_nsko_0710)
call ShowUnitHide(gg_unit_nsko_0711)
call ShowUnitHide(gg_unit_nsko_0709)
call ShowUnitHide(gg_unit_nsko_0712)
call RemoveLocation(udg_SP3)
endfunction