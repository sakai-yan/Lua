local Style = {}
local Constant = require "Lib.API.Constant"
local Point = require "FrameWork.Manager.Point"
local Frame = require "Core.UI.Frame"

-- WC3 屏幕坐标系固定尺寸（4:3 基准，x∈[0,0.8] y∈[0,0.6]）。
-- fixed 节点的编译期参考盒子与运行时锚点父节点统一改为屏幕（GameUI），与 CSS fixed 语义对齐。
local SCREEN_WIDTH  = 0.8
local SCREEN_HEIGHT = 0.6

-- 缓存标准库函数，减少反复索引 math 表的开销，同时也让后面的布局代码更简洁。
local math_floor = math.floor
local math_max = math.max
local rawget = rawget
local type = type
local ANCHOR_TOP = Constant.ANCHOR_TOP
local ANCHOR_BOTTOM = Constant.ANCHOR_BOTTOM
local ANCHOR_LEFT = Constant.ANCHOR_LEFT
local ANCHOR_RIGHT = Constant.ANCHOR_RIGHT

--[[
    这个模块的职责
    1. 它不是直接创建 UI，而是先把带有 style/tree 的声明式配置编译成 Frame.lua 能理解的绝对坐标。
    2. 之所以这样设计，是因为 Frame.lua 当前最稳定、最明确的能力就是绝对 top-left 定位。
       与其把浏览器那套完整运行时搬进来，不如先做一层“布局编译器”，把相对/流式写法提前算成 x/y/width/height。
    3. 这个模块的实现方式是：
       - 先归一化 style、padding、gap 等输入
       - 再根据 position 计算当前节点自己的绝对位置
       - 再根据 display 计算子节点在容器中的流式位置
       - 最后递归整棵 tree，把所有节点都转换成 Frame 友好的配置

    一条最重要的坐标约定
    - Frame.lua 使用的是“绝对左上角锚点”
    - 本模块内部会把子元素的 local_y 当成“距离父内容区顶部向下多少”
    - 但真正写回 config.y 时，要换算成绝对 top-left 坐标，因此会做：
      config.y = parent_content.abs_y - local_y

    当前 position 的支持范围
    - static / relative / absolute：和前面一致
    - fixed：相对“当前布局树的根盒子”定位，而不是相对父内容区
    - sticky：由于 Frame.lua 没有现成的浏览器式滚动运行时，这里实现的是“编译期静态 sticky”
      也就是：元素仍参与普通流，但最终位置会被 top/right/bottom/left 夹紧在父内容区允许范围内
      它能表达 sticky 的阈值语义，但不会自动监听滚动并在运行时持续重排

    一个典型输入示例
    local panel = {
        x = 0.10,
        y = 0.60,
        width = 0.40,
        height = 0.20,
        style = {
            display = "flex",
            padding = 0.01,
            gap = 0.005,
        },
        tree = {
            {
                class = "text",
                width = 0.10,
                height = 0.03,
                value = "Hello",
                style = {
                    position = "relative",
                    left = 0.002,
                },
            }
        }
    }
]]



--[[
    函数：to_number
    1. 这个函数是用来干什么的
       - 把输入安全地转成 number。
       - 如果输入不是 number，就回退到默认值。

    2. 为什么这样设计函数
       - 布局代码里会大量读取 style.left、style.gap、config.width 这类字段。
       - 用户声明式配置里，这些字段可能缺失，也可能写成 nil。
       - 如果每次都手写 type 判断，布局函数会很啰嗦，所以抽一个最基础的数值归一化工具。

    3. 这个函数是通过做了什么达到设计目的
       - 先判断 value 的类型是否为 number。
       - 是 number 就直接返回原值，避免多余处理。
       - 不是 number 就返回 default_value；如果 default_value 也没有，则回退为 0。
]]
local function to_number(value, default_value)
    if type(value) == "number" then return value end
    return default_value or 0
end

--[[
    函数：normalize_style
    1. 这个函数是用来干什么的
       - 确保每个节点都拥有一个可读写的 style 表。

    2. 为什么这样设计函数
       - 后续所有布局逻辑都默认 config.style 是表。
       - 如果节点没写 style，而后面又直接访问 style.position / style.display，就会出现空值判断噪音。
       - 因此先做一次统一兜底，后面的代码就能按“style 一定存在”来写。

    3. 这个函数是通过做了什么达到设计目的
       - 用 rawget 直接读取原始字段，避免未来可能存在的元方法干扰。
       - 如果 style 不是 table，就新建一个空表并挂回 config.style。
       - 最终始终返回一个表给调用方使用。
]]
local function normalize_style(config)
    local style = rawget(config, "style")
    if type(style) ~= "table" then
        style = {}
        config.style = style
    end

    return style
end

--[[
    规范化Padding：normalize_padding
    1. 这个函数是用来干什么的
       - 把各种写法的 padding 统一转换成 { top, right, bottom, left } 结构。

    2. 为什么这样设计函数
       - 调用者可能写：
         padding = 0.01
         padding = { 0.01, 0.02 }
         padding = { top = 0.01, left = 0.02 }
       - 如果后续每个布局函数都各自解释 padding，规则会分散且容易出错。
       - 所以在进入核心布局前先把 padding 归一成一种标准结构。

    3. 这个函数是通过做了什么达到设计目的
       - 支持 number：四边相同
       - 支持命名表：top/right/bottom/left
       - 支持数组表：
         { a } => 四边都是 a
         { v, h } => 上下 v，左右 h
         { t, h, b } => 上 t，左右 h，下 b
         { t, r, b, l } => 四边分别指定
       - 如果完全无法识别，就返回全 0 的 padding
]]
local function normalize_padding(padding)
    if type(padding) == "number" then
        return {
            top = padding,
            right = padding,
            bottom = padding,
            left = padding,
        }
    end

    if type(padding) == "table" then
        -- 先处理命名字段写法，因为这种写法语义最明确。
        if padding.top or padding.right or padding.bottom or padding.left then
            return {
                top = to_number(padding.top, 0),
                right = to_number(padding.right, 0),
                bottom = to_number(padding.bottom, 0),
                left = to_number(padding.left, 0),
            }
        end

        --接下来处理数组表写法
        local count = #padding

        -- { a } => 四边统一
        if count == 1 then
            local all = to_number(padding[1], 0)
            return {
                top = all,
                right = all,
                bottom = all,
                left = all,
            }
        end

        -- { vertical, horizontal } => 上下 / 左右
        if count == 2 then
            local vertical = to_number(padding[1], 0)
            local horizontal = to_number(padding[2], 0)
            return {
                top = vertical,
                right = horizontal,
                bottom = vertical,
                left = horizontal,
            }
        end

        -- { top, horizontal, bottom } => 上 / 左右 / 下
        if count == 3 then
            local top = to_number(padding[1], 0)
            local horizontal = to_number(padding[2], 0)
            local bottom = to_number(padding[3], 0)
            return {
                top = top,
                right = horizontal,
                bottom = bottom,
                left = horizontal,
            }
        end

        -- { top, right, bottom, left } => 四边分别指定
        if count >= 4 then
            return {
                top = to_number(padding[1], 0),
                right = to_number(padding[2], 0),
                bottom = to_number(padding[3], 0),
                left = to_number(padding[4], 0),
            }
        end
    end

    -- 没写 padding 或写法不符合约定时，默认无内边距。
    return {
        top = 0,
        right = 0,
        bottom = 0,
        left = 0,
    }
end

