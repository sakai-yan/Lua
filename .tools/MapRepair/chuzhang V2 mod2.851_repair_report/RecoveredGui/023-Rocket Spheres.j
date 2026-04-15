//=========================================================================== 
// Trigger: Rocket Spheres
//=========================================================================== 
function InitTrig_Rocket_Spheres takes nothing returns nothing

    //Creates locals
    local trigger RS = CreateTrigger()
    local integer index = 0

    //Initialise the event for every player
    loop
        call TriggerRegisterPlayerUnitEvent(RS, Player(index), EVENT_PLAYER_UNIT_SPELL_EFFECT, null)
        set index = index + 1
        exitwhen index == bj_MAX_PLAYER_SLOTS
    endloop

    call TriggerAddCondition(RS, Condition(function RS_NewInstance))

    //Get all the map bounds so they can be used efficiently later
    set udg_RS_MapMaxX = GetRectMaxX(bj_mapInitialPlayableArea)
    set udg_RS_MapMinX = GetRectMinX(bj_mapInitialPlayableArea)
    set udg_RS_MapMaxY = GetRectMaxY(bj_mapInitialPlayableArea)
    set udg_RS_MapMinY = GetRectMinY(bj_mapInitialPlayableArea)

    //Initialise the Z-height finding location
    set udg_RS_ZLoc = Location(0,0)

    //Nulls variables
    set RS = null

endfunction

function RS_NewInstance takes nothing returns boolean

    //Creates all the local variables needed for this section
    local unit u
    local integer TempInt
    local integer TempInt2
    local real TempReal
    local real TempReal2
    local real x
    local real y
    local real x2
    local real y2
    local real z
    local real Angle = 0
    local real Index = 0
    local real RocketMass
    local real SphereMass
    local real BlastPower
    local real CrossSectionEnd
    local real HealthDamage
    local real ManaDamage

    //Checks if the right ability was casted
    if (GetSpellAbilityId() == RS_Ability()) then
        //Sets up basic information about the casting unit
        set u = GetTriggerUnit()
        set x = GetUnitX(u)
        set y = GetUnitY(u)
        set TempInt = GetUnitAbilityLevel(u, RS_Ability())

        //Sets up Sphere data
        set TempInt2 = RS_SphereCountBase() + (RS_SphereCountPerLevel() * TempInt)
        set TempReal = I2R(TempInt)
        set TempReal2 = RS_SphereSpreadSpaceBase() + (RS_SphereSpreadSpacePerLevel() * TempReal)
        set SphereMass = RS_SphereMassBase() + (RS_SphereMassPerLevel() * TempReal)
        set RocketMass = (RS_SphereStandardMass() / SphereMass) * RS_RocketStandardMass()
        set BlastPower = RS_BlastPowerBase() + (RS_BlastPowerPerLevel() * TempReal)
        set CrossSectionEnd = RS_SphereBottom()
        set HealthDamage = RS_RocketHealthDamageBase() + (RS_RocketHealthDamagePerLevel() * TempReal)
        set ManaDamage = RS_RocketManaDamageBase() + (RS_RocketManaDamagePerLevel() * TempReal)

        //Creates Spheres
        loop
            set Index = Index + 1
            exitwhen Index > TempInt2
            set Angle = Angle + (360.00 / TempInt2)
            set x2 = x + TempReal2 * Cos(Angle * bj_DEGTORAD)
            set y2 = y + TempReal2 * Sin(Angle * bj_DEGTORAD)
            set z = RS_SphereHeightBase() + (RS_SphereHeightPerLevel() * TempReal)

            call DestroyEffect(AddSpecialEffect(RS_RocketSpawnModel(), x2, y2))
            //Passes parameters to the Sphere creation function
            call RS_RocketSphereCreation(BlastPower, RocketMass, SphereMass, CrossSectionEnd, HealthDamage, ManaDamage, z, x2, y2, u)

        endloop

    endif

    set u = null

    return false

endfunction