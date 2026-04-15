//=========================================================================== 
// Trigger: lostitem
//=========================================================================== 
function InitTrig_lostitem takes nothing returns nothing
set gg_trg_lostitem=CreateTrigger()
call TriggerRegisterTimerEventSingle(gg_trg_lostitem,15.00)
call TriggerAddAction(gg_trg_lostitem,function Trig_lostitem_Actions)
endfunction

function Trig_lostitem_Actions takes nothing returns nothing
set udg_LOST_ITEM[1]='wolg'
set udg_LOST_ITEM[2]='glsk'
set udg_LOST_ITEM[3]='gcel'             //cs
set udg_LOST_ITEM[4]='stel'
set udg_LOST_ITEM[5]='mcou'
set udg_LOST_ITEM[6]='gopr'

set udg_LOST_ITEM[11]='rde4'
set udg_LOST_ITEM[12]='sora'
set udg_LOST_ITEM[13]='ratf'
set udg_LOST_ITEM[14]='sfog'
set udg_LOST_ITEM[15]='tkno'            //��ʾ ʳƷ
set udg_LOST_ITEM[16]='ofro'
set udg_LOST_ITEM[17]='desc'
set udg_LOST_ITEM[18]='rnsp'
set udg_LOST_ITEM[19]='flag'

set udg_LOST_ITEM[21]='fwss'
set udg_LOST_ITEM[22]='ram1'
set udg_LOST_ITEM[23]='sor4'
set udg_LOST_ITEM[24]='axas'
set udg_LOST_ITEM[25]='tels'
set udg_LOST_ITEM[26]='oflg'
set udg_LOST_ITEM[27]='hbth'        //����
set udg_LOST_ITEM[28]='tbak'
set udg_LOST_ITEM[29]='tbsm'
set udg_LOST_ITEM[30]='brag'
set udg_LOST_ITEM[31]='sor2'
set udg_LOST_ITEM[32]='rat3'
set udg_LOST_ITEM[33]='rej5'
set udg_LOST_ITEM[34]='sor2'

set udg_LOST_ITEM[41]='sorf'
set udg_LOST_ITEM[42]='wtlg'
set udg_LOST_ITEM[43]='kysn'        // d1����
set udg_LOST_ITEM[44]='ches'
set udg_LOST_ITEM[45]='phlt'
set udg_LOST_ITEM[46]='sbch'
set udg_LOST_ITEM[47]='rde2'

set udg_LOST_ITEM[51]='srbd'
set udg_LOST_ITEM[52]='stpg'
set udg_LOST_ITEM[53]='soul'
set udg_LOST_ITEM[54]='gvsm'
set udg_LOST_ITEM[55]='oven'           //d ��ʰ
set udg_LOST_ITEM[56]='jdrn'
set udg_LOST_ITEM[57]='rots'
set udg_LOST_ITEM[58]='shdt'
set udg_LOST_ITEM[59]='crdt'
set udg_LOST_ITEM[60]='gemt'

set udg_LOST_ITEM[61]='srbd'
set udg_LOST_ITEM[62]='stpg'
set udg_LOST_ITEM[63]='soul'
set udg_LOST_ITEM[64]='gvsm'
set udg_LOST_ITEM[65]='oven'           //d ��ʰ
set udg_LOST_ITEM[66]='jdrn'
set udg_LOST_ITEM[67]='rots'
set udg_LOST_ITEM[68]='shdt'
set udg_LOST_ITEM[69]='crdt'
set udg_LOST_ITEM[70]='gemt'

set udg_LOST_ITEM[71]='rlif'
set udg_LOST_ITEM[72]='clsd'
set udg_LOST_ITEM[73]='ward'
set udg_LOST_ITEM[74]='cnhn'         //c1
set udg_LOST_ITEM[75]='dthb'
set udg_LOST_ITEM[76]='dkfw'
set udg_LOST_ITEM[77]='dphe'
set udg_LOST_ITEM[78]='jpnt'

set udg_LOST_ITEM[81]='rlif'
set udg_LOST_ITEM[82]='clsd'
set udg_LOST_ITEM[83]='ward'
set udg_LOST_ITEM[84]='cnhn'         //c1
set udg_LOST_ITEM[85]='dthb'
set udg_LOST_ITEM[86]='dkfw'
set udg_LOST_ITEM[87]='dphe'
set udg_LOST_ITEM[88]='jpnt'

