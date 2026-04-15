# UI 框架全面分析报告

## Context

针对 `Code/Core/UI/` 目录下的 Warcraft 3 自定义 Lua UI 框架进行全面审查，覆盖架构设计、性能、可维护性、开发便利性，并列举框架目前支持的所有写法供开发参考。

---

## 一、框架整体架构

### 1.1 文件结构

```
Code/Core/UI/
├── Frame.lua        — 所有 UI 的抽象基类（属性/事件/定位/生命周期）
├── Component.lua    — 声明式工厂层（类型注册 + 树状创建入口）
├── Theme.lua        — 主题系统（token/vars/rules/selector）
├── Style.lua        — 布局编译器（flex/absolute/static/fixed/sticky）
├── Panel.lua        — BACKDROP 容器，等价于 HTML <div>
├── Texture.lua      — CSimpleTexture 轻量贴图（继承 Panel）
├── Text.lua         — CTEXT 标准文本
├── SimpleText.lua   — CSimpleFontString 轻量文本
├── TextArea.lua     — TEXTAREA 多行文本
├── Button.lua       — SIMPLEBUTTON 按钮
├── Slider.lua       — SLIDER 滑块/进度条
├── Model.lua        — MODEL 简单 3D 模型
├── Sprite.lua       — SPRITE 完整 3D 精灵（继承 Model）
└── Portrait.lua     — CPortraitButton 肖像（继承 Sprite）
```

关联模块（非 UI 目录但 UI 强依赖）：
- `Lib/Base/Class.lua` — OOP 基础设施
- `FrameWork/Manager/Async.lua` — UI tick 异步引擎
- `FrameWork/Manager/Point.lua` — 二维坐标值对象
- `Lib/Base/LinkedList.lua` — 事件/Watcher 链表

### 1.2 类继承链

```
Frame（抽象基类）
├── Panel（BACKDROP）
│   └── Texture（CSimpleTexture）
├── Text（CTEXT）
├── SimpleText（CSimpleFontString）
├── TextArea（TEXTAREA）
├── Button（SIMPLEBUTTON）
├── Slider（SLIDER）
└── Model（MODEL）
    └── Sprite（SPRITE）
        └── Portrait（CPortraitButton）
```

### 1.3 架构分层（从上到下）

```
┌────────────────────────────────────────────┐
│  业务层 View/、Logic/                       │
├────────────────────────────────────────────┤
│  Component 工厂       Theme 主题系统         │  声明式入口
│  Style 布局编译器                           │  布局预处理
├────────────────────────────────────────────┤
│  Frame 基类 + Widget 子类                   │  核心运行时
├────────────────────────────────────────────┤
│  Tween 补间动画   Watcher 属性监听           │  增强运行时
├────────────────────────────────────────────┤
│  Async UI-tick引擎  Point 坐标对象           │  基础设施
├────────────────────────────────────────────┤
│  Jass API（MHFrame_*）                      │  底层平台
└────────────────────────────────────────────┘
```

---

## 二、各模块详细分析

### 2.1 Class.lua — OOP 基础设施

**设计亮点：**
- `_index_compilers`/`_newindex_compilers` 查表法：按「有无 getattr」×「__index__ 类型」预生成 6 种特化闭包，运行期零分支
- `modify_field(name)` 用唯一表键（`{}`）存储私有字段，彻底规避字符串 key 命名冲突
- 属性访问器编译时特化，子类传播时按需局部重编译（`_attrToSubClassFromBase`）
- 支持元类钩子（`__metaclass__`/`__newclass__`），可在类创建时做全局变换
- 实例方法存 proxy（`class.__data__`），静态成员 `rawset` 写 class 本体，职责清晰

**问题：**
- `_instance_gc` 用 `__gc` 检测未销毁实例，标准 Lua 5.3 table 不保证 finalizer 触发，实际可能失效（Class.lua:292-303）
- `_instance_destroy` 线性遍历继承链调用 `__del__`，当前最深 3 层可接受，继承链加深后线性增长

### 2.2 Frame.lua — 基类核心

**设计亮点：**
- `modify_field` 缓存私有字段 key，避免运行时字符串拼接
- `LinkedList_add/remove/forEachExecute` 静态引用缓存，减少全局表查找
- `childs` 用保护元表封装，外部无法意外写入（Frame.lua:72-86）
- `wrapHandle` 惰性封装外部 handle，不重复创建
- `hook_destroy` 单点钩子，Component 注入 Watcher/Tween 清理，低耦合
- 事件系统：`FRAME_EVENT_MAP` 预构建名称→ID 映射，O(1) 查找
- `__common_constructor` 被大多数子类共享，减少重复代码

**问题：**

