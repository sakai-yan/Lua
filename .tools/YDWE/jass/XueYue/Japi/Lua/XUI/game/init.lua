--[[
未完工！！
这个容器太麻烦了，可能会咕！
]]

local tb_insert = table.insert
local class = {
    list = {},  --队列列表
    container = {}, --容器
    ui = {},

}
xui.game = class

--删除指定计时器的窗口
function class:delTimerDialog( targetTimer )
    local container = class.container.timerDialog

    for index, _timerdialog in ipairs(container) do

        if _timerdialog.timer == targetTimer then
            _timerdialog:del()
            table.remove( container, index )
            break
        end

    end

    self:redrawTimerdDialog()
end



function class:init()
    
end

function class:redrawTimerdDialog()
    local i = 0
    local h = 0.2
    ---@type xui.timer
    local container = class.container.timerDialog
    local count = #container
    class.ui.timerDialog.h = count * 0.01
    --class.ui.timerDialog.w = 0.03 --展开/收缩时不同
    for index, _timerdialog in ipairs(container) do
        if _timerdialog.boxed then
            i = i + 1
            _timerdialog.h = h
            _timerdialog.x = i * h
        end
        
    end
end

function class:redraw()
    self:redrawTimerdDialog()
end

function class:insert( obj, pos, redraw )
    if pos <= 0 then
        pos = #class.list + 1 + pos
    end
    tb_insert( class.list, pos, obj )
    if redraw then
        self:redraw()
    end
end



