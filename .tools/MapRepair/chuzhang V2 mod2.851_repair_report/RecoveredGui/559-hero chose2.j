//=========================================================================== 
// Trigger: hero chose2
//=========================================================================== 
function InitTrig_hero_chose2 takes nothing returns nothing
set gg_trg_hero_chose2=CreateTrigger()
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[1])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[2])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[3])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[4])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[5])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[6])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[7])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[8])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[9])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[10])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[11])
call TriggerRegisterDialogEventBJ(gg_trg_hero_chose2,udg_HERO_SET[12])
call TriggerAddAction(gg_trg_hero_chose2,function Trig_hero_chose2_Actions)
endfunction

function Trig_hero_chose2_Actions takes nothing returns nothing
if(Trig_hero_chose2_Func001C())then
set udg_M_YJM[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])            //  ������
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")    //  ѡ���ɫ
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"侠客")    // ����
set udg_MDX_set_1[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"枭雄")   // ����
set udg_MDX_set_4[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"白衣")   //  ����
set udg_MDX_set_5[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"豆丁")   //  ����
set udg_MDX_set_11[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func002C())then
set udg_M_TXM[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])         // ̫��
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"侠客")   // ����
set udg_MDX_set_1[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"红颜")   //  ����
set udg_MDX_set_3[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"枭雄")   //  ����
set udg_MDX_set_4[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func003C())then
set udg_M_FHM[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])           //  ����
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"儒生")   //  ����
set udg_MDX_set_6[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"佳人")   //   ����
set udg_MDX_set_7[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func004C())then
set udg_M_SLS[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])             //  ����
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"方丈")   //����
set udg_MDX_set_8[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"怒熊")   // ��
set udg_MDX_set_9[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"猛将")  //  �ͽ�
set udg_MDX_set_10[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"壮士")     // ׳ʿ
set udg_MDX_set_12[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"老江�?")   //�Ͻ���
set udg_MDX_set_14[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func005C())then
set udg_M_PDM[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])                 //  �µ�
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"怒熊")  //  ��
set udg_MDX_set_9[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"侠客") //  ����
set udg_MDX_set_1[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"猛将")  //  �ͽ�
set udg_MDX_set_10[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"老江�?")   //�Ͻ���
set udg_MDX_set_14[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func006C())then
set udg_M_GM[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])             //   ��ڣ
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"武姬")    //
set udg_MDX_set_2[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"惊羽")    //
set udg_MDX_set_13[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func007C())then
set udg_M_SNG[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])          //  ���ĸ�
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"佳人") //����
set udg_MDX_set_7[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"红颜")  //����
set udg_MDX_set_3[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func008C())then
set udg_M_QMF[GetConvertedPlayerId(GetTriggerPlayer())]=true
call DialogClear(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())])            // ��ľ��
call DialogSetMessage(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择角色")
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"豆丁")   //  ����
set udg_MDX_set_11[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],"壮士")     // ׳ʿ
set udg_MDX_set_12[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(GetTriggerPlayer(),udg_MDX_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
else
call DoNothing()
endif
if(Trig_hero_chose2_Func009C())then
call ReadSaveFile(GetTriggerPlayer(),0)
else
call DoNothing()
endif
endfunction