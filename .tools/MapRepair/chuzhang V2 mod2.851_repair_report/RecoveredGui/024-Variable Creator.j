//=========================================================================== 
// Trigger: Variable Creator
//=========================================================================== 
function InitTrig_Variable_Creator takes nothing returns nothing
    set gg_trg_Variable_Creator = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Variable_Creator, function Trig_Variable_Creator_Actions )
endfunction

function Trig_Variable_Creator_Actions takes nothing returns nothing
    set udg_RS_ActivationTime[0] = 0.00
    set udg_RS_CurrentEffect[0] = udg_RS_CurrentEffect[0]
    set udg_RS_CurrentZ[0] = 0.00
    set udg_RS_HealthDamage[0] = 0.00
    set udg_RS_LastNode = 0
    set udg_RS_ManaDamage[0] = 0.00
    set udg_RS_MapMaxX = 0.00
    set udg_RS_MapMaxY = 0.00
    set udg_RS_MapMinX = 0.00
    set udg_RS_MapMinY = 0.00
    set udg_RS_NextNode[0] = 0
    set udg_RS_NodeNumber = 0
    set udg_RS_OriginalCaster[0] = udg_RS_OriginalCaster[0]
    set udg_RS_PreviousNode[0] = 0
    set udg_RS_RecycleNodes[0] = 0
    set udg_RS_RecycleableNodesNumber = 0
    set udg_RS_SpellCounter = 0
    set udg_RS_TempGroup = udg_RS_TempGroup
    set udg_RS_TempGroup2 = udg_RS_TempGroup2
    set udg_RS_Unit[0] = udg_RS_Unit[0]
    set udg_RS_XVelocity[0] = 0.00
    set udg_RS_YVelocity[0] = 0.00
    set udg_RS_ZLoc = udg_RS_ZLoc
    set udg_RS_ZVelocity[0] = 0.00
endfunction