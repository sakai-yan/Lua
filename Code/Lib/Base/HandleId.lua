--[[
    HandleId（Generational Handle / 复用句柄池）
    Lua 5.3+

【它是什么】
    这是现代工程里很常见的一类“句柄(handle) / 实体ID(entity id)”实现：
        handle = { typeTag, index, generation(version) }

    - index     ：可复用槽位编号（对象销毁后回收到空闲链表）
    - generation：槽位版本号（每次释放时 +1），用于避免 ABA
    - typeTag   ：类型标签（不同系统/类型用不同 tag，防止跨类型误用）

【为什么要 generation（避免 ABA）】
    如果句柄只有 index：
        A 使用 index=7 → A 被销毁 → index=7 被复用给 B
    旧句柄“7”仍可能命中 B（ABA）。
    通过 generation，每次 free 时 generation++，旧句柄就会失效。

【编码路径】
    本模块直接内建 (tag/index/generation) 的位打包与解包逻辑：
    - encodedId = tag | (index << signBits) | (version << (signBits + indexBits))
    - 通过预计算 mask/shift，alloc/free/verify/decode 全路径为纯整数位运算。

【性能特性】
    - alloc/free 使用 state + 单向 free-list，运行期稳定、GC 抖动小
    - encode/decode/safeDecode/alive 热路径：纯整数位运算 + 数组访问，无额外内存分配
    - 不使用哈希算法生成 tag：tag/signId 通过注册时递增编号分配（稳定、可控）
--]]

local tointeger = math.tointeger
local type = type

local HandleId = {}

local IS_64BITS = math.maxinteger > 0x7FFFFFFF
local TOTAL_BITS = IS_64BITS and 64 or 32

-- 默认 tag 位数：64位给 16（最多 65536 类型），32位给 6（最多 64 类型）
local DEFAULT_SIGN_BITS = IS_64BITS and 16 or 6

-- 签名注册表（不做 hash 生成 id，只做递增编号）
local signatureToId = {}
local idToSignature = {}
local nextSignId = 0

-- 同 signature 只创建一次池（池有状态：state/free-list）
local poolCache = {}

local function bitMask(bits)
    return ~(-1 << bits)
end

local function assertInt(v, name)
    local i = tointeger(v)
    if i == nil then
        error(name .. " 必须为整数", 3)
    end
    return i
end

-- 计算“能表示 0..maxValue”的最小 bits（即 2^bits - 1 >= maxValue）
local function bitsForMaxInclusive(maxValue)
    local bits = 0
    local v = 1
    while v <= maxValue do
        v = v << 1
        bits = bits + 1
    end
    return bits
end

--[[
registerSignature(signature, signBits)->signId
    为 signature 分配一个递增的整数 tag（0..2^signBits-1）。
    - 不使用哈希算法（不从字符串计算 hash），只做注册编号。
--]]
local function registerSignature(signature, signBits)
    local existing = signatureToId[signature]
    if existing then
        return existing
    end

    local maxSigns = 1 << signBits
    if nextSignId >= maxSigns then
        error(("HandleId: 签名数量超出 signBits 容量限制 (signBits=%d, max=%d)")
            :format(signBits, maxSigns), 3)
    end

    local signId = nextSignId
    nextSignId = signId + 1

    signatureToId[signature] = signId
    idToSignature[signId] = signature
    return signId
end

