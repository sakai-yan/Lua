//=========================================================================== 
// Trigger: set rw
//=========================================================================== 
function InitTrig_set_rw takes nothing returns nothing
set gg_trg_set_rw=CreateTrigger()
call TriggerAddAction(gg_trg_set_rw,function Trig_set_rw_Actions)
endfunction

function Trig_set_rw_Actions takes nothing returns nothing
set udg_R_shenggancao_p1[1]=GetRectCenter(gg_rct_shenggancao1)
set udg_R_shenggancao_p1[2]=GetRectCenter(gg_rct_shenggancao2)
set udg_R_shenggancao_p1[3]=GetRectCenter(gg_rct_shenggancao3)
set udg_R_shenggancao_p1[4]=GetRectCenter(gg_rct_shenggancao4)
set udg_R_shenggancao_p1[5]=GetRectCenter(gg_rct_shenggancao6)
set udg_R_shenggancao_p1[6]=GetRectCenter(gg_rct_shenggancao5)
set udg_R_qingzao_p1[1]=GetRectCenter(gg_rct_qingzao1)
set udg_R_qingzao_p1[2]=GetRectCenter(gg_rct_qingzao2)
set udg_R_qingzao_p1[3]=GetRectCenter(gg_rct_qingzao3)
set udg_R_qingzao_p1[4]=GetRectCenter(gg_rct_qingzao4)
set udg_R_qingzao_p1[5]=GetRectCenter(gg_rct_qingzao5)
set udg_R_qingzao_p1[6]=GetRectCenter(gg_rct_qingzao6)
set udg_R_qingzao_p1[7]=GetRectCenter(gg_rct_qingzao7)
set udg_R_qingzao_p1[8]=GetRectCenter(gg_rct_qingzao8)
set udg_R_xiufushizhen_p1[1]=GetRectCenter(gg_rct_shiliao1)
set udg_R_xiufushizhen_p1[2]=GetRectCenter(gg_rct_shiliao2)
set udg_R_xiufushizhen_p1[3]=GetRectCenter(gg_rct_shiliao3)
set udg_R_xiufushizhen_p1[4]=GetRectCenter(gg_rct_shiliao4)
set udg_R_xiufushizhen_p1[5]=GetRectCenter(gg_rct_shiliao5)
set udg_R_xiufushizhen_p1[6]=GetRectCenter(gg_rct_shiliao6)
set udg_R_xiufushizhen_p1[7]=GetRectCenter(gg_rct_shiliao7)
set udg_R_FS_hanwei_type[1]='nmrl'
set udg_R_FS_hanwei_type[2]='nmrr'
set udg_R_FS_hanwei_type[3]='nrzs'
set udg_R_FS_hanwei_type[4]='nmrm'
set udg_R_FS_hanwei_type[5]='nrzt'
set udg_R_FS_hanwei_type[6]='nrzb'
set udg_R_FS_hanwei_type[7]='nrzm'
set udg_R_FS_hanwei_type[8]='nqbh'

