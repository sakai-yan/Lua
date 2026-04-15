---@class xui.img : XUI
xui.img = {
    xui = 'img',
    image = '', --DROP图像
    flag = 0, -- 0拉伸 1平铺 2左上

}
xui:extends(xui.base)( xui.img )
---@return xui.img
function xui.img:new( params )
    if not params then params = {} end
    local t = self:create( 'BACKDROP', params.name, params.parent, params.template, params.id )
    return t + params
end

local DzFrameSetTexture = japi.DzFrameSetTexture
xui.img:set_property('image','set',function (class, this, key, value)
    this.data[key] = value
    DzFrameSetTexture( this.frame , this.image, this.flag or 0 )
end)

xui.img:set_property('flag','set',function (class, this, key, value)
    this.data[key] = value
    DzFrameSetTexture( this.frame, this.image, this.flag or 0 )
end)