set udg_LOST_ITEM[91]='I02X'
set udg_LOST_ITEM[92]='I02X'
set udg_LOST_ITEM[93]='I02X'
set udg_LOST_ITEM[94]='I02X'
set udg_LOST_ITEM[95]='rots'      //C ��ʰ

set udg_LOST_ITEM[101]='stwa'
set udg_LOST_ITEM[102]='shea'
set udg_LOST_ITEM[103]='dtsb'
set udg_LOST_ITEM[104]='rspd'
set udg_LOST_ITEM[105]='lure'
set udg_LOST_ITEM[106]='mnsf'
set udg_LOST_ITEM[107]='sneg'
set udg_LOST_ITEM[108]='grsl'
set udg_LOST_ITEM[109]='srtl'            //��
set udg_LOST_ITEM[111]='tlum'
set udg_LOST_ITEM[112]='tgxp'
set udg_LOST_ITEM[113]='gfor'
set udg_LOST_ITEM[114]='tint'
set udg_LOST_ITEM[115]='btst'
set udg_LOST_ITEM[116]='gsou'
set udg_LOST_ITEM[117]='hbth'
set udg_LOST_ITEM[118]='tdex'

set udg_LOST_ITEM[121]='I04Z'
set udg_LOST_ITEM[122]='I050'
set udg_LOST_ITEM[123]='I051'          //׿Խ
set udg_LOST_ITEM[124]='I052'
set udg_LOST_ITEM[125]='I053'
set udg_LOST_ITEM[126]='I054'
set udg_LOST_ITEM[127]='I062'
set udg_LOST_ITEM[128]='I069'

set udg_LOST_ITEM[221]='I301'
set udg_LOST_ITEM[222]='I301'
set udg_LOST_ITEM[223]='I301'
set udg_LOST_ITEM[224]='I301'
set udg_LOST_ITEM[225]='I301'
set udg_LOST_ITEM[226]='I301'
set udg_LOST_ITEM[227]='I301'
set udg_LOST_ITEM[228]='I301'
set udg_LOST_ITEM[229]='I301'


set udg_LOST_ITEM[231]='I501'
set udg_LOST_ITEM[232]='I502'          //juanzhou
set udg_LOST_ITEM[233]='I503'
set udg_LOST_ITEM[234]='I504'
set udg_LOST_ITEM[235]='I505'
set udg_LOST_ITEM[236]='I506'
set udg_LOST_ITEM[237]='I507'
set udg_LOST_ITEM[238]='I508'
set udg_LOST_ITEM[239]='I509'
set udg_LOST_ITEM[241]='I401'
set udg_LOST_ITEM[242]='I402'
set udg_LOST_ITEM[243]='I403'
set udg_LOST_ITEM[244]='I404'
set udg_LOST_ITEM[245]='I405'
set udg_LOST_ITEM[246]='I406'

set udg_LOST_ITEM[251]='Irvt'
set udg_LOST_ITEM[252]='I12B'
set udg_LOST_ITEM[253]='Imna'
set udg_LOST_ITEM[254]='I12Q'
set udg_LOST_ITEM[255]='I05N'

set udg_LOST_ITEM[256]='I06H'
set udg_LOST_ITEM[257]='I052'
set udg_LOST_ITEM[258]='I054'
set udg_LOST_ITEM[259]='I053'
set udg_LOST_ITEM[300]='rde3'
set udg_LOST_ITEM[301]='rhth'
set udg_LOST_ITEM[302]='kpin'
set udg_LOST_ITEM[303]='belv'
set udg_LOST_ITEM[304]='bgst'        //d1 �·�     czd1
set udg_LOST_ITEM[305]='sbch'
set udg_LOST_ITEM[306]='rde2'
set udg_LOST_ITEM[307]='rde1'
set udg_LOST_ITEM[308]='dsum'