1. **`childsUpdate` 每次全量重建**（Frame.lua:142-162）
   每次父子关系变化都清空再重建，子节点多且频繁变更时有冗余遍历。可考虑差量更新或仅在真正需要 childs 视图时懒同步。

2. **`TreeCreate` 子节点坐标默认值继承过宽**（Frame.lua:197-202）
   子节点未填 x/y/width/height 时直接继承父节点，容易导致子节点完全重叠父节点而难以察觉。建议在 `__DEBUG__` 下对缺失坐标子节点发出警告。

3. **事件存储在实例字段 `__events`**（Frame.lua:816）
   每次 `on()` 首次调用才创建 `__events` 表，这是合理的懒初始化。但 `__events` 直接挂在实例上，destroy 时 Component 的 hook 负责置 nil，若用户绕过 Component 直接操作 Frame，清理可能遗漏。

4. **`width`/`height` setter 各自重建 Point**（Frame.lua:403-419）
   单独设置 width 时会 `frame.height`（触发 getter 走 JASS），再构造新 Point。频繁单独改 width 的场景有冗余 JASS 调用，推荐改用 `frame.size = Point(w, h)` 一次设置。

---

### 2.3 Style.lua — 布局编译器

**设计亮点：**
- 一次性「编译期」把声明式 tree 转换成 Frame 的绝对坐标，运行时无持续计算
- `ensure_content_box` / `ensure_viewport_box` 惰性缓存，同一父节点多子节点只算一次 padding
- `normalize_padding` 支持 number / 数组 / 命名表三种写法，兼容性好
- `normalize_gap` 支持 gap / row_gap / column_gap 组合写法
- 支持 static / relative / absolute / fixed / sticky 五种 position 模式
- flex/grid 两种 display 模式

**设计亮点（补充）：**
- `cleanup_layout_state`（Style.lua:1358）在 `applyLayout` 末尾递归清理全部 `__layout_*` 临时字段，config 不会残留编译垃圾
- `Style.bindRuntimeLayout`（Style.lua:1419）两阶段架构：编译期产出坐标，frame 创建后再升级成运行时锚点
- `Style.updateStickyFrame` / `Style.updateStickyTree`（Style.lua:1459/1476）已提供完整的运行时 sticky 刷新 API

**问题：**

1. **`sticky` / `fixed` 运行时能力已存在但需主动调用**（Style.lua:1406-1489）
   `bindRuntimeLayout` + `updateStickyTree` 已实现运行时跟随，但需业务层在 frame 创建后显式调用，且 sticky 需在 scroll 事件中持续调用 `updateStickyTree`。详见下方「§4 sticky/fixed 运行时方案」。

2. **`fixed` 参考布局树根节点而非屏幕**（Style.lua:287-302）
   与 CSS `position: fixed` 语义不同（CSS 参考 viewport，此框架参考布局根节点）。这是有意设计，需在文档中明确。

   **P5 可行性评估：改为参考屏幕（viewport）**

   WC3 的屏幕坐标系固定：x ∈ [0, 0.8]，y ∈ [0, 0.6]（4:3 基准比例）。GameUI frame 就是屏幕根节点。因此「参考屏幕」等价于「以 GameUI 为参考父节点」。

   可行性：**高**，改动量极小。

   需要修改两处：

   **修改一：`get_viewport_box`（Style.lua:295）** — 编译期用屏幕尺寸替代布局根节点尺寸：
   ```lua
   -- 修改前：用布局根节点 x/y/width/height
   local function get_viewport_box(config)
       return {
           abs_x = to_number(config.x, 0),
           abs_y = to_number(config.y, 0),
           width = to_number(config.width, 0),
           height = to_number(config.height, 0),
       }
   end

   -- 修改后：用屏幕固定尺寸（4:3 WC3 坐标系）
   local SCREEN_WIDTH  = 0.8
   local SCREEN_HEIGHT = 0.6
   local function get_viewport_box(_config)
       return {
           abs_x  = 0,
           abs_y  = SCREEN_HEIGHT,  -- Frame 坐标系 y 轴向上，顶部为 0.6
           width  = SCREEN_WIDTH,
           height = SCREEN_HEIGHT,
       }
   end
   ```

   **修改二：`apply_runtime_box_anchor`（Style.lua:568）** — 运行时锚点改为相对 GameUI frame 而非 root_frame：
   ```lua
   -- Style.bindRuntimeLayout 中对 fixed 节点的调用：
   -- 修改前：
   apply_runtime_box_anchor(current_frame, root_frame, style, base_left, base_top)

   -- 修改后：先拿到 GameUI frame
   local game_ui = Frame.getGameUI()  -- 需在顶部 require Frame
   apply_runtime_box_anchor(current_frame, game_ui, style, base_left, base_top)
   ```

   **注意事项**：
   - WC3 宽高比固定（4:3），不存在浏览器的 viewport resize 问题，屏幕尺寸常量可安全硬编码。
   - 若地图支持 16:9 宽屏，x 轴实际范围会超出 0.8，需按比例调整 `SCREEN_WIDTH`（通常为 `0.8 * 16/12 ≈ 1.067`）。
   - Style.lua 引入 Frame 会形成循环 require（Frame → Style？），需先确认 Frame 是否已 require Style；若有循环需改为延迟 `require` 或从外部传入 game_ui frame。

   **结论**：改动安全，两处修改即可完成。建议先确认宽屏支持需求再决定是否启用。

