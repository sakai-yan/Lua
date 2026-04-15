local base = xui.base

local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetEnable = japi.DzFrameSetEnable
local DzFrameShow = japi.DzFrameShow
local DzFrameSetParent = japi.DzFrameSetParent
local DzFrameSetVertexColor = japi.DzFrameSetVertexColor
local DzGetColor = japi.DzGetColor

local set_xy = function (class, this, key, value)
    this.data[key] = value

    local cur = this
    local parent = cur.parent
    local x = 1
    local y = 1
    while parent do
        x = x * parent.w
        y = y * parent.h
        cur = parent
        parent = cur.parent
    end
    x = this.x * x
    y = this.y * y

    --相对的xy会随着父或自身调节而实时变化，它是实质的值，而不是xy简单的对父相对性
    this.data['real_' .. key] = (key == 'x' and x or y)

    local bg = xui:getFrameBG(this)
    local target = xui:getFrameBG(this.parent)
    if bg ~= this then
        bg.data[key] = value
    end
    --DzFrameClearAllPoints( bg.frame )
    DzFrameSetPoint( bg.frame, 0, target.frame , 0, x * 0.8, -y *0.6 )

    if this.parent.xui == 'panel'  then
        this.visible = this.y >= 0 and this.y + this.h <= 1
    end

    --拖拽时卡顿
    this:refresh()
end

base:set_property( 'x', 'set', set_xy )
base:set_property( 'y', 'set', set_xy)

local set_wh = function (class, this, key, value)
    this.data[key] = value
    local cur = this
    local w = 1.000
    local h = 1.000

    while cur do
        h = h * cur.h
        w = w * cur.w
        cur =  cur.parent
    end

    this.data['real_'..key] = (key == 'w' and w or h)

    local bg = xui:getFrameBG(this)
    if bg ~= this then --同步值给背景
        bg.data[key] = value
    end
    --print(w, h, bg.frame, xui.base.frame)
    DzFrameSetSize( bg.frame , w * 0.8, h*0.6 )

    this:refresh()
end

base:set_property( 'w', 'set', set_wh )
base:set_property( 'h', 'set', set_wh )

base:set_property( 'enable', 'set', function (class, this, key, value)
    value = value and true or false
    if this.enable == value then
        return
    end
    this.data[key] = value
    local bg = xui:getFrameBG(this)
    if bg.xui == 'img' then
        return
    end
    DzFrameSetEnable( bg.frame , this.enable )
end )

base:set_property( 'visible', 'set', function (class, this, key, value)
    value = value and true or false
    this.data[key] = value
    DzFrameShow( this.frame or this.frame_background.frame , this.visible )
end )

-- button.parent = panel

base:set_property( 'parent', 'set', function (class, this, key, value)
    local op = this.parent
    if op == value then
        return
    end

    local main = xui:getFrameBG(this)
    local parent = xui:getFrameBG(value)
    if op then
        --从旧的父中删除自身
        for index, child in ipairs(op.childs) do
            if child == main then
                table.remove( op.childs, index )
                break
            end
        end
    end

    this.data.parent = value
    --DzFrameClearAllPoints( main.frame )
    DzFrameSetParent(main.frame, parent.frame)

    --将自身加入到父的表中
    table.insert( value.childs, this )

    --刷新父UI。及时将自身大小尺寸更新
    if value == xui.base or value == xui.base.parent then
        return
    end
    value:refresh()
end )


base:set_property( 'color', 'set', function (class, this, key, value)
    if type(value) ~= 'table' then
        print("Frame的color应设置table<k,v> key分别为RGBA")
        return
    end
    local color = this.color

    local v = {
        R = value.R or color.R,
        G = value.G or color.G,
        B = value.B or color.B,
        A = value.A or color.A ,
    }

    this.data[key] = v
    DzFrameSetVertexColor( this.frame, DzGetColor( v.R, v.G, v.B, v.A ) )
end )

base:set_property( 'real_h', 'get', function (class, this, key, value)
    if not class.propertys_set.h then
        return this.data.h
    end
    local cur = this
    local h = 1
    while cur do
        h = h * cur.h
        cur =  cur.parent
    end
    return h
end )

base:set_property( 'real_w', 'get', function (class, this, key, value)
    if not class.propertys_set.w then
        return this.data.w
    end
    local cur = this
    local w = 1
    while cur do
        w = w * cur.w
        cur =  cur.parent
    end
    return w
end )