--[[
    规范化gap：normalize_gap
    1. 这个函数是用来干什么的
       - 把容器上的 gap、row_gap、column_gap 统一整理成两个数值：行间距与列间距。

    2. 为什么这样设计函数
       - flex/grid 布局都需要间距，但不同写法可能是：
         gap = 0.01
         gap = { 0.01, 0.02 }
         row_gap = ...
         column_gap = ...
       - 如果不统一处理，flex/grid 都要重复解释这些字段。

    3. 这个函数是通过做了什么达到设计目的
       - 先读取 style 上更具体的 row_gap / column_gap
       - 再用 gap 作为兜底
       - 最终返回 row_gap, column_gap 两个 number，供容器布局直接使用
]]
local function normalize_gap(style)
    local row_gap = style.row_gap
    local column_gap = style.column_gap
    local gap = style.gap

    --有时单独写了 row_gap / column_gap其中一个，另一个是写在gap里的
    local gap_type = type(gap)
    if gap_type == "number" then
        -- 单值 gap 表示行列都用同一个间距，除非调用者单独写了 row_gap / column_gap。
        row_gap = row_gap == nil and gap or row_gap
        column_gap = column_gap == nil and gap or column_gap
    elseif gap_type == "table" then
        -- 表格式 gap 允许分别指定行列间距；若只写一个值，则行列共用。
        row_gap = row_gap == nil and (gap.row or gap[1]) or row_gap
        column_gap = column_gap == nil and (gap.column or gap[2] or gap[1]) or column_gap
    end

    return to_number(row_gap, 0), to_number(column_gap, 0)
end

--[[
    函数：get_position_mode
    1. 这个函数是用来干什么的
       - 从 style 中识别当前节点应该采用哪一种 position 逻辑。

    2. 为什么这样设计函数
       - 当前模块只显式支持 static / relative / absolute / fixed / sticky 五种行为。
       - 对未知值直接硬报错会让声明式配置太脆弱；更稳妥的方式是回退到 static。

    3. 这个函数是通过做了什么达到设计目的
       - 读取 style.position
       - 如果是 relative / absolute / fixed / sticky 就原样返回
       - 其余情况统一按 static 处理
]]
local function get_position_mode(style)
    local mode = style.position
    if mode == "relative" or mode == "absolute" or mode == "fixed" or mode == "sticky" then
        return mode
    end

    if __DEBUG__ then
        print("get_position_mode: unknown position mode", mode)
    end

    return "static"
end

--[[
    函数：get_viewport_box
    1. 这个函数是用来干什么的
       - 返回 fixed 节点编译期使用的"视口盒子"。

    2. 为什么这样设计函数
       - WC3 屏幕坐标系固定（4:3 基准 0.8×0.6），不存在浏览器 viewport resize 问题。
       - 用屏幕固定尺寸作为 fixed 的参考盒子，与 CSS `position: fixed` 参考 viewport 的语义对齐。
       - 编译期只需要尺寸用于偏移计算，abs_x/abs_y 从屏幕左上角（0, SCREEN_HEIGHT）出发。

    3. 这个函数是通过做了什么达到设计目的
       - 返回固定的屏幕尺寸常量盒子，不再读取布局根节点的 x/y/width/height。
]]
local function get_viewport_box(_config)
    return {
        abs_x  = 0,
        abs_y  = SCREEN_HEIGHT,
        width  = SCREEN_WIDTH,
        height = SCREEN_HEIGHT,
    }
end

--[[
    函数：ensure_viewport_box
    1. 这个函数是用来干什么的
       - 在一次布局编译过程中，按需计算并缓存根节点的 viewport_box。

    2. 为什么这样设计函数
       - `fixed` 子节点可能在同一棵树里出现多个。
       - 如果每次都重新从根节点构造视口盒子，会产生重复计算和重复表分配。
       - 因此与 content_box 一样，这里也使用惰性缓存。

    3. 这个函数是通过做了什么达到设计目的
       - 先读取 __layout_viewport_box__ 缓存
       - 若存在则直接复用
       - 若不存在则调用 get_viewport_box(config) 计算一次并缓存
]]
local function ensure_viewport_box(config)
    local viewport_box = rawget(config, "__layout_viewport_box__")
    if not viewport_box then
        viewport_box = get_viewport_box(config)
        config.__layout_viewport_box__ = viewport_box
    end

    return viewport_box
end

--[[
    函数：get_content_box
    1. 这个函数是用来干什么的
       - 计算“父容器的内容区”。
       - 内容区的意思是：从父节点的 x/y/width/height 中扣掉 padding 后，子节点真正能摆放的位置区域。

    2. 为什么这样设计函数
       - 子节点的流式布局、absolute 定位，本质上都不应该直接参考父节点整个盒子，
         而应该参考父节点的内容区。
       - 这样 flex/grid/absolute 的行为才和常见盒模型更接近，也更容易推导。

    3. 这个函数是通过做了什么达到设计目的
       - 先拿到父节点 style 并归一化 padding
       - 计算内容区左上角的绝对坐标：
         abs_x = config.x + left padding
         abs_y = config.y - top padding
       - 再计算扣掉左右/上下 padding 后的可用宽高
]]
local function get_content_box(config)
    local style = normalize_style(config)
    local padding = normalize_padding(style.padding)
    local width = to_number(config.width)
    local height = to_number(config.height)

    return {
        -- 内容区左边界 = 父节点绝对左边界 + left padding
        abs_x = to_number(config.x) + padding.left,
        -- 内容区顶边界 = 父节点绝对顶边界向下 top padding
        abs_y = to_number(config.y) - padding.top,
        -- 可用宽高需要扣掉 padding，且不能小于 0
        width = math_max(width - padding.left - padding.right, 0),
        height = math_max(height - padding.top - padding.bottom, 0),
    }
end

--[[
    函数：ensure_content_box
    1. 这个函数是用来干什么的
       - 在一次布局编译过程中，按需计算并缓存当前节点的 content_box。

    2. 为什么这样设计函数
       - 原始写法里，同一个父节点的内容区可能会被它的每个孩子重复计算一次。
       - 这种计算虽然不复杂，但会反复做 padding 归一化和新表分配。
       - 对布局树较大时，这种重复是很容易积累成纯消耗的。
       - 因此这里改成“惰性缓存”：
         只有第一次真正需要时才计算；
         算完挂到节点上；
         后续同一轮布局直接复用。

    3. 这个函数是通过做了什么达到设计目的
       - 先读取 __layout_content_box__ 临时缓存
       - 如果缓存存在，直接返回
       - 如果不存在，就调用 get_content_box(config) 计算一次并写入缓存
]]
local function ensure_content_box(config)
    local content_box = rawget(config, "__layout_content_box__")
    if not content_box then
        content_box = get_content_box(config)
        config.__layout_content_box__ = content_box
    end

    return content_box
end

--[[
    函数：resolve_flow_position
    1. 这个函数是用来干什么的
       - 取出当前节点在“父布局流”中的基础位置。

    2. 为什么这样设计函数
       - 某个子节点的最终位置通常分两段得到：
         第一段：由父容器的 flex/grid 先决定它大概应该排到哪里
         第二段：再由它自己的 position 偏移做微调
       - 因此需要一个统一入口，优先读取父容器事先算好的流式位置。

    3. 这个函数是通过做了什么达到设计目的
       - 优先读取 __layout_flow_x__ / __layout_flow_y__
       - 如果父容器没有预先写入，就退回到节点自身声明的 x / y
]]
local function resolve_flow_position(config)
    local flow_x = rawget(config, "__layout_flow_x__")
    local flow_y = rawget(config, "__layout_flow_y__")

    if flow_x == nil then
        flow_x = to_number(config.x)
    end
    if flow_y == nil then
        flow_y = to_number(config.y)
    end

    return flow_x, flow_y
end