set udg_LOST_ITEM[309]='rots'
set udg_LOST_ITEM[310]='gemt'
set udg_LOST_ITEM[311]='sor3'
set udg_LOST_ITEM[312]='sor3'
set udg_LOST_ITEM[313]='jdrn'
set udg_LOST_ITEM[314]='oven'
set udg_LOST_ITEM[315]='soul'
set udg_LOST_ITEM[316]='gvsm'       //d1 ����     czd2
set udg_LOST_ITEM[317]='crdt'
set udg_LOST_ITEM[318]='shdt'
set udg_LOST_ITEM[319]='stpg'
set udg_LOST_ITEM[320]='srbd'

set udg_LOST_ITEM[321]='sror'
set udg_LOST_ITEM[322]='azhr'
set udg_LOST_ITEM[323]='bzbf'
set udg_LOST_ITEM[324]='ches'
set udg_LOST_ITEM[325]='k3m1'
set udg_LOST_ITEM[326]='k3m2'
set udg_LOST_ITEM[327]='k3m3'        //d123 wu��      czd3
set udg_LOST_ITEM[328]='ktrm'
set udg_LOST_ITEM[329]='kymn'
set udg_LOST_ITEM[330]='kysn'
set udg_LOST_ITEM[331]='ledg'
set udg_LOST_ITEM[332]='phlt'
set udg_LOST_ITEM[333]='gmfr'
set udg_LOST_ITEM[334]='shwd'
set udg_LOST_ITEM[335]='sclp'
set udg_LOST_ITEM[336]='wtlg'

set udg_LOST_ITEM[350]='I04Z'
set udg_LOST_ITEM[351]='I050'
set udg_LOST_ITEM[352]='I051'     //d5  ׿Խ
set udg_LOST_ITEM[353]='I062'
set udg_LOST_ITEM[354]='I069'


set udg_LOST_ITEM[360]='cnhn'
set udg_LOST_ITEM[361]='I001'
set udg_LOST_ITEM[362]='dphe'
set udg_LOST_ITEM[363]='jpnt'
set udg_LOST_ITEM[364]='dkfw'          //c1 wuqi
 //                                     czc1
set udg_LOST_ITEM[365]='ward'
set udg_LOST_ITEM[366]='rlif'
set udg_LOST_ITEM[367]='clsd'
set udg_LOST_ITEM[368]='lgdh'    //c1 yifu

set udg_LOST_ITEM[370]='sor1'
set udg_LOST_ITEM[371]='thle'        //c2 wuqi
set udg_LOST_ITEM[372]='skrt'
set udg_LOST_ITEM[373]='bzbe'
set udg_LOST_ITEM[374]='engs'
                              //czc2
set udg_LOST_ITEM[375]='rat9'
set udg_LOST_ITEM[376]='ratc'
set udg_LOST_ITEM[377]='rat6'     //c2  yfu

set udg_LOST_ITEM[380]='mgtk'
set udg_LOST_ITEM[381]='kygh'
set udg_LOST_ITEM[382]='bfhr'
set udg_LOST_ITEM[383]='frgd'    //c3 wuqi yfiu       cz   c3
set udg_LOST_ITEM[384]='kybl'
set udg_LOST_ITEM[385]='tint'

set udg_LOST_ITEM[390]='shea'
set udg_LOST_ITEM[391]='scul'
set udg_LOST_ITEM[392]='sprn'
set udg_LOST_ITEM[393]='shtm'    //c12 shoushi       czc4
set udg_LOST_ITEM[394]='shhn'
set udg_LOST_ITEM[395]='kgal'
set udg_LOST_ITEM[396]='arsh'

set udg_LOST_ITEM[400]='rin1'
set udg_LOST_ITEM[401]='I052'    //c zhuoyue  shoushi    czc5
set udg_LOST_ITEM[402]='I053'
set udg_LOST_ITEM[403]='I054'
set udg_LOST_ITEM[404]='I061'
set udg_LOST_ITEM[405]='I06D'
set udg_LOST_ITEM[406]='I06H'

