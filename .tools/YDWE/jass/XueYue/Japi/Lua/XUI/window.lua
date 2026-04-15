---@class xui.window : XUI
class = {
    xui = 'window',
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
    private_on_sys_drag = function (self, frame, key, x, y)
        if self.state == 'disable' then
            return
        end
        local on = self.on_drag
        if type(on) == "function" then
            on(self, frame, key, x, y)
        end
    end
}
---@class xui.window
xui.window = class
xui:extends(xui.base)( class )

local _point = xconst.frame
---@return xui.window
function xui.window:new( params )
    ---@class xui.window
    local shell = self:shell()
    --面板背景
    shell.frame_background = xui.img:new {
        parent = params.parent,
        template = params.template or self.template,
    }

    --触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_background,
    }
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_LT, shell.frame_background.frame, _point.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, _point.POINT_RB, shell.frame_background.frame, _point.POINT_RB, 0, 0  )

    shell.frame_page = xui.panel:new
    {
        parent = shell.frame_background,
        x = 0.02,
        y = 0.085,
        w = 0.96,
        h = 0.9,
        image = "UI\\blank.blp",
    }
    --窗口图标
    shell.frame_icon = xui.img:new
    {
        parent = shell.frame_background,
        template = params.icon_template,
        align = _point.ALIGN_C,
        visible = false,
        x = 0.01,
        y = 0.01 ,
        w = 0.05,
        h = 0.05,
    }

    shell.frame_title = xui.text:new
    {
        parent = shell.frame_background,
        template = params.title_template,
        align = _point.ALIGN_C,
        x = 0.00,
        y = 0.00 ,
        w = 0.85,
        h = 0.06,
    }

    --关闭按钮
    shell.frame_closeButton = xui.button:new
    {
        parent = shell.frame_background,
        visible = params.hasCloseButton and true or false,
        x = 0.92,
        y = 0,
        w = 0.08,
        h = 0.1,
        --value = '×'
    }

    shell.frame_closeButton.image_normal = "ui\\close_normal.blp"
    shell.frame_closeButton.image_active = "ui\\close_light.blp"
    shell.frame_closeButton.image_down = "ui\\close_down.blp"
    shell.frame_closeButton.image = shell.frame_closeButton.image_normal

    --Init
    shell:init()
    return shell + params
end

function xui.window:del()
    self.frame_background:del()
    self.frame_trigger:del()
    self.frame_closeButton:del()
    self.frame_title:del()
    self.frame_icon:del()
    self.frame_page:del()
end

function class:init( )
    xui:save( self.frame_trigger.frame, self )

    self.frame_closeButton:event( 'click',
        function (btn)
            self.visible = false
        end
    )

    self.frame_title.on_sys_drag =
    function (obj, ...)
        self.private_on_sys_drag(self, ...)
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
list = {'x','y', 'image',}

for i, v in ipairs(list) do
    xui.window:set_property( v, 'set', img_prop )
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
    xui.window:set_property( v, 'set', general_set_property )
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