3. **`__runtime_layout__` / `__runtime_parent_config__` 不在 cleanup 范围内**
   `cleanup_layout_state` 只清 `__layout_*` 前缀字段（Style.lua:1358-1379），而 `bindRuntimeLayout` 写入的 `__runtime_layout__` / `__runtime_parent_config__` 在 config 上永久保留（这是 `updateStickyFrame` 正常工作的依赖）。若 config 在 frame destroy 后仍被持有，这两个字段会造成 frame 引用泄漏。

   **修复方案**（待决策）：在 `Component.lua` 的 `hook_destroy` 中，通过遍历 config 树将 runtime 字段置 nil：

   ```lua
   -- Component.lua 中 attachRuntimeTheme / hook_destroy 附近
   local function cleanup_runtime_layout(config)
       if type(config) ~= "table" then return end
       config.__runtime_layout__ = nil
       config.__runtime_parent_config__ = nil
       local tree = rawget(config, "tree")
       if type(tree) == "table" then
           for i = 1, #tree do
               cleanup_runtime_layout(tree[i])
           end
       end
   end

   -- 在注册 hook_destroy 时追加：
   frame:hook_destroy(function()
       cleanup_runtime_layout(config)
   end)
   ```

   注意：此方案依赖调用方在 `Component()` 创建时保留了 config 引用，且 config 本身不被其他地方复用。若 config 会被多个 frame 共享，需改用外部 `WeakMap`（弱值表）存储 config→frame 映射。

---

### 2.4 Theme.lua — 主题系统

**设计亮点：**
- `reserved_keys` + `mergeable_keys` 双白名单机制，避免主题字段污染业务 config
- `$token` 字符串语法简洁，`Theme.ref(name, fallback)` 提供带兜底的引用
- 支持 `extends` 继承、`vars`/`theme_vars` 节点级变量覆盖
- `parse_selector` 支持类型名、`.label`、`#id` 及复合 selector，specificity 排序
- `clone_value` 深拷贝处理循环引用，`clone_declaration_value` 函数值直传不克隆

**问题：**

1. ~~**`mergeable_keys` 白名单需手动维护**~~ **[已修复]**
   已在 Theme.lua 新增 `Theme.collectAttributeKeys(classes)` 函数，在初始化阶段一次性从各 Widget 的 `__attributes__` 自动收集属性名写入 `mergeable_keys`。

   **使用方式**（在所有 Widget 类 require 完成后调用一次）：

   ```lua
   local Theme = require "Core.UI.Theme"
   local Panel    = require "Core.UI.Panel"
   local Texture  = require "Core.UI.Texture"
   local Text     = require "Core.UI.Text"
   local SimpleText = require "Core.UI.SimpleText"
   local TextArea = require "Core.UI.TextArea"
   local Button   = require "Core.UI.Button"
   local Slider   = require "Core.UI.Slider"
   local Model    = require "Core.UI.Model"
   local Sprite   = require "Core.UI.Sprite"
   local Portrait = require "Core.UI.Portrait"

   Theme.collectAttributeKeys({
       Panel, Texture, Text, SimpleText, TextArea,
       Button, Slider, Model, Sprite, Portrait,
   })
   -- 也支持传字符串类名：Theme.collectAttributeKeys({ "Panel", "Text", ... })
   ```

2. **selector 不支持后代/兄弟关系**（Theme.lua:405-410 注释）
   只支持单节点 selector，无 `parent > child` 等复合路径，复杂主题规则受限。

3. **`runtime_declarations` 弱引用表依赖 GC**
   运行时换主题的快照存在弱引用表，GC 时机不可控，在 WC3 宿主 Lua 环境中弱引用 GC 行为需验证。

---

### 2.5 Component.lua — 声明式工厂

