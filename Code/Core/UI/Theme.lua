local Theme = {}
local themes = {}
local getmetatable = getmetatable
local next = next
local pairs = pairs
local print = print
local rawget = rawget
local rawset = rawset
local require = require
local setmetatable = setmetatable
local table_sort = table.sort
local table_unpack = table.unpack
local tonumber = tonumber
local type = type

local runtime_style
local runtime_point
local runtime_declarations = table.setmode({}, "k") or setmetatable({}, { __mode = "k" })
local theme_ref_flag = "__theme_ref__"

--[[
    模块：Theme
    1. 作用
       - 把 Theme 定义展开成普通 UI config。
       - 该模块属于应用层配置标准化阶段，通常由 `Component(...)` 在创建 Frame 之前调用。
    2. 边界
       - 不参与 `Frame` 的底层运行时逻辑。
       - 不做异步、watcher 或浏览器式自动重算。
       - `rules` / `tokens` / `vars` 只支持对象式 authoring，不支持数组式写法。
    3. 当前能力
       - `Theme.define(name, definition)` 注册命名主题。
       - `extends` 继承。
       - `"$token"` 与 `Theme.ref("token", fallback)` 引用。
       - `vars` / `theme_vars` 节点级变量覆盖。
       - 单节点 selector：类型、`.label`、`#id`、复合 selector。
    4. 运行约束
       - Theme 默认值先写入 config，inline config 后覆盖。
       - 声明期子树统一用 `tree`，运行期活树统一用 `frame.childs`。
]]
-- Theme 自己的保留字段，不能当作普通样式字段合并进目标 config。
local reserved_keys = {
    theme = true,
    name = true,
    extends = true,
    tokens = true,
    vars = true,
    theme_vars = true,
    rules = true,
    tree = true,
    children = true,
    class = true,
    id = true,
    label = true,
    parent = true,
    data = true,
    __theme_decl__ = true,
}
-- Theme 允许写回目标 config 的内置字段白名单。
-- 仅保留"没有对应 __attributes__ 的构造期 config 字段"，其余字段由 collectAttributeKeys 自动注入。
-- layout / font / align：构造期 config 字段，无对应 attribute setter，需手动维护。
-- camera_x/y/z / focus_x/y/z：Portrait.__init__ 直接读 template，无对应 attribute，需手动维护。
local mergeable_keys = {
    layout = true,
    font = true,
    align = true,
    camera_x = true,
    camera_y = true,
    camera_z = true,
    focus_x = true,
    focus_y = true,
    focus_z = true,
}
--[[
    函数：collectAttributeKeys
    1. 这个函数是用来干什么的
       - 遍历一组 Widget 类，把它们 __attributes__ 中的所有属性名自动写入 mergeable_keys。
    2. 为什么这样设计函数
       - mergeable_keys 手动维护容易遗漏，尤其是新增 Widget 属性时。
       - Class.getAttributeNames 已提供从类获取属性名数组的能力，直接复用即可。
    3. 这个函数是通过做了什么达到设计目的
       - 遍历传入的类数组，对每个类调用 Class.getAttributeNames。
       - 把返回的 attr.name 写入 mergeable_keys。
       - 必须在所有 Widget 类 require 完成后调用一次（通常在启动初始化末尾）。
]]
local function collectAttributeKeys(classes)
    if type(classes) ~= "table" then return end

    local Class = require "Lib.Base.Class"
    for index = 1, #classes do
        local cls = classes[index]
        if type(cls) == "string" then
            cls = Class.get(cls)
        end
        if not cls then goto not_cls_end end
        local attrs = Class.getAttributeNames(cls)
        if not attrs then goto not_cls_end end
        for i = 1, #attrs do
            local attr = attrs[i]
            if type(attr) == "table" and type(attr.name) == "string" then
                mergeable_keys[attr.name] = true
            end
        end
        ::not_cls_end::
    end
end
collectAttributeKeys({"Frame", "Model", "Panel", "Portrait", "SimpleText", "Slider", "Sprite", "Text", "TextArea", "Texture"})

-- 判断 key 是否属于 Theme 内部保留字段。
local function is_reserved_key(key)
    return reserved_keys[key] == true or (type(key) == "string" and key:sub(1, 2) == "__")
end
--[[
    函数：should_snapshot_declaration_key
    1. 这个函数是用来做什么的
       - 判断一个声明期 config 字段要不要进入 Theme 的运行时声明快照。
    2. 为什么要单独做这一层判断
       - 运行时换主题时，Theme 只需要保留后续重建还会用到的字段。
       - `tree` / `parent` / `data` 这类字段有各自的边界，不应该被无差别塞进快照。
       - 把快照字段规则集中到这里，后面 `snapshot_declaration_node(...)` 就不用再写长判断链。
       ]]
local function should_snapshot_declaration_key(key)
    if type(key) == "number" then
        return false
    end
    if key == "tree" or key == "children" or key == "parent" or key == "data" then
        return false
    end
    return mergeable_keys[key] == true or reserved_keys[key] == true or not is_reserved_key(key)
end

--[[
    函数：trim
    1. 这个函数是用来做什么的
       - 去掉字符串首尾空白。
    2. 为什么这样设计函数
       - Theme authoring 往往是手写配置，首尾空格很常见。
       - 在 token 名、selector 等解析里统一 trim，能减少边界分支。
       ]]
