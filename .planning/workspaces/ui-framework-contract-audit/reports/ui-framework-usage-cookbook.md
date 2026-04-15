# UI框架可用写法手册

更新时间：2026-03-21  
用途：整理“当前项目里实际存在的 UI 写法”，并明确每种写法的证据级别与当前建议。

## 1. 先看结论

当前最重要的前置提醒：

- 真实 `Point.lua` 已被本轮实验验证为不适合普通 UI 小数坐标。
- `Frame.position`、`Frame.size`、`Text.shadow_off`、`Tween position/size` 都依赖 `Point(...)` / `Point.get(...)`。
- 因此，任何依赖常规 `x/y/width/height` 小数 UI 坐标的高层写法，当前都不能被标成“生产稳定写法”。

所以本手册的含义是：

- “写法存在”是真的
- “语法和模块边界清楚”是真的
- “全部 live runtime 安全”目前不成立

## 2. 证据级别与建议级别

### 2.1 证据级别

| 级别 | 含义 |
| --- | --- |
| `repo-used` | 仓库里确实出现过此写法 |
| `smoke-validated` | 当前 smoke 明确覆盖了此写法或其关键语义 |
| `source-only` | 只在源码、注释、API 面里存在，尚未被 smoke 或业务样本证明 |

### 2.2 建议级别

| 级别 | 含义 |
| --- | --- |
| `建议保留` | 方向对、边界清楚、当前证据相对扎实 |
| `可用但有限制` | 可以继续用，但要明确边界或验证缺口 |
| `暂不建议扩散` | API 虽然存在，但当前风险或盲区较大 |
| `当前未充分验证` | 先不要把它写进“稳定能力”清单 |

## 3. 当前主要写法总览

| 写法 | 证据级别 | 当前建议 | 备注 |
| --- | --- | --- | --- |
| `Component({...})` 声明式树 | `repo-used` + `smoke-validated` | `可用但有限制` | 是架构上最清楚的高层入口，但 geometry 仍受 `Point` 阻塞。 |
| `Component.define(...)` / `Component.create(...)` | `repo-used` + `smoke-validated` | `可用但有限制` | 当前 smoke 已明确暴露 registry `tree` metadata 契约不稳。 |
| `Theme.define(...)` / `Theme.set(...)` / `Theme.refresh(...)` | `repo-used` + `smoke-validated` | `建议保留` | Theme 归属边界是对的；但运行时 replay 仍非浏览器 cascade。 |
| `Style.applyLayout(config)` | `repo-used` + `smoke-validated` | `可用但有限制` | 布局编译器成立，但 `display:none` 仍不等价。 |
| direct constructor：`Panel({...})` / `Text({...})` | `repo-used` + `smoke-validated` | `暂不建议扩散` | 构造路径存在，但最终仍走 `Frame.position/size`，会撞上 `Point` 风险。 |
| direct constructor：其余控件 | `source-only` | `当前未充分验证` | 语法面在，但没有单独 smoke。 |
| `frame:on(...)` / `frame:off(...)` | `source-only` | `当前未充分验证` | 事件系统代码存在，但当前没有正式 smoke。 |
| `Frame.setRelativePoint/centerIn/above/...` | `source-only`，其中 `Style` 间接依赖 | `可用但有限制` | helper 很直观，但没有独立直接验证。 |
| `Watcher.watch(...)` | `repo-used` + `smoke-validated` | `建议保留` | alpha 成功 / 失败 / unwatch 路径已有验证。 |
| `Tween.animate(...)` 的标量属性 | `repo-used` + `smoke-validated` | `建议保留` | `alpha` 类标量补间较可靠。 |
| `Tween.animate(...)` 的 `position/size` | `repo-used` + `smoke-validated` | `暂不建议扩散` | 当前受 `Point` 风险直接影响。 |
| raw `MHFrame_*` / `MHUI_*` | `repo-used` | `暂不建议扩散` | 仓库里有 JASS 直接调用样本，但这会绕开 Lua UI 框架。 |

## 4. 高层推荐入口与注意事项

### 4.1 `Component({...})`

当前建议：`可用但有限制`

适用意图：

- 想同时使用 Theme 和 Style
- 想让 authoring 更接近“声明式配置”
- 想把 Theme/Style 的责任边界交给框架

当前事实：

- `Theme.apply -> Style.applyLayout -> class.new -> Theme.attach` 的顺序已被 smoke 覆盖
- 当前 Theme 的正式归属就是 `Component`
- 当前 layout 编译的正式归属也在这里
- 但 `config.x/y/width/height` 最终仍会落到 `Frame.position/size`

