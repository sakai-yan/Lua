# UI 框架与真正 HTML5 + CSS + JS 的写法差距报告

日期：2026-03-19

## Summary
- 本轮复核 smoke 结果：`pass=7 / fail=0 / blocker=0`。
- 新增证据已经确认：
- `Core.UI.Frame` 严格 `require` 通过。
- `Panel({...})` / `Text({...})` 直构路径可用。
- `Component({...})` 仍返回 `nil`，还不能当成 HTML/JSX 式入口。
- `style.display = "none"` 仍不是 CSS 里的 `display:none` 语义。
- 这份报告只基于当前工作区仍然存在的 UI 框架代码来判断，不再把已删除的旧文档、旧 `Builder*`、旧 `Layout.lua` 当成“应该存在”的功能。
- 结合本轮本地复核，当前框架的状态比上一轮更好：
  - `Core.UI.Frame` 已能严格 `require`
  - `Panel({...})`、`Text({...})` 这类直接构造写法本地 stub 可走通
  - 但 `Component({...})` 这条更像 HTML/JSX 的入口仍然没有闭环
- 所以当前框架最接近的不是“真正 HTML5 + CSS + JS”，而是：
  - 一套 `Frame`/组件直接构造 API
  - 加一层 CSS 风格的布局编译器 `Style`
  - 再加少量 JS 风格辅助能力（事件、Watcher、Tween）

换句话说：
- 你已经拥有“部分 Web 风格写法”
- 但你还没有真正拥有“浏览器那一整套写法模型”

## 本轮额外复核结论

### 1. `Frame` 现在可以严格加载
- 结论：之前基座阻断已经被修掉。
- 含义：后面的“写法差距”报告不再把 `Class.lua` 基座问题当成主结论。

### 2. 当前最稳定的写法仍是“直接构造组件”
- 本地 stub 已验证：

```lua
local panel = Panel({
    x = 0.1, y = 0.5,
    width = 0.3, height = 0.2,
    image = "bg.blp",
})

local text = Text({
    parent = panel,
    x = 0.12, y = 0.48,
    width = 0.1, height = 0.03,
    value = "Hello",
})
```

- 这条路径能走通，说明你当前框架最像的是“Lua 直接 new 组件”，不是 HTML 标记语言。

### 3. `Component` 仍然不是可用的 HTML/JSX 式入口
- 本地复核：

```lua
local result = Component({
    class = "Panel",
    x = 0.1, y = 0.5,
    width = 0.3, height = 0.2,
})

print(result)  --> nil
```

- 原因不是 `Panel` 不存在，而是 `Component.__call` 还在要求：
  - `Class.get(config.class)` 找到类
  - 并且 `Class.issubclass(ui_class, Component)` 成立
- 但当前内建组件例如 `Panel`、`Text` 的继承链仍是 `Frame` 子类，不是 `Component` 子类。

因此：
- 你现在不能把 `Component` 当成“真正声明式 UI 根入口”
- 它目前更像一个半成品入口或将来的扩展点

---

## 一、HTML 层的写法差距

真正的 HTML5 先给你的是“标记结构能力”。

你可以这样写：

```html
<div class="panel">
  <span class="title">Hello</span>
</div>
```

或者运行时这样写：

```js
const panel = document.createElement("div");
panel.className = "panel";

const title = document.createElement("span");
title.textContent = "Hello";

panel.appendChild(title);
document.body.appendChild(panel);
```

### 你的框架当前不能这样用

#### 不能使用的写法 1：HTML 标签字符串

```lua
local ui = [[
<div class="panel">
  <span>Hello</span>
</div>
]]
```

为什么不能：
- 当前框架没有 HTML parser
- 没有 tag -> component 的解释器
- 没有 DOM tree builder

你现在只能写成“Lua 构造配置”或“直接构造对象”：

```lua
local panel = Panel({
    x = 0.1, y = 0.5,
    width = 0.3, height = 0.2,
})

local text = Text({
    parent = panel,
    x = 0.12, y = 0.48,
    width = 0.1, height = 0.03,
    value = "Hello",
})
```

这说明你的框架目前缺的不是“组件类”，而是“标记层”。

#### 不能使用的写法 2：DOM 风格动态增删节点

真正 Web 可以这样写：

```js
const item = document.createElement("div");
list.appendChild(item);
list.removeChild(item);
```

你当前框架不能这样写：

