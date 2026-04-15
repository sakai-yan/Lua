---@class xui.tooltip : XUI
class = {
    xui = 'tooltip',
    stat = 'normal',
    template = 'xui_window',
    title = '',
    on_sys_wheel = function (self, frame, delta)
        if self.state == 'disable' then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, delta)
        end

    end,
}
---@class xui.tooltip
xui.tooltip = class
xui:extends(xui.base)( class )

local _point = xconst.frame
---@return xui.tooltip
function xui.tooltip:new( params )
    ---@class xui.tooltip
    local shell = self:shell()
    --面板背景
    shell.frame_background = xui.img:new {
        parent = params.parent,
        template = params.template or self.template,
    }

    
--[[
-----------------------------
 #icon#   #      title     # 
 #icon#   #      cost      #
# lv   #  #      dur       #
-----------------------------
#attribute#
-----------------------------
#desc#
-----------------------------
]]
    --图标
    shell.frame_icon = xui.slot:new
    {
        parent = shell.frame_background,
        x = 0.05,
        y = 0.05,
        w = xui:a2rH( 64 ),
        h = xui:a2rV( 64 ),
        image = "UI\\blank.blp",
        enable = false,
    }
    --标题
    shell.frame_title = xui.text:new
    {
        parent = shell.frame_background,
        template = params.title_template,

        x = shell.frame_icon.x + shell.frame_icon.w + 0.001,
        y = shell.frame_icon.y,
        w = 0.85,
        h = 0.06,
        enable = false,
    }
    --价格、花费
    shell.frame_cost = xui.text:new
    {
        parent = shell.frame_background,
        template = params.cose_template,

        x = shell.frame_title.x,
        y = shell.frame_title.y + shell.frame_title.h + 0.001,
        w = 0.85,
        h = 0.06,
        enable = false,
    }
    --等级
    shell.frame_level = xui.text:new
    {
        parent = shell.frame_background,
        template = params.level_template,
        align = _point.ALIGN_C,
        x = shell.frame_icon.x - 0.002,
        y = shell.frame_icon.y,
        w = shell.frame_icon.w + 0.004,
        h = 0.06,
        enable = false,
    }
    --分隔条1
    shell.frame_splitter_1 = xui.img:new
    {
        parent = shell.frame_background,
        template = params.splitter_1_template,
        x =  0.001,
        y = shell.frame_icon.y,
        w = 0.098,
        h = 0.01,
        enable = false,
    }

    --属性
    shell.frame_attribute = xui.text:new
    {
        parent = shell.frame_background,
        template = params.attribute_template,
        x =  0.001,
        y = shell.frame_icon.y,
        w = 0.098,
        h = 0.01,
        enable = false,
    }

    --分隔条2
    shell.frame_splitter_2 = xui.img:new
    {
        parent = shell.frame_background,
        template = params.splitter_2_template,
        x =  0.001,
        y = shell.frame_icon.y,
        w = 0.098,
        h = 0.01,
        enable = false,
    }

    --（详细）描述
    shell.frame_description = xui.text:new
    {
        parent = shell.frame_background,
        template = params.description_template,
        x =  0.001,
        y = shell.frame_icon.y,
        w = 0.098,
        h = 0.01,
        enable = false,
    }

    --触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_background,
    }
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_LT, shell.frame_background.frame, _point.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_RB, shell.frame_background.frame, _point.POINT_RB, 0, 0  )

    --Init
    shell:init()
    return shell + params
end

function xui.tooltip:del()
    self.frame_background:del()
    self.frame_trigger:del()

    self.frame_icon:del()
    self.frame_splitter_1:del()
    self.frame_attribute:del()
    self.frame_splitter_2:del()
    self.frame_description:del()

end

function class:init( )
    xui:save( self.frame_trigger.frame, self )

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
list = {'x','y', 'image',}

for i, v in ipairs(list) do
    xui.tooltip:set_property( v, 'set', img_prop )
end


list = {'w','h','enable','visible',}

local general_set_property = function (class, this, key, value)
    this.data[key] = value
    this.frame_background[key] = value
    this.frame_trigger[key] = value
    for _, c in ipairs(this.childs) do
        print(c.xui)
    end
    if key == 'w' or key == 'h' then
        this:refresh()
    end
end

for i, v in ipairs(list) do
    xui.tooltip:set_property( v, 'set', general_set_property )
end

class:set_property( 'frame', 'get', function (class, this, key)
    return this.frame_background.frame
end )

class:set_property( 'title', 'set', function (class, this, key, value)
    this.frame_title.value = value
end )
class:set_property( 'title', 'get', function (class, this, key, value)
    return this.frame_title.value
end )

class:set_property( 'align', 'set', function (class, this, key, value)
    this.frame_title.align = value
end )
class:set_property( 'align', 'get', function (class, this, key, value)
    return this.frame_title.align
end )