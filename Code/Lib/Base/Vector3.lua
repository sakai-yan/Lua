local Struct = require "Lib.Base.Struct"

-- @module Vector3
--- 轻量级三维向量库，底层使用 `Struct` 管理字段存储。
---
--- 本模块将 `x`、`y`、`z` 分量分别存放在三组独立数组中，并使用整数
--- 句柄表示一个向量实例。这样的布局可以避免为每个向量创建 table，
--- 在高频更新场景下能够明显减少内存分配与 GC 压力。
---
--- 设计约定：
--- 1. `Vector3.new` 返回的是整数句柄，不是 table 对象。
--- 2. 句柄在 `Vector3.delete` 后立即失效，之后可能被对象池复用。
--- 3. 大部分运算函数使用 `out` 输出参数，便于复用临时向量并减少分配。
--- 4. `Vector3.x`、`Vector3.y`、`Vector3.z` 是由 `Struct` 创建的底层
---    分量数组，出于兼容性会暴露出来，但通常应视为实现细节。
---
--- 典型用法：
--- ```lua
--- local position = Vector3.new(0.0, 0.0, 0.0)
--- local velocity = Vector3.new(10.0, 0.0, 0.0)
--- local temp = Vector3.new()
---
--- Vector3.addScaled(position, velocity, 0.02, temp)
--- Vector3.copy(temp, position)
--- ```
---@alias Vector3Id integer

local Vector3 = Struct.define({
    fields = { "x", "y", "z" },
    defaults = {
        x = 0.0,
        y = 0.0,
        z = 0.0,
    }
}) or error("Failed to define Vector3 struct")

local _x = Vector3.x
local _y = Vector3.y
local _z = Vector3.z

Vector3.delete = Vector3.recycle
Vector3.get = Vector3.getAll
Vector3.set = Vector3.setAll


local math_sqrt = math.sqrt
local string_format = string.format

--- 创建一个向量并返回其句柄。
--- 重写new函数
--- 缺省分量会被初始化为 `0.0`。本函数适合创建需要长期保留的向量，
--- 也适合为热路径预先分配可反复复用的临时缓冲向量。
---
--- 适用场景：
--- - 保存位置、速度、方向等持久状态
--- - 为逐帧更新逻辑预分配临时向量
---
--- 注意：
--- - 返回值是句柄，不是 table
--- - 被删除的句柄后续可能再次由 `new` 返回
---
--@param x number|nil X 分量，缺省时为 `0.0`
--@param y number|nil Y 分量，缺省时为 `0.0`
--@param z number|nil Z 分量，缺省时为 `0.0`
--@return Vector3Id id 向量句柄
---@function Vector3.new(x, y, z)


--- 删除一个向量句柄，并将其归还到内部对象池。
---
--- 当临时向量不再需要时，应调用本函数回收句柄。相比放任大量短生命周期
--- 向量等待 GC 处理，主动复用句柄的成本更低。
---
--- 适用场景：
--- - 释放一次性计算阶段用到的临时向量
--- - 回收已经结束生命周期的运动、特效或模拟数据
---
--- 注意：
--- - 删除后的句柄不能继续使用
--- - 为了性能，本函数不检查重复删除
---
--@param id Vector3Id 待回收的向量句柄
---@function Vector3.recycle(id)
---@function Vector3.delete(id)


--- 读取一个向量的三个分量。
---
--- 当外部 API 需要分离的 `x`、`y`、`z` 数值，而不是向量句柄时，
--- 这是最直接的解包方式。
---
--- 适用场景：
--- - 调用引擎或 JASS 接口并传入坐标
--- - 调试、打印或序列化向量数据
---
--@param id Vector3Id 向量句柄
---@return number x
---@return number y
---@return number z
---@function Vector3.get(id)


--- 原地覆盖一个向量的三个分量。
---
--- 当句柄本身需要保持不变，但内容需要刷新时，可以使用本函数直接写入，
--- 例如更新实体缓存状态，或重用一个输出缓冲向量。
---
--- 注意：
--- - 与 `Vector3.new` 不同，本函数不会自动补默认值
--- - 若传入 `nil`，就会直接写入 `nil`；如果要表达数值零，请显式传 `0`
---
--@param id Vector3Id 向量句柄
--@param x number|nil 新的 X 分量
--@param y number|nil 新的 Y 分量
--@param z number|nil 新的 Z 分量
---@function Vector3.set(id, x, y, z)