**设计亮点：**
- `classes_cache` 弱引用 kv 缓存，避免重复 `Class.get()` 查找
- `normalizeConfig` 在创建前应用 Theme + Style，职责单一
- `attachRuntimeTheme` 支持运行时主题附加，扩展点清晰
- `Component(config)` 通过 `setmetatable(Component, Component)` 实现 `__call`，调用语法简洁

**问题：**

- `Component.define` 注册的 type_name 不做子树处理（不走 Style 布局），而 `Component.__call` 走完整 normalizeConfig。两条路径行为不一致，需在文档中说明差异。

---

### 2.6 Tween.lua — 补间动画

**设计亮点：**
- flat 数组 + 写指针紧缩移除完成/取消的 tween，零碎片无 table.remove
- `active_count == 0` 时自动取消 Async tick loop，无动画时零消耗
- `delay` 通过 `elapsed` 初始为负值实现，无额外字段
- 7 种内置缓动函数，支持自定义函数
- 支持 5 种可动画属性：alpha / scale / position / size / color
- 注入 `Frame.animate` / `Frame.stopAnimate` 语法糖，无需 require Tween

**问题：**

1. **`Tween.cancel` 线性扫描**（Tween.lua:376-384）
   按 id 取消需遍历全部活跃 tween，活跃数量大时有开销。可考虑 id→index 映射，但当前场景数量通常极小，影响不大。

2. **`color` lerp 每帧拆包/重组 ARGB**（Tween.lua:178-192）
   涉及 4 次位运算 + 4 次 floor，频率高时有一定计算量。可预计算拆开的分量存在 tween 对象上。

---

### 2.7 Watcher.lua — 属性监听

**设计亮点：**
- 包装发生在 class 级别，所有实例共享同一包装 setter，开销极低
- `_watchers` / `_wrapped` 均为弱引用表，frame 销毁后自动 GC
- 与 Frame 销毁钩子集成（Component.lua hook），destroy 时自动清理

**问题：**

- `wrapSetter` 直接修改 `class.__setattr__` 表（Watcher.lua:81）。若多个 class 实例共享同一个 setattr 函数引用，包装后影响全部实例，这是预期行为，但需开发者理解其全局性。

---

### 2.8 Async.lua — 异步引擎

**设计亮点：**
- 同 Tween 一样采用写指针紧缩，无 table.remove 开销
- delta 从 FPS 估算并做上下限裁剪（15-240 FPS），稳健
- 支持 defer / after / every / onTick
- `__DEBUG__` 下回调异常用 pcall 捕获并计数，不崩溃主循环

**问题：**

- `Async.cancel` 同样是线性扫描（Async.lua:264-272），与 Tween.cancel 同样问题，当前场景无影响。
- `ensureStarted` 只注册一次底层 tick，无法重启。若游戏重载需要注意。

---

## 三、目前项目支持的所有写法

### 3.1 直接构造器写法（最底层，最直接）

适用：需要精确控制，不走 Theme/Style 处理。

```lua
local Panel  = require "Core.UI.Panel"
local Text   = require "Core.UI.Text"
local Button = require "Core.UI.Button"

-- 创建容器
local panel = Panel({
    parent   = Frame.getGameUI(),
    level    = 1,
    x        = 0.2,  y = 0.3,
    width    = 0.3,  height = 0.2,
    is_show  = true,
    alpha    = 220,
    image    = "war3mapImported\\bg.blp",
})

-- 创建文本
local label = Text({
    parent  = panel,
    level   = 2,
    x       = 0.21, y = 0.38,
    width   = 0.28, height = 0.03,
    value   = "Hello",
    font    = { "Fonts\\FZXS14.ttf", 0.018 },
    align   = { Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER },
    color   = 0xFFFFFFFF,
})

-- 创建按钮
local btn = Button({
    parent = panel, level = 2,
    x = 0.22, y = 0.32, width = 0.08, height = 0.04,
})
btn:on("click", function(f) print("clicked") end)
```

### 3.2 tree 子树声明写法（结构化，推荐）

在 config 中用 `tree` 数组声明子节点，框架递归创建。

```lua
local panel = Panel({
    parent = Frame.getGameUI(), level = 1,
    x = 0.1, y = 0.5, width = 0.4, height = 0.2,
    tree = {
        {
            class = Text,  -- 直接引用类
            level = 2,
            x = 0.12, y = 0.48, width = 0.36, height = 0.03,
            value = "标题",
        },
        {
            class = Button,
            level = 2,
            x = 0.15, y = 0.35, width = 0.08, height = 0.04,
        },
    }
})
```

### 3.3 Component 声明式写法（带 Theme + Style 预处理）

`Component(config)` 是推荐的业务层入口，会先跑 Theme.apply + Style.applyLayout。

