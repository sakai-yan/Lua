//=========================================================================== 
// Trigger: SkillHP
//=========================================================================== 
function InitTrig_SkillHP takes nothing returns nothing
set gg_trg_SkillHP=CreateTrigger()
call TriggerAddAction(gg_trg_SkillHP,function Trig_SkillHP_Actions)
endfunction

function Trig_SkillHP_Actions takes nothing returns nothing
set bj_forLoopAIndex=1
set bj_forLoopAIndexEnd=999
loop
exitwhen bj_forLoopAIndex>bj_forLoopAIndexEnd
set udg_Skillup_JX[GetForLoopIndexA()]=(GetForLoopIndexA()*GetForLoopIndexA())
set udg_Skillup_DX[GetForLoopIndexA()]=(GetForLoopIndexA()*GetForLoopIndexA())
set udg_Skillup_FX[GetForLoopIndexA()]=(GetForLoopIndexA()*GetForLoopIndexA())
set udg_Skillup_GX[GetForLoopIndexA()]=(GetForLoopIndexA()*GetForLoopIndexA())
set udg_Skillup_QX[GetForLoopIndexA()]=(GetForLoopIndexA()*GetForLoopIndexA())
set udg_Skillup_zhizao[GetForLoopIndexA()]=(GetForLoopIndexA()*5)
set bj_forLoopAIndex=bj_forLoopAIndex+1
endloop
endfunction