```lua
local item = Frame.createElement("Panel")
parent:appendChild(item)
parent:removeChild(item)
```

为什么不能：
- 当前 `Frame` 没有 `createElement`
- 没有 `appendChild/removeChild/insertBefore/replaceChild`
- 你对子节点树的主要入口仍然是：
  - 创建时通过 `parent`
  - 或创建时通过 `tree`
  - 或底层 `setParent`

也就是说：
- 你已经有“父子关系”
- 但你还没有“DOM 操作模型”

---

## 二、CSS 层的写法差距

真正 CSS 最强的地方不是“能写 left/top”，而是它是一整套样式系统：
- 选择器
- 级联
- 继承
- 伪类
- 媒体查询
- 变量
- 动画/过渡

你当前的 `Style` 更像“布局编译器”，而不是“完整 CSS 引擎”。

### 你现在大致支持的 CSS 味道
- `position`
  - `static`
  - `relative`
  - `absolute`
  - `fixed`
  - `sticky`
- `display`
  - `flex`
  - `grid`
  - `table`
- `padding`
- `gap / row_gap / column_gap`
- `justify / align / justify_self / align_self`
- `left / right / top / bottom`

### 但你不能使用真正 CSS 的这些核心写法

#### 不能使用的写法 3：选择器

真正 CSS：

```css
.panel > .title {
  color: red;
}

#main .item.active:hover {
  background: yellow;
}
```

你当前不能这样写：

```lua
Style.define(".panel > .title", {
    color = 0xFFFF0000
})
```

为什么不能：
- 当前 `Style.lua` 只有布局分发函数，没有 selector parser
- 没有 class / id 匹配系统
- 没有 rule matching
- 没有 cascade resolution

你现在只能写“每个节点自己带 style”：

```lua
{
    class = Text,
    value = "Hello",
    style = {
        position = "relative",
        left = 0.01,
    }
}
```

这和真正 CSS 的差别是：
- 真正 CSS 是“把规则写在外面，批量匹配节点”
- 你现在是“把配置写回每个节点自己身上”

#### 不能使用的写法 4：class/id 驱动的样式复用

真正 HTML + CSS：

```html
<div class="card primary"></div>
<div class="card secondary"></div>
```

```css
.card { padding: 12px; }
.primary { color: white; background: blue; }
.secondary { color: black; background: gray; }
```

你当前不能这样写：

```lua
{
    class = Panel,
    className = "card primary"
}
```

为什么不能：
- 当前框架没有 `className`
- 没有 `id`
- 没有对应 selector 规则系统

所以你现在只能手动重复：

```lua
local cardA = Panel({
    x = 0.1, y = 0.5,
    width = 0.2, height = 0.1,
})

local cardB = Panel({
    x = 0.35, y = 0.5,
    width = 0.2, height = 0.1,
})
```

如果颜色、边距、布局规则重复很多，就需要你自己抽 Lua 函数，而不是靠 CSS class 复用。

#### 不能使用的写法 5：CSS 变量 / 主题 token

真正 CSS：

```css
:root {
  --primary: #2d6cdf;
  --gap-sm: 8px;
}

.button {
  background: var(--primary);
  margin-right: var(--gap-sm);
}
```

你当前不能这样写：

```lua
style = {
    color = "var(--primary)",
    gap = "var(--gap-sm)",
}
```

为什么不能：
- 当前 `Style` 没有 token 解析
- 没有变量作用域
- 没有继承链上的变量查找

#### 不能使用的写法 6：伪类

真正 CSS：

```css
.button:hover { background: orange; }
.button:active { transform: scale(0.96); }
.input:focus { border-color: blue; }
```

你当前不能这样写：

```lua
style = {
    [":hover"] = { color = 0xFFFFAA00 }
}
```

为什么不能：
- 当前没有伪类状态机
- 没有 selector + state 匹配
- 没有 hover/focus/active 的样式重算层

你现在只能手动事件驱动：

```lua
button:on("mouse_enter", function(frame)
    frame.color = 0xFFFFAA00
end)

button:on("mouse_leave", function(frame)
    frame.color = 0xFFFFFFFF
end)
```

这就是典型的：
- Web：声明式状态样式
- 当前框架：手动事件脚本

#### 不能使用的写法 7：媒体查询

真正 CSS：

```css
@media (max-width: 768px) {
  .panel {
    width: 100%;
  }
}
```

你当前不能这样写：

