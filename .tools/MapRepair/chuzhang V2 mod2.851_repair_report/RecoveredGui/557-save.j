//=========================================================================== 
// Trigger: save
//=========================================================================== 
function InitTrig_save takes nothing returns nothing
set gg_trg_save=CreateTrigger()
call TriggerAddAction(gg_trg_save,function Trig_save_Actions)
endfunction

function Trig_save_Actions takes nothing returns nothing
set udg_j=1
loop
exitwhen udg_j>12
if(Trig_save_Func001Func001C())then
set udg_ListFile[udg_j]=IniReadString((udg_War3Path[(udg_j-1)]+udg_FileName),"FileName","ListFile","",(udg_j-1),GetPlayerId(GetLocalPlayer()))
if(Trig_save_Func001Func001Func002C())then
set udg_pid[udg_j]=GetStoredIntegerBJ("Nubmer",("CacheListFile"+I2S((udg_j-1))),udg_Cache)
set udg_pid[udg_j]=(udg_pid[udg_j]+1)
set udg_File[(udg_j-1)]=I2S(udg_pid[udg_j])
set udg_ListFile[udg_j]=(udg_ListFile[udg_j]+(GetHeroProperName(udg_HERO[udg_j])+("等级"+(I2S(GetHeroLevel(udg_HERO[udg_j]))+("|"+(udg_File[(udg_j-1)]+"|"))))))
call AnalyzeList(udg_ListFile[udg_j],udg_j-1)
else
set udg_ListFile[udg_j]=GetCacheFilePath(udg_j-1)
endif
set udg_pid[udg_j]=IniWriteString((udg_War3Path[(udg_j-1)]+udg_FileName),"FileName","ListFile",udg_ListFile[udg_j],(udg_j-1),GetPlayerId(GetLocalPlayer()))
set udg_pid[udg_j]=GetUnitTypeId(udg_HERO[udg_j])
set udg_s[udg_j]=I2S(udg_pid[udg_j])
set udg_pid[udg_j]=GetHeroLevel(udg_HERO[udg_j])
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_EXP_HERO[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+1]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+2]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+3]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+4]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+5]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+6]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_skill[(udg_j-1)*7+7]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=GetPlayerState(ConvertedPlayer(udg_j),PLAYER_STATE_RESOURCE_GOLD)
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=GetPlayerState(ConvertedPlayer(udg_j),PLAYER_STATE_RESOURCE_LUMBER)
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Exp_JX_skill[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Exp_DX_skill[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Exp_FX_skill[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Exp_GX_skill[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Exp_QX_skill[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_Skillup_zhizao[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_JX_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_DX_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_FX_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_GX_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_QX_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_zhizao_lv[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=0
set bj_forLoopBIndexEnd=5
loop
exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
set udg_item[(((udg_j-1)*36)+GetForLoopIndexB())]=GetItemTypeId(UnitItemInSlot(udg_ITEM_BAG_A[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+GetForLoopIndexB()]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item[(((udg_j-1)*36)+(6+GetForLoopIndexB()))]=GetItemTypeId(UnitItemInSlot(udg_ITEM_BAG_B[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+(6+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item[(((udg_j-1)*36)+(12+GetForLoopIndexB()))]=GetItemTypeId(UnitItemInSlot(udg_ITEM_bag[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+(12+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item[(((udg_j-1)*36)+(18+GetForLoopIndexB()))]=GetItemTypeId(UnitItemInSlot(udg_HERO[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+(18+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item[(((udg_j-1)*36)+(24+GetForLoopIndexB()))]=GetItemTypeId(UnitItemInSlot(udg_ITEM_BAG_C[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+(24+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item[(((udg_j-1)*36)+(30+GetForLoopIndexB()))]=GetItemTypeId(UnitItemInSlot(udg_ITEM_BAG_D[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*36)+(30+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+GetForLoopIndexB())]=GetItemCharges(UnitItemInSlot(udg_ITEM_BAG_A[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+GetForLoopIndexB()]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+(6+GetForLoopIndexB()))]=GetItemCharges(UnitItemInSlot(udg_ITEM_BAG_B[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+(6+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+(12+GetForLoopIndexB()))]=GetItemCharges(UnitItemInSlot(udg_ITEM_bag[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+(12+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+(18+GetForLoopIndexB()))]=GetItemCharges(UnitItemInSlot(udg_HERO[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+(18+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+(24+GetForLoopIndexB()))]=GetItemCharges(UnitItemInSlot(udg_ITEM_BAG_C[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+(24+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*36)+(30+GetForLoopIndexB()))]=GetItemCharges(UnitItemInSlot(udg_ITEM_BAG_D[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*36)+(30+GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=bj_forLoopBIndex+1
endloop
set udg_pid[udg_j]=udg_ZZ_1[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_ZZ_0[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_hero_point[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_TIli_point[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_P_STR[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_P_AGI[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_P_INT[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_hero_SP_N[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_lingshou[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_ZZ_TY[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_XIA[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_SL[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_SLT[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_CH[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
if(Trig_save_Func001Func001Func085C())then
set udg_pid[udg_j]=udg_BB[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_EXP_HERO_BB[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_BB_SKILL[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=0
set bj_forLoopBIndexEnd=5
loop
exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
set udg_item[(((udg_j-1)*6)+bj_forLoopBIndex)]=udg_BB_ITEM[(((udg_j-1)*12)+(bj_forLoopBIndex+1))]
set udg_pid[udg_j]=udg_item[((udg_j-1)*6)+(GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*6)+bj_forLoopBIndex)]=udg_BB_ITEM_NUM[(((udg_j-1)*12)+(bj_forLoopBIndex+1))]
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*6)+(GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=bj_forLoopBIndex+1
endloop
else
set udg_BB_LV[udg_j]=GetHeroLevel(udg_HERO_BB[udg_j])
set udg_BB[udg_j]=((((((udg_BB_TYPE[udg_j]*1000000)+(udg_BB_LV[udg_j]*10000))+(udg_BB_STR[udg_j]*1000))+(udg_BB_AGI[udg_j]*100))+(udg_BB_INT[udg_j]*10))+udg_BB_HP[udg_j])
set udg_pid[udg_j]=udg_BB[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_EXP_HERO_BB[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_BB_SKILL[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=0
set bj_forLoopBIndexEnd=5
loop
exitwhen bj_forLoopBIndex>bj_forLoopBIndexEnd
set udg_item[(((udg_j-1)*6)+bj_forLoopBIndex)]=GetItemTypeId(UnitItemInSlot(udg_HERO_BB[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item[((udg_j-1)*6)+(GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_item_num[(((udg_j-1)*6)+bj_forLoopBIndex)]=GetItemCharges(UnitItemInSlot(udg_HERO_BB[udg_j],GetForLoopIndexB()))
set udg_pid[udg_j]=udg_item_num[((udg_j-1)*6)+(GetForLoopIndexB())]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set bj_forLoopBIndex=bj_forLoopBIndex+1
endloop
endif
set udg_pid[udg_j]=udg_V_00[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_pid[udg_j]=udg_LiQi[udg_j]
set udg_s[udg_j]=(udg_s[udg_j]+("|"+I2S(udg_pid[udg_j])))
set udg_s[udg_j]=(udg_s[udg_j]+"|")
set udg_s[udg_j]=CodeString(udg_s[udg_j])
set udg_pid[udg_j]=IniWriteString((udg_War3Path[(udg_j-1)]+udg_FileName),("Hero"+udg_File[(udg_j-1)]),"Date",udg_s[udg_j],(udg_j-1),GetPlayerId(GetLocalPlayer()))
set udg_s[udg_j]=I2S(GetFingerMark(udg_s[udg_j],51687788))
set udg_pid[udg_j]=IniWriteString((udg_War3Path[(udg_j-1)]+udg_FileName),("Hero"+udg_File[(udg_j-1)]),"DateStock",udg_s[udg_j],(udg_j-1),GetPlayerId(GetLocalPlayer()))
else
endif
set udg_j=udg_j+1
endloop
endfunction