set udg_LOST_ITEM[410]='pspd'
set udg_LOST_ITEM[411]='gsou'
set udg_LOST_ITEM[412]='tgxp'
set udg_LOST_ITEM[413]='ram4'
set udg_LOST_ITEM[414]='ram2'
set udg_LOST_ITEM[415]='ram3'
set udg_LOST_ITEM[416]='sneg'
set udg_LOST_ITEM[346]='btst'
set udg_LOST_ITEM[417]='lure'
set udg_LOST_ITEM[418]='dtsb'    //c   ����     czc6
set udg_LOST_ITEM[419]='grsl'
set udg_LOST_ITEM[420]='srtl'
set udg_LOST_ITEM[421]='stwa'
set udg_LOST_ITEM[422]='gfor'
set udg_LOST_ITEM[423]='btst'
set udg_LOST_ITEM[424]='tdex'
///////////////////////////////////////////////

set udg_LOST_ITEM[429]='I055'      //
set udg_LOST_ITEM[430]='I056'

set udg_LOST_ITEM[431]='kygh'
set udg_LOST_ITEM[432]='mgtk'
set udg_LOST_ITEM[433]='frgd'
set udg_LOST_ITEM[434]='bfhr'             //fyc4    --
set udg_LOST_ITEM[435]='kybl'
set udg_LOST_ITEM[436]='lgdh'
set udg_LOST_ITEM[437]='rin1'
set udg_LOST_ITEM[438]='scul'
set udg_LOST_ITEM[439]='sprn'
set udg_LOST_ITEM[440]='kgal'

set udg_LOST_ITEM[501]='gldo'
set udg_LOST_ITEM[502]='rde0'
set udg_LOST_ITEM[503]='rej4'
set udg_LOST_ITEM[504]='uflg'       //b1   ����  fyb0
set udg_LOST_ITEM[505]='tmsc'
set udg_LOST_ITEM[506]='gobm'
set udg_LOST_ITEM[507]='cosl'

set udg_LOST_ITEM[523]='I011'
set udg_LOST_ITEM[524]='I012'
set udg_LOST_ITEM[525]='I013'
set udg_LOST_ITEM[526]='I014'            //    fyb1
set udg_LOST_ITEM[527]='I00Y'
set udg_LOST_ITEM[528]='I00Z'
set udg_LOST_ITEM[529]='I010'

set udg_LOST_ITEM[538]='I03L'
set udg_LOST_ITEM[539]='I03M'
set udg_LOST_ITEM[540]='I03N'         //fya0
set udg_LOST_ITEM[541]='I03S'
set udg_LOST_ITEM[542]='I03R'

set udg_LOST_ITEM[555]='I205'
set udg_LOST_ITEM[556]='I206'
set udg_LOST_ITEM[557]='I207'         //fya1    �����·� ѩ�� ���� ���
set udg_LOST_ITEM[558]='I208'
set udg_LOST_ITEM[559]='I209'
set udg_LOST_ITEM[560]='I210'
set udg_LOST_ITEM[561]='I203'
set udg_LOST_ITEM[562]='I204'
set udg_LOST_ITEM[563]='I212'
set udg_LOST_ITEM[564]='I201'
set udg_LOST_ITEM[565]='I213'
/////////////////////////////////////////////////////////////

set udg_LOST_ITEM[570]='I02A'         //bzb0   �׻�
set udg_LOST_ITEM[571]='I02B'
set udg_LOST_ITEM[572]='I01E'

set udg_LOST_ITEM[575]='afac'
set udg_LOST_ITEM[576]='skul'
set udg_LOST_ITEM[577]='lhst'
set udg_LOST_ITEM[578]='sbok'       //��Ʒ  ����    bzb1
set udg_LOST_ITEM[579]='rst1'

set udg_LOST_ITEM[580]='I018'
set udg_LOST_ITEM[581]='I027'
set udg_LOST_ITEM[582]='I028'      //   ������      bzb2
set udg_LOST_ITEM[583]='I029'
set udg_LOST_ITEM[584]='I203'    //I04K

set udg_LOST_ITEM[590]='I021'
set udg_LOST_ITEM[591]='I026'
set udg_LOST_ITEM[592]='I025'         //   b3   ����
set udg_LOST_ITEM[593]='I024'
set udg_LOST_ITEM[594]='I023'

set udg_LOST_ITEM[600]='I203'           //  bza0

set udg_LOST_ITEM[605]='I05N'
set udg_LOST_ITEM[606]='I05Q'
set udg_LOST_ITEM[607]='I12B'     //  bza1       ׿Խ  ����  ��ָ   /////////////
set udg_LOST_ITEM[608]='I12Q'
set udg_LOST_ITEM[609]='hdzj'
 /////////////////////////////////////////////////////