```lua
style = {
    ["@media (max-width: 768px)"] = {
        width = 1.0
    }
}
```

为什么不能：
- 当前没有媒体条件系统
- 没有 viewport rule reevaluation
- 没有 responsive breakpoint dispatcher

你只能自己在 Lua 里分支。

---

## 三、`display` 和布局能力的差距

当前 `Style` 的 `display` 更准确地说是“少量容器布局模式”，不是完整 CSS `display` 系统。

### 当前支持的核心 `display`
- `flex`
- `grid`
- `table`
- 没写时就是普通静态流

### 当前不能用的 `display` 写法

#### 不能使用的写法 8：`display: none`

真正 CSS：

```css
.hidden {
  display: none;
}
```

你可能会自然想写：

```lua
style = {
    display = "none"
}
```

但当前这不会得到真正 CSS 的“隐藏并退出布局”效果。

本地复核中，下面代码仍然会给子节点算位置：

```lua
local cfg = {
    x = 0,
    y = 1,
    width = 1,
    height = 1,
    style = { display = "none" },
    tree = {
        { width = 0.2, height = 0.2 }
    }
}

Style.applyLayout(cfg)
print(cfg.tree[1].x, cfg.tree[1].y)  --> 仍然被计算
```

为什么：
- `Style` 只会在 `display_mode` 对应到已知 handler 时才分发
- 当前没有 `layout_apply_func.none`
- 所以 `"none"` 只是“未知 display 值”，不是“隐藏逻辑”

当前正确做法仍是：

```lua
frame.is_show = false
```

这和 CSS `display:none` 的差异非常大，因为：
- `display:none` 影响布局参与
- `is_show = false` 更像“隐藏 frame”

#### 不能使用的写法 9：`block / inline / inline-block / contents / inline-flex / inline-grid`

真正 CSS：

```css
display: block;
display: inline;
display: inline-block;
display: inline-flex;
display: inline-grid;
display: contents;
```

你当前都不能把它们当成真正有语义的 `display` 值使用。

为什么：
- 当前代码里只有 `flex`、`grid`、`table` 三种容器 handler
- 没有行内排版模型
- 没有 block formatting context
- 没有 `contents` 这种“自己不成盒，只让子节点参与”的行为

### 你当前缺失的 Flexbox 能力

真正 CSS Flex：

```css
.list {
  display: flex;
  flex-wrap: wrap;
}

.item {
  flex: 1 1 200px;
  order: 2;
}
```

你当前不能稳定使用：
- `flex-wrap`
- `order`
- `flex-grow`
- `flex-shrink`
- `flex-basis`

为什么不能：
- 当前 `flex` 主要支持的是：
  - `direction`
  - `gap`
  - `justify`
  - `align`
  - `stretch`
- 它不是完整 flex formatting algorithm

也就是说：
- 你有“简化版 flex 布局”
- 但你没有浏览器那种“真正 flexbox”

### 你当前缺失的 Grid 能力

真正 CSS Grid：

```css
.layout {
  display: grid;
  grid-template-columns: 200px 1fr 1fr;
  grid-template-rows: auto auto;
  grid-template-areas:
    "header header header"
    "nav content aside";
}
```

你当前不能这样写：

```lua
style = {
    display = "grid",
    grid_template_columns = { 0.2, "1fr", "1fr" },
    grid_template_areas = {
        "header header header",
        "nav content aside"
    }
}
```

为什么不能：
- 当前 grid 只有比较轻量的列数/单元格宽高/对齐计算
- 没有 `template columns/rows`
- 没有 `areas`
- 没有 `minmax/auto-fit/auto-fill`
- 没有自动放置算法的完整浏览器版本

---

## 四、`position` 的差距

当前 `Style` 支持：
- `static`
- `relative`
- `absolute`
- `fixed`
- `sticky`

这已经很接近 Web 表面语义了，但仍不等价于浏览器。

### 不能使用的写法 10：浏览器自动维护的 `sticky`

真正 CSS：

```css
.header {
  position: sticky;
  top: 0;
}
```

浏览器会自动：
- 监听滚动
- 判断何时吸顶
- 自动重排/重绘

你当前不能只写：

```lua
style = {
    position = "sticky",
    top = 0
}
```

然后就期待它像浏览器一样自动工作。

