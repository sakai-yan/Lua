//=========================================================================== 
// Trigger: kuangshi set
//=========================================================================== 
function InitTrig_kuangshi_set takes nothing returns nothing
set gg_trg_kuangshi_set=CreateTrigger()
call TriggerRegisterTimerEventSingle(gg_trg_kuangshi_set,8.00)
call TriggerAddAction(gg_trg_kuangshi_set,function Trig_kuangshi_set_Actions)
endfunction

function Trig_kuangshi_set_Actions takes nothing returns nothing
set udg_tie[1]=gg_rct_tie1
set udg_tie[2]=gg_rct_tie2
set udg_tie[3]=gg_rct_tie3
set udg_tie[4]=gg_rct_tie4
set udg_tie[5]=gg_rct_tie5
set udg_tie[6]=gg_rct_tie6
set udg_tie[7]=gg_rct_tie7
set udg_tie[8]=gg_rct_tie8
set udg_tie[9]=gg_rct_tie9
set udg_tie[10]=gg_rct_tie10
set udg_tie[11]=gg_rct_tie11
set udg_tie[12]=gg_rct_tie12
set udg_tie[13]=gg_rct_tie13
set udg_tie[14]=gg_rct_tie14
set udg_tie[15]=gg_rct_tie15
set udg_tie[16]=gg_rct_tie16
set udg_tie[17]=gg_rct_tie17
set udg_tie[18]=gg_rct_tie18
set udg_tie[19]=gg_rct_tie19
set udg_tie[20]=gg_rct_tie20
set udg_tie[21]=gg_rct_tie21
set udg_tie[22]=gg_rct_tie22
set udg_tie[23]=gg_rct_tie23
set udg_tie[24]=gg_rct_tie24
set udg_tong[1]=gg_rct_tong1
set udg_tong[2]=gg_rct_tong2
set udg_tong[3]=gg_rct_tong3
set udg_tong[4]=gg_rct_tong4
set udg_tong[5]=gg_rct_tong5
set udg_tong[6]=gg_rct_tong6
set udg_tong[7]=gg_rct_tong7
set udg_tong[8]=gg_rct_tong8
set udg_tong[9]=gg_rct_tong9
set udg_tong[10]=gg_rct_tong10
set udg_tong[11]=gg_rct_tong11
set udg_tong[12]=gg_rct_tong12
set udg_tong[13]=gg_rct_tong13
set udg_tong[14]=gg_rct_tong14
set udg_tong[15]=gg_rct_tong15
set udg_tong[16]=gg_rct_tong16
set udg_tong[17]=gg_rct_tong17
set udg_tong[18]=gg_rct_tong18
set udg_tong[19]=gg_rct_tong19
set udg_tong[20]=gg_rct_tong20
set udg_li[1]=gg_rct_li1
set udg_li[2]=gg_rct_li2
set udg_li[3]=gg_rct_li3
set udg_li[4]=gg_rct_li4
set udg_li[5]=gg_rct_li5
set udg_li[6]=gg_rct_li6
set udg_li[7]=gg_rct_li7
set udg_li[8]=gg_rct_li8
set udg_li[9]=gg_rct_li9
set udg_li[10]=gg_rct_li10
set udg_li[11]=gg_rct_li11
set udg_li[12]=gg_rct_li12
set udg_li[13]=gg_rct_li13
set udg_li[14]=gg_rct_li14
set udg_li[15]=gg_rct_li15
set udg_tree[1]=gg_rct_tree1
set udg_tree[2]=gg_rct_tree2
set udg_tree[3]=gg_rct_tree3
set udg_tree[4]=gg_rct_tree4
set udg_tree[5]=gg_rct_tree5
set udg_tree[6]=gg_rct_tree6
set udg_tree[7]=gg_rct_tree7
set udg_tree[8]=gg_rct_tree8
set udg_tree[9]=gg_rct_tree9
set udg_tree[10]=gg_rct_tree10
set udg_tree[11]=gg_rct_tree11
set udg_tree[12]=gg_rct_tree12
set udg_tree[13]=gg_rct_tree13
set udg_KUANG=1
loop
exitwhen udg_KUANG>6
set udg_SP2=GetRandomLocInRect(udg_tie[GetRandomInt(1,24)])
call CreateDestructableLoc('BTtw',udg_SP2,GetRandomDirectionDeg(),1,0)
call RemoveLocation(udg_SP2)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_1x,GetLastCreatedDestructable())
set udg_KUANG=udg_KUANG+1
endloop
set udg_KUANG=1
loop
exitwhen udg_KUANG>4
set udg_SP=GetRectCenter(udg_tong[GetRandomInt(1,20)])
call CreateDestructableLoc('OTtw',udg_SP,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_2x,GetLastCreatedDestructable())
call RemoveLocation(udg_SP)
set udg_KUANG=udg_KUANG+1
endloop
set udg_KUANG=1
loop
exitwhen udg_KUANG>3
set udg_SP3=GetRectCenter(udg_li[GetRandomInt(1,15)])
call CreateDestructableLoc('DTsh',udg_SP3,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_3x,GetLastCreatedDestructable())
call RemoveLocation(udg_SP3)
set udg_KUANG=udg_KUANG+1
endloop
set udg_KUANG=1
loop
exitwhen udg_KUANG>3
set udg_SP3=GetRectCenter(udg_tree[GetRandomInt(1,13)])
call CreateDestructableLoc('NTtw',udg_SP3,GetRandomDirectionDeg(),1,0)
call TriggerRegisterDeathEvent(gg_trg_kuangshi_4x,GetLastCreatedDestructable())
call RemoveLocation(udg_SP3)
set udg_KUANG=udg_KUANG+1
endloop
endfunction