set udg_LOST_ITEM[610]='clfm'
set udg_LOST_ITEM[611]='ciri'              //  ����+���ʶ�  wlc3
set udg_LOST_ITEM[612]='clfm'
set udg_LOST_ITEM[613]='ciri'
set udg_LOST_ITEM[614]='clfm'
set udg_LOST_ITEM[615]='olig'

set udg_LOST_ITEM[621]='kygh'
set udg_LOST_ITEM[622]='mgtk'
set udg_LOST_ITEM[623]='frgd'
set udg_LOST_ITEM[624]='bfhr'             //  c4�� ���ʶ�  wlc4
set udg_LOST_ITEM[625]='kybl'
set udg_LOST_ITEM[626]='lgdh'
set udg_LOST_ITEM[627]='rin1'
set udg_LOST_ITEM[628]='scul'
set udg_LOST_ITEM[629]='sprn'
set udg_LOST_ITEM[630]='kgal'
set udg_LOST_ITEM[631]='olig'

set udg_LOST_ITEM[635]='fczr'
set udg_LOST_ITEM[636]='kgmx'           //  �̹�����    wlb0
set udg_LOST_ITEM[637]='I13N'

set udg_LOST_ITEM[640]='prvt'
set udg_LOST_ITEM[641]='pmna'
set udg_LOST_ITEM[642]='brac'          // �·�����   wlb1
set udg_LOST_ITEM[643]='penr'

set udg_LOST_ITEM[650]='hval'
set udg_LOST_ITEM[651]='bspd'          //������  +A    wlb2
set udg_LOST_ITEM[652]='rwiz'
set udg_LOST_ITEM[653]='evtl'
set udg_LOST_ITEM[654]='I204'

set udg_LOST_ITEM[660]='Irvt'
set udg_LOST_ITEM[661]='Imna'
set udg_LOST_ITEM[662]='hdgz'      //�����׹+׿Խ   wla0
set udg_LOST_ITEM[663]='I204'

///////////////////////////////////////////

set udg_LOST_ITEM[665]='hcun'
set udg_LOST_ITEM[666]='I048'      //����2��    xhbo

set udg_LOST_ITEM[668]='I047'     //Կ��+����   xhb1
set udg_LOST_ITEM[669]='I04C'

set udg_LOST_ITEM[670]='I210'
set udg_LOST_ITEM[671]='I213'    // ������     xhb2
set udg_LOST_ITEM[672]='I212'

set udg_LOST_ITEM[675]='I03L'
set udg_LOST_ITEM[676]='I03M'
set udg_LOST_ITEM[677]='I03N'      //    A    xha0
set udg_LOST_ITEM[678]='I03S'
set udg_LOST_ITEM[679]='I03R'

set udg_LOST_ITEM[680]='I201'
set udg_LOST_ITEM[681]='I202'
set udg_LOST_ITEM[682]='I203'
set udg_LOST_ITEM[683]='I204'
set udg_LOST_ITEM[684]='I205'
set udg_LOST_ITEM[685]='I206'
set udg_LOST_ITEM[686]='I207'
set udg_LOST_ITEM[687]='I208'      //    A  ����  xha1
set udg_LOST_ITEM[688]='I209'
set udg_LOST_ITEM[689]='I210'
set udg_LOST_ITEM[690]='I212'
set udg_LOST_ITEM[691]='I213'
/////////////////////////////////////////

set udg_LOST_ITEM[700]='fwss'
set udg_LOST_ITEM[701]='ram1'
set udg_LOST_ITEM[702]='sor4'
set udg_LOST_ITEM[703]='axas'
set udg_LOST_ITEM[704]='tels'
set udg_LOST_ITEM[705]='oflg'
set udg_LOST_ITEM[706]='hbth'        //����    clc1
set udg_LOST_ITEM[707]='tbak'
set udg_LOST_ITEM[708]='tbsm'
set udg_LOST_ITEM[709]='brag'
set udg_LOST_ITEM[710]='sor2'
set udg_LOST_ITEM[711]='rat3'
set udg_LOST_ITEM[712]='rej5'
set udg_LOST_ITEM[713]='sor2'

