xui = {
    objs = table.k {},
    _h2o = {},
    width = 1920,
    height = 1080,
    ratio = 1080 / 1920,
}

local xui = xui
local name_id = 0
---扩展子类UI
---使用方法： extends(父模板...)(  子类 )
function xui:extends(...)

    local parents = {...}
    local count = select('#',...)

    return function (child_class)
        local parent_class = parents[1]
        local tbl = {}
        local mt = getmetatable(parent_class)
        if mt ~= nil then
            tbl.__tostring = mt.__tostring
            tbl.__call = mt.__call
            tbl.__add = mt.__add
        end

        ---从parents中逐个查找
        if count == 1 then
            tbl.__index = parent_class
        else
            tbl.__index = function (_, key)
                for i = 1,count do
					local v = parents[i]
                    if v and v[key]~=nil then
                        return v[key]
                    end
                end
            end
        end

        if not child_class.propertys_set then
            child_class.propertys_set = {}
        end
        if not child_class.propertys_get then
            child_class.propertys_get = {}
        end

        setmetatable(child_class.propertys_set, {
            __index = function (_, key)
                for i = 1,count do
                    local v = parents[i].propertys_set
                    if v then
                        local vv = v[key]
                        if vv then
                            return vv
                        end
                    end
                end
            end
        })

        setmetatable(child_class.propertys_get, {
            __index = function (_,key)
                for i = 1,count do
                    local v = parents[i].propertys_get
                    if v then
                        local vv = v[key]
                        if vv then
                            return vv
                        end
                    end
                end
            end
        })
        child_class.data = {}
        child_class.type = 'XUI'
        setmetatable(child_class, tbl)
        return child_class
    end

end

local gameUI = xconst.frame.GameUI
---@class xui.base
local data = {


}
---@class xui.base
local base = {
    type = 'XUI',
    class = 'ui_base',
    data = data,        -- 数据表 存放需要监测的键值
    propertys_set = {}, --可操作性属性设置 对应函数 func(table,key,value)
    propertys_get = {}, --可操作性属性读取 对应函数 func(table,key,value)


    enable = true,      --控件启用
    visible = true,     --控件可视
    parent = {
        type = 'static',
        class = 'ui_base',
        frame = gameUI,
        w = 1,
        h = 1,
        x = 0,
        y = 0,
        real_x = 0,
        real_y = 0,
        real_w = 1,
        real_h = 1,
        childs = {},
    }, --父控件

    --frame = gameUI, --checkbox会黑屏
    x = 0,
    y = 0,
    w = 1,
    h = 1,
    real_x = 0,
    real_y = 0,
    real_w = 1,
    real_h = 1,
    color = {R=255, G=255, B=255, A=255},

    --目标锚点
    targetPoint = -1,
    targetFrame = -1,
    childs = {},
}

---@class XUI : xui.base
xui.base = base

--setmetatable( base, base )

local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
function base:create ( _type, name, parent, template, id )
    local t = {
        _type    = _type or 'BACKDROP',
        name     = name or xui:newName(),
        parent   = parent or self.parent,
        template = template or 'template',
        id       = id or 0,
    }
    ---@class XUI
    local shell = self:shell()
    shell.frame = DzCreateFrameByTagName( t._type, t.name, t.parent.frame, t.template, t.id  )
    shell._type = t._type
    shell.name = t.name
    --不直接写入data中 为了更新childs
    shell.parent = t.parent
    shell.data.template = t.template
    shell.data.id = t.id

    --table.insert(xui.objs, shell)

    return shell
end