local function trim(value)
    if type(value) ~= "string" then
        return value
    end
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- 深拷贝 Theme 处理中会复用的值，保留 metatable 并处理循环引用。
local function clone_value(value, cache)
    if type(value) ~= "table" then
        return value
    end
    cache = cache or {}
    local cached = cache[value]
    if cached then
        return cached
    end
    local copy = {}
    cache[value] = copy
    for key, child in pairs(value) do
        copy[clone_value(key, cache)] = clone_value(child, cache)
    end
    return setmetatable(copy, getmetatable(value))
end
--[[
    函数：clone_declaration_value
    1. 作用
       - 为运行时声明快照复制单个字段值。
    2. 约定
       - `class` 直接保留原值。
       - 函数值也直接保留，其余字段再走 `clone_value(...)`。
]]
local function clone_declaration_value(key, value)
    if key == "class" or type(value) == "function" then
        return value
    end
    return clone_value(value)
end

-- 浅拷贝数组壳，用于组合规则列表。
local function copy_array(source)
    local copy = {}
    if type(source) ~= "table" then
        return copy
    end
    for index = 1, #source do
        copy[index] = source[index]
    end
    return copy
end
--[[
    函数：merge_object_fields
    1. 这个函数是用来干什么的
       - 合并一层对象式 table，把 `source` 的字段写入 `target`。
       - 仅对字符串键工作，且仅在字段值本身也是对象式 table 时递归。
    2. 为什么单独保留它
       - `merge_props(...)` 负责顶层白名单控制。
       - 顶层一旦确认字段允许合并，例如 `style` / `layout`，内部字段仍然需要一条轻量的对象合并路径。
]]
local function merge_object_fields(target, source, overwrite)
    if type(target) ~= "table" or type(source) ~= "table" then
        return target
    end
    for key, value in pairs(source) do
        if type(key) == "string" then
            local current = target[key]
            if type(current) == "table"
                and type(value) == "table"
                and rawget(current, 1) == nil
                and rawget(value, 1) == nil
            then
                merge_object_fields(current, value, overwrite)
            elseif overwrite or current == nil then
                target[key] = clone_value(value)
            end
        end
    end
    return target
end
--[[
    函数：merge_props
    1. 作用
       - 把 Theme 规则命中的 patch 合并进目标 config。
    2. 当前约束
       - 顶层只接受 `mergeable_keys` 白名单中的字段。
       - 遍历 `source` 里真实存在的键，再用白名单过滤，避免每次都扫完整张内置键表。
       - `style` / `layout` 这类对象字段再交给 `merge_object_fields(...)` 继续合并。
]]
local function merge_props(target, source, overwrite)
    if type(target) ~= "table" or type(source) ~= "table" then
        return target
    end
    for key, value in pairs(source) do
        if mergeable_keys[key] == true then
            local current = target[key]
            if type(current) == "table"
                and type(value) == "table"
                and rawget(current, 1) == nil
                and rawget(value, 1) == nil
            then
                merge_object_fields(current, value, overwrite)
            elseif overwrite or current == nil then
                target[key] = clone_value(value)
            end
        end
    end
    return target
end
    --[[
    函数：copy_token_table
    1. 这个函数是用来做什么的
       - 复制 `tokens` / `vars` / `theme_vars` 这类 token 表。
    2. 当前约定
       - token key 直接写 `gap-sm`。
       - 常用引用时写 `"$gap-sm"`。
       - 少数需要 fallback 的场景写 `Theme.ref("gap-sm", 8)`。
       - 只接受字符串 key，不再额外兼容别的写法。
       --]]
       local function copy_token_table(source)
    if type(source) ~= "table" then
        return nil
    end
    local copied
    for key, value in pairs(source) do
        if type(key) == "string" and key ~= "" then
            copied = copied or {}
            copied[key] = clone_value(value)
        end
    end
    return copied
end
--[[
    函数：assign_token_values
    1. 这个函数是用来干什么的
       - 把一张 token 表覆盖写入目标 token 作用域。
    2. 为什么这样设计函数
       - token 不是 UI config，不应该走 `mergeable_keys` 白名单。
       - token 覆盖按整个值替换处理，不做 config 风格的深合并。
    3. 返回约定
       - 返回 `target`，方便在构建作用域时顺手串起来写。
]]
local function assign_token_values(target, source)
    if type(target) ~= "table" or type(source) ~= "table" then
        return target
    end
    for key, value in pairs(source) do
        target[key] = clone_value(value)
    end
    return target
end
--[[
    函数：parse_token_string
    1. 这个函数是用来做什么的
       - 判断一个字符串是不是 Theme 的常用 token 引用写法。
    2. 当前约定
       - 只认 `"$token"`。
       - 不再解析 `var(...)` 这一层字符串语法。
       - 常用路径尽量只做最小判断，减少额外解析开销。
        --]]
local function parse_token_string(value)
    if type(value) ~= "string" or value:sub(1, 1) ~= "$" then
        return nil
    end
    local token_name = value:sub(2)
    if token_name == "" then
        return nil
    end
    return token_name