为什么不能：
- 当前 `sticky` 的编译期语义在 `Style.applyLayout` 里能成立
- 但运行时更新必须显式调用：
  - `Style.bindRuntimeLayout`
  - `Style.updateStickyFrame`
  - `Style.updateStickyTree`

也就是说你现在需要自己补运行时层：

```lua
Style.applyLayout(config)
local root = Panel(config)
Style.bindRuntimeLayout(root, config)

scroll_frame:on("scroll", function(frame, value)
    Style.updateStickyTree(root, config, 0, value)
end)
```

这和浏览器差别在于：
- 浏览器：自动
- 当前框架：你手动驱动

### 不能使用的写法 11：真正 viewport 语义的 `fixed`

真正 CSS：

```css
.toast {
  position: fixed;
  right: 16px;
  bottom: 16px;
}
```

浏览器里它是相对于 viewport。

你当前虽然有 `fixed`，但它更接近：
- 相对于当前布局树根盒子
- 再通过 `Style.bindRuntimeLayout(root_frame, config)` 绑定成相对锚点

所以它不是完全等价于浏览器 viewport 模型。

---

## 五、JS / DOM API 层的差距

真正 JS 给你的不仅是事件回调，而是整个 DOM API 和事件模型。

### 你当前可以做的
- `frame:on("click", callback)`
- `frame:off("click", callback)`
- `Tween.animate(...)`
- `Watcher.watch(...)`

### 但你不能使用这些典型 Web 写法

#### 不能使用的写法 12：DOM 查询器

真正 JS：

```js
document.querySelector(".item.active");
document.querySelectorAll(".panel > .title");
document.getElementById("main");
```

你当前没有等价写法。

当前只有非常有限的查询入口：
- `Frame.getByName(name)`
- `Frame.getByHandle(handle)`
- `Frame.getGameUI()`
- `Frame.getConsoleUI()`

这意味着：
- 你有“按名字/句柄查对象”
- 但你没有“按结构/选择器查询 DOM”

#### 不能使用的写法 13：完整 DOM 事件对象

真正 JS：

```js
button.addEventListener("click", function (event) {
  event.preventDefault();
  event.stopPropagation();
  console.log(event.target, event.currentTarget);
});
```

你当前不能这样写。

为什么不能：
- `Frame.on` 的事件名是固定白名单，不是浏览器任意事件系统
- 目前固定事件名只有：
  - `mouse_enter`
  - `mouse_leave`
  - `mouse_down`
  - `mouse_up`
  - `click`
  - `double_click`
  - `scroll`
  - `tick`
- 回调拿到的是 `frame`，不是完整 `event` 对象
- 没有 `preventDefault`
- 没有 `stopPropagation`
- 没有 capture / bubble 模型

所以 Web 这类写法：

```js
parent.addEventListener("click", onClick, true);
```

在你当前框架里没有对应机制。

####   14：自定义事件分发

真正 JS：

```js
el.dispatchEvent(new CustomEvent("open", { detail: { id: 1 } }));
```

你当前没有一套对应的 Frame 自定义事件系统。

---

## 六、动画写法的差距

当前你已经有 `Tween.animate`，这一点非常像 JS 或 Web Animation API。

但它仍然不是 CSS 动画系统。

### 不能使用的写法 15：CSS transition

真正 CSS：

```css
.button {
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.button:hover {
  transform: scale(1.05);
  opacity: 0.8;
}
```

你当前不能这样写。

为什么不能：
- 没有 `transition` 解析
- 没有伪类驱动的样式变更
- 没有“样式变了就自动补间”的机制

你只能命令式地写：

```lua
button:on("mouse_enter", function(frame)
    frame:animate({ alpha = 200, scale = 1.05 }, 0.2, "easeOut")
end)

button:on("mouse_leave", function(frame)
    frame:animate({ alpha = 255, scale = 1.0 }, 0.2, "easeOut")
end)
```

这仍然很好用，但它是 JS imperative 动画，不是 CSS declarative transition。

### 不能使用的写法 16：CSS keyframes

真正 CSS：

```css
@keyframes pulse {
  0%   { transform: scale(1); }
  50%  { transform: scale(1.1); }
  100% { transform: scale(1); }
}

.button {
  animation: pulse 1s infinite;
}
```

你当前没有：
- `@keyframes`
- `animation-name`
- `animation-iteration-count`
- `animation-fill-mode`

如果要实现，只能自己用 Tween 或时序逻辑手写。

---

## 七、状态与渲染模型的差距

