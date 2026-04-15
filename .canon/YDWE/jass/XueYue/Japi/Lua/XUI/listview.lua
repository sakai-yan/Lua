---@type mouse
local mouse = require ( xconst.module.MOUSE )
local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
---@class xui.listview : XUI
local class = {
    xui = 'listview',
    stat = 'normal',
    draggable = false,
    pressX = 0,
    pressY = 0,
    on_sys_wheel = function (self, frame, delta)
        if self.state == 'disable' then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, delta)
        end

        self.frame_vScroll:on_sys_wheel( frame, delta )

    end,
    on_sys_press = function (self, frame, key)
        if not self.enable then
            return
        end

        if key == MOUSE_LEFT then
            self.state = 'down'
        else
            return
        end

        if not self.draggable then
            return
        end

        --鼠标在滚动条上位置的占比
        local loc_x = ( mouse.x  - self.x)
        local loc_y = ( mouse.y  - self.y)
        --将占比转化为控件占比
        --local fix_x = loc_x  / (self.real_w)
        --local fix_y = loc_y  / (self.real_h)

        self.pressX = loc_x
        self.pressY = loc_y

    end,
    on_sys_drag = function (self, frame, key, x, y)
        if not self.enable then
            return
        end
        if key ~= MOUSE_LEFT then
            return
        end

        if not self.draggable then
            return
        end

        self.x = mouse.x - self.pressX
        self.y = mouse.y - self.pressY
    end,
}
---@class xui.listview
xui.listview = class
xui:extends(xui.base)( class )
local _point = xconst.frame
---@return xui.listview
function xui.listview:new( params )
    ---@class xui.listview
    local shell = self:shell()
    shell.items = {}
    --面板背景
    shell.frame_background = xui.img:new {
        parent = params.parent,
        template = params.template or 'xui_img_alpha',
    }

    --触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_background,
    }
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_LT, shell.frame_background.frame, _point.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_RB, shell.frame_background.frame, _point.POINT_RB, 0, 0  )

    assert( params.list, 'xui.listview:new  list is nil' )

    shell.list = params.list or {}

    --垂直滚动条
    shell.frame_vScroll = xui.verticalscrollbar:new {
        parent = shell.frame_background,
        x = 0.92,
        w = 0.05,
        y = 0.105 - (params.hasCloseButton and 0 or 0.05),
        h = 0.86 + (params.hasCloseButton and 0 or 0.05),
        visible = params.hasScrollBar and true or false,
    }

    --Init
    shell:init()
    shell = shell + params

    shell:countLimit()
    shell:initItems()
    return shell
end

function xui.listview:del()
    self.frame_background:del()
    self.frame_trigger:del()
    self.frame_vScroll:del()
end

local map_evt_tp = {
    ['wheel'] = 'wheel',
}
---注册事件
---@param eventName string 事件名中文英文皆可,英文注意小写 值改变 value_change
---@param callback fun(...)
function class:event( eventName, callback )
    assert(type(callback)=='function', 'listview(xui):event callback类型错误')
    eventName = map_evt_tp[eventName]
    assert(eventName, 'listview(xui):event eventName==nil' )
    self [ 'on_' .. eventName ] = callback
end

function class:addItem( item )
    local countCurrent = #self.items + 1
    self.items[countCurrent] = item

    if countCurrent > self.countActual then
        
    end

end

function class:countLimit()
    --根据面板xywh计算可容纳项目数
    local ui_count_h = ( 0.9 / self:a2rV(96) ) // 1 >> 0
    local ui_count_w = ( 0.9 / self:a2rH(96) ) // 1 >> 0

    local countPage = ui_count_h * ui_count_w --每页项目总数
    local countExpected = (ui_count_h + 1) * ui_count_w --多创建一行用于滚动
    local countActual = #self.list % countPage --实际列表项目总数[单页]

    --如果实际项目总数大于预计项目总数，则需要滚动条
    if countActual > countPage then
        self.frame_vScroll.visible = true
    end
    self.itemsPerPage = countPage
    self.itemsPerLine = ui_count_w
    self.countExpected = countExpected
    self.countActual = countActual
end

function class:getScrollbarSize ()
    local totalItems = #self.list
    if totalItems <= 0 then
        return 0
    end
    --scrollbarSize = (itemsPerPage / totalItems) * maxScroll
    local scrollbarSize = (self.itemsPerPage / totalItems) * 100
    scrollbarSize = scrollbarSize < 10 and 10 or scrollbarSize
    return self:a2rV(scrollbarSize)
end

--- 获取当前页第一个项目索引
function class:getFirstIndex()
    return (self.frame_vScroll.value // self.itemsPerPage) * self.itemsPerPage + 1
end

function class:init( )
    xui:save( self.frame_trigger.frame, self )
    local vScrollBar = self.frame_vScroll

    vScrollBar:event( 'value_change', function (scroll, value)
        local firstIndex = self:getFirstIndex()
        local lastIndex = firstIndex + self.itemsPerPage - 1
        print( firstIndex, value )
        local kHeight96 = self:a2rV(96)
        for idx, item in ipairs(self.items) do
            --item.y = item.y_origin + (value - vScrollBar.value) * kHeight96
            --刷新当前页项目
            --item.image = self.list[firstIndex + idx - 1].image or ''
            item.text = ((firstIndex + idx - 1) // 1 >> 0) .. ''
        end
    end )

    self:event( 'wheel', function (self, delta)

        local firstIndex = self:getFirstIndex()
        local kHeight96 = self:a2rV(96)

        for index, child in ipairs(self.childs) do

            if child ~= vScrollBar then
                --child.y = child.y + vScrollBar.value - value
                vScrollBar.value = vScrollBar.value + delta
            end

        end

    end )

end

function class:initItems()
    self.items = {}
    local kHeight96 = self:a2rV(96)
    local kWidth96 = self:a2rH(96)
    print( '每页项目数:' .. self.itemsPerPage, '每行项目数:' .. self.itemsPerLine, self.w, self.real_w, kWidth96 )
    for i = 1,self.itemsPerPage do
        local item = xui.tile:new {
            parent = self,
            text = i .. '',
            font = self.font or 'Fonts\\dfst-m3u.ttf',

            x = 0.05 + ( (i-1) % (self.itemsPerLine) ) * kWidth96,
            y = 0.05 + ( (i-1) // self.itemsPerLine  ) * kHeight96,

            w = kWidth96,
            h = kHeight96,
        }
        item.y_origin = item.y
        item.itemId = i
        --print(i,  (i % self.itemsPerLine) , i // self.itemsPerLine  )
        self.items[i] = item
        item:event( 'wheel', function (item, delta)
            self:on_wheel( delta )
        end )

    end
end

--转发值

local img_prop = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    if key == 'x' or key == 'y' then
        this:refresh()
    end
end

local list
list = {'x','y', 'image'}

for i, v in ipairs(list) do
    xui.listview:set_property( v, 'set', img_prop )
end


list = {'w','h','enable','visible',}

local general_set_property = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    this.frame_trigger[key] = value
    if key == 'w' or key == 'h' then
        this:refresh()
    end
end

for i, v in ipairs(list) do
    xui.listview:set_property( v, 'set', general_set_property )
end

class:set_property( 'frame', 'get', function (class, this, key)
    return this.frame_background.frame
end )
