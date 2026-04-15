--计时器窗口
local MOUSE_LEFT = xconst.mouse.MOUSE_LEFT
local mouse = require 'XG_JAPI.Lua.Mouse'
local constFrame = xconst.frame
local class = {
    xui = 'timerdialog',
    type = 'class',
    image_normal = 'ui\\blank.blp',
    image_disable = 'ui\\blank.blp',
    checked = false,

    on_sys_enter =  function (self, frame, x, y)
        local stat = self.stat
        if stat == 'disable' then
            return
        end

        local on = self.on_enter
        if type(on) == "function" then
            on(self, x, y)
        end
    end,

    on_sys_leave = function (self, frame, x, y)
        local stat = self.stat
        if stat == 'disable' then
            return
        end

        local on = self.on_leave
        if type(on) == "function" then
            on(self, x, y)
        end
    end,

    on_sys_press = function (self, frame, key)
        if self.stat == 'disable' then
            return
        end


        local on = self.on_press
        if type(on) == "function" then
            on(self, key)
        end
    end,

    on_sys_release = function (self, frame, key)
        if self.stat == 'disable' then
            return
        end

        local on = self.on_release
        if type(on) == "function" then
            on(self, key)
        end
    end,

    on_sys_wheel = function (self, frame, key)
        if self.stat == 'disable' then
            return
        end

        local on = self.on_wheel
        if type(on) == "function" then
            on(self, key)
        end
        if self.parent.xui == 'panel' then
            self.parent:on_sys_wheel(frame,key)
        end
    end,

    on_sys_click = function (self, frame, key)
        if self.stat == 'disable' then
            return
        end

        local on = self.on_click
        if type(on) == "function" then
            on(self, key)
        end

    end,
}
xui.timerdialog = class
xui:extends(xui.base)( class )

function xui.timerdialog:new( params )
    local shell = self:shell()
    shell.xui = class.xui
    --背景
    shell.frame_background = xui.img:new  {
        parent = params.parent,
        image = class.image_normal,
    }

     --状态指示器
     shell.frame_state = xui.img:new {
        parent = shell.frame_background,
        x = 0,
        y = 0,
        w = 0.1,
        h = 1,

    }

    --描述文本
    shell.frame_desc = xui.text:new {
        parent = shell.frame_background,
        x = shell.frame_state.w,
        y = 0,
        w = 0.8,
        h = 0.5
    }

    --计数文本 countdown
    shell.frame_cd = xui.text:new {
        parent = shell.frame_background,
        x = shell.frame_desc.x + shell.frame_desc.w,
        y = 0,
        w = 0.1,
        h = 1,
        value = "00:00"
    }

    --事件触发器
    shell.frame_trigger = xui.text:new {
        parent = shell.frame_background,
    }

    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_LT, shell.frame_background.frame, constFrame.POINT_LT, 0, 0  )
    japi.DzFrameSetPoint( shell.frame_trigger.frame, constFrame.POINT_RB, shell.frame_background.frame, constFrame.POINT_RB, 0, 0  )

    shell:init()

    return shell + params
end


function class:init()
    xui:save(
        self.frame_trigger.frame,
        self
    )
end

function class:del()

    xui:save( self.frame_trigger, nil )

    self.frame_trigger:del()
    self.frame_cd:del()
    self.frame_desc:del()
    self.frame_state:del()
    self.frame_background:del()

end