```lua
local Component = require "Core.UI.Component"

-- class 填字符串类名（框架自动 Class.get 查找）
local panel = Component({
    class   = "Panel",
    parent  = Frame.getGameUI(),
    level   = 1,
    x = 0.1, y = 0.5, width = 0.4, height = 0.2,
    style   = { display = "flex", padding = 0.01, gap = 0.005 },
    tree    = {
        { class = "Text",   width = 0.15, height = 0.03, value = "HP" },
        { class = "Slider", width = 0.20, height = 0.02 },
    }
})

-- 注册复合组件类型
Component.define("hp-bar", {
    class = function(config)
        -- 自定义工厂函数，返回 frame
        return Panel(config)
    end,
})
local hp_bar = Component.create("hp-bar", { x=0.1, y=0.5, width=0.2, height=0.03 })
```

### 3.4 Style 布局写法（flex / grid / absolute）

```lua
-- flex 横排
local row = Component({
    class = "Panel",
    x = 0.05, y = 0.55, width = 0.5, height = 0.05,
    style = { display = "flex", flex_direction = "row", gap = 0.005, padding = 0.005 },
    tree  = {
        { class = "Button", width = 0.08, height = 0.04 },
        { class = "Button", width = 0.08, height = 0.04 },
    }
})

-- absolute 绝对定位子节点
local overlay = Component({
    class = "Panel",
    x = 0.1, y = 0.5, width = 0.3, height = 0.2,
    tree = {
        {
            class = "Text",
            width = 0.1, height = 0.02,
            value = "右下角标签",
            style = { position = "absolute", right = 0.005, bottom = 0.005 },
        }
    }
})
```

### 3.5 Theme 主题写法

```lua
local Theme = require "Core.UI.Theme"

-- 定义主题
Theme.define("dark", {
    tokens = {
        ["color-primary"] = 0xFF2080FF,
        ["padding-sm"]    = 0.008,
    },
    rules = {
        ["Panel"] = {
            alpha = 200,
        },
        ["Text"] = {
            color = "$color-primary",   -- token 引用
        },
        [".title"] = {                  -- label selector
            font = { "Fonts\\FZXS14.ttf", 0.022 },
        },
        ["#main-btn"] = {               -- id selector
            alpha = 255,
        },
    },
})

-- config 内联引用 token
local btn = Component({
    class = "Button",
    id    = "main-btn",
    label = "title",
    theme = "dark",
    x = 0.1, y = 0.4, width = 0.1, height = 0.04,
    color = Theme.ref("color-primary", 0xFFFFFFFF),  -- 带 fallback 引用
})

-- 节点级变量覆盖
local special = Component({
    class      = "Text",
    theme      = "dark",
    theme_vars = { ["color-primary"] = 0xFFFF4444 },  -- 覆盖当前节点的 token
    x = 0.1, y = 0.35, width = 0.2, height = 0.03,
    value = "特殊颜色",
})
```

### 3.6 事件系统写法

```lua
-- 注册事件
btn:on("click",        function(frame) end)
btn:on("mouse_enter",  function(frame) end)
btn:on("mouse_leave",  function(frame) end)
btn:on("mouse_down",   function(frame) end)
btn:on("mouse_up",     function(frame) end)
btn:on("double_click", function(frame) end)
btn:on("scroll",       function(frame, value) end)  -- value 为滚轮值
btn:on("tick",         function(frame) end)

-- 注销
btn:off("click", my_callback)
```

### 3.7 定位系统写法

```lua
-- 绝对定位（默认）
frame.position = Point(0.1, 0.4)  -- 左上角锚点

-- 相对定位（锚点对齐）
frame:setRelativePoint(Constant.ANCHOR_TOP_LEFT, target, Constant.ANCHOR_TOP_RIGHT, 0.005, 0)

-- 快捷定位方法
frame:centerIn(panel)          -- 居中
frame:above(button, 0.01)      -- 目标上方
frame:below(button, 0.01)      -- 目标下方
frame:leftOf(label, 0.005)     -- 目标左侧
frame:rightOf(icon, 0.005)     -- 目标右侧
frame:setAllPoints(panel)      -- 完全填充目标

-- 清除锚点
frame:clearAllPoints()

-- 绑定单位头顶
frame:bindToUnit(unit)
frame:unbind()
```

### 3.8 属性读写写法