--[[
    函数：set_local_position
    1. 这个函数是用来干什么的
       - 把“相对于父内容区的局部坐标”换算成 Frame 需要的绝对 x / y。

    2. 为什么这样设计函数
       - 布局算法内部更适合使用 local_x / local_y 来思考：
         例如“离父内容区左边 0.01”、“离顶部 0.02”
       - 但 Frame.lua 最后只能吃绝对 top-left 坐标。
       - 所以需要一个专门的转换点，把“局部布局语义”统一落到“绝对创建配置”。

    3. 这个函数是通过做了什么达到设计目的
       - 先把 local_x / local_y 暂存下来，便于调试和理解布局结果
       - 如果有 parent_content，就基于父内容区左上角换算出绝对坐标
       - 如果没有父节点，说明当前就是根节点，直接把 local 当绝对值使用
]]
local function set_local_position(config, parent_content, local_x, local_y)
    -- 保存一份“相对父内容区”的坐标，调试布局时很有用。
    config.__layout_local_x__ = local_x
    config.__layout_local_y__ = local_y

    if parent_content then
        -- x 方向直接相加：父内容区左边界 + 子节点相对偏移
        config.x = parent_content.abs_x + local_x
        -- y 方向要从父内容区顶边界往下走，因此是减去 local_y
        config.y = parent_content.abs_y - local_y
    else
        -- 根节点没有父内容区时，本身声明的 local 就等于绝对位置。
        config.x = local_x
        config.y = local_y
    end
end

--[[
    函数：resolve_alignment_offset
    1. 这个函数是用来干什么的
       - 计算某个元素在交叉轴/单元格内部的对齐偏移量。

    2. 为什么这样设计函数
       - flex 的 align、grid 的 align_self / justify_self，本质上都是：
         “在一个可用空间里，元素应该靠前、居中、还是靠后”
       - 这个规则在多个布局算法中都会复用，所以抽成统一函数。

    3. 这个函数是通过做了什么达到设计目的
       - align == "center" 时，返回剩余空间的一半
       - align == "end" 时，返回剩余空间全部
       - 其他情况默认靠前，偏移为 0
]]
local function resolve_alignment_offset(align, available_size, item_size)
    if align == "center" then
        return math_max((available_size - item_size) * 0.5, 0)
    end

    if align == "end" then
        return math_max(available_size - item_size, 0)
    end

    return 0
end

--[[
    函数：resolve_justify
    1. 这个函数是用来干什么的
       - 计算 flex 主轴上项目整体的起始偏移量和实际间距。

    2. 为什么这样设计函数
       - 主轴排列不仅仅是“一个个往后摆”，还涉及：
         start / center / end / space-between / space-around / space-evenly
       - 这类规则比较独立，而且只和主轴总空间、项目总尺寸、项目数量、基础 gap 有关。
       - 抽出来后，flex 主循环就能更专注于“逐个放置项目”。

    3. 这个函数是通过做了什么达到设计目的
       - 先算出在使用基础 gap 时，所有项目一共占多少主轴空间
       - 再根据 justify 的不同模式，算出：
         start_offset：第一个项目从哪里开始放
         actual_gap：项目之间实际应该使用多大间距
]]
local function resolve_justify(justify, available_size, items_size, item_count, base_gap)
    local total_size = items_size + base_gap * math_max(item_count - 1, 0)
    local start_offset = 0
    local actual_gap = base_gap

    if justify == "center" then
        start_offset = math_max((available_size - total_size) * 0.5, 0)
    elseif justify == "end" then
        start_offset = math_max(available_size - total_size, 0)
    elseif justify == "space-between" and item_count > 1 and available_size > items_size then
        actual_gap = (available_size - items_size) / (item_count - 1)
    elseif justify == "space-around" and item_count > 0 and available_size > items_size then
        actual_gap = (available_size - items_size) / item_count
        start_offset = actual_gap * 0.5
    elseif justify == "space-evenly" and item_count > 0 and available_size > items_size then
        actual_gap = (available_size - items_size) / (item_count + 1)
        start_offset = actual_gap
    end

    return start_offset, actual_gap
end

--[[
    函数：clamp_value
    1. 这个函数是用来干什么的
       - 把一个数值夹在最小值和最大值之间。

    2. 为什么这样设计函数
       - `sticky` 的核心语义不是直接改写坐标，而是：
         “先保留流式位置，再把结果限制在某个阈值范围内”。
       - 这本质上就是 clamp 行为，所以抽成独立工具最清晰。

    3. 这个函数是通过做了什么达到设计目的
       - 如果给了 min_value，就保证结果不小于它
       - 如果给了 max_value，就保证结果不大于它
       - 如果上下界写反了，会先收敛成同一个值，保证结果稳定
]]
local function clamp_value(value, min_value, max_value)
    if min_value ~= nil and max_value ~= nil and max_value < min_value then
        max_value = min_value
    end

    if min_value ~= nil and value < min_value then
        value = min_value
    end

    if max_value ~= nil and value > max_value then
        value = max_value
    end

    return value
end

--[[
    函数：apply_runtime_box_anchor
    1. 这个函数是用来干什么的
       - 在真实 frame 已经创建完成之后，把一个节点重新改成“基于相对锚点”的运行时定位。
    2. 为什么这样设计函数
       - `fixed` 真正有价值的地方，不是“创建那一刻算对坐标”，而是根节点之后如果移动或缩放，子节点还能继续保持正确关系。
       - `Frame.setRelativePoint()` 正好提供了这个能力，所以这里把“编译期坐标结果”再翻译成“运行时锚点关系”。
       - 之所以单独抽成函数，而不是把逻辑散落在 `bindRuntimeLayout` 里，是因为 fixed 和后续可能扩展的其他锚点模式都会复用同一套轴向锚定规则。
    3. 这个函数是通过做了什么达到设计目的
       - 先 `clearAllPoints()`，避免旧的绝对点或旧锚点继续残留。
       - 再分开处理水平方向和垂直方向：
         如果 style 同时给了 left/right 或 top/bottom，就各自把两侧都钉住；
         否则优先尊重显式 inset；
         如果没有显式 inset，就退回到调用方给出的基础 local 坐标。
       - 这样既能保留 CSS 风格 inset 语义，又能把“相对 target 持续跟随”的能力真正交给 Frame 运行时。
]]
local function apply_runtime_box_anchor(frame, target_frame, style, base_left, base_top)
    if type(frame) ~= "table" or type(target_frame) ~= "table" then
        return
    end

    local left = style.left
    local right = style.right
    local top = style.top
    local bottom = style.bottom

    -- 关键步骤 1：先清空旧锚点。
    -- 如果不先 clear，旧的 absolute point 或之前的 relative point 可能会继续生效，导致多套定位规则叠在一起。
    frame:clearAllPoints()

    -- 关键步骤 2：水平方向单独处理。
    -- 这样可以同时支持：
    -- 1. 只锁左边
    -- 2. 只锁右边
    -- 3. 左右同时锁住，让宽度随 target 变化而拉伸
    if left ~= nil and right ~= nil then
        frame:setRelativePoint(ANCHOR_LEFT, target_frame, ANCHOR_LEFT, to_number(left, 0), 0)
        frame:setRelativePoint(ANCHOR_RIGHT, target_frame, ANCHOR_RIGHT, -to_number(right, 0), 0)
    elseif left ~= nil then
        frame:setRelativePoint(ANCHOR_LEFT, target_frame, ANCHOR_LEFT, to_number(left, 0), 0)
    elseif right ~= nil then
        frame:setRelativePoint(ANCHOR_RIGHT, target_frame, ANCHOR_RIGHT, -to_number(right, 0), 0)
    else
        frame:setRelativePoint(ANCHOR_LEFT, target_frame, ANCHOR_LEFT, base_left, 0)
    end

    -- 关键步骤 3：垂直方向也独立处理。
    -- JASS 这里的 y 偏移是“向上为正”，所以布局里的“向下 top 距离”要写成负值。
    if top ~= nil and bottom ~= nil then
        frame:setRelativePoint(ANCHOR_TOP, target_frame, ANCHOR_TOP, 0, -to_number(top, 0))
        frame:setRelativePoint(ANCHOR_BOTTOM, target_frame, ANCHOR_BOTTOM, 0, to_number(bottom, 0))
    elseif top ~= nil then
        frame:setRelativePoint(ANCHOR_TOP, target_frame, ANCHOR_TOP, 0, -to_number(top, 0))
    elseif bottom ~= nil then
        frame:setRelativePoint(ANCHOR_BOTTOM, target_frame, ANCHOR_BOTTOM, 0, to_number(bottom, 0))
    else
        frame:setRelativePoint(ANCHOR_TOP, target_frame, ANCHOR_TOP, 0, -base_top)
    end
