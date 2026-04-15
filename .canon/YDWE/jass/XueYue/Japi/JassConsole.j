#ifndef JAPI_XG_JASS_CONSOLE
#define JAPI_XG_JASS_CONSOLE

library JassConsole

call XG_ImportFile("XueYue\\Japi\\JassConsole.lua","XG_JAPI\\JassConsole.lua")

function XG_JassConsole_Enable takes nothing returns nothing
    call Lua_Exec( "exec-lua:\"XG_JAPI.JassConsole\"" )
endfunction

endlibrary

#endif