end
--[[
    函数：is_theme_ref
    1. 这个函数是用来做什么的
       - 判断一个 table 值是不是 `Theme.ref(...)` 生成的 token 引用对象。
    2. 为什么保留这条路径
       - 常用 token 引用已经由 `"$token"` 负责。
       - `Theme.ref(...)` 只留给少数需要 fallback 或代码式构造的场景。
       ]]
local function is_theme_ref(value)
    return type(value) == "table" and rawget(value, theme_ref_flag) == true
end

-- 递归解析 `"$token"` 与 `Theme.ref(...)`。
local function resolve_value(value, vars, stack)
    if type(value) == "string" then
        local token_name = parse_token_string(value)
        if not token_name then
            return value
        end 
        stack = stack or {}
        if stack[token_name] then
            return value
        end
        local token_value = vars and vars[token_name]
        if token_value ~= nil then
            stack[token_name] = true
            local resolved = resolve_value(clone_value(token_value), vars, stack)
            stack[token_name] = nil
            return resolved
        end
        return value
        end
        if type(value) ~= "table" then
            return value
        end
        if is_theme_ref(value) then
            local token_name = rawget(value, "name")
            local fallback = rawget(value, "fallback")
            if type(token_name) ~= "string" or token_name == "" then
                if fallback ~= nil then
                    return resolve_value(clone_value(fallback), vars, stack)
                end
                return value
            end
                stack = stack or {}
        if stack[token_name] then
            if fallback ~= nil then
                return resolve_value(clone_value(fallback), vars, stack)
            end
            return value
        end
        local token_value = vars and vars[token_name]
        if token_value ~= nil then
            stack[token_name] = true
            local resolved = resolve_value(clone_value(token_value), vars, stack)
            stack[token_name] = nil
            return resolved
        end
            if fallback ~= nil then
                return resolve_value(clone_value(fallback), vars, stack)
            end
            return value
        end
        for key, child in pairs(value) do
            value[key] = resolve_value(child, vars, stack)
        end
        return value
    end
-- 先整理当前作用域内 token 之间的依赖关系。
local function resolve_var_table(vars)
    if type(vars) ~= "table" then
        return vars
    end
    for key, value in pairs(vars) do
        vars[key] = resolve_value(value, vars, { [key] = true })
    end
    return vars
end

