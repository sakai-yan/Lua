require "jass.console".enable = true
local runtime = require "jass.runtime"

print("version", runtime.version)

--Lua中handle的数据类型可用__Handle_Level__获取
local handle_level = runtime.handle_level
if handle_level == 0 then
    __Handle_Level__ = "number"
elseif handle_level == 1 then
    __Handle_Level__ = "lightuserdata"
elseif handle_level == 2 then
    __Handle_Level__ = "userdata"
end
print("handle_level", __Handle_Level__)

