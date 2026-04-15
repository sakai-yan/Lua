--[[============================================================================
    IDGenerator - 魔兽争霸3四字符ID生成器
    
    模块说明:
    --------
    本模块用于生成魔兽争霸3中使用的四字符标识符（rawcode）。
    魔兽争霸3使用四字符ID来唯一标识单位、技能、物品、Buff等游戏对象。
    每个四字符ID实际上是一个32位整数（每个字符占8位）。
    
    字符集:
    ------
    使用62个合法字符: 0-9, A-Z, a-z
    
    设计特点:
    --------
    1. 支持0-3个字符的自定义前缀，剩余位数自动生成
    2. 全局唯一性保证 - 所有生成器共享同一个已用ID池
    3. 生成器缓存 - 相同前缀的生成器只创建一次
    4. 按需生成 - 调用生成器函数时才分配ID
    
    容量说明:
    --------
    根据前缀长度，每个生成器可生成的ID数量不同：
    - 0个前缀字符: 62^4 = 14,776,336 个ID
    - 1个前缀字符: 62^3 = 238,328 个ID
    - 2个前缀字符: 62^2 = 3,844 个ID
    - 3个前缀字符: 62^1 = 62 个ID
    
    使用示例:
    --------
    ```lua
    local IDGenerator = require "GameSettings.IDGenerator"
    
    -- 创建一个以"AB"为前缀的ID生成器
    local unitIDGen = IDGenerator.create("A", "B")
    
    -- 生成ID（返回整数形式的rawcode）
    local id1 = unitIDGen()  -- 例如返回 1094795585 (对应"AB00")
    local id2 = unitIDGen()  -- 例如返回 1094795586 (对应"AB01")
    
    -- 不同类型对象使用不同前缀，便于管理
    local abilityIDGen = IDGenerator.create("S", "K")  -- 技能ID以"SK"开头
    local buffIDGen = IDGenerator.create("B", "F")     -- Buff ID以"BF"开头
    local itemIDGen = IDGenerator.create("I", "T")     -- 物品ID以"IT"开头
    ```
    
    注意事项:
    --------
    1. 只能使用合法字符(0-9, A-Z, a-z)作为前缀，否则会抛出错误
    2. 前缀最多3个字符，超出部分会被忽略
    3. 当某个前缀的ID耗尽时，生成器返回nil
    4. 生成的ID是整数形式，可使用 Tool.Id2S() 转换为字符串形式
    
    版本: 1.0
============================================================================]]--

local Tool = require "Lib.API.Tool"

---@class IDGenerator
---@field used table<integer, boolean> 全局已使用的ID集合，用于保证唯一性
---@field generators table<string, function> 已创建的生成器缓存，键为前缀字符串
---@field chars string 合法字符集，包含62个字符(0-9, A-Z, a-z)
---@field charCount integer 字符集大小，固定为62
local IDGenerator = {
    used = {},          -- 存储所有已分配的ID，防止重复
    generators = {},    -- 缓存已创建的生成器，避免重复创建
    chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
    charCount = 62      -- 字符集大小
}

