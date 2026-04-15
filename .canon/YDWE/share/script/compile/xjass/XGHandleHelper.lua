XGHandleHelper = {}
local codeNames = {

}

XGHandleHelper.JassInit = function(self)
    local jass = {}
    local i = 0
    for codeName, _ in pairs(codeNames) do
        i = i + 1
        jass[i] = ('    call XG_HandleHelper_CodeRecord(function %s, "%s")'):format( codeName ,codeName )
    end
    return table.concat(jass, '\n')
end

XGHandleHelper.Init = function(self, jass)

    for codeName in jass:gmatch([[%s-function ([%w_]-) takes %s*nothing %s*returns %s*nothing]]) do
        if codeName == 'main' or codeName == 'config' then
            --跳过main和config函数
            goto continue
        end
        codeNames[codeName] = true
        ::continue::
    end

    local mainCode =
[[
function XG_HandleHelper_CodeInit takes nothing returns nothing
    %s
endfunction
]]
    mainCode = mainCode:format(self.JassInit())
    --在function main 前面插入一个函数
    local mainStart, mainEnd = jass:find("function%s-main%s-takes")
    if mainStart then
        jass = jass:sub(1, mainStart - 1).. mainCode .. jass:sub(mainStart)
    end
    return jass
end

return XGHandleHelper