```lua
-- 通用属性（所有 Frame 子类可用）
frame.is_show  = true / false
frame.alpha    = 0 ~ 255
frame.level    = 1
frame.scale    = 1.5
frame.disable  = true
frame.is_track = true       -- 忽略鼠标事件穿透
frame.view_port = true      -- 启用视口裁剪
frame.size     = Point(0.2, 0.1)
frame.width    = 0.2        -- 注意：会触发一次 JASS height getter
frame.height   = 0.1

-- 只读
local p = frame.parent
local childs = frame.childs  -- 受保护，只读
local border = frame.border_top

-- Panel 专属
panel.image   = "path.blp"
panel.is_tile = true

-- Texture 专属
texture.color      = 0xFFFFFFFF
texture.blend_mode = 1

-- Text 专属
text.value          = "内容"
text.font_height    = 0.018
text.limit          = 100
text.flag           = 0
text.style          = 0
text.shadow_off     = Point(0.001, -0.001)
text.color          = 0xFFFFFFFF
text.normal_color   = 0xFFFFFFFF
text.disable_color  = 0xFF888888
text.highlight_color = 0xFFFFFF00
text.shadow_color   = 0xFF000000
text:setFont("Fonts\\FZXS14.ttf", 0.018)
text:setFont("Fonts\\FZXS14.ttf", 0.018, Constant.TEXT_TYPE_NORMAL)
text:setAlign(Constant.TEXT_VERTEX_ALIGN_CENTER, Constant.TEXT_HORIZON_ALIGN_CENTER)

-- Button 专属
btn.state = Constant.SIMPLE_BUTTON_STATE_ENABLE
btn.state = Constant.SIMPLE_BUTTON_STATE_PUSHED
btn.state = Constant.SIMPLE_BUTTON_STATE_DISABLE
btn:click()          -- 模拟点击
btn:getTexture(state)
btn:getHighlight()

-- Slider 专属
slider.value     = 50
slider.min_limit = 0
slider.max_limit = 100
slider:addBorder("border.blp", "bg.blp", 0, 0.01, 0.005, false)

-- Sprite 专属
sprite.x = 100  sprite.y = 200  sprite.z = 50  -- 世界坐标
sprite.roll = 0  sprite.pitch = 0  sprite.yaw = 45
sprite.scale   = 1.5
sprite.x_scale = 2  sprite.y_scale = 1  sprite.z_scale = 1
sprite.color      = 0xFFFF0000
sprite.animation  = "stand"
sprite.animation_progress = 0.5
sprite:setPosition(x, y, z)
sprite:setScaleEx(x, y, z)
sprite:setAnimation("walk", "attack")  -- 主动画 + 附加动画
sprite:setImage("path.blp", id)

-- Portrait 专属
portrait.path = "units\\human\\Hero\\Hero.mdl"
portrait:setCameraPosition(x, y, z)
portrait:setCameraFocus(x, y, z)
```

### 3.9 补间动画写法

```lua
local Tween = require "Core.UI.Tween"  -- require 后自动注入 frame:animate / frame:stopAnimate
frame:animate({ alpha = 0 }, 0.5, "easeOut")
frame:animate({ position = {0.4, 0.3} }, 0.5, "easeInOut")
frame:animate({ size = {0.2, 0.1} }, 0.3, "linear")
frame:animate({ scale = 1.5 }, 0.2, "easeOutCubic")
frame:animate({ color = 0xFFFF0000 }, 0.4, "easeInOut")
frame:animate({ alpha = 0 }, 0.5, "easeOut", {
    delay = 0.2,
    on_complete = function(f) f:destroy() end,
    on_update   = function(f, t) end,
})
frame:stopAnimate()
local id = Tween.animate(frame, { alpha = 128 }, 0.3, "easeOut")
Tween.cancel(id)
Tween.cancelAll(frame)
-- 缓动名: linear easeIn easeOut easeInOut easeInCubic easeOutCubic easeInOutCubic
-- 或传自定义函数: frame:animate({alpha=0}, 0.3, function(t) return t*t end)
```

### 3.10 属性监听（Watcher）写法

```lua
local Watcher = require "Core.UI.Watcher"

-- 监听属性变化
Watcher.watch(hp_bar, "alpha", function(frame, new_val, old_val, prop)
    print(prop, old_val, "->", new_val)
end)

-- 取消单个监听
Watcher.unwatch(hp_bar, "alpha", my_callback)

-- 清除某属性全部监听
Watcher.unwatchAll(hp_bar, "alpha")

-- 清除 frame 全部监听
Watcher.clear(hp_bar)
```

### 3.11 Async 异步写法

```lua
local Async = require "FrameWork.Manager.Async"

Async.defer(function(delta) print("下一帧执行") end)

Async.after(0.5, function(delta) print("0.5秒后执行") end)

local id = Async.every(0.2, function(delta)
    -- 每0.2秒执行，返回false停止
    return true
end)
Async.cancel(id)
Async.clear()  -- 清空全部任务

-- 每 UI tick 执行（由 Tween 内部使用，业务层也可用）
Async.onTick(function(delta)
    -- delta 为当前帧估算时长（秒）
    return true  -- 返回 false 停止
end)
```