--[[------------------------------------------------------------------------
    创建一个ID生成器
    
    根据指定的前缀字符创建一个唯一的ID生成器函数。
    前缀字符用于区分不同类型的对象（如单位、技能、物品等）。
    
    参数:
        ... (string) - 0到3个单字符参数，作为ID的前缀
                       每个字符必须是合法字符(0-9, A-Z, a-z)
    
    返回值:
        function - ID生成器函数，每次调用返回一个新的唯一ID(integer)
                   当ID耗尽时返回nil
    
    示例:
        -- 创建不同用途的生成器
        local heroGen = IDGenerator.create("H")      -- 英雄ID: H000, H001, ...
        local skillGen = IDGenerator.create("A", "B") -- 技能ID: AB00, AB01, ...
        local buffGen = IDGenerator.create("B", "U", "F") -- BuffID: BUF0, BUF1, ...
        
        -- 使用生成器
        local heroID = heroGen()   -- 获取一个英雄ID
        local skillID = skillGen() -- 获取一个技能ID
    
    错误:
        当传入非法字符时抛出错误
------------------------------------------------------------------------]]--
---@param ... string 0-3个前缀字符
---@return fun():integer|nil 返回一个生成器函数，调用该函数可获取新ID
function IDGenerator.create(...)
    local args = {...}
    local prefix = ""
    
    -- 验证并拼接前缀字符（最多取前3个）
    for i = 1, math.min(3, #args) do
        local char = args[i]
        -- 检查字符是否在合法字符集中
        if not string.find(IDGenerator.chars, char, 1, true) then
            error("Invalid character: " .. char .. " (只允许使用0-9, A-Z, a-z)")
        end
        prefix = prefix .. char
    end
    
    -- 如果已经存在相同前缀的生成器，直接返回（单例模式）
    if IDGenerator.generators[prefix] then
        return IDGenerator.generators[prefix]
    end
    
    -- 计算后缀长度和最大可生成数量
    local suffixLen = 4 - #prefix           -- 后缀长度 = 4 - 前缀长度
    local maxCount = IDGenerator.charCount ^ suffixLen  -- 最大ID数量 = 62^后缀长度
    local count = 0                         -- 当前已尝试的计数
    
    --[[
        生成器函数（闭包）
        
        工作原理:
        1. 将计数器count转换为62进制表示
        2. 拼接前缀和62进制后缀形成4字符字符串
        3. 将4字符字符串转换为32位整数
        4. 检查ID是否已被使用，如已使用则尝试下一个
        5. 标记ID为已使用并返回
        
        返回值:
            integer - 生成的唯一ID（32位整数形式）
            nil - 当所有可能的ID都已耗尽时
    ]]--
    local generator = function()
        -- 检查是否已耗尽所有可能的ID
        if count >= maxCount then return nil end
        
        local id
        repeat
            local n = count
            local str = prefix
            
            -- 将计数n转换为62进制，生成后缀字符
            for i = 1, suffixLen do
                local idx = (n % IDGenerator.charCount) + 1  -- Lua索引从1开始
                str = str .. string.sub(IDGenerator.chars, idx, idx)
                n = math.floor(n / IDGenerator.charCount)
            end
            
            -- 将4字符字符串转换为32位整数（每个字符8位）
            -- 例如: "AB00" -> 'A'*256^3 + 'B'*256^2 + '0'*256 + '0'
            local num = 0
            for i = 1, 4 do
                num = num * 256 + string.byte(str, i)
            end
            
            id = num
            count = count + 1
        until not IDGenerator.used[id] or count >= maxCount  -- 跳过已使用的ID
        
        -- 成功生成新ID
        if count <= maxCount then
            IDGenerator.used[id] = true  -- 标记为已使用
            return id
        end
        
        return nil  -- ID已耗尽
    end
    
    -- 缓存生成器以便复用
    IDGenerator.generators[prefix] = generator
    return generator
end



--[[============================================================================
    调试模式下的单元测试
    
    当 __DEBUG__ 全局变量为真时执行以下测试用例，验证IDGenerator的各项功能：
    
    测试项目:
    ---------
    1. 相同前缀返回相同函数（单例模式验证）
    2. 不同前缀返回不同函数
    3. 生成ID的唯一性
    4. 不同生成器生成全局唯一ID
    5. 参数数量测试（0-3个参数）
    6. 无效字符处理
    7. 生成器容量测试
    8. 函数状态保持
============================================================================]]--
if __DEBUG__ then
    print("=== ID生成器测试开始 ===")
    print()
    
    -- 重置状态以确保测试的独立性
    IDGenerator.used = {}
    IDGenerator.generators = {}
    
    -- 测试1: 相同前缀返回相同函数
    print("测试1: 相同前缀返回相同函数")
    local gen1 = IDGenerator.create("A", "B")
    local gen2 = IDGenerator.create("A", "B")
    
    if gen1 == gen2 then
        print("✓ 通过: 相同前缀返回了相同的函数实例")
    else
        print("✗ 失败: 相同前缀返回了不同的函数实例")
    end
    print()
    
    -- 测试2: 不同前缀返回不同函数
    print("测试2: 不同前缀返回不同函数")
    local gen3 = IDGenerator.create("X", "Y")
    
    if gen1 ~= gen3 then
        print("✓ 通过: 不同前缀返回了不同的函数实例")
    else
        print("✗ 失败: 不同前缀返回了相同的函数实例")
    end
    print()
    
    -- 测试3: 生成ID的唯一性
    print("测试3: 生成ID的唯一性")
    local seenIDs = {}
    local duplicateFound = false
    
    for i = 1, 10 do
        local id = gen1()
        if id then
            if seenIDs[id] then
                duplicateFound = true
                print("✗ 发现重复ID: " .. id)
            else
                seenIDs[id] = true
                print("  生成ID " .. i .. ": " .. id, Tool.Id2S(id))
            end
        else
            print("  无法生成更多ID")
            break
        end
    end
    
    if not duplicateFound then
        print("✓ 通过: 所有生成的ID都是唯一的")
    else
        print("✗ 失败: 发现了重复的ID")
    end
    print()
    
    -- 测试4: 不同生成器生成全局唯一ID
    print("测试4: 不同生成器生成全局唯一ID")
    local gen4 = IDGenerator.create("C", "D")
    local idFromGen1 = gen1()
    local idFromGen4 = gen4()
    
    if idFromGen1 and idFromGen4 and idFromGen1 ~= idFromGen4 then
        print("✓ 通过: 不同生成器生成的ID是全局唯一的")
        print("  gen1生成的ID: " .. idFromGen1)
        print("  gen4生成的ID: " .. idFromGen4)
    else
        print("✗ 失败: 不同生成器生成了相同的ID或无法生成ID")
    end
    print()
    
    -- 测试5: 参数数量测试 (0-3个参数)
    print("测试5: 参数数量测试")
    
    -- 0个参数
    local gen0 = IDGenerator.create()
    local id0 = gen0()
    if id0 then
        print("✓ 通过: 0个参数生成器正常工作，ID: " .. id0)
    else
        print("✗ 失败: 0个参数生成器无法生成ID")
    end
    
    -- 1个参数
    local gen1param = IDGenerator.create("Z")
    local id1 = gen1param()
    if id1 then
        print("✓ 通过: 1个参数生成器正常工作，ID: " .. id1)
    else
        print("✗ 失败: 1个参数生成器无法生成ID")
    end
    
    -- 2个参数
    local gen2param = IDGenerator.create("M", "N")
    local id2 = gen2param()
    if id2 then
        print("✓ 通过: 2个参数生成器正常工作，ID: " .. id2)
    else
        print("✗ 失败: 2个参数生成器无法生成ID")
    end
    
    -- 3个参数
    local gen3param = IDGenerator.create("P", "Q", "R")
    local id3 = gen3param()
    if id3 then
        print("✓ 通过: 3个参数生成器正常工作，ID: " .. id3)
    else
        print("✗ 失败: 3个参数生成器无法生成ID")
    end
    print()
    
    -- 测试6: 无效字符处理
    print("测试6: 无效字符处理")
    local success, err = pcall(IDGenerator.create, "!", "A")
    if not success then
        print("✓ 通过: 无效字符被正确检测并抛出错误: " .. err)
    else
        print("✗ 失败: 无效字符未被检测到")
    end
    print()
    
    -- 测试7: 生成器容量测试
    print("测试7: 生成器容量测试")
    local limitedGen = IDGenerator.create("1", "2", "3") -- 前缀长度为3，只能生成62个ID
    local capacityCount = 0
    
    while true do
        local id = limitedGen()
        if id then
            capacityCount = capacityCount + 1
        else
            break
        end
        
        -- 防止无限循环，设置安全上限
        if capacityCount > 100 then
            break
        end
    end
    
    if capacityCount == 62 then
        print("✓ 通过: 3参数生成器正确生成了62个ID")
    else
        print("✗ 失败: 3参数生成器生成了 " .. capacityCount .. " 个ID，预期是62个")
    end
    print()
    
    -- 测试8: 函数状态保持
    print("测试8: 函数状态保持")
    local stateGen = IDGenerator.create("S", "T")
    local firstID = stateGen()
    local secondID = stateGen()
    
    if firstID and secondID and firstID ~= secondID then
        print("✓ 通过: 生成器正确保持了状态")
        print("  第一次调用: " .. firstID)
        print("  第二次调用: " .. secondID)
    else
        print("✗ 失败: 生成器状态保持不正确")
    end
    print()
    
    print("=== ID生成器测试结束 ===")

end

--[[------------------------------------------------------------------------
    导出模块
    
    使用方式:
        local IDGenerator = require "GameSettings.IDGenerator"
        local gen = IDGenerator.create("A", "B")
        local id = gen()
------------------------------------------------------------------------]]--
return IDGenerator