--- 将一个向量的值复制到另一个句柄中。
---
--- 这是把临时计算结果提交回持久向量的低成本方式，无需重新创建句柄。
---
--- 适用场景：
--- - 将临时计算结果写回位置或速度
--- - 让两个不同句柄保持相同的向量值
---
---@param from Vector3Id 源向量
---@param to Vector3Id 目标向量
function Vector3.copy(from, to)
    if to then
        _x[to] = _x[from]
        _y[to] = _y[from]
        _z[to] = _z[from]
    end
end

--- 计算两个向量的和，并将结果写入 `out`。
---
--- 输出句柄可以与 `a` 或 `b` 相同，因此可以安全地用于原地累加。
---
--- 适用场景：
--- - 累积位移、偏移量
--- - 将基础方向与修正方向、扰动方向相加
---
---@param a Vector3Id 左操作数
---@param b Vector3Id 右操作数
---@param out Vector3Id 输出向量
function Vector3.add(a, b, out)
    if out then
        _x[out] = _x[a] + _x[b]
        _y[out] = _y[a] + _y[b]
        _z[out] = _z[a] + _z[b]
        return out
    end

    return _x[a] + _x[b], _y[a] + _y[b], _z[a] + _z[b]
end

--- 计算 `a - b`，并将结果写入 `out`。
---
--- 输出句柄可以与任一输入句柄重合，因此可以安全地用于原地更新差值。
---
--- 适用场景：
--- - 计算从一个点指向另一个点的方向
--- - 计算当前位置与目标位置之间的偏差
---
---@param a Vector3Id 左操作数
---@param b Vector3Id 右操作数
---@param out Vector3Id 输出向量
function Vector3.sub(a, b, out)
    local x = _x[a] - _x[b]
    local y = _y[a] - _y[b]
    local z = _z[a] - _z[b]

    if out then
        _x[out] = x
        _y[out] = y
        _z[out] = z
        return out
    end

    return x, y, z
end

--- 将一个向量按标量缩放，并将结果写入 `out`。
---
--- 输出句柄可以与输入句柄相同，因此适合原地放大或缩小向量。
---
--- 适用场景：
--- - 应用速度、加速度、插值系数
--- - 将方向向量转换为某个距离上的位移量
---
---@param a Vector3Id 输入向量
---@param s number 缩放系数
---@param out Vector3Id 输出向量
function Vector3.scale(a, s, out)
    local x = _x[a] * s
    local y = _y[a] * s
    local z = _z[a] * s

    if out then
        _x[out] = x
        _y[out] = y
        _z[out] = z
        return out
    end

    return x, y, z
end

--- 计算并返回两个向量的点积。
---
--- 点积常用于衡量方向一致性、向量投影以及长度关系，而且不需要额外构造
--- 中间向量。
---
--- 适用场景：
--- - 判断两个方向是否大致同向
--- - 将速度投影到某个朝向轴上
---
---@param a Vector3Id 左操作数
---@param b Vector3Id 右操作数
---@return number result 点积结果
function Vector3.dot(a, b)
    return _x[a] * _x[b] + _y[a] * _y[b] + _z[a] * _z[b]
end

--- 返回向量的平方长度。
---
--- 本函数避免了 `Vector3.length` 中的开方开销，因此在只需要比较大小、
--- 不需要真实长度值时通常更高效。
---
--- 适用场景：
--- - 与半径平方、阈值平方进行比较
--- - 在热路径中判断向量是否接近零向量
---
---@param a Vector3Id 输入向量
---@return number result 平方长度
function Vector3.lengthSquared(a)
    local x = _x[a]
    local y = _y[a]
    local z = _z[a]
    return x * x + y * y + z * z
end

--- 返回向量的欧几里得长度。
---
--- 当确实需要真实模长时使用本函数；如果只是做大小比较，通常优先使用
--- `Vector3.lengthSquared` 以减少开销。
---
--- 适用场景：
--- - 计算移动距离或速度大小
--- - 在归一化前取得向量模长
---
---@param a Vector3Id 输入向量
---@return number result 向量长度
function Vector3.length(a)
    local x = _x[a]
    local y = _y[a]
    local z = _z[a]
    return math_sqrt(x * x + y * y + z * z)
end