示例：

```lua
local Component = require "Core.UI.Component"

local panel = Component({
    class = "Panel",
    theme = "builtin.web.dark",
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
            class = "Text",
            value = "Hello",
            width = 0.10,
            height = 0.03,
        }
    }
})
```

结论：

- 从架构角度，这是最该保留的入口
- 从 live geometry 正确性角度，这个入口目前仍被 `Point` 风险卡住

### 4.2 `Component.define(...)` / `Component.create(...)`

当前建议：`可用但有限制`

示例：

```lua
local Component = require "Core.UI.Component"
local Panel = require "Core.UI.Panel"

Component.define("panel_card", {
    class = function(config)
        return Panel(config)
    end,
})

local card = Component.create("panel_card", {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.1,
})
```

当前限制：

- 当前 smoke 已明确断言：registry `tree` metadata 目前没有形成稳定契约
- 这条入口“能创建”，但“组件定义的 declarative 元数据故事”还不完整

### 4.3 direct constructor

当前建议：`暂不建议扩散`

适用意图：

- 想直接操作某个控件类
- 不需要 Theme 预处理
- 不需要 declarative layout 编译

示例：

```lua
local Panel = require "Core.UI.Panel"
local Text = require "Core.UI.Text"

local panel = Panel({
    parent = Frame.getGameUI(),
    x = 0.10,
    y = 0.50,
    width = 0.20,
    height = 0.10,
    image = "war3mapImported\\panel_bg.blp",
})

local text = Text({
    parent = panel,
    x = 0.12,
    y = 0.48,
    width = 0.16,
    height = 0.03,
    value = "Title",
})
```

当前限制：

- direct constructor 不自动 Theme
- direct constructor 不自动 Style
- 仍会通过 `Frame.__init__` 把几何值写进 `Point(...)`

## 5. Theme / Style / 事件 / Watcher / Tween

### 5.1 Theme 写法

当前建议：`建议保留`

已知可用语义：

- `Theme.define(name, definition)`
- `extends`
- token：`"$token"`
- fallback token：`Theme.ref("token", fallback)`
- `vars` / `theme_vars`
- selector：类型、`.label`、`#id`、单节点复合 selector
- runtime：`Theme.set(frame, theme)` / `Theme.refresh(frame)`

示例：

```lua
local Theme = require "Core.UI.Theme"

Theme.define("my.card", {
    tokens = {
        gap_sm = 0.005,
        alpha_soft = 220,
    },
    alpha = "$alpha_soft",
    rules = {
        ["Panel.card"] = {
            style = {
                padding = "$gap_sm",
                gap = "$gap_sm",
            },
        },
        ["#title"] = {
            alpha = 255,
        },
    },
})
```

当前限制：

- selector 只有浅层，不支持 descendant/cascade
- runtime replay 不是浏览器式重算
- 对 direct constructor，Theme 不会自动生效

### 5.2 Style 写法

当前建议：`可用但有限制`

已知可写语义：

- `display = "flex"` / `display = "grid"`
- `position = "static" | "relative" | "absolute" | "fixed" | "sticky"`
- `padding`
- `gap` / `row_gap` / `column_gap`
- runtime sticky/fixed 绑定

示例：

```lua
local Style = require "Core.UI.Style"

local config = {
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
            class = "Text",
            width = 0.10,
            height = 0.03,
            style = {
                position = "relative",
                left = 0.002,
            },
        }
    }
}

Style.applyLayout(config)
```

当前限制：

- 这是 layout compiler，不是浏览器 runtime
- `display = "none"` 当前不等价于真实隐藏并移出布局
- Style 单独调用不自动 Theme
- 编译产物最终仍会进入 `Frame.position/size`

### 5.3 事件写法：`frame:on(...)`

当前建议：`当前未充分验证`

```lua
button:on("click", function(frame)
    print(frame.name)
end)
```

说明：

- `Frame.on/off` 代码存在
- 事件名到 `Constant.EVENT_ID_FRAME_*` 的映射存在
- 底层通过 `Jass.MHFrameEvent_RegisterByCode`
- 当前 smoke 没有单独覆盖 `Frame.on/off`

### 5.4 `Watcher.watch(...)`

当前建议：`建议保留`

```lua
local Watcher = require "Core.UI.Watcher"

Watcher.watch(frame, "alpha", function(frame, new_value, old_value)
    print(old_value, "->", new_value)
end)
```