end

--[[
    函数：apply_runtime_sticky_position
    1. 这个函数是用来干什么的
       - 在运行时根据滚动偏移，重新计算 sticky 节点在父容器中的当前位置。
    2. 为什么这样设计函数
       - `setRelativePoint()` 本身只能表达“和谁保持相对关系”，但 sticky 还多了一层“何时开始吸附”的动态阈值逻辑。
       - 这意味着 sticky 不能只靠一次 setRelativePoint 完成，而是要在滚动时重新计算结果。
       - 为了保持低消耗，这里不做全局布局引擎，而是只在外部明确提供 scroll_x / scroll_y 时更新目标节点。
    3. 这个函数是通过做了什么达到设计目的
       - 先拿到 sticky 在正常流中的原始 flow_x / flow_y。
       - 再减去滚动偏移，得到“如果跟着内容一起滚动，它此刻应该出现在哪里”。
       - 然后使用和编译期同样的 clamp 规则，把结果限制在 sticky 的阈值范围内。
       - 最后把这个结果重新写成相对父 frame 的 LEFT/TOP 锚点。
]]
local function apply_runtime_sticky_position(frame, config, scroll_x, scroll_y)
    if type(frame) ~= "table" or type(config) ~= "table" then
        return
    end

    local runtime = rawget(config, "__runtime_layout__")
    if type(runtime) ~= "table" or runtime.position_mode ~= "sticky" then
        return
    end

    local parent_frame = frame.parent
    local parent_config = rawget(config, "__runtime_parent_config__")
    if type(parent_frame) ~= "table" or type(parent_config) ~= "table" then
        return
    end

    local style = normalize_style(config)
    local parent_style = normalize_style(parent_config)
    local parent_padding = normalize_padding(parent_style.padding)
    local parent_content = get_content_box(parent_config)
    local width = to_number(config.width, 0)
    local height = to_number(config.height, 0)
    local flow_x = to_number(runtime.flow_x, 0) - to_number(scroll_x, 0)
    local flow_y = to_number(runtime.flow_y, 0) - to_number(scroll_y, 0)
    local min_x
    local max_x
    local min_y
    local max_y

    -- 关键步骤 1：把 sticky 的 inset 解释成“允许的阈值范围”。
    if style.left ~= nil then
        min_x = to_number(style.left, 0)
    end
    if style.right ~= nil then
        max_x = parent_content.width - to_number(style.right, 0) - width
    end
    if style.top ~= nil then
        min_y = to_number(style.top, 0)
    end
    if style.bottom ~= nil then
        max_y = parent_content.height - to_number(style.bottom, 0) - height
    end

    local local_x = clamp_value(flow_x, min_x, max_x)
    local local_y = clamp_value(flow_y, min_y, max_y)

    -- 关键步骤 2：sticky 不把 inset 当成“直接固定的锚边”，
    -- 而是先算出当前结果，再把结果写回父内容区对应的位置。
    frame:clearAllPoints()
    frame:setRelativePoint(ANCHOR_LEFT, parent_frame, ANCHOR_LEFT, parent_padding.left + local_x, 0)
    frame:setRelativePoint(ANCHOR_TOP, parent_frame, ANCHOR_TOP, 0, -(parent_padding.top + local_y))
end

--[[
    函数：walk_runtime_tree
    1. 这个函数是用来干什么的
       - 按 config.tree 和 frame.childs 的同序关系，同时遍历“声明树”和“真实 frame 树”。
    2. 为什么这样设计函数
       - `Style_demo.lua` 处理的是 config，`Frame.lua` 处理的是真实 frame。
       - 当我们要把编译期结果升级成运行时锚点时，必须把“哪一个 config 对应哪一个 frame”重新配对。
       - 当前框架最稳定、成本最低的配对依据，就是 `Frame.tree` 创建时的子节点顺序。
    3. 这个函数是通过做了什么达到设计目的
       - 先访问当前节点。
       - 再按顺序拿 config.tree 里的子配置，对齐 frame.childs 里的子 frame。
       - 用递归持续向下，把整个树都建立起映射。
]]
local function walk_runtime_tree(config, frame, visit_func)
    if type(config) ~= "table" or type(frame) ~= "table" then
        return
    end

    visit_func(config, frame)

    local tree = rawget(config, "tree")
    local childs = rawget(frame, "childs")
    if type(tree) ~= "table" or type(childs) ~= "table" then
        return
    end

    local child_frame_index = 1
    for index = 1, #tree do
        local child_config = tree[index]
        if type(child_config) == "table" then
            local child_frame = childs[child_frame_index]
            if child_frame then
                walk_runtime_tree(child_config, child_frame, visit_func)
            end
            child_frame_index = child_frame_index + 1
        end
    end
end

--[[
    layout_apply_func 的职责
    1. 用途：统一收纳各种布局模式对应的“编译函数”。
    2. 设计原因：position 和 display 都是“模式分发”问题，用表来做分发表，比大量 if/elseif 更容易扩展和阅读。
    3. 实现方式：先按 position 选择 static/relative/absolute/fixed/sticky，再按 display 选择 flex/grid/table。
]]
local layout_apply_func = {}

--[[
    函数：layout_apply_func.static
    1. 这个函数是用来干什么的
       - 按 static 规则放置当前节点。

    2. 为什么这样设计函数
       - static 是最基础、最保守的布局模式。
       - 它不额外解释 left/right/top/bottom，只尊重父布局流给出的基础位置。
       - 未知 position 值也会回退到这里，保证系统足够稳。

    3. 这个函数是通过做了什么达到设计目的
       - 先取出父布局流中给当前节点预计算的基础位置
       - 再直接把这个局部位置换算成绝对坐标
]]
layout_apply_func.static = function(config, _)
    local parent_content = rawget(config, "__layout_parent_content__")

    -- static 只吃“流式位置”，不做额外偏移。
    local flow_x, flow_y = resolve_flow_position(config)
    set_local_position(config, parent_content, flow_x, flow_y)
end

--[[
    函数：layout_apply_func.relative
    1. 这个函数是用来干什么的
       - 在流式基础位置上，再应用 left/right/top/bottom 偏移。

    2. 为什么这样设计函数
       - relative 的典型语义是“元素仍在原来的流里，但视觉位置可以微调”。
       - 这和 static 的区别不在于它是否参与流布局，而在于它会在流位置基础上追加偏移。

    3. 这个函数是通过做了什么达到设计目的
       - 先拿到父布局流给出的 flow_x / flow_y
       - 再叠加 left/top，并用 right/bottom 作为反向偏移
       - 最后把调整后的局部位置换算为绝对坐标
]]
layout_apply_func.relative = function(config, style)
    local parent_content = rawget(config, "__layout_parent_content__")
    local flow_x, flow_y = resolve_flow_position(config)

    -- relative 是“在原来位置上挪动”，因此偏移直接叠加到 flow 坐标上。
    local local_x = flow_x + to_number(style.left, 0) - to_number(style.right, 0)
    local local_y = flow_y + to_number(style.top, 0) - to_number(style.bottom, 0)

    set_local_position(config, parent_content, local_x, local_y)
end

