local jdebug = require 'jass.debug'
--[[
i2h     function: 7AC5B206
globaldef       function: 7AC5AF9A
currentpos      function: 7AC5B10E
gchash  function: 7AC5B25E
handle_ref      function: 7AC5B228
handle_unref    function: 7AC5B243
handlecount     function: 7AC5B186
handledef       function: 7AC5B011
h2i     function: 7AC5B1E4
handlemax       function: 7AC5B15C
]]
local h2i = jdebug.h2i
local i2h = jdebug.i2h

local XGJAPI = XGJAPI

Xfunc['XG_Int2Unit'] = function ()
    XGJAPI.unit[0] = i2h( XGJAPI.integer[1] )
end

Xfunc['XG_Int2Item'] = function ()
    XGJAPI.item[0] = i2h( XGJAPI.integer[1] )
end