真正 HTML + CSS + JS 的现代开发体验，通常不只是 DOM API，而是“状态 -> 视图”的开发模型。

例如你会自然写出：

```js
state.count++;
render();
```

或者 React/Vue 风格：

```jsx
setCount(count + 1);
```

### 你当前不能使用的写法 17：状态驱动自动重渲染

你当前没有：
- Virtual DOM
- diff
- 组件重渲染生命周期
- 模板重新计算 -> 自动 patch UI

`Watcher.watch` 能做的是：
- 监听某个 frame 属性 setter 被调用

它不能做的是：
- 接收业务 state 并自动重绘整棵 UI 树

所以你不能把它当成：

```lua
state.count = state.count + 1
-- 然后 UI 自动重渲染
```

当前你仍然要显式改 frame：

```lua
text.value = tostring(new_count)
```

---

## 八、当前最应该怎么理解你自己的框架

如果用最准确的话来描述：

### 你已经具备的部分
1. 一个可用的 `Frame`/组件对象层
2. 一个有 Web 味道的布局描述层
3. 一个类 DOM 的基础事件层
4. 一个类 JS 的属性观察与补间层

### 你还没有具备的部分
1. HTML 标记层
2. CSS 规则系统
3. DOM API 系统
4. 浏览器自动布局/事件传播/样式重算机制
5. 现代前端那种声明式组件渲染闭环

---

## 最重要的“不能这样写”清单

下面这些是真正会让你误以为“像 Web，所以应该能写”，但当前实际不能这么用的：

### A. 不能写 HTML 标签或模板字符串

```html
<div class="panel"><span>Hello</span></div>
```

原因：
- 没有 parser
- 没有 tag -> component 映射

### B. 不能写 DOM API

```js
document.createElement("div");
el.appendChild(child);
el.innerHTML = "...";
```

原因：
- 没有 `createElement/appendChild/innerHTML`

### C. 不能写 CSS selector

```css
.panel > .title:hover { color: red; }
```

原因：
- 没有 selector/cascade/pseudo-class

### D. 不能把 `display:none` 当真正 CSS 用

```lua
style = { display = "none" }
```

原因：
- 当前不会变成“退出布局并隐藏”
- 只是未知 display 值

### E. 不能直接把 `sticky` 当浏览器自动 sticky

```lua
style = { position = "sticky", top = 0 }
```

原因：
- 还需要你手动绑定运行时和滚动更新

### F. 不能用 `Component` 当真正 JSX/HTML 入口

```lua
Component({
    class = "Panel",
    ...
})
```

原因：
- 当前实际会返回 `nil`
- 声明式入口还没闭环

### G. 不能用 DOM 查询器

```js
document.querySelector(".item.active")
```

原因：
- 当前只有 `getByName/getByHandle`

### H. 不能用 CSS transition / keyframes

```css
transition: all .2s ease;
animation: pulse 1s infinite;
```

原因：
- 当前只有命令式 Tween，没有 CSS 动画规则系统

---

## 结论

如果问题是：

### “我的框架现在是不是已经能像真正 HTML5 + CSS + JS 那样写？”

答案是：
- 还不能。

### “它现在最像什么？”

答案是：
- 一个以 `Frame`/组件直接构造为核心
- 用 `Style` 提供少量 CSS 风格布局语义
- 用 `Watcher/Tween` 提供少量 JS 风格行为能力
- 但还没有浏览器那套完整标记、样式、DOM、事件、重排、动画、响应式渲染机制的 UI 框架

### “当前最稳定的写法是什么？”

答案是：
- 直接构造组件：

```lua
local panel = Panel({...})
local text = Text({ parent = panel, ... })
```

而不是：

```lua
Component({ class = "Panel", ... })
```

---

## 下一步最值得补的能力

如果你的目标真的是往 “HTML5 + CSS + JS 的写法体验” 靠，优先级建议是：

1. 先把声明式入口定下来
   - 让 `Component` 真正可用，或者重新建立新的稳定入口

2. 再补样式规则层
   - `className`
   - `id`
   - selector
   - cascade
   - reusable theme/token

3. 再补 DOM/浏览器行为层
   - 节点增删改查
   - 更完整的事件模型
   - 自动 sticky / fixed / layout refresh

4. 最后补高级体验
   - transition / keyframes
   - 状态驱动重渲染
   - 更强的 flex/grid 语义
