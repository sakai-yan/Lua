//=========================================================================== 
// Trigger: hero chose1
//=========================================================================== 
function InitTrig_hero_chose1 takes nothing returns nothing
set gg_trg_hero_chose1=CreateTrigger()
call TriggerAddAction(gg_trg_hero_chose1,function Trig_hero_chose1_Actions)
endfunction

function Trig_hero_chose1_Actions takes nothing returns nothing
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=12
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
call DialogClear(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())])
call DialogSetMessage(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"请选择初始门派")
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"御剑门")  //  ������
set udg_HERO_SET_1[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"太虚观")  // ̫��
set udg_HERO_SET_2[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"法魂门") //  ����
set udg_HERO_SET_3[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"少林寺") //  ����
set udg_HERO_SET_4[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"月刀门") //  �µ�
set udg_HERO_SET_5[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"鬼冢")   //   ��ڣ
set udg_HERO_SET_6[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"清心阁") //  ���ĸ�
set udg_HERO_SET_7[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogAddButtonBJ(udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],"返回")    //  ����
set udg_HERO_SET_9[GetConvertedPlayerId(GetTriggerPlayer())]=GetLastCreatedButtonBJ()
call DialogDisplay(ConvertedPlayer(GetConvertedPlayerId(GetTriggerPlayer())),udg_HERO_SET[GetConvertedPlayerId(GetTriggerPlayer())],true)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
endfunction