--[[
    函数：layout_apply_func.absolute
    1. 这个函数是用来干什么的
       - 让当前节点脱离普通流，直接相对父内容区做绝对定位。

    2. 为什么这样设计函数
       - absolute 最常见的用途是角标、浮层、覆盖按钮等，它们不应该挤占普通流式元素的位置。
       - 因此在父容器布局时，absolute 子节点会被跳过，不参与“占位尺寸”统计。
       - 但它仍然需要参考父内容区来解释 left/right/top/bottom。

    3. 这个函数是通过做了什么达到设计目的
       - 如果没有父内容区，退回 relative，避免根节点 absolute 无参考物时出现不可预测行为
       - 如果同时给了 left/right，就推导 width
       - 如果同时给了 top/bottom，就推导 height
       - 再根据 left/right/top/bottom 计算最终局部坐标
       - 最后换算为绝对坐标
]]
layout_apply_func.absolute = function(config, style)
    local parent_content = rawget(config, "__layout_parent_content__")

    -- 根节点没有父内容区时，absolute 没有明确参考物，因此退回 relative 行为更稳妥。
    if not parent_content then
        layout_apply_func.relative(config, style)
        return
    end

    local left = style.left
    local right = style.right
    local top = style.top
    local bottom = style.bottom

    -- 同时给 left/right 时，宽度由“父内容区可用宽度 - 左右偏移”反推。
    if left ~= nil and right ~= nil then
        config.width = math_max(parent_content.width - to_number(left, 0) - to_number(right, 0), 0)
    end

    -- 同时给 top/bottom 时，高度由“父内容区可用高度 - 上下偏移”反推。
    if top ~= nil and bottom ~= nil then
        config.height = math_max(parent_content.height - to_number(top, 0) - to_number(bottom, 0), 0)
    end

    local width = to_number(config.width, 0)
    local height = to_number(config.height, 0)
    local flow_x, flow_y = resolve_flow_position(config)
    local local_x = flow_x
    local local_y = flow_y

    -- x 方向优先级：left 明确指定优先；否则如果写了 right，就从右边反推左边。
    if left ~= nil then
        local_x = to_number(left, 0)
    elseif right ~= nil then
        local_x = math_max(parent_content.width - to_number(right, 0) - width, 0)
    end

    -- y 方向优先级：top 明确指定优先；否则如果写了 bottom，就从底边反推顶部距离。
    if top ~= nil then
        local_y = to_number(top, 0)
    elseif bottom ~= nil then
        local_y = math_max(parent_content.height - to_number(bottom, 0) - height, 0)
    end

    set_local_position(config, parent_content, local_x, local_y)
end

--[[
    函数：layout_apply_func.fixed
    1. 这个函数是用来干什么的
       - 让当前节点脱离普通流，并相对“当前布局树根盒子”进行定位。

    2. 为什么这样设计函数
       - 在标准网页里，fixed 参考的是浏览器视口。
       - 但当前这套编译器没有真正的浏览器视口与滚动树，只有一棵待编译的 UI 配置树。
       - 因此这里采用最稳妥的低成本语义：
         把当前树的根节点盒子视为视口。
       - 这样 fixed 至少能满足最重要的使用场景：
         中间嵌套层级怎么变都不影响它相对整棵布局根的定位。

    3. 这个函数是通过做了什么达到设计目的
       - 先找到当前节点所在布局树的根节点
       - 再以根节点盒子作为 fixed 的参考盒子
       - 支持 left/right/top/bottom 和 absolute 类似的尺寸反推逻辑
       - 最后把局部 fixed 坐标换算为绝对坐标
]]
layout_apply_func.fixed = function(config, style)
    local layout_root = rawget(config, "__layout_root__") or config
    local viewport_box = ensure_viewport_box(layout_root)
    local left = style.left
    local right = style.right
    local top = style.top
    local bottom = style.bottom

    -- fixed 与 absolute 一样，也允许通过左右或上下同时指定来反推尺寸。
    if left ~= nil and right ~= nil then
        config.width = math_max(viewport_box.width - to_number(left, 0) - to_number(right, 0), 0)
    end
    if top ~= nil and bottom ~= nil then
        config.height = math_max(viewport_box.height - to_number(top, 0) - to_number(bottom, 0), 0)
    end

    local width = to_number(config.width, 0)
    local height = to_number(config.height, 0)
    local flow_x, flow_y = resolve_flow_position(config)
    local local_x = flow_x
    local local_y = flow_y

    -- x / y 的解释方式与 absolute 一致，只是参考盒子从父内容区改成了布局根盒子。
    if left ~= nil then
        local_x = to_number(left, 0)
    elseif right ~= nil then
        local_x = math_max(viewport_box.width - to_number(right, 0) - width, 0)
    end

    if top ~= nil then
        local_y = to_number(top, 0)
    elseif bottom ~= nil then
        local_y = math_max(viewport_box.height - to_number(bottom, 0) - height, 0)
    end

    -- 除了写回这一次编译得到的绝对坐标，也把“这是一个 fixed 节点”记录下来。
    -- 后面如果外部在 frame 创建完成后调用 Style.bindRuntimeLayout，就可以把它升级成真正的运行时锚点关系。
    config.__runtime_layout__ = {
        position_mode = "fixed",
    }

    set_local_position(config, viewport_box, local_x, local_y)
end

--[[
    函数：layout_apply_func.sticky
    1. 这个函数是用来干什么的
       - 让当前节点仍参与普通流，但最终位置会被 top/right/bottom/left 夹紧在父内容区允许范围内。

    2. 为什么这样设计函数
       - 标准 sticky 依赖“滚动中的实时位置变化”，这需要滚动容器、滚动偏移、运行时重排。
       - 当前 Frame.lua 没有现成的浏览器式滚动布局运行时，因此无法低成本实现真正的动态 sticky。
       - 在这种前提下，最合理的低成本近似是：
         先把元素当作普通流元素排布；
         再根据 top/right/bottom/left 把最终结果限制在父内容区范围内。
       - 这样保留了 sticky 最关键的两个特点：
         1. 仍参与流式占位
         2. 受阈值约束，不会越过指定边界
       - 但它不会自动响应运行时滚动；这一点必须明确记录。

    3. 这个函数是通过做了什么达到设计目的
       - 先拿到 flow_x / flow_y，也就是父布局给它的普通流位置
       - 再根据 top/right/bottom/left 计算允许的最小/最大范围
       - 然后用 clamp 把流式位置夹进这个范围
       - 最后换算成绝对坐标
]]
layout_apply_func.sticky = function(config, style)
    local parent_content = rawget(config, "__layout_parent_content__")

    -- 根节点没有父内容区时，sticky 就失去了“相对父容器阈值”的意义，因此退回 relative。
    if not parent_content then
        layout_apply_func.relative(config, style)
        return
    end

    local flow_x, flow_y = resolve_flow_position(config)
    local width = to_number(config.width, 0)
    local height = to_number(config.height, 0)
    local left = style.left
    local right = style.right
    local top = style.top
    local bottom = style.bottom
    local min_x
    local max_x
    local min_y
    local max_y

    -- sticky 的 inset 在这里被解释为“允许的阈值范围”，而不是 absolute 那样的直接锚点。
    if left ~= nil then
        min_x = to_number(left, 0)
    end
    if right ~= nil then
        max_x = parent_content.width - to_number(right, 0) - width
    end
    if top ~= nil then
        min_y = to_number(top, 0)
    end
    if bottom ~= nil then
        max_y = parent_content.height - to_number(bottom, 0) - height
    end

    local local_x = clamp_value(flow_x, min_x, max_x)
    local local_y = clamp_value(flow_y, min_y, max_y)

    -- sticky 需要保留“原始流位置”，因为运行时滚动更新时，
    -- 真正参与阈值判断的是“流位置减去滚动偏移”。
    config.__runtime_layout__ = {
        position_mode = "sticky",
        flow_x = flow_x,
        flow_y = flow_y,
    }

    set_local_position(config, parent_content, local_x, local_y)
