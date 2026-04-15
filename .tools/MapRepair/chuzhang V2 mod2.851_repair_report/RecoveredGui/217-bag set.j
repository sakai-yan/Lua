//=========================================================================== 
// Trigger: bag set
//=========================================================================== 
function InitTrig_bag_set takes nothing returns nothing
set gg_trg_bag_set=CreateTrigger()
call TriggerAddAction(gg_trg_bag_set,function Trig_bag_set_Actions)
endfunction

function Trig_bag_set_Actions takes nothing returns nothing
set udg_ITEM_BAG_A[1]=gg_unit_hwtw_0031
set udg_ITEM_BAG_B[1]=gg_unit_hwtw_0032
set udg_ITEM_BAG_C[1]=gg_unit_hwtw_0033
set udg_ITEM_BAG_D[1]=gg_unit_hwtw_0371
set udg_ITEM_BAG_E[1]=gg_unit_hwtw_0399
set udg_ITEM_bag[1]=gg_unit_hpea_0039
set udg_ITEM_BAG_A[2]=gg_unit_hwtw_0040
set udg_ITEM_BAG_B[2]=gg_unit_hwtw_0041
set udg_ITEM_BAG_C[2]=gg_unit_hwtw_0042
set udg_ITEM_BAG_D[2]=gg_unit_hwtw_0388
set udg_ITEM_BAG_E[2]=gg_unit_hwtw_0400
set udg_ITEM_bag[2]=gg_unit_hpea_0043
set udg_ITEM_BAG_A[3]=gg_unit_hwtw_0044
set udg_ITEM_BAG_B[3]=gg_unit_hwtw_0045
set udg_ITEM_BAG_C[3]=gg_unit_hwtw_0046
set udg_ITEM_BAG_D[3]=gg_unit_hwtw_0389
set udg_ITEM_BAG_E[3]=gg_unit_hwtw_0401
set udg_ITEM_bag[3]=gg_unit_hpea_0047
set udg_ITEM_BAG_A[4]=gg_unit_hwtw_0048
set udg_ITEM_BAG_B[4]=gg_unit_hwtw_0049
set udg_ITEM_BAG_C[4]=gg_unit_hwtw_0050
set udg_ITEM_BAG_D[4]=gg_unit_hwtw_0390
set udg_ITEM_BAG_E[4]=gg_unit_hwtw_0403
set udg_ITEM_bag[4]=gg_unit_hpea_0051
set udg_ITEM_BAG_A[5]=gg_unit_hwtw_0052
set udg_ITEM_BAG_B[5]=gg_unit_hwtw_0053
set udg_ITEM_BAG_C[5]=gg_unit_hwtw_0054
set udg_ITEM_BAG_D[5]=gg_unit_hwtw_0391
set udg_ITEM_BAG_E[5]=gg_unit_hwtw_0404
set udg_ITEM_bag[5]=gg_unit_hpea_0058
set udg_ITEM_BAG_A[6]=gg_unit_hwtw_0055
set udg_ITEM_BAG_B[6]=gg_unit_hwtw_0056
set udg_ITEM_BAG_C[6]=gg_unit_hwtw_0057
set udg_ITEM_BAG_D[6]=gg_unit_hwtw_0392
set udg_ITEM_BAG_E[6]=gg_unit_hwtw_0405
set udg_ITEM_bag[6]=gg_unit_hpea_0059
set udg_ITEM_BAG_A[7]=gg_unit_hwtw_0060
set udg_ITEM_BAG_B[7]=gg_unit_hwtw_0061
set udg_ITEM_BAG_C[7]=gg_unit_hwtw_0062
set udg_ITEM_BAG_D[7]=gg_unit_hwtw_0393
set udg_ITEM_BAG_E[7]=gg_unit_hwtw_0406
set udg_ITEM_bag[7]=gg_unit_hpea_0063
set udg_ITEM_BAG_A[8]=gg_unit_hwtw_0064
set udg_ITEM_BAG_B[8]=gg_unit_hwtw_0065
set udg_ITEM_BAG_C[8]=gg_unit_hwtw_0066
set udg_ITEM_BAG_D[8]=gg_unit_hwtw_0394
set udg_ITEM_BAG_E[8]=gg_unit_hwtw_0407
set udg_ITEM_bag[8]=gg_unit_hpea_0067
set udg_ITEM_BAG_A[9]=gg_unit_hwtw_0068
set udg_ITEM_BAG_B[9]=gg_unit_hwtw_0069
set udg_ITEM_BAG_C[9]=gg_unit_hwtw_0070
set udg_ITEM_BAG_D[9]=gg_unit_hwtw_0395
set udg_ITEM_BAG_E[9]=gg_unit_hwtw_0408
set udg_ITEM_bag[9]=gg_unit_hpea_0071
set udg_ITEM_BAG_A[10]=gg_unit_hwtw_0072
set udg_ITEM_BAG_B[10]=gg_unit_hwtw_0073
set udg_ITEM_BAG_C[10]=gg_unit_hwtw_0074
set udg_ITEM_BAG_D[10]=gg_unit_hwtw_0396
set udg_ITEM_BAG_E[10]=gg_unit_hwtw_0409
set udg_ITEM_bag[10]=gg_unit_hpea_0075
set udg_ITEM_BAG_A[11]=gg_unit_hwtw_0076
set udg_ITEM_BAG_B[11]=gg_unit_hwtw_0077
set udg_ITEM_BAG_C[11]=gg_unit_hwtw_0078
set udg_ITEM_BAG_D[11]=gg_unit_hwtw_0397
set udg_ITEM_BAG_E[11]=gg_unit_hwtw_0410
set udg_ITEM_bag[11]=gg_unit_hpea_0079
set udg_ITEM_BAG_A[12]=gg_unit_hwtw_0080
set udg_ITEM_BAG_B[12]=gg_unit_hwtw_0081
set udg_ITEM_BAG_C[12]=gg_unit_hwtw_0082
set udg_ITEM_BAG_D[12]=gg_unit_hwtw_0398
set udg_ITEM_BAG_E[12]=gg_unit_hwtw_0411
set udg_ITEM_bag[12]=gg_unit_hpea_0083
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=12
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_ITEM_CL1[(((bj_forLoopAIndex-1)*12)+1)]=udg_ITEM_bag[bj_forLoopAIndex]
set udg_ITEM_CL1[(((bj_forLoopAIndex-1)*12)+2)]=udg_ITEM_BAG_A[bj_forLoopAIndex]
set udg_ITEM_CL1[(((bj_forLoopAIndex-1)*12)+3)]=udg_ITEM_BAG_B[bj_forLoopAIndex]
set udg_ITEM_CL1[(((bj_forLoopAIndex-1)*12)+4)]=udg_ITEM_BAG_C[bj_forLoopAIndex]
set udg_ITEM_CL1[(((bj_forLoopAIndex-1)*12)+5)]=udg_ITEM_BAG_D[bj_forLoopAIndex]
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
endfunction