### 3.12 Frame 工具方法

```lua
-- 查找
local f = Frame.getByHandle(handle)
local f = Frame.getByName("main_panel")
local ui = Frame.getGameUI()
local console = Frame.getConsoleUI()

-- 同步子树
local childs = Frame.syncChilds(panel)

-- 强制刷新
Frame.update(frame)

-- 点击检测
if Frame.includePoint(frame, x, y) then ... end

-- 鼠标锁定
frame:cageMouse(true)

-- 加载 TOC
Frame.loadToc("UI\\MyTemplate.toc")

-- 销毁（递归销毁子节点）
frame:destroy()
```

---

## 四、综合评估

### 4.1 优势总结

| 维度 | 评价 |
|------|------|
| 性能 | 编译时特化 metamethod、写指针紧缩、无动画时零 tick 消耗、惰性缓存，热路径设计良好 |
| 可维护性 | 分层清晰，Frame/Component/Theme/Style 各司其职；注释详尽，设计意图明确 |
| 开发便利性 | 支持多种写法从底层到声明式；属性赋值语法直观；事件 on/off 类 DOM API |
| 扩展性 | Class 元类支持；Component.define 注册复合组件；hook_destroy 可注入清理逻辑 |
| 安全性 | childs 只读保护；__DEBUG__ 模式断言完备；destroy 防重入 |

### 4.2 主要不足与建议

| 编号 | 问题 | 建议 |
|------|------|------|
| P1 | `mergeable_keys` 手动维护，新属性易漏 | **[已修复]** 新增 `Theme.collectAttributeKeys(classes)` 自动从 `__attributes__` 收集，见 §2.4 问题1 |
| P2 | `childsUpdate` 全量重建 | 低频场景无影响，暂不修改 |
| P3 | `__runtime_layout__` 等字段 destroy 后可能泄漏 frame 引用 | **[已修复]** Component.lua 新增 `cleanup_runtime_layout`，在 `attachRuntimeTheme` 中注册 destroy 钩子自动清理 |
| P4 | `width`/`height` 独立 setter 有冗余 JASS 调用 | 批量改尺寸优先用 `frame.size = Point(w,h)` |
| P5 | `fixed` 参考布局根节点而非屏幕 | **[已修复]** `get_viewport_box` 改用屏幕常量(0.8×0.6)，`bindRuntimeLayout` 改以 `GameUI` 为锚点父节点 |
| P6 | 树结构变更后不自动重排 | **[已修复]** 新增 `Style.reapplyLayout(root_frame, config)`，见 §六 |
| P7 | `__gc` 在 Lua 5.3 table 上不保证触发 | 调试检测可改为显式 destroy 校验或单测覆盖 |

### 4.3 性能关键路径优先级

1. **高频读写属性**：优先用 `rawset`/`rawget` 绕过访问器（仅当确认不需要 setter 副作用时）
2. **批量创建**：用 tree 声明式一次性创建，避免逐个 `Panel()` 调用
3. **动画**：用 `frame:animate()` 而非手写 `Async.every`，Tween 有零消耗自停机制
4. **属性监听**：Watcher 包装在 class 级别，大量实例监听同一属性时无额外开销

---

## 五、关键文件路径索引

| 文件 | 核心职责 |
|------|----------|
| [Frame.lua](Code/Core/UI/Frame.lua) | 基类、属性系统、事件、定位、销毁 |
| [Component.lua](Code/Core/UI/Component.lua) | 声明式工厂、树创建、Theme+Style 集成 |
| [Theme.lua](Code/Core/UI/Theme.lua) | 主题注册、token、selector、继承 |
| [Style.lua](Code/Core/UI/Style.lua) | 布局编译器、flex/grid/absolute |
| [Tween.lua](Code/Core/UI/Tween.lua) | 补间动画引擎 |
| [Watcher.lua](Code/Core/UI/Watcher.lua) | 属性变化监听 |
| [Class.lua](Code/Lib/Base/Class.lua) | OOP 基础设施 |
| [Async.lua](Code/FrameWork/Manager/Async.lua) | UI tick 异步调度器 |

---

## 六、布局运行时重排方案（P6 详细说明）

### 6.1 现状与限制

`Style.applyLayout(config)` 是**编译期一次性**布局，执行时真实 frame 尚不存在，输出结果为绝对 x/y/width/height。frame 创建后树结构若发生变化（增删子节点、修改 width/height），布局不会自动重算。

这是有意的设计取舍：运行时完整 CSS 布局引擎成本极高，当前框架优先保证低消耗。

