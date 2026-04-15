--[[
    单位索引模块 将单位引用转化为索引 __tostring = index
    单位移除时只需移除表内 handle 的索引值 即可彻底清空引用计数器
    解决异步内引用 handle 造成 handle 异步
    为此需要重写以单位为参数相关函数
    function GetHandleId(h)
            if h then
                    
            end
    end
]]
