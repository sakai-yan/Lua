//=========================================================================== 
// Trigger: set skill
//=========================================================================== 
function InitTrig_set_skill takes nothing returns nothing
set gg_trg_set_skill=CreateTrigger()
call TriggerAddAction(gg_trg_set_skill,function Trig_set_skill_Actions)
endfunction

function Trig_set_skill_Actions takes nothing returns nothing
set udg_SKILL_f[1]='mt02'
set udg_SKILL_f[2]='AHhb'
set udg_SKILL_f[3]='Ainf'
set udg_SKILL_f[4]='Acri'
set udg_SKILL_f[5]='Aadm'              //cd  ʱ��
set udg_SKILL_f[6]='ACsl'
set udg_SKILL_f[7]='A011'
set udg_SKILL_f[8]='AOsf'
set udg_SKILL_f[9]='AHbz'
set udg_SKILL_f[10]='AEer'
set udg_SKILL_f[11]='AUfn'
set udg_SKILL_f[12]='Afae'
set udg_SKILL_f[13]='ACr2'
set udg_SKILL_f[14]='A002'
set udg_SKILL_f[15]='ANab'
set udg_SKILL_f[16]='A003'
set udg_SKILL_f[17]='ANrf'
set udg_SKILL_f[18]='A004'
set udg_SKILL_f[19]='A00G'
set udg_SKILL_f[20]='A05I'
set udg_SKILL_f[21]='Aslo'
set udg_SKILL_f[22]='Awrs'
set udg_SKILL_f[23]='Ambd'
set udg_SKILL_f[24]='A013'
set udg_SKILL_f[25]='A014'
set udg_SKILL_f[26]='A015'
set udg_SKILL_f[27]='A016'
set udg_SKILL_f[28]='A017'
set udg_SKILL_f[29]='ACfd'
set udg_SKILL_f[30]='A04B'
set udg_SKILL_f[31]='ANmo'
set udg_SKILL_f[32]='AUin'
set udg_SKILL_f[33]='AEtq'
set udg_SKILL_f[34]='A04I'
set udg_SKILL_f[35]='A04H'
set udg_SKILL_f[36]='A068'
set udg_SKILL_f[37]='A089'
set udg_SKILL_f[38]='bird'
set udg_SKILL_f[39]='bf60'
set udg_SKILL_f[40]='bf61'
set udg_SKILL_f[41]='bf63'
set udg_SKILL_f[42]='bf65'
set udg_SKILL_f[43]='bf67'
set udg_SKILL_f[44]='jss0'
set udg_SKILL_f[45]='jss3'
set udg_SKILL_f[46]='jss2'
set udg_SKILL_f[47]='pwp0'
set udg_SKILL_f[48]='nzl0'
set udg_SKILL_f[49]='Agu8'
set udg_SKILL_f[50]='Agu9'
set udg_SKILL_f[51]='mfpz'




endfunction