### 6.2 现有运行时能力（已可用）

框架已提供两阶段布局 API，可覆盖 `fixed` 和 `sticky` 的运行时跟随需求：

```lua
local Style = require "Core.UI.Style"

-- 阶段一：frame 创建前，编译期布局（Component 内部已自动调用）
Style.applyLayout(config)

-- 阶段二：frame 树创建完成后，升级 fixed/sticky 为运行时锚点
-- fixed  -> 改为相对 root_frame 的 setRelativePoint，root 移动时自动跟随
-- sticky -> 写入初始相对父节点位置，后续滚动时调用 updateStickyTree 刷新
Style.bindRuntimeLayout(root_frame, config)

-- 滚动时刷新所有 sticky 节点（在 scroll 事件回调中调用）
Style.updateStickyTree(root_frame, config, scroll_x, scroll_y)

-- 或只刷新单个 sticky 节点
Style.updateStickyFrame(frame, config, scroll_x, scroll_y)
```

**完整使用示例：**

```lua
local Style     = require "Core.UI.Style"
local Component = require "Core.UI.Component"

local config = {
    class  = "Panel",
    parent = Frame.getGameUI(),
    level  = 1,
    x = 0.0, y = 0.6, width = 0.8, height = 0.6,
    style  = { display = "flex", padding = 0.01, gap = 0.005 },
    tree   = {
        {
            class = "Text",
            width = 0.3, height = 0.03,
            value = "固定标题",
            style = { position = "fixed", top = 0.005, left = 0.01 },
        },
        {
            class = "Text",
            width = 0.3, height = 0.03,
            value = "吸附栏",
            style = { position = "sticky", top = 0 },
        },
    }
}

-- Component 内部已调用 applyLayout，直接创建
local root_frame = Component(config)

-- 升级 fixed/sticky 为运行时锚点（frame 创建后立即调用）
Style.bindRuntimeLayout(root_frame, config)

-- 滚动容器绑定 scroll 事件，持续刷新 sticky
local scroll_y = 0
root_frame:on("scroll", function(frame, value)
    scroll_y = scroll_y + value * 0.01  -- 根据实际滚轮比例调整
    Style.updateStickyTree(root_frame, config, 0, scroll_y)
end)
```

### 6.3 树结构变更后重排方案 [已实现]

**方案 A：原地重排（不销毁 frame，保留事件绑定）**

已在 Style.lua 新增 `Style.reapplyLayout(root_frame, config)`：

```lua
local Style = require "Core.UI.Style"

-- config.tree 或某子节点 width/height 变更后，调用一次即可：
Style.reapplyLayout(root_frame, config)
-- 内部自动：applyLayout → 写回 frame.size/position → bindRuntimeLayout
```

实现步骤（Style.lua 末尾）：
1. `Style.applyLayout(config)` — 重新编译整棵 config 树坐标
2. `walk_runtime_tree` 遍历对应 frame，把新 x/y/width/height 写回 `frame.size` / `frame.position`
3. fixed/sticky 节点跳过绝对坐标写回，交由步骤 4 处理
4. `Style.bindRuntimeLayout(root_frame, config)` — 重新升级 fixed/sticky 锚点

**方案 B：整树重建（适合增删子节点）**

```lua
-- config.tree 结构本身有增删时，需要销毁旧 frame 重建
if root_frame then root_frame:destroy() end
root_frame = Component(new_config)
Style.bindRuntimeLayout(root_frame, new_config)
```

### 6.4 sticky / fixed 与 CSS 对齐说明

| 特性 | CSS 标准 | 本框架现状 | 差异说明 |
|------|----------|------------|----------|
| `fixed` 参考系 | 浏览器 viewport | 布局根节点（root_frame） | 有意设计；框架无全局 viewport 对象 |
| `fixed` 运行时跟随 | 自动 | 需调用 `bindRuntimeLayout` | 两阶段设计，frame 创建前无 handle |
| `sticky` 触发条件 | 跟随滚动容器 scroll | 需外部传入 scroll_x/y | 无内置滚动容器；scroll 值由业务层从 scroll 事件获取 |
| `sticky` 刷新 | 自动 | 需在 scroll 事件中调用 `updateStickyTree` | 低消耗设计，不做全局帧监听 |
| `sticky` + `fixed` 编译期坐标 | 不需要 | 先编译一次绝对坐标再升级为锚点 | 两阶段流程的必要中间态 |

**结论**：框架的 `fixed`/`sticky` 在调用 `bindRuntimeLayout` 后，运行时行为已与 CSS 语义基本对齐，主要差异仅在参考系（根节点 vs viewport）和调用方式（主动 vs 自动）上。