--- 将一个向量归一化，并把单位方向写入 `out`。
---
--- 如果输入是零向量，则输出会被设置为 `(0, 0, 0)`，不会发生除零。
--- 输出句柄可以与输入句柄相同。
---
--- 适用场景：
--- - 将位移向量转换为方向向量
--- - 为转向、瞄准、朝向控制准备单位向量
---
---@param a Vector3Id 输入向量
---@param out Vector3Id 输出向量
function Vector3.normalize(a, out)
    local x = _x[a]
    local y = _y[a]
    local z = _z[a]
    local len_sq = x * x + y * y + z * z
    local nx
    local ny
    local nz

    if len_sq > 0 then
        local inv = 1 / math_sqrt(len_sq)
        nx = x * inv
        ny = y * inv
        nz = z * inv
    else
        nx = 0.0
        ny = 0.0
        nz = 0.0
    end

    if out then
        _x[out] = nx
        _y[out] = ny
        _z[out] = nz
        return out
    end

    return nx, ny, nz
end

--- 计算 `a` 与 `b` 的叉积，并将结果写入 `out`。
---
--- 叉积遵循右手法则。函数会先把输入分量缓存到局部变量中，因此 `out`
--- 可以安全地与任一输入句柄重合。
---
--- 适用场景：
--- - 构造正交基向量
--- - 从两个方向求法线或侧向轴
---
---@param a Vector3Id 左操作数
---@param b Vector3Id 右操作数
---@param out Vector3Id 输出向量
function Vector3.cross(a, b, out)
    local ax = _x[a]
    local ay = _y[a]
    local az = _z[a]
    local bx = _x[b]
    local by = _y[b]
    local bz = _z[b]
    local x = ay * bz - az * by
    local y = az * bx - ax * bz
    local z = ax * by - ay * bx

    if out then
        _x[out] = x
        _y[out] = y
        _z[out] = z
        return out
    end

    return x, y, z
end

--- 计算 `pos + velocity * dt`，并将结果写入 `out`。
---
--- 这是最常见的显式 Euler 积分一步封装，能够减少调用侧拆成多次向量运算
--- 带来的样板代码和函数调度开销。
---
--- 适用场景：
--- - 根据速度更新投射物或特效的位置
--- - 预估下一帧位置并写入临时缓冲
---
---@param pos Vector3Id 基础位置向量
---@param velocity Vector3Id 速度向量或每秒位移向量
---@param dt number 时间步长
---@param out Vector3Id 输出向量
function Vector3.addScaled(pos, velocity, dt, out)
    local x = _x[pos] + _x[velocity] * dt
    local y = _y[pos] + _y[velocity] * dt
    local z = _z[pos] + _z[velocity] * dt

    if out then
        _x[out] = x
        _y[out] = y
        _z[out] = z
        return out
    end

    return x, y, z
end

--- 使用对应的速度数组，对一批位置向量进行原地积分更新。
---
--- 对于每个索引 `i`，位置会按以下公式更新：
--- `posList[i] = posList[i] + velocityList[i] * dt`
---
--- 本函数为了降低开销，不做输入校验；调用者应保证两个数组长度一致，
--- 且索引一一对应。
---
--- 适用场景：
--- - 批量更新投射物运动
--- - 批量更新特效或粒子的位置
---
---@param posList Vector3Id[] 位置句柄数组
---@param velocityList Vector3Id[] 与位置一一对应的速度句柄数组
---@param dt number 时间步长
function Vector3.batchIntegrate(posList, velocityList, dt)
    for i = 1, #posList do
        local p = posList[i]
        local v = velocityList[i]
        _x[p] = _x[p] + _x[v] * dt
        _y[p] = _y[p] + _y[v] * dt
        _z[p] = _z[p] + _z[v] * dt
    end
end

--- 返回向量的格式化字符串表示。
---
--- 本函数主要用于日志、断言和临时检查，不适合放在热路径中频繁调用，
--- 因为字符串格式化会产生额外分配。
---
--- 适用场景：
--- - 开发期打印向量状态
--- - 为错误信息补充易读的坐标描述
---
---@param id Vector3Id 向量句柄
---@return string result 可读的向量字符串
function Vector3.debug(id)
    return string_format("Vector3(%.3f, %.3f, %.3f)", _x[id], _y[id], _z[id])
end

return Vector3