--创建外壳[无UI]
--需要为外壳设置一遍property
---@return XUI
function base:shell (  )
    ---@class XUI
    local t = {
        data = {},
        childs = {},
        tags = {}, --ui标签
    }
    table.insert(xui.objs, t)
    local propertys_set = self.propertys_set
    local propertys_get = self.propertys_get
    setmetatable(t, {
        __index = function (this, key)
            local on_get = propertys_get[key]

            if on_get then
                return on_get(self, this, key )
            else
                local v = this.data[key]
                if v ~= nil then
                    return v
                end
                return self[key]
            end
            
        end,
        __newindex = function (this, key, value)
            local on_set = propertys_set[key]
            if on_set then
                on_set( self, this, key, value )
            else
                this.data[key] = value
            end
        end,
        __add = function (this, params)

            for k, v in xPairs(params) do
                if propertys_set[k] or propertys_get[k] or self[k] ~= nil then
                    this [ k ] = v
                end
            end

            return this
        end,
    })

    return t
end

---设置属性回调
--- 例如base:set_property( 'x', 'set', func ) 当你以后为base.x会调起func
---@param key string
---@param method string 'set|get'
---@param callback fun(class,this,key,value) --需要手动设置this.data[key]来存储值
---@return self
function base:set_property( key, method, callback )
    if method == 'set' then
        self.propertys_set[ key ] = callback
    elseif method == 'get' then
        self.propertys_get[ key ] = callback
    else
        print("set_property传入了错误值:", key)
    end
    return self
end

---获取属性回调
--- 例如base:get_property( 'x', 'set' ) 当你以后为base.x会调起func
---@param key string
---@param method string 'set|get'
---@return fun(self,key,value)
function base:get_property( key, method )
    if method == 'set' then
        return self.propertys_set[ key ]
    elseif method == 'get' then
        return self.propertys_get[ key ]
    else
        print("get_property传入了错误值:", key)
        assert(false, debug.traceback())
    end
end

---添加标签
---@param tag string
---@return self
function base:addTag( tag )
    self.tags[tag] = true
    return self
end

---删除标签
---@param tag string
---@return self
function base:delTag( tag )
    self.tags[tag] = nil
    return self
end

---是否拥有标签
---@param tag string
---@return bool
function base:hasTag( tag )
    return self.tags[tag] and true or false
end

local DzDestroyFrame = japi.DzDestroyFrame
---销毁控件
function base:del( )
    if self.frame == 0 then
        return
    end

    DzDestroyFrame( self.frame )
    xui:save(self.frame, nil)
    self.frame = 0
    for index, child in ipairs(self.childs) do
        child:del()
    end

end

function xui:newName( )
    name_id = name_id + 1
    return  'xui_'  .. name_id
end

---将frameHandle 转换为 Obj
---@param frame int
---@return XUI
function xui:h2o(frame)
    return self._h2o[ frame ]
end

---为frame映射obj，来支持h2o
---@param frame int 
---@param obj XUI shell
function xui:save( frame, obj )
    self._h2o[ frame ] = obj
end

function xui:reset()
    local objs = xui.objs
    for index, obj in ipairs(xui.objs) do
        obj:del()
        objs[index] = nil
    end
    name_id = 0
    base.parent.frame = japi.DzGetGameUI()
    xconst.frame.GameUI = japi.DzGetGameUI()
    xui.event:reset()
end

function base:refresh()
    for index, child in ipairs(self.childs) do
        child.x = child.x
        child.w = child.w
        --child:refresh()
    end
    --print( 'refresh', self.xui )
end

function xui:getFrameBG( this )
    local bg

    while this.frame_background do
        this = this.frame_background
        bg = this
    end

    return bg or this
end

---绝对水平坐标 absolute to relative horizontal
---@return number
function xui:a2rH( x )
    return x / self.width
end

---绝对垂直坐标  absolute to relative vertical
---@return number
function xui:a2rV( y )
    return y / self.height
end

---绝对水平坐标 absolute to relative horizontal
---@return number
function base:a2rH( x )
    return x / xui.width / self.real_w
    --return x / (self.real_w * xui.width)
end

---绝对垂直坐标  absolute to relative vertical
---@return number
function base:a2rV( y )
    return  y / (self.real_h * xui.height)
end


japi.DzLoadToc("XG_JAPI\\Lua\\XUI\\Ui\\xui.toc")
require 'XG_JAPI.Lua.XUI.propertys'
