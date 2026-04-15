//=========================================================================== 
// Trigger: set item
//=========================================================================== 
function InitTrig_set_item takes nothing returns nothing
set gg_trg_set_item=CreateTrigger()
call TriggerAddAction(gg_trg_set_item,function Trig_set_item_Actions)
endfunction

function Trig_set_item_Actions takes nothing returns nothing
set udg_ITEM_E[1]='gcel'
set udg_ITEM_E[2]='gopr'
set udg_ITEM_E[3]='wolg'
set udg_ITEM_E[4]='stel'
set udg_ITEM_E[5]='glsk'
set udg_ITEM_D1[1]='kymn'
set udg_ITEM_D1[2]='k3m1'
set udg_ITEM_D1[3]='azhr'
set udg_ITEM_D1[4]='k3m3'
set udg_ITEM_D1[5]='ledg'
set udg_ITEM_D2[1]='kysn'
set udg_ITEM_D2[2]='ches'
set udg_ITEM_D2[3]='wtlg'
set udg_ITEM_D2[4]='sorf'
set udg_ITEM_D2[5]='phlt'
set udg_ITEM_D3[1]='ktrm'
set udg_ITEM_D3[2]='bzbf'
set udg_ITEM_D3[3]='sclp'
set udg_ITEM_D3[4]='shwd'
set udg_ITEM_D3[5]='gmfr'
set udg_ITEM_D3[6]='k3m2'
set udg_ITEM_C1[1]='dphe'
set udg_ITEM_C1[2]='cnhn'
set udg_ITEM_C1[3]='dthb'
set udg_ITEM_C1[4]='dkfw'
set udg_ITEM_C1[5]='jpnt'
set udg_ITEM_C2[1]='sor1'
set udg_ITEM_C2[2]='thle'
set udg_ITEM_C2[3]='skrt'
set udg_ITEM_C2[4]='engs'
set udg_ITEM_C2[5]='bzbe'
endfunction