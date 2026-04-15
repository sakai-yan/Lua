local japi = require 'jass.japi'
xconst = {
    mouse = {
        --控件鼠标类
        EVENT_MOUSE_CLICK       = 1,    --鼠标点击
        EVENT_MOUSE_RELEASE     = 4,    --鼠标松开
        EVENT_MOUSE_PRESS       = 5,    --鼠标按下
        EVENT_MOUSE_WHEEL       = 6,    -- 鼠标滚轮
        EVENT_MOUSE_DOUBLECLICK = 12,   -- 鼠标双击
        EVENT_MOUSE_MOVE        = 100,  -- 鼠标移动 [自己声明的]
        
        MOUSE_PRESS             = 1,    --鼠标状态：按下
        MOUSE_RELEASE           = 0,    --鼠标状态：释放
        MOUSE_LEFT              = 1,    --鼠标左键
        MOUSE_RIGHT             = 2,    --鼠标右键
    },
    frame = {
        GameUI   = japi.DzGetGameUI(), --DzGetGameUI
        --感谢吴少 分享以下对齐数值
        --[[
                        T = TOP(上)
        L = LEFT(左)    C=CENTER(中心)  R = RIGHT(右)
                        B = BOTTOM(下)
        ]]
        ALIGN_LT = 13, --文本对齐方式:左上 Left Top
        ALIGN_L  = 14, --文本对齐方式:左 Left
        ALIGN_LB = 12, --文本对齐方式:左下 Left Bottom
        ALIGN_RT = 3, --文本对齐方式:右上 Right Top
        ALIGN_R  = 2, --文本对齐方式:右 Right
        ALIGN_RB = 100, --文本对齐方式:右下 Right Bottom
        ALIGN_T  = 17, --文本对齐方式:上 TOP
        ALIGN_C  = 50, --文本对齐方式:中心 Center
        ALIGN_B  = 16, --文本对齐方式:下 Bottom

        --控件锚点
        POINT_LT = 0, --锚点:左上 Left Top
        POINT_T  = 1, --锚点:上 TOP
        POINT_RT = 2, --锚点:右上 Right Top
        POINT_L  = 3, --锚点:左 Left
        POINT_C  = 4, --锚点:中心 Center
        POINT_R  = 5, --锚点:右 Right
        POINT_LB = 6, --锚点:左下 Left Bottom
        POINT_B  = 7, --锚点:下 Bottom
        POINT_RB = 8, --锚点:右下 Right Bottom

        --frame专用
        EVENT_MOUSE_ENTER       = 2,    --鼠标进入
        EVENT_MOUSE_LEAVE       = 3,    --鼠标离开
        EVENT_MOUSE_DRAG       = 7,    --鼠标拖拽
        EVENT_MOUSE_DROP       = 8,    --鼠标拖放
        --mouse
        EVENT_MOUSE_CLICK       = 1,    --鼠标点击
        EVENT_MOUSE_RELEASE     = 4,    --鼠标松开
        EVENT_MOUSE_PRESS       = 5,    --鼠标按下
        EVENT_MOUSE_WHEEL       = 6,    -- 鼠标滚轮
        EVENT_MOUSE_DOUBLECLICK = 12,   -- 鼠标双击
        EVENT_MOUSE_MOVE        = 100,  -- 鼠标移动 [自己声明的]
    },

    module = {
       MOUSE = 'XG_JAPI.Lua.Mouse',
    }

}