-- 解析单节点 selector，并预计算 specificity。
local function parse_selector(selector)
    if type(selector) ~= "string" then
        return nil
    end
    local normalized = trim(selector)
    if normalized == "" then
        return nil
    end
    if normalized == "*" then
        return {
            raw = normalized,
            specificity = 0,
            labels = {},
            universal = true,
        }
    end
    if normalized:find("[%s>:]") then
        if __DEBUG__ then
            print("Theme: selector only supports single-node matching", normalized)
        end
        return nil
    end
    local parsed = {
        raw = normalized,
        labels = {},
        specificity = 0,
    }
    local cursor = 1
    local length = #normalized
    local type_name = normalized:match("^[^.#]+")
    if type_name and type_name ~= "" then
        parsed.type_name = type_name
        parsed.specificity = parsed.specificity + 1
        cursor = #type_name + 1
    end
    while cursor <= length do
        local prefix = normalized:sub(cursor, cursor)
        if prefix ~= "." and prefix ~= "#" then
            return nil
        end
        local start_index = cursor + 1
        local next_dot = normalized:find("%.", start_index, true)
        local next_hash = normalized:find("#", start_index, true)
        local end_index = length + 1
        if next_dot and next_dot < end_index then
            end_index = next_dot
        end
        if next_hash and next_hash < end_index then
            end_index = next_hash
        end
        local fragment = normalized:sub(start_index, end_index - 1)
        if fragment == "" then
            return nil
        end
        if prefix == "." then
            parsed.labels[#parsed.labels + 1] = fragment
            parsed.specificity = parsed.specificity + 10
        else
            if parsed.id then
                return nil
            end
            parsed.id = fragment
            parsed.specificity = parsed.specificity + 100
        end
        cursor = end_index
    end
    return parsed
end
    local function normalize_rule_entries(rules)
        if type(rules) ~= "table" then
            return nil
        end
        local entries
        for selector, props in pairs(rules) do
            if type(selector) == "string" and type(props) == "table" then
                local parsed = parse_selector(selector)
                if parsed then
                    entries = entries or {}
                    entries[#entries + 1] = {
                        selector = selector,
                        parsed = parsed,
                        props = props,
                    }
                end
            end
        end
        if not entries or not next(entries) then
            return nil
        end
        table_sort(entries, function(left, right)
            if left.parsed.specificity ~= right.parsed.specificity then
                return left.parsed.specificity < right.parsed.specificity
            end
            return left.selector < right.selector
        end)
        return entries
    end
-- 把一组规则顺序追加到另一组规则后面。
local function append_rule_entries(target, source)
        if type(target) ~= "table" or type(source) ~= "table" then
            return target
        end
        for index = 1, #source do
            target[#target + 1] = source[index]
        end
        return target
    end
-- 单次 apply / resolve 过程内的临时缓存。
local function create_resolve_cache()
        return {
            named = {},
            tables = {},
        }
    end
-- 解析命名主题、匿名主题以及 extends 链。
local function resolve_theme(theme_like, stack, cache)
        local original_theme = theme_like
        if cache then
            if type(original_theme) == "string" then
                local cached_by_name = cache.named[original_theme]
                if cached_by_name then
                    return cached_by_name
                end
            elseif type(original_theme) == "table" then
                local cached_by_table = cache.tables[original_theme]
                if cached_by_table then
                    return cached_by_table
                end
            end
        end
        if type(theme_like) == "string" then
            theme_like = themes[theme_like]
        end
        if cache and type(theme_like) == "table" then
            local cached_by_table = cache.tables[theme_like]
            if cached_by_table then
                if type(original_theme) == "string" then
                    cache.named[original_theme] = cached_by_table
                end
                return cached_by_table
            end
        end
        if type(theme_like) ~= "table" then
            return nil
        end
        stack = stack or {}
        if stack[theme_like] then
            if __DEBUG__ then
                print("Theme.resolve: circular extends detected", theme_like.name or "<anonymous>")
            end
            return nil
        end
        stack[theme_like] = true
        local resolved = {
            name = theme_like.name,
            tokens = {},
            rules = {},
        }
        local extends = rawget(theme_like, "extends")
        if extends ~= nil then
            if type(extends) == "string" or type(extends) == "table" then
                local base_theme = resolve_theme(extends, stack, cache)
                if base_theme then
                    assign_token_values(resolved.tokens, base_theme.tokens)
                    append_rule_entries(resolved.rules, base_theme.rules)
                end
            elseif __DEBUG__ then
                print("Theme.resolve: extends must be a string or theme table")
            end
        end
        assign_token_values(resolved.tokens, copy_token_table(rawget(theme_like, "tokens")))
        assign_token_values(resolved.tokens, copy_token_table(rawget(theme_like, "vars")))
        append_rule_entries(resolved.rules, normalize_rule_entries(rawget(theme_like, "rules")))
        stack[theme_like] = nil
        if cache then
            cache.tables[theme_like] = resolved
            if type(original_theme) == "string" then
                cache.named[original_theme] = resolved
            end
        end
        return resolved
    end
-- 组合父节点可见规则和当前节点局部主题规则。
local function combine_themes(parent_theme, local_theme)
        if not parent_theme then
            return local_theme
        end
        if not local_theme then
            return parent_theme
        end
        local combined = {
            rules = copy_array(parent_theme.rules),
        }
        append_rule_entries(combined.rules, local_theme.rules)
        return combined
    end
-- `label` authoring is convention-based: use a string like `"card primary"`.
local function collect_labels(config)
        local labels = rawget(config, "label")
        if type(labels) ~= "string" then
            return nil
        end
        local result = {}
        for label_name in labels:gmatch("%S+") do
            result[label_name] = true
        end
        return next(result) and result or nil
    end
-- 从 config 或 class hint 推断当前节点的类型名。
local function infer_type_name(config, class_hint)
        local class_value = class_hint or rawget(config, "class")
        if type(class_value) == "string" then
            return class_value
        end
        if type(class_value) == "table" and type(class_value.name) == "string" then
            return class_value.name
        end
        return nil
    end
-- 为规则匹配准备当前节点的 selector 上下文。
local function build_selector_context(config, class_hint)
        return {
            type_name = infer_type_name(config, class_hint),
            id = rawget(config, "id"),
            labels = collect_labels(config),
        }
    end
-- 判断规则是否命中当前节点。
local function matches_rule(rule, selector_context)
        local parsed = rule and rule.parsed
        if not parsed then
            return false
        end
        if parsed.universal then
            return true
        end
        if parsed.type_name and parsed.type_name ~= selector_context.type_name then
            return false
        end
        if parsed.id and parsed.id ~= selector_context.id then
            return false
        end
        if #parsed.labels > 0 then
            local labels = selector_context.labels
            if not labels then
                return false
            end
            for index = 1, #parsed.labels do
                if not labels[parsed.labels[index]] then
                    return false
                end
            end
        end
        return true
    end
-- 构建当前节点可见的 token / vars 作用域。
local function build_var_scope(inherited_vars, local_theme, config, reset_scope)
        local vars = reset_scope and {} or clone_value(inherited_vars or {})
        if local_theme and type(local_theme.tokens) == "table" then
            assign_token_values(vars, local_theme.tokens)
        end
        assign_token_values(vars, copy_token_table(rawget(config, "theme_vars")))
        assign_token_values(vars, copy_token_table(rawget(config, "vars")))
        resolve_var_table(vars)
        return vars
    end
-- 先把命中的规则合成为 patch，再一次性并回 config。
local function apply_rules(config, current_theme, class_hint)
        if type(config) ~= "table" or type(current_theme) ~= "table" or type(current_theme.rules) ~= "table" then
            return config
        end
        local selector_context = build_selector_context(config, class_hint)
        local patch
        for index = 1, #current_theme.rules do
            local rule = current_theme.rules[index]
            if matches_rule(rule, selector_context) then
                patch = patch or {}
                merge_props(patch, rule.props, true)
            end
        end
        if patch then
            merge_props(config, patch, false)
        end
        return config
    end
-- 解析节点普通字段里的 token 引用。
local function resolve_node_values(config, vars)
        if type(config) ~= "table" then
            return config
        end
        for key, value in pairs(config) do
            if type(key) ~= "number" and not is_reserved_key(key) then
                config[key] = resolve_value(value, vars)
            end
        end
        return config
    end
-- 截取当前节点的声明快照，供运行时换主题重建使用。
local function snapshot_declaration_node(config)
        local snapshot = {}
        for key, value in pairs(config) do
            if should_snapshot_declaration_key(key) then
                snapshot[key] = clone_declaration_value(key, value)
            end
        end
        return snapshot
    end
-- 确保声明期 config 已缓存 `__theme_decl__` 快照。
local function ensure_declaration_snapshot(config)
        local snapshot = rawget(config, "__theme_decl__")
        if type(snapshot) ~= "table" then
            snapshot = snapshot_declaration_node(config)
            rawset(config, "__theme_decl__", snapshot)
        end
        return snapshot
    end
-- 顺序遍历声明期 `tree` 子节点。
local function walk_child_nodes(config, callback)
        local tree = rawget(config, "tree")
        if type(tree) == "table" then
            for index = 1, #tree do
                callback(tree[index])
            end
        end
    end
-- 递归地对整棵声明树应用 Theme。
local function apply_node(config, inherited_theme, inherited_vars, class_hint, resolve_cache)
        if type(config) ~= "table" then
            return config
        end
        ensure_declaration_snapshot(config)
        local theme_value = rawget(config, "theme")
        local local_theme
        local current_theme
        local reset_scope = false
        if theme_value == false then
            current_theme = nil
            reset_scope = true
        elseif theme_value ~= nil then
            local_theme = resolve_theme(theme_value, nil, resolve_cache)
            current_theme = combine_themes(inherited_theme, local_theme)
        else
            current_theme = inherited_theme
        end
        local current_vars = build_var_scope(inherited_vars, local_theme, config, reset_scope)
        apply_rules(config, current_theme, class_hint)
        resolve_node_values(config, current_vars)
        walk_child_nodes(config, function(child)
            local child_hint = type(child) == "table" and rawget(child, "class") or nil
            apply_node(child, current_theme, current_vars, child_hint, resolve_cache)
        end)
        return config
    end
-- 运行时热应用走固定标量属性列表，避免每次重放主题时做大范围动态扫描。
local runtime_scalar_props = {
        "is_show",
        "alpha",
        "level",
        "scale",
        "x_scale",
        "y_scale",
        "z_scale",
        "z",
        "roll",
        "pitch",
        "yaw",
        "is_track",
        "view_port",
        "disable",
        "image",
        "is_tile",
        "blend_mode",
        "state",
        "path",
        "font_height",
        "value",
        "limit",
        "min_limit",
        "max_limit",
        "flag",
        "shadow_off",
        "color",
        "normal_color",
        "disable_color",
        "highlight_color",
        "shadow_color",
        "animation",
        "animation_progress",
    }

-- 少量必须通过方法提交的属性单独收口，避免和普通字段赋值混在一起。
local runtime_method_props = {
    { key = "font", method = "setFont" },
    { key = "align", method = "setAlign" },
}

-- 按需加载运行时换主题所需模块，避免影响声明期预处理开销。
local function ensure_runtime_modules()
    if not runtime_style then
        runtime_style = require "Core.UI.Style"
    end
    if not runtime_point then
        runtime_point = require "FrameWork.Manager.Point"
    end
end

-- 从 live frame 的 metatable 推断 selector 使用的类型提示。
local function get_frame_class_hint(frame)
    if type(frame) ~= "table" then
        return nil
    end
    local class = getmetatable(frame)
    if type(class) == "table" then
        return class
    end
    return nil
end

-- 从声明快照复制运行时可重建的 authoring 信息。
local function clone_runtime_declaration(config)
    if type(config) ~= "table" then
        return nil
    end
    local source = rawget(config, "__theme_decl__")
    if type(source) ~= "table" then
        source = config
    end
    return snapshot_declaration_node(source)
end

-- 把声明期 Theme 快照绑定到已创建完成的 live frame 树。
local function attach_runtime_tree(frame, config)
    if type(frame) ~= "table" or type(config) ~= "table" then
        return frame
    end
    runtime_declarations[frame] = clone_runtime_declaration(config) or {}
    local tree = rawget(config, "tree")
    local childs = rawget(frame, "childs")
    if type(tree) ~= "table" or type(childs) ~= "table" then
        return frame
    end
    for index = 1, #tree do
        local child_frame = childs[index]
        local child_config = tree[index]
        if type(child_frame) == "table" and type(child_config) == "table" then
            attach_runtime_tree(child_frame, child_config)
        end
    end
    return frame
end

-- 读取或创建某个 live frame 对应的 Theme 运行时声明快照。
local function ensure_frame_declaration(frame)
    -- Runtime Theme state is stored in Theme-owned weak tables to keep Frame clean.
    local declaration = runtime_declarations[frame]
    if type(declaration) == "table" then
        return declaration
    end
    declaration = {}
    local class_hint = get_frame_class_hint(frame)
    if class_hint then
        declaration.class = class_hint
    end
    runtime_declarations[frame] = declaration
    return declaration
end

-- 从 live frame.childs 重建一棵临时运行时 config tree。
local function build_runtime_theme_tree(frame)
    local declaration = ensure_frame_declaration(frame)
    local config = {}
    for key, value in pairs(declaration) do
        config[key] = clone_declaration_value(key, value)
    end
    if rawget(config, "class") == nil then
        local class_hint = get_frame_class_hint(frame)
        if class_hint then
            config.class = class_hint
        end
    end
    local childs = rawget(frame, "childs")
    if type(childs) == "table" and #childs > 0 then
        local tree = {}
        for index = 1, #childs do
            local child = childs[index]
            if child then
                tree[index] = build_runtime_theme_tree(child)
            end
        end
        if next(tree) then
            config.tree = tree
        end
    end
    return config
end

-- 把运行时临时 config 的结果回写到 live frame。
local function apply_runtime_frame_props(frame, config)
    ensure_runtime_modules()
    if rawget(config, "size") ~= nil then
        frame.size = rawget(config, "size")
    else
        local width = rawget(config, "width")
        local height = rawget(config, "height")
        if width ~= nil then
            frame.width = width
        end
        if height ~= nil then
            frame.height = height
        end
    end
    local x = rawget(config, "x")
    local y = rawget(config, "y")
    if x ~= nil and y ~= nil then
        frame.position = runtime_point(x, y)
    end
    for index = 1, #runtime_scalar_props do
        local key = runtime_scalar_props[index]
        local value = rawget(config, key)
        if value ~= nil then
            frame[key] = value
        end
    end
    local style_value = rawget(config, "style")
    if style_value ~= nil and type(style_value) ~= "table" then
        frame.style = style_value
    end
    for index = 1, #runtime_method_props do
        local runtime_prop = runtime_method_props[index]
        local value = rawget(config, runtime_prop.key)
        local method = frame[runtime_prop.method]
        if type(value) == "table" and type(method) == "function" then
            method(frame, table_unpack(value))
        end
    end
end

-- 按 live frame.childs 顺序递归提交整棵运行时主题树。
local function commit_runtime_theme_tree(frame, config)
    if type(frame) ~= "table" or type(config) ~= "table" then
        return frame
    end
    apply_runtime_frame_props(frame, config)
    local childs = rawget(frame, "childs")
    local tree = rawget(config, "tree")
    if type(childs) ~= "table" or type(tree) ~= "table" then
        return frame
    end
    for index = 1, #childs do
        local child_frame = childs[index]
        local child_config = tree[index]
        if child_frame and type(child_config) == "table" then
            commit_runtime_theme_tree(child_frame, child_config)
        end
    end
    return frame
end

-- 注册一个命名主题。
function Theme.define(name, definition)
    if type(name) ~= "string" or type(definition) ~= "table" then
        if __DEBUG__ then
            print("Theme.define: name must be a string and definition must be a table")
        end
        return nil
    end
    definition.name = name
    themes[name] = definition
    return definition
end
--[[
    函数：Theme.ref
    1. 这个函数是用来做什么的
       - 创建一个少数场景使用的 token 引用对象。
    2. 适用场景
       - 常用场景请直接写 `"$token"`。
       - 只有确实需要 fallback 或代码式构造时，再写 `Theme.ref("token", fallback)`。
    3. 返回约定
       - 返回一个给 Theme 内部识别的轻量标记 table。
       - 这个 table 不应该被 `Frame` / `Style` 直接消费。
       ]]
function Theme.ref(name, fallback)
    return {
        [theme_ref_flag] = true,
        name = name,
        fallback = fallback,
    }
end

-- 读取原始注册的主题定义。
function Theme.get(name)
    return themes[name]
end

-- 暴露一次性的主题解析结果，便于调试和检查。
function Theme.resolve(theme_like)
    return resolve_theme(theme_like, nil, create_resolve_cache())
end

-- 对声明期 config tree 应用 Theme 预处理。
function Theme.apply(config, class_hint)
    return apply_node(config, nil, nil, class_hint, create_resolve_cache())
end

-- `Theme.apply(...)` 的语义别名。
function Theme.reapply(config, class_hint)
    return Theme.apply(config, class_hint)
end

-- 把声明期 Theme 快照绑定到已创建完成的 live frame 树。
function Theme.attach(frame, config)
    return attach_runtime_tree(frame, config)
end

-- 对 live frame 树重新应用 Theme，可选地改写根节点主题。
function Theme.applyRuntime(frame, theme_like)
    if type(frame) ~= "table" then
        return nil
    end
    local declaration = ensure_frame_declaration(frame)
    if theme_like ~= nil then
        declaration.theme = theme_like
    end
    local runtime_config = build_runtime_theme_tree(frame)
    local class_hint = get_frame_class_hint(frame)
    Theme.apply(runtime_config, class_hint)
    if type(runtime_config.x) == "number"
        and type(runtime_config.y) == "number"
        and type(runtime_config.width) == "number"
        and type(runtime_config.height) == "number"
    then
        ensure_runtime_modules()
        runtime_style.applyLayout(runtime_config)
    end
    commit_runtime_theme_tree(frame, runtime_config)
    if runtime_style and type(runtime_config.tree) == "table" then
        runtime_style.bindRuntimeLayout(frame, runtime_config)
    end
    return runtime_config
end

-- 运行时切换根节点主题。
function Theme.set(frame, theme_like)
    return Theme.applyRuntime(frame, theme_like)
end

-- 按当前已绑定主题刷新 live frame 树。
function Theme.refresh(frame)
    return Theme.applyRuntime(frame)
end
--[[
    函数：Theme.reapplyRuntime
    1. 作用
       - 作为 `Theme.refresh(...)` 的语义别名，按当前已绑定主题重放一次运行时 Theme。
]]
function Theme.reapplyRuntime(frame)
    return Theme.applyRuntime(frame)
end

--[[
    函数：register_builtin_themes
    1. 作用
       - 注册几套内置的 web 风格预设主题，方便直接试写 Theme。
    2. 说明
       - 这些只是 authoring 起点，不是强制设计系统。
    3. 主题层级
       builtin.web.base          基础骨架（tokens + 通用规则）
         ├─ builtin.web.light    浅色系（高 alpha，深色文字）
         └─ builtin.web.dark     深色系（低 alpha，浅色文字）
              ├─ builtin.web.dashboard  数据看板（绿色 accent）
              ├─ builtin.web.console    终端控制台（青绿 accent，极低 alpha）
              └─ builtin.web.glass      玻璃拟态（极低 alpha，淡紫 accent）
]]
local function register_builtin_themes()
    --[[
        主题：builtin.web.base
        风格：所有内置 web 主题的公共骨架，本身为中性暗色基调
        tokens：
            space-xs     4   最小间距，用于紧凑元素内边距
            space-sm     8   小间距，用于元素间 gap
            space-md    12   中间距，用于面板内边距
            space-lg    16   大间距，用于章节级分隔或宽松布局
            surface-alpha  215  主面板背景不透明度（0–255）
            card-alpha     235  卡片背景不透明度，比 surface 更实
            section-alpha  200  分区背景不透明度，比 surface 略透
            title-color    0xFFFFFFFF  标题文字色（ARGB）
            body-color     0xFFE8E8E8  正文文字色
            muted-color    0xFFB8B8B8  辅助/次要文字色
            accent-color   0xFF79C8FF  强调色，用于链接、高亮、主按钮
        rules：
            Panel.surface   主面板容器，标准内边距与 gap
            Panel.card      卡片容器，比 surface 更不透明，适合内容块
            Panel.section   分区容器，较透明，适合次级分组
            Text.title      标题文字，使用 title-color
            Text.body       正文文字，使用 body-color
            Text.muted      辅助文字，使用 muted-color（灰暗）
            Text.accent     强调文字，使用 accent-color（高亮）
        适用：作为继承基础，不建议直接使用
    ]]
    Theme.define("builtin.web.base", {
        tokens = {
            ["space-xs"] = 4,
            ["space-sm"] = 8,
            ["space-md"] = 12,
            ["space-lg"] = 16,
            ["surface-alpha"] = 215,
            ["card-alpha"] = 235,
            ["section-alpha"] = 200,
            ["title-color"] = 0xFFFFFFFF,
            ["body-color"] = 0xFFE8E8E8,
            ["muted-color"] = 0xFFB8B8B8,
            ["accent-color"] = 0xFF79C8FF,
        },
        rules = {
            ["Panel.surface"] = {
                alpha = "$surface-alpha",
                style = {
                    padding = "$space-md",
                    gap = "$space-sm",
                },
            },
            ["Panel.card"] = {
                alpha = "$card-alpha",
                style = {
                    padding = "$space-md",
                    gap = "$space-sm",
                },
            },
            ["Panel.section"] = {
                alpha = "$section-alpha",
                style = {
                    padding = "$space-sm",
                    gap = "$space-sm",
                },
            },
            ["Text.title"] = {
                color = "$title-color",
            },
            ["Text.body"] = {
                color = "$body-color",
            },
            ["Text.muted"] = {
                color = "$muted-color",
            },
            ["Text.accent"] = {
                color = "$accent-color",
            },
        },
    })

    --[[
        主题：builtin.web.light
        风格：标准浅色系，接近现代 Web 应用的亮色 UI（如 GitHub Light、Notion）
        继承：builtin.web.base
        tokens（覆盖 base）：
            surface-alpha  235  高不透明度，面板几乎不透明
            card-alpha     255  卡片完全不透明，白色实底
            section-alpha  225  分区略微半透明
            title-color    0xFF20242A  近黑色标题，高对比
            body-color     0xFF3B414A  深灰正文，易读
            muted-color    0xFF6D7682  中灰辅助文字
            accent-color   0xFF0066CC  标准蓝色强调，符合 web 惯例
        适用：工具面板、编辑器、配置界面等浅色场景
    ]]
    Theme.define("builtin.web.light", {
        extends = "builtin.web.base",
        tokens = {
            ["surface-alpha"] = 235,
            ["card-alpha"] = 255,
            ["section-alpha"] = 225,
            ["title-color"] = 0xFF20242A,
            ["body-color"] = 0xFF3B414A,
            ["muted-color"] = 0xFF6D7682,
            ["accent-color"] = 0xFF0066CC,
        },
    })

    --[[
        主题：builtin.web.dark
        风格：标准深色系，接近现代 Web 应用的暗色 UI（如 VS Code Dark、GitHub Dark）
        继承：builtin.web.base
        tokens（覆盖 base）：
            surface-alpha  180  半透明深色面板，允许背景透出
            card-alpha     220  卡片较实，但仍有轻微透明感
            section-alpha  200  分区介于两者之间
            title-color    0xFFF5F7FA  近白色标题，高对比
            body-color     0xFFD7DCE3  浅灰正文
            muted-color    0xFF97A3B3  中蓝灰辅助文字
            accent-color   0xFF5CB8FF  亮蓝强调色，在暗底上清晰可见
        适用：游戏内 HUD、夜间模式、沉浸式界面
    ]]
    Theme.define("builtin.web.dark", {
        extends = "builtin.web.base",
        tokens = {
            ["surface-alpha"] = 180,
            ["card-alpha"] = 220,
            ["section-alpha"] = 200,
            ["title-color"] = 0xFFF5F7FA,
            ["body-color"] = 0xFFD7DCE3,
            ["muted-color"] = 0xFF97A3B3,
            ["accent-color"] = 0xFF5CB8FF,
        },
    })

    --[[
        主题：builtin.web.dashboard
        风格：数据看板风格，深色底 + 翠绿强调，突出数据指标（如 Grafana、Datadog）
        继承：builtin.web.dark
        tokens（覆盖 dark）：
            surface-alpha  190  面板略比 dark 更实，减少视觉干扰
            card-alpha     230  卡片接近不透明，数据清晰
            section-alpha  210  分区适中
            accent-color   0xFF3DD1A5  翠绿色强调，传递「健康/在线/正向」语义
        rules（新增）：
            Panel.toolbar   工具栏面板，紧凑内边距，用于顶部/侧边操作栏
            Text.metric     指标数值文字，使用 accent-color 高亮，用于数字/百分比等关键数据
        适用：实时数据面板、监控界面、统计展示
    ]]
    Theme.define("builtin.web.dashboard", {
        extends = "builtin.web.dark",
        tokens = {
            ["surface-alpha"] = 190,
            ["card-alpha"] = 230,
            ["section-alpha"] = 210,
            ["accent-color"] = 0xFF3DD1A5,
        },
        rules = {
            ["Panel.toolbar"] = {
                alpha = "$surface-alpha",
                style = {
                    padding = "$space-sm",
                    gap = "$space-sm",
                },
            },
            ["Text.metric"] = {
                color = "$accent-color",
            },
        },
    })

    --[[
        主题：builtin.web.console
        风格：终端/控制台风格，极低不透明度 + 青绿色文字，模拟命令行氛围
        继承：builtin.web.dark
        tokens（覆盖 dark）：
            surface-alpha  170  极低不透明度，强烈透明感
            card-alpha     205  卡片也较透明
            section-alpha  190  分区透明度居中
            accent-color   0xFF39FFB6  高亮青绿色，模拟终端输出色
            muted-color    0xFF6BE3C2  低饱和青绿，用于次要输出行
        rules（新增）：
            Panel.console   控制台输出区，紧凑行间距（gap=space-xs）
            Text.console    控制台输出文字，使用 accent-color
        适用：调试控制台、日志输出区、命令输入面板
    ]]
    Theme.define("builtin.web.console", {
        extends = "builtin.web.dark",
        tokens = {
            ["surface-alpha"] = 170,
            ["card-alpha"] = 205,
            ["section-alpha"] = 190,
            ["accent-color"] = 0xFF39FFB6,
            ["muted-color"] = 0xFF6BE3C2,
        },
        rules = {
            ["Panel.console"] = {
                alpha = "$surface-alpha",
                style = {
                    padding = "$space-sm",
                    gap = "$space-xs",
                },
            },
            ["Text.console"] = {
                color = "$accent-color",
            },
        },
    })

    --[[
        主题：builtin.web.glass
        风格：玻璃拟态（Glassmorphism）——极低不透明度，模拟磨砂玻璃质感浮层
        继承：builtin.web.dark
        tokens（覆盖 dark）：
            surface-alpha  140  极透明面板，玻璃背板效果
            card-alpha     180  卡片半透明，内容区稍实
            section-alpha  160  分区介于两者之间
            title-color    0xFFFFFFFF  纯白标题，在透明底上保证高对比
            body-color     0xFFE8F0FF  冰白正文，带轻微蓝调
            muted-color    0xFF9AAAC8  蓝灰辅助文字
            accent-color   0xFFB794F4  淡紫强调色，呼应玻璃的冷感与光感
        rules（新增）：
            Panel.glass     浮层/弹窗玻璃背板，使用 surface-alpha
            Panel.overlay   全屏遮罩层（alpha=120，比 glass 更透，用于模态背景）
            Text.label      辅助标签，使用 muted-color（比 body 更暗淡）
        适用：HUD 浮层、模态对话框、半透明工具面板、覆盖在游戏场景上的 UI
    ]]
    Theme.define("builtin.web.glass", {
        extends = "builtin.web.dark",
        tokens = {
            ["surface-alpha"] = 140,
            ["card-alpha"] = 180,
            ["section-alpha"] = 160,
            ["title-color"] = 0xFFFFFFFF,
            ["body-color"] = 0xFFE8F0FF,
            ["muted-color"] = 0xFF9AAAC8,
            ["accent-color"] = 0xFFB794F4,
        },
        rules = {
            ["Panel.glass"] = {
                alpha = "$surface-alpha",
                style = {
                    padding = "$space-md",
                    gap = "$space-sm",
                },
            },
            ["Panel.overlay"] = {
                alpha = 120,
                style = {
                    padding = "$space-lg",
                    gap = "$space-md",
                },
            },
            ["Text.label"] = {
                color = "$muted-color",
            },
        },
    })
end
register_builtin_themes()

return Theme