end

--[[
    函数：layout_apply_func.flex
    1. 这个函数是用来干什么的
       - 按 flex 规则为当前容器的普通子节点预计算流式位置。

    2. 为什么这样设计函数
       - flex 更适合一维排列：一行排开，或者一列排开。
       - 这里我们不做浏览器级别的完整 flex 实现，而是保留最有用的核心能力：
         direction / gap / justify / align / stretch
       - 这样既能覆盖大量常见场景，又不会把运行时变得太重。

    3. 这个函数是通过做了什么达到设计目的
       - 先拿到容器内容区，确定主轴与交叉轴
       - 收集所有“非 absolute”的子节点作为流式项目
       - 统计它们在主轴上总共占多少尺寸
       - 根据 justify 计算主轴起点和实际 gap
       - 逐个为子节点写入 __layout_flow_x__ / __layout_flow_y__
       - 子节点后续再由自己的 position 规则把这个流式位置编译成最终绝对坐标
]]
layout_apply_func.flex = function(config, style)
    local tree = rawget(config, "tree")
    if type(tree) ~= "table" or #tree == 0 then
        return
    end

    local content_box = ensure_content_box(config)
    local direction = style.direction or style.flex_direction or "row"
    local justify = style.justify or "start"
    local align = style.align or "start"
    local row_gap, column_gap = normalize_gap(style)
    local gap = direction == "column" and row_gap or column_gap
    local main_size = direction == "column" and content_box.height or content_box.width
    local cross_size = direction == "column" and content_box.width or content_box.height

    local flow_count = 0
    local items_size = 0

    for index = 1, #tree do
        local child = tree[index]
        if type(child) == "table" then
            local child_style = normalize_style(child)

            -- absolute / fixed 元素都脱离普通流，因此不参与 flex 的占位统计。
            local child_position = rawget(child_style, "position")
            if child_position ~= "absolute" and child_position ~= "fixed" then
                flow_count = flow_count + 1

                -- 主轴总尺寸统计只关心主轴方向上的 size。
                if direction == "column" then
                    items_size = items_size + to_number(child.height, 0)
                else
                    items_size = items_size + to_number(child.width, 0)
                end
            end
        end
    end

    if flow_count == 0 then
        return
    end

    local start_offset, actual_gap = resolve_justify(justify, main_size, items_size, flow_count, gap)
    local cursor = start_offset
    local placed_count = 0

    -- 这里改成第二次直接遍历原 tree，而不是先构造 flow_children 数组。
    -- 这样做的原因是：
    -- 1. 可以少分配一个中间数组
    -- 2. 子节点顺序本来就保存在 tree 里，直接二次扫描更省内存
    for index = 1, #tree do
        local child = tree[index]
        if type(child) == "table" then
            local child_style = normalize_style(child)
            local child_position = rawget(child_style, "position")
            if child_position ~= "absolute" and child_position ~= "fixed" then
                placed_count = placed_count + 1

                local child_align = child_style.align_self or align
                local offset_x = to_number(child.x, 0)
                local offset_y = to_number(child.y, 0)

                if direction == "column" then
                    -- stretch 在纵向主轴下表示：交叉轴是宽度，因此可以拉伸宽度占满可用区域。
                    if child_align == "stretch" and child.width == nil then
                        child.width = cross_size
                    end

                    local child_width = to_number(child.width, 0)

                    -- x 由交叉轴对齐决定；y 由主轴 cursor 决定。
                    child.__layout_flow_x__ = resolve_alignment_offset(child_align, cross_size, child_width) + offset_x
                    child.__layout_flow_y__ = cursor + offset_y

                    -- 放完当前项后，cursor 沿主轴向后推进当前项的高度。
                    cursor = cursor + to_number(child.height, 0)
                else
                    -- stretch 在横向主轴下表示：交叉轴是高度，因此可以拉伸高度占满可用区域。
                    if child_align == "stretch" and child.height == nil then
                        child.height = cross_size
                    end

                    local child_height = to_number(child.height, 0)

                    -- row 模式下：x 由主轴 cursor 决定；y 由交叉轴对齐决定。
                    child.__layout_flow_x__ = cursor + offset_x
                    child.__layout_flow_y__ = resolve_alignment_offset(child_align, cross_size, child_height) + offset_y

                    -- 放完当前项后，cursor 沿主轴向后推进当前项的宽度。
                    cursor = cursor + to_number(child.width, 0)
                end

                -- 项与项之间再补上一段主轴间距。
                if placed_count < flow_count then
                    cursor = cursor + actual_gap
                end
            end
        end
    end
end

--[[
    函数：layout_apply_func.grid
    1. 这个函数是用来干什么的
       - 按 grid 规则为子节点分配网格单元，并预计算每个子节点的流式位置。

    2. 为什么这样设计函数
       - grid 比 flex 更适合二维分布：既关心行，也关心列。
       - 这里仍然坚持“够用优先”的实现思路，只支持当前最需要的能力：
         columns / gap / cell_width / cell_height / align / justify / stretch
       - 这样能支持卡片网格、表格式宫格等常见布局，同时避免引入复杂的浏览器级网格算法。

    3. 这个函数是通过做了什么达到设计目的
       - 先确定总列数
       - 再按“从左到右、从上到下”的顺序给普通流子节点分配 row / column
       - 统计每列宽度和每行高度
       - 计算每一列和每一行的起始偏移
       - 最后把每个子节点在各自单元格里的对齐结果写回 __layout_flow_x__ / __layout_flow_y__
]]
layout_apply_func.grid = function(config, style)
    local tree = rawget(config, "tree")
    if type(tree) ~= "table" or #tree == 0 then
        return
    end

    local columns = math_max(math_floor(to_number(style.columns or style.cols, 1)), 1)
    local content_box = ensure_content_box(config)
    local row_gap, column_gap = normalize_gap(style)
    local justify = style.justify or "start"
    local align = style.align or "start"
    local explicit_cell_width = style.cell_width
    local explicit_cell_height = style.cell_height

    local column_widths = {}
    local row_heights = {}
    local flow_index = 0

    for index = 1, #tree do
        local child = tree[index]
        if type(child) == "table" then
            local child_style = normalize_style(child)

            -- absolute / fixed 子节点都不参与网格占位，只在之后用自己的定位规则单独计算。
            local child_position = rawget(child_style, "position")
            if child_position ~= "absolute" and child_position ~= "fixed" then
                flow_index = flow_index + 1

                -- 采用简单、稳定的按序填充方式：先列后行。
                local row = math_floor((flow_index - 1) / columns) + 1
                local column = ((flow_index - 1) % columns) + 1

                -- 如果容器声明了统一单元格尺寸，而子节点自己没写，就直接继承容器尺寸。
                if explicit_cell_width ~= nil and child.width == nil then
                    child.width = explicit_cell_width
                end
                if explicit_cell_height ~= nil and child.height == nil then
                    child.height = explicit_cell_height
                end

                local cell_width = explicit_cell_width
                if cell_width == nil and content_box.width > 0 then
                    -- 没有显式 cell_width 时，默认把可用宽度平均分配给每一列。
                    cell_width = (content_box.width - column_gap * (columns - 1)) / columns
                end

                local width = to_number(child.width, 0)
                local height = to_number(child.height, 0)

                -- 每列宽度优先使用容器统一列宽；否则由该列出现过的最大元素宽度撑开。
                if cell_width ~= nil then
                    column_widths[column] = cell_width
                else
                    column_widths[column] = math_max(column_widths[column] or 0, width)
                end

                -- 每行高度由该行的最大元素高度决定，或者使用显式 cell_height。
                row_heights[row] = math_max(row_heights[row] or 0, height, to_number(explicit_cell_height, 0))
            end
        end
    end

    if flow_index == 0 then
        return
    end

    local row_count = math_floor((flow_index + columns - 1) / columns)
    local column_offsets = {}
    local row_offsets = {}
    local x_cursor = 0
    local y_cursor = 0

    -- 预先算出每一列左边界，后面定位单元格时可以直接查表。
    for column = 1, columns do
        column_offsets[column] = x_cursor
        x_cursor = x_cursor + (column_widths[column] or 0)
        if column < columns then
            x_cursor = x_cursor + column_gap
        end
    end

    -- 同理，预先算出每一行的顶部偏移。
    for row = 1, row_count do
        row_offsets[row] = y_cursor
        y_cursor = y_cursor + (row_heights[row] or 0)
        if row < row_count then
            y_cursor = y_cursor + row_gap
        end
    end

    -- 这里不再创建 placements 临时表，而是再次顺序扫描 tree。
    -- 这样仍然能得到完全相同的 row/column 结果，但能少分配很多小表。
    flow_index = 0
    for index = 1, #tree do
        local child = tree[index]
        if type(child) == "table" then
            local child_style = normalize_style(child)
            local child_position = rawget(child_style, "position")
            if child_position ~= "absolute" and child_position ~= "fixed" then
                flow_index = flow_index + 1

                local row = math_floor((flow_index - 1) / columns) + 1
                local column = ((flow_index - 1) % columns) + 1
                local child_justify = child_style.justify_self or justify
                local child_align = child_style.align_self or align
                local offset_x = to_number(child.x, 0)
                local offset_y = to_number(child.y, 0)
                local cell_width = column_widths[column] or 0
                local cell_height = row_heights[row] or 0

                -- stretch 表示在当前单元格内把自己沿对应方向拉满。
                if child_justify == "stretch" and child.width == nil then
                    child.width = cell_width
                end
                if child_align == "stretch" and child.height == nil then
                    child.height = cell_height
                end

                local width = to_number(child.width, 0)
                local height = to_number(child.height, 0)

                -- 单元格最终位置 = 单元格起点 + 单元格内对齐偏移 + 子节点自己声明的额外偏移。
                child.__layout_flow_x__ = column_offsets[column]
                    + resolve_alignment_offset(child_justify, cell_width, width)
                    + offset_x
                child.__layout_flow_y__ = row_offsets[row]
                    + resolve_alignment_offset(child_align, cell_height, height)
                    + offset_y
            end
        end
    end
