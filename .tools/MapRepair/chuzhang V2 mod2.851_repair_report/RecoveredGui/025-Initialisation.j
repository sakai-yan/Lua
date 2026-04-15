//=========================================================================== 
// Trigger: Initialisation
//=========================================================================== 
function InitTrig_Initialisation takes nothing returns nothing
    set gg_trg_Initialisation = CreateTrigger(  )
    call TriggerAddAction( gg_trg_Initialisation, function Trig_Initialisation_Actions )
endfunction

function Trig_Initialisation_Actions takes nothing returns nothing
    call FogEnableOff(  )
    call FogMaskEnableOff(  )
endfunction