说明：

- alpha 的 watch/unwatch 成功路径已被 smoke 覆盖
- 未找到 setter 的失败路径也已被 smoke 覆盖

### 5.5 `Tween.animate(...)` / `Frame.animate(...)`

当前建议：

- 标量属性补间：`建议保留`
- `position/size` 补间：`暂不建议扩散`

```lua
local Tween = require "Core.UI.Tween"

Tween.animate(frame, { alpha = 0 }, 0.3, "linear")
Frame.animate(frame, { alpha = 255 }, 0.2, "linear")
Frame.stopAnimate(frame)
```

## 6. 控件层公开面清单

| 类 | 构造入口 | 公开属性 / 方法 | 证据级别 | 当前建议 |
| --- | --- | --- | --- | --- |
| `Frame` | 基类，不直接实例化 | `parent,height,width,position,is_show,alpha,level,scale,is_track,view_port,disable,border_*,size`；`loadToc/getByHandle/getByName/getGameUI/getConsoleUI/setScreenLimit/syncChilds/update/includePoint/clearAllPoints/setRelativePoint/setAllPoints/centerIn/above/below/leftOf/rightOf/on/off/bindToUnit/unbind/cageMouse` | 多数 `source-only`，部分被 Style/Theme smoke 间接触达 | 作为理解基类保留；不要把所有 helper 都当成已正式验证 |
| `Panel` | `Panel({...})` | `image,is_tile` + Frame 面 | 构造 `smoke-validated`；`image` 间接受 Theme smoke；`is_tile` `source-only` | 低层容器类可继续保留 |
| `Texture` | `Texture({...})` | `color,blend_mode` + Frame 面 | `source-only` | 当前未充分验证 |
| `Text` | `Text({...})` | `font_height,value,limit,flag,style,shadow_off,color,normal_color,disable_color,highlight_color,shadow_color`；`setFont/setAlign` | 构造 `smoke-validated`；大量细项 `source-only` | 文本类重要，但 `shadow_off` 受 `Point` 风险影响 |
| `SimpleText` | `SimpleText({...})` | `value,font_height,limit,color`；`setFont/setAlign` | `source-only` | 当前未充分验证 |
| `TextArea` | `TextArea({...})` | `value`；`setFont/addText` | `source-only` | 当前未充分验证 |
| `Button` | `Button({...})` | `state`；`click/getTexture/getHighlight` | `source-only` | 当前未充分验证 |
| `Slider` | `Slider({...})` | `value,max_limit,min_limit`；`addBorder` | `source-only` | 当前未充分验证 |
| `Model` | `Model({...})` | `path` | `source-only` | 当前未充分验证 |
| `Sprite` | `Sprite({...})` | `x,y,z,roll,pitch,yaw,scale,x_scale,y_scale,z_scale,color,animation,animation_progress`；`setPosition/setScaleEx/setAnimation/setImage` | `source-only` | 能力丰富，但验证缺口大 |
| `Portrait` | `Portrait({...})` | `path`；`setCameraPosition/setCameraFocus` | `source-only` | 当前未充分验证 |

## 7. 仓库里真实出现过的样本

高价值样本：

- `.planning/tools/ui_framework_remaining_smoke.lua`
- `../Style_demo.lua`
- `War3/map/war3map.j`

当前没有找到：

- `Code` 业务模块里的大规模高层 Lua UI 消费
- `Button` / `Slider` / `Sprite` / `Portrait` 的业务级高层样本

## 8. 当前不建议继续扩散的写法

- 把 `frame.position = Point(0.1, 0.2)` 当成稳定 API 写法
- 把 `frame.size = Point(0.3, 0.15)` 当成稳定 API 写法
- 在当前状态下把 `Component({...})` 或 direct constructor 宣称为“已稳定的 live UI authoring 基线”
- 把 `display = "none"` 写成 CSS 等价能力
- 把 Theme runtime replay 写成浏览器 cascade
- 在没有 smoke 的前提下，把 source-only 控件方法写入正式“稳定接口”文档

## 9. 当前最安全的使用策略

1. 先把 `Point` 风险当成最高优先级阻塞项处理。
2. 在问题修复前，只把 Theme/Style/Component 当作“架构形状”和“API 方向”来使用。
3. 需要运行时联动时，优先用 `Watcher.watch(...)`。
4. 需要补间时，优先限制在 `alpha` 这类标量属性。
5. 任何要推广给别人用的控件 API，都先补 smoke，再写正式文档。