end

--[[
    函数：layout_apply_func["table"]
    1. 这个函数是用来干什么的
       - 给外部保留一个 table 布局入口，目前内部直接复用 grid 的实现。

    2. 为什么这样设计函数
       - 有些调用侧会更习惯把这种二维排布叫 table。
       - 但在当前这版轻量实现里，table 和 grid 的需求高度重合，没有必要重复造一套算法。

    3. 这个函数是通过做了什么达到设计目的
       - 直接把参数转发给 grid，让 table 成为 grid 的别名
]]
layout_apply_func["table"] = function(config, style)
    layout_apply_func.grid(config, style)
end

--[[
    函数：apply_layout_tree
    1. 这个函数是用来干什么的
       - 递归处理整棵声明式配置树，把每个节点都编译为最终可创建的布局结果。

    2. 为什么这样设计函数
       - 布局计算有明显的父子依赖：
         父节点先决定自己的内容区
         子节点再根据父内容区计算自己的位置
       - 因此最自然的执行顺序就是深度优先递归。
       - 同时 position 与 display 的责任不同：
         position 决定“当前节点自己怎么放”
         display 决定“当前节点的子节点怎么排”
       - 所以这里先应用当前节点的 position，再应用当前节点作为容器时的 display。

    3. 这个函数是通过做了什么达到设计目的
       - 先给当前节点写入 parent、layout_root 与 parent_content 的编译上下文
       - 再根据 style.position 分发到 static / relative / absolute / fixed / sticky
       - 再根据 style.display 分发到 flex / grid / table
       - 然后递归处理所有子节点
]]
local function apply_layout_tree(config, parent_config)
    if type(config) ~= "table" then
        return config
    end

    local style = normalize_style(config)
    local tree = rawget(config, "tree")
    local has_children = type(tree) == "table" and #tree > 0

    -- 运行时绑定元数据不属于“本轮临时态”，
    -- 但同一份 config 如果再次重新编译，必须先清空旧结果，避免保留过期模式。
    config.__runtime_layout__ = nil
    config.__runtime_parent_config__ = parent_config

    -- 这三项是当前节点在编译阶段的上下文：
    -- 1. 它是谁的孩子
    -- 2. 它所在布局树的根是谁（给 fixed 使用）
    -- 3. 它参考哪个父内容区（给 static/relative/absolute/sticky 使用）
    config.__layout_parent__ = parent_config
    config.__layout_root__ = parent_config and (rawget(parent_config, "__layout_root__") or parent_config) or config
    config.__layout_parent_content__ = parent_config and ensure_content_box(parent_config) or nil

    -- 第一步：先决定“当前节点自己放在哪里”。
    local position_mode = get_position_mode(style)
    local position_apply = layout_apply_func[position_mode] or layout_apply_func.static
    position_apply(config, style)

    -- 如果当前节点有孩子，那么它自己的内容区一定会在本轮编译中反复被访问。
    -- 这里提前缓存下来，避免每个孩子都重新计算一遍。
    if has_children then
        ensure_content_box(config)
    end

    -- 根节点盒子会被 fixed 子节点当作“静态视口”使用。
    -- 这里也提前缓存，后面 fixed 分支就可以直接复用。
    if rawget(config, "__layout_root__") == config then
        ensure_viewport_box(config)
    end

    -- 第二步：如果当前节点是容器，再决定“它的孩子们应该如何排布”。
    local display_mode = style.display
    local display_apply = display_mode and layout_apply_func[display_mode]
    if display_apply then
        display_apply(config, style)
    end

    if has_children then
        for index = 1, #tree do
            local child = tree[index]
            if type(child) == "table" then
                -- 如果父布局没有为子节点预先写入流式坐标，就保留子节点自身声明的 x/y 作为起点。
                if child.__layout_flow_x__ == nil then
                    child.__layout_flow_x__ = to_number(child.x, 0)
                end
                if child.__layout_flow_y__ == nil then
                    child.__layout_flow_y__ = to_number(child.y, 0)
                end

                apply_layout_tree(child, config)
            end
        end
    end

    return config
end

--[[
    函数：cleanup_layout_state
    1. 这个函数是用来干什么的
       - 清理布局编译过程中挂在节点上的临时字段。

    2. 为什么这样设计函数
       - __layout_parent__、__layout_flow_x__ 这些字段只在“编译布局”这一瞬间有意义。
       - 如果把它们永久留在配置表上，会让最终配置看起来很脏，也容易误导后续代码。

    3. 这个函数是通过做了什么达到设计目的
       - 递归整棵 tree
       - 把所有 __layout_* 临时字段都置空
]]
local function cleanup_layout_state(config)
    if type(config) ~= "table" then
        return
    end

    config.__layout_parent__ = nil
    config.__layout_root__ = nil
    config.__layout_parent_content__ = nil
    config.__layout_content_box__ = nil
    config.__layout_viewport_box__ = nil
    config.__layout_flow_x__ = nil
    config.__layout_flow_y__ = nil
    config.__layout_local_x__ = nil
    config.__layout_local_y__ = nil

    local tree = rawget(config, "tree")
    if type(tree) == "table" then
        for index = 1, #tree do
            cleanup_layout_state(tree[index])
        end
    end
end