set udg_LOST_ITEM[714]='I03T'
set udg_LOST_ITEM[715]='I03O'
set udg_LOST_ITEM[716]='I03Q'
set udg_LOST_ITEM[717]='I02K'         //�߼�����   clc2
set udg_LOST_ITEM[720]='rej6'
set udg_LOST_ITEM[721]='I01E'
///////////////////////////////////////

set udg_LOST_ITEM[800]='Absk'
set udg_LOST_ITEM[801]='AOmi'
set udg_LOST_ITEM[802]='A04O'
set udg_LOST_ITEM[803]='A04N'         //������
set udg_LOST_ITEM[804]='A08P'
set udg_LOST_ITEM[805]='AOhw'
set udg_LOST_ITEM[806]='A048'
set udg_LOST_ITEM[807]='A04A'
set udg_LOST_ITEM[808]='ACsh'
set udg_LOST_ITEM[809]='A045'

set udg_LOST_ITEM[810]='AEer'
set udg_LOST_ITEM[811]='AOsf'
set udg_LOST_ITEM[812]='Ahwd'
set udg_LOST_ITEM[813]='Aspl'         //̫��
set udg_LOST_ITEM[814]='ANso'
set udg_LOST_ITEM[815]='Ambd'
set udg_LOST_ITEM[816]='A04C'
set udg_LOST_ITEM[817]='A04D'
set udg_LOST_ITEM[818]='ANmo'
set udg_LOST_ITEM[819]='AUin'

set udg_LOST_ITEM[820]='A002'
set udg_LOST_ITEM[821]='AUfn'
set udg_LOST_ITEM[822]='A04B'
set udg_LOST_ITEM[823]='A08A'         //����
set udg_LOST_ITEM[824]='ANab'
set udg_LOST_ITEM[825]='Aslo'
set udg_LOST_ITEM[826]='A011'
set udg_LOST_ITEM[827]='A089'
set udg_LOST_ITEM[828]='Awrs'
set udg_LOST_ITEM[829]='ACfd'

set udg_LOST_ITEM[830]='AOw2'
set udg_LOST_ITEM[831]='A00E'
set udg_LOST_ITEM[832]='Aroa'
set udg_LOST_ITEM[833]='Atru'         //����
set udg_LOST_ITEM[834]='ACcl'
set udg_LOST_ITEM[835]='Atau'
set udg_LOST_ITEM[836]='A04F'
set udg_LOST_ITEM[837]='A04G'
set udg_LOST_ITEM[838]='AOre'
set udg_LOST_ITEM[839]='A046'

set udg_LOST_ITEM[840]='Aimp'
set udg_LOST_ITEM[841]='AOcr'
set udg_LOST_ITEM[842]='Aflk'
set udg_LOST_ITEM[843]='AOcl'         //�µ�
set udg_LOST_ITEM[844]='AIpv'
set udg_LOST_ITEM[845]='A01D'
set udg_LOST_ITEM[846]='AOww'
set udg_LOST_ITEM[847]='A04K'
set udg_LOST_ITEM[848]='A047'
set udg_LOST_ITEM[849]='A04M'

set udg_LOST_ITEM[850]='Acri'
set udg_LOST_ITEM[851]='Aadm'
set udg_LOST_ITEM[852]='AIh1'
set udg_LOST_ITEM[853]='A02M'         //���ĸ�
set udg_LOST_ITEM[854]='Afae'
set udg_LOST_ITEM[855]='ACr2'
set udg_LOST_ITEM[856]='A04H'
set udg_LOST_ITEM[857]='A04I'

set udg_LOST_ITEM[860]='bf60'
set udg_LOST_ITEM[861]='bf67'
set udg_LOST_ITEM[862]='bf65'
set udg_LOST_ITEM[863]='mfpz'         //����
set udg_LOST_ITEM[864]='bird'
set udg_LOST_ITEM[865]='xxfz'
set udg_LOST_ITEM[866]='bg64'
set udg_LOST_ITEM[867]='qtjt'
set udg_LOST_ITEM[868]='bf61'
set udg_LOST_ITEM[869]='A04I'
endfunction