--[[
HandleId.new(signature, capacity [, opts]) -> pool

创建一个“可复用 + 带版本号”的句柄池。

参数:
    - signature (string): 类型标签名（用于分配 typeTag/signId）。
    - capacity  (integer): 最大槽位数量（index 范围为 1..capacity；0 保留为无效）。
    - opts (table|nil):
        - signBits    (integer|nil): tag 占用位数，默认 `DEFAULT_SIGN_BITS`。
        - indexBits   (integer|nil): index 占用位数；缺省时按 capacity 自动推导最小位数。
        - versionBits (integer|nil): generation/version 占用位数；缺省时用剩余位数。

返回:
    - pool (table): 提供 alloc/free/safeDecode/alive 等方法。

说明:
    - 同 signature 只创建一次（缓存）；再次 new 会校验参数一致并直接返回缓存实例。
--]]
function HandleId.new(signature, capacity, opts)
    assert(type(signature) == "string", "HandleId.new: signature 必须为 string")

    local cached = poolCache[signature]
    if cached then
        if capacity ~= nil and cached._capacity ~= capacity then
            error(("HandleId.new('%s') 重复创建但 capacity 不一致：old=%d new=%d")
                :format(signature, cached._capacity, capacity), 2)
        end
        if opts then
            if opts.signBits and opts.signBits ~= cached._signBits then
                error(("HandleId.new('%s') 重复创建但 signBits 不一致：old=%d new=%d")
                    :format(signature, cached._signBits, opts.signBits), 2)
            end
            if opts.indexBits and opts.indexBits ~= cached._indexBits then
                error(("HandleId.new('%s') 重复创建但 indexBits 不一致：old=%d new=%d")
                    :format(signature, cached._indexBits, opts.indexBits), 2)
            end
            if opts.versionBits and opts.versionBits ~= cached._versionBits then
                error(("HandleId.new('%s') 重复创建但 versionBits 不一致：old=%d new=%d")
                    :format(signature, cached._versionBits, opts.versionBits), 2)
            end
        end
        return cached
    end

    local cap = tointeger(capacity)
    assert(cap and cap > 0, "HandleId.new: capacity 必须为正整数")

    local signBits = (opts and opts.signBits) or DEFAULT_SIGN_BITS
    assert(signBits > 0 and signBits < TOTAL_BITS, "HandleId.new: signBits 参数非法")

    local indexBits = (opts and opts.indexBits) or bitsForMaxInclusive(cap)
    assert(indexBits > 0 and indexBits < TOTAL_BITS, "HandleId.new: indexBits 参数非法")

    local versionBits = (opts and opts.versionBits) or (TOTAL_BITS - signBits - indexBits)
    assert(versionBits and versionBits > 0, "HandleId.new: 位数不足（versionBits 必须 > 0）")

    if signBits + indexBits + versionBits > TOTAL_BITS then
        error(("HandleId.new: 位数总和超出平台整数位数：sign=%d index=%d version=%d total=%d")
            :format(signBits, indexBits, versionBits, TOTAL_BITS), 2)
    end

    -- 注册类型标签（递增编号）
    local signId = registerSignature(signature, signBits)

    -- 位布局：低位(tag) + 中位(index) + 高位(version)
    local signMask = bitMask(signBits)
    if signId > signMask then
        error(("HandleId.new('%s'): signBits=%d 无法容纳 signId=%d")
            :format(signature, signBits, signId), 2)
    end

    local indexMask = bitMask(indexBits)
    local versionMask = bitMask(versionBits)
    local indexShift = signBits
    local versionShift = signBits + indexBits
    local signPacked = signId

    -- state[i]：合并 versions/next 的单整数状态（不预填充，按需增长）
    -- 低位布局：
    --   bit0          : alive 标记（1=占用中，0=空闲）
    --   bit1..indexBits: free-list next 指针（仅空闲时有效，0 表示链尾）
    --   其余高位       : generation/version
    -- 这样 safeDecode/free 只需要 1 次 table 读取即可拿到 alive/version/next。
    local state = {}
    local stateVersionShift = indexBits + 1

    local freeHead = 0
    local nextNew = 1
    local aliveCount = 0

    local function decodeFast(encodedId)
        local tag = encodedId & signMask
        if tag ~= signId then
            return nil
        end

        local index = (encodedId >> indexShift) & indexMask
        if index == 0 or index > cap then
            return nil
        end

        local st = state[index]
        if st == nil or (st & 1) == 0 then
            return nil
        end

        local version = (encodedId >> versionShift) & versionMask
        local curVersion = (st >> stateVersionShift) & versionMask
        if curVersion ~= version then
            return nil
        end

        return index, version
    end

    local self = {
        _signature = signature,
        _capacity = cap,
        _signBits = signBits,
        _indexBits = indexBits,
        _versionBits = versionBits,
        _signId = signId,
    }

    --[[
    pool:alloc() -> encodedId, index, version
        分配一个句柄（优先复用空闲槽位）。
        - encodedId：打包后的整数句柄
        - index/version：用于调试或与外部结构对接
    --]]
    function self:alloc()
        local index = freeHead
        local version
        if index ~= 0 then
            local st = state[index]
            freeHead = (st >> 1) & indexMask
            version = (st >> stateVersionShift) & versionMask
        else
            index = nextNew
            if index > cap then
                error(("HandleId('%s') 槽位已满(capacity=%d)"):format(signature, cap), 2)
            end
            nextNew = index + 1
            version = 0
        end

        aliveCount = aliveCount + 1

        -- 标记为占用中（alive=1），next 指针无意义置 0
        state[index] = (version << stateVersionShift) | 1

        -- 低位固定 signPacked，中位 index，高位 version
        -- alloc 的 index/version 均保证在合法范围内，因此无需再做 & mask。
        local encodedId = signPacked
            | (index << indexShift)
            | (version << versionShift)
        return encodedId, index, version
    end

    --[[
    pool:free(encodedId) -> boolean
        释放句柄：校验 typeTag/index/version 都匹配后，generation++ 并回收到 free-list。
        - 返回 true：释放成功
        - 返回 false：encodedId 非法/不匹配/已释放
    --]]
    function self:free(encodedId)
        local index, version = decodeFast(encodedId)
        if not index then
            return false
        end

        local nextFree = freeHead
        local newVersion = (version + 1) & versionMask
        state[index] = (newVersion << stateVersionShift) | (nextFree << 1) -- alive=0
        freeHead = index
        aliveCount = aliveCount - 1
        return true
    end

    --[[
    pool:alive(encodedId) -> boolean
        判断 encodedId 是否仍然指向“当前存活对象”。
        - 需要 typeTag/index/version 全部匹配才返回 true。
    --]]
    function self:alive(encodedId)
        return decodeFast(encodedId) ~= nil
    end

    --[[
    pool:safeDecode(encodedId) -> index|nil
        安全解码：若 encodedId 合法且仍存活，返回 index，否则返回 nil。
        - 常用于 “encodedId -> 内部数组索引” 的安全映射。
    --]]
    self.safeDecode = decodeFast

    --[[
    pool:verify(encodedId) -> boolean
        仅校验 typeTag 是否属于该池（不校验 index/version 是否存活）。
    --]]
    function self:verify(encodedId)
        return encodedId ~= nil and ((encodedId & signMask) == signId)
    end

    --[[
    pool:tag(encodedId) -> tag(signId)
        提取低位 typeTag（无需校验）。
    --]]
    function self:tag(encodedId)
        return encodedId & signMask
    end

    --[[
    pool:decode(encodedId) -> index, version
        仅解包 index/version（不做校验）。
        - 若需要安全性，请用 safeDecode/alive。
    --]]
    function self:decode(encodedId)
        local index = (encodedId >> indexShift) & indexMask
        local version = (encodedId >> versionShift) & versionMask
        return index, version
    end

    --[[
    pool:encode(index, version) -> encodedId
        把 index/version 打包成 encodedId（不校验是否存活）。
        - 一般仅用于调试或外部数据结构对接。
    --]]
    function self:encode(index, version)
        local rawIndex = assertInt(index, "index")
        local rawVersion = assertInt(version, "version")
        return signPacked
            | ((rawIndex & indexMask) << indexShift)
            | ((rawVersion & versionMask) << versionShift)
    end

    function self:count()
        return aliveCount
    end

    function self:capacity()
        return cap
    end

    function self:config()
        return {
            signature = signature,
            signId = signId,
            totalBits = TOTAL_BITS,
            signBits = signBits,
            indexBits = indexBits,
            versionBits = versionBits,
            capacity = cap,
            indexMask = indexMask,
            versionMask = versionMask,
        }
    end

    poolCache[signature] = self
    return self
end

--[[
HandleId.getSignatureById(signId)->string|nil
    根据 signId 查回 signature（调试接口）。
--]]
function HandleId.getSignatureById(signId)
    return idToSignature[signId]
end

--[[
HandleId.getRegisteredCount()->integer
    获取已注册类型数量（调试接口）。
--]]
function HandleId.getRegisteredCount()
    return nextSignId
end

return HandleId