--[[
    函数：Style.applyLayout
    1. 这个函数是用来干什么的
       - 这是模块的公开入口，用来对一整棵 UI 配置树执行布局编译。

    2. 为什么这样设计函数
       - 外部调用方不应该关心内部先调 position、再调 display、再清临时状态这些细节。
       - 提供一个单一入口后，调用方只需要记住一件事：
         “把声明式配置传进来，拿回编译好的绝对坐标配置。”

    3. 这个函数是通过做了什么达到设计目的
       - 先递归编译整棵 tree
       - 再清理临时状态
       - 最后把原配置表返回，方便外部链式继续使用
]]
function Style.applyLayout(config)
    apply_layout_tree(config, nil)
    cleanup_layout_state(config)
    return config
end

-- 把布局分发表也暴露出去，便于调试或做更细粒度的扩展。
Style.layout_apply_func = layout_apply_func

--[[
    函数：Style.bindRuntimeLayout
    1. 这个函数是用来干什么的
       - 在真实 frame 树创建完成之后，把 `fixed` 和 `sticky` 从“编译期坐标结果”升级成“运行时锚点关系”。
    2. 为什么这样设计函数
       - `Style.applyLayout(config)` 运行时，真实 frame 还不存在，所以那时只能先把样式编译成 x/y/width/height。
       - 但 `fixed` 真正的能力，必须等 frame 创建出来后，调用 `setRelativePoint()` 才能让它在后续继续跟随 root。
       - sticky 也一样，只有在 frame 存在后，后续滚动更新时我们才能重新写锚点。
       - 因此这里把“编译布局”和“绑定运行时关系”拆成两个阶段：前者负责产出结果，后者负责把结果接到真实 frame 上。
    3. 这个函数是通过做了什么达到设计目的
       - 先同步遍历 config 树和 frame 树。
       - 对 fixed 节点，把它改成相对 root_frame 的运行时锚点。
       - 对 sticky 节点，先按 scroll=0 的状态写入一次相对父节点的位置，这样后续只需要调用 updateStickyFrame / updateStickyTree 即可继续刷新。
]]
function Style.bindRuntimeLayout(root_frame, config)
    if type(root_frame) ~= "table" or type(config) ~= "table" then
        return root_frame
    end

    -- fixed 运行时锚点改为相对 GameUI（屏幕根节点），与编译期 get_viewport_box 使用屏幕尺寸的语义保持一致。
    -- base_left / base_top 是编译期算出的绝对坐标（相对屏幕左上角），直接作为 setRelativePoint 的 offset。
    local game_ui = Frame.getGameUI()

    walk_runtime_tree(config, root_frame, function(current_config, current_frame)
        local runtime = rawget(current_config, "__runtime_layout__")
        if type(runtime) ~= "table" then
            return
        end

        if runtime.position_mode == "fixed" then
            local style = normalize_style(current_config)
            local base_left = to_number(current_config.x, 0)
            local base_top  = SCREEN_HEIGHT - to_number(current_config.y, 0)
            apply_runtime_box_anchor(current_frame, game_ui, style, base_left, base_top)
        elseif runtime.position_mode == "sticky" then
            apply_runtime_sticky_position(current_frame, current_config, 0, 0)
        end
    end)

    return root_frame
end

--[[
    函数：Style.updateStickyFrame
    1. 这个函数是用来干什么的
       - 用外部提供的滚动偏移，刷新单个 sticky frame 的实时位置。
    2. 为什么这样设计函数
       - `setRelativePoint()` 只解决“跟着谁走”，不能替代 sticky 的阈值判断。
       - 但只要调用方能够拿到滚动值，这里就能用一个很轻量的函数把 sticky 恢复成真正的运行时行为。
       - 单独提供单节点接口，是为了方便调用方在已有 scroll 回调里只更新受影响节点，而不是每次都重跑整棵树。
    3. 这个函数是通过做了什么达到设计目的
       - 直接复用 `apply_runtime_sticky_position()`。
       - scroll_x / scroll_y 都按“内容已经滚过去多少”的语义解释。
       - 如果节点不是 sticky，函数会直接无副作用返回。
]]
function Style.updateStickyFrame(frame, config, scroll_x, scroll_y)
    apply_runtime_sticky_position(frame, config, scroll_x, scroll_y)
    return frame
end

--[[
    函数：Style.updateStickyTree
    1. 这个函数是用来干什么的
       - 批量刷新一整棵 frame 树里所有 sticky 节点的运行时位置。
    2. 为什么这样设计函数
       - 有些滚动容器里的 sticky 节点不止一个，逐个手写调用既啰嗦也容易漏。
       - 提供一个整树版本后，调用方可以在 scroll 事件里统一传入一次滚动偏移，让所有 sticky 节点一起更新。
    3. 这个函数是通过做了什么达到设计目的
       - 沿用 `walk_runtime_tree()` 的 config/frame 对齐遍历。
       - 遇到 sticky 节点就调用 `apply_runtime_sticky_position()`。
       - 其他节点直接跳过，因此不会把普通节点重复改写成相对锚点。
]]
function Style.updateStickyTree(root_frame, config, scroll_x, scroll_y)
    if type(root_frame) ~= "table" or type(config) ~= "table" then
        return root_frame
    end

    walk_runtime_tree(config, root_frame, function(current_config, current_frame)
        local runtime = rawget(current_config, "__runtime_layout__")
        if type(runtime) == "table" and runtime.position_mode == "sticky" then
            apply_runtime_sticky_position(current_frame, current_config, scroll_x, scroll_y)
        end
    end)

    return root_frame
end

--[[
    函数：Style.reapplyLayout
    1. 这个函数是用来干什么的
       - 在真实 frame 树已存在的情况下，重新编译 config 布局并把新坐标/尺寸写回对应的 frame。
       - 这是 P6「最小可行路径运行时重排」的实现：
         applyLayout 负责重新产出坐标，reapplyLayout 负责把产出结果写回已有 frame。

    2. 为什么这样设计函数
       - Style.applyLayout 只操作 config，不知道 frame 的存在。
       - bindRuntimeLayout 只处理 fixed/sticky 的锚点升级，不回写尺寸/位置。
       - 因此需要一个第三步：同步遍历 config 树和 frame 树，把新编译结果写入已有 frame。
       - 刻意不销毁/重建 frame，保留事件绑定和业务状态，降低调用方负担。

    3. 这个函数是通过做了什么达到设计目的
       - 先调用 applyLayout(config) 重新编译整棵 config 树。
       - 再用 walk_runtime_tree 同步遍历 config 树和已有 frame 树。
       - 对每个节点，把 config.x/y/width/height 写回 frame 的 size 和 position。
       - 最后调用 bindRuntimeLayout 升级 fixed/sticky 为运行时锚点。
]]
function Style.reapplyLayout(root_frame, config)
    if type(root_frame) ~= "table" or type(config) ~= "table" then
        return root_frame
    end

    -- 步骤 1：重新编译布局，产出最新的 x/y/width/height。
    Style.applyLayout(config)

    -- 步骤 2：把编译结果写回已有 frame，不销毁重建。
    walk_runtime_tree(config, root_frame, function(current_config, current_frame)
        local w = to_number(current_config.width, 0)
        local h = to_number(current_config.height, 0)
        local x = current_config.x
        local y = current_config.y

        -- 跳过 fixed/sticky 节点的绝对坐标写回；
        -- 它们会在步骤 3 的 bindRuntimeLayout 里通过 setRelativePoint 重新定位。
        local runtime = rawget(current_config, "__runtime_layout__")
        local is_anchored = type(runtime) == "table" and
            (runtime.position_mode == "fixed" or runtime.position_mode == "sticky")

        current_frame.size = Point(w, h)

        if not is_anchored and x ~= nil and y ~= nil then
            current_frame.position = Point(to_number(x, 0), to_number(y, 0))
        end
    end)

    -- 步骤 3：升级 fixed/sticky 为运行时锚点。
    Style.bindRuntimeLayout(root_frame, config)

    return root_frame
end

return Style