set udg_R_FS_hantmdweia_type[1]='tjg5'
set udg_R_FS_hantmdweia_type[2]='tjg6'
set udg_R_FS_hantmdweia_type[3]='tjg7'
set udg_R_FS_hantmdweia_type[4]='tjg8'
set udg_R_FS_hantmdweia_type[5]='tjg9'
set udg_R_FS_hantmdweia_type[6]='tjgA'
set udg_R_FS_hantmdweia_type[7]='tjgB'
set udg_R_FS_hantmdweia_type[8]='tjgC'
set udg_R_FS_hantmdweia_type[9]='tjgD'
set udg_R_FS_hantmdweia_type[10]='tjgE'
set udg_R_FS_hantmdweia_type[11]='tjgF'
set udg_R_FS_hantmdweia_type[12]='tjgG'
set udg_R_FS_hantmdweia_type[13]='tjgH'
set udg_R_FS_hantmdweia_type[14]='tjgI'
set udg_R_FS_hantmdweia_type[15]='tjgJ'
set udg_R_FS_hantmdweia_type[16]='tjgK'
set udg_R_FS_hantmdweia_type[17]='tjgL'
set udg_R_FS_hantmdweia_type[18]='tjgM'
set udg_R_FS_hantmdweia_type[19]='tjgN'
set udg_R_FS_hantmdweia_type[20]='tjgO'
set udg_R_FS_hantmdweia_type[21]='tjgP'
set udg_R_FS_hantmdweia_type[22]='tjgQ'
set udg_R_FS_hantmdweia_type[23]='tjgR'
set udg_R_FS_hantmdweia_type[24]='tjgS'
set udg_R_FS_hantmdweia_type[25]='tjgT'
set udg_R_FS_hantmdweia_type[26]='tjgU'
set udg_R_FS_hantmdweia_type[27]='tjgV'
set udg_R_yaohua_p1[1]=GetRectCenter(gg_rct_yaohua1)
set udg_R_yaohua_p1[2]=GetRectCenter(gg_rct_yaohua2)
set udg_R_yaohua_p1[3]=GetRectCenter(gg_rct_yaohua3)
set udg_R_yaohua_p1[4]=GetRectCenter(gg_rct_yaohua4)
set udg_R_tamuzhigen_p1[1]=GetRectCenter(gg_rct_tamu_p1)
set udg_R_tamuzhigen_p1[2]=GetRectCenter(gg_rct_tamu_p2)
set udg_R_tamuzhigen_p1[3]=GetRectCenter(gg_rct_tamu_p3)
set udg_R_tamuzhigen_p1[4]=GetRectCenter(gg_rct_tamu_p4)
set udg_R_tamuzhigen_p1[5]=GetRectCenter(gg_rct_tamu_p5)
set udg_R_tamuzhigen_p1[6]=GetRectCenter(gg_rct_tamu_p6)
set udg_MP_shengming_p1[1]=GetRectCenter(gg_rct_shengming1)
set udg_MP_shengming_p1[2]=GetRectCenter(gg_rct_shengming2)
set udg_MP_shengming_p1[3]=GetRectCenter(gg_rct_shengming3)
set udg_MP_shengming_p1[4]=GetRectCenter(gg_rct_shengming4)
set udg_MP_shengming_p1[5]=GetRectCenter(gg_rct_shengming5)
set udg_MP_shengming_p1[6]=GetRectCenter(gg_rct_shengming6)
set udg_MP_shengming_p1[7]=GetRectCenter(gg_rct_shengming7)
set udg_MP_shengming_p1[8]=GetRectCenter(gg_rct_shengming8)
set udg_MP_shengming_p2[1]=GetRectCenter(gg_rct_xuesi1)
set udg_MP_shengming_p2[2]=GetRectCenter(gg_rct_xuesi2)
set udg_MP_shengming_p2[3]=GetRectCenter(gg_rct_xuesi3)
set udg_MP_shengming_p2[4]=GetRectCenter(gg_rct_xuesi4)
set udg_MP_shengming_p2[5]=GetRectCenter(gg_rct_xuesi5)
set udg_MP_shengming_p2[6]=GetRectCenter(gg_rct_xuesi6)
set udg_MP_shengming_p2[7]=GetRectCenter(gg_rct_xuesi7)
set udg_R_zhigu_p1[1]=GetRectCenter(gg_rct_baihecao1)
set udg_R_zhigu_p1[2]=GetRectCenter(gg_rct_baihecao2)
set udg_R_zhigu_p1[3]=GetRectCenter(gg_rct_baihecao3)
set udg_R_zhigu_p1[4]=GetRectCenter(gg_rct_baihecao4)
set udg_R_zhigu_p1[5]=GetRectCenter(gg_rct_baihecao5)
endfunction