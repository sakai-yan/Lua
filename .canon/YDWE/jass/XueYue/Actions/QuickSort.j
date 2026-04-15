<?
do


local code_AscendingOder_int = [=[

function XG_QuickSort_AscendingOrder_int__array_ takes integer left, integer right returns nothing
    local integer temp = 0
    local integer ptrLeft = left + 1
    local integer ptrRight = right
    loop

        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrLeft] >= _array_[left]
            set ptrLeft = ptrLeft + 1
        endloop
        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrRight] <= _array_[left]
            set ptrRight = ptrRight - 1
        endloop

        exitwhen ptrLeft >= ptrRight

        set temp = _array_[ptrLeft]
        set _array_[ptrLeft] = _array_[ptrRight]
        set _array_[ptrRight] = temp

        set ptrLeft = ptrLeft + 1
        set ptrRight = ptrRight - 1
    endloop

    set temp = _array_[left]
    set _array_[left] = _array_[ptrRight]
    set _array_[ptrRight] = temp

    if left < ptrRight - 1 then
        call XG_QuickSort_AscendingOrder_int__array_( left, ptrRight - 1 )
    endif

    if ptrLeft < right then
        call XG_QuickSort_AscendingOrder_int__array_( ptrLeft, right )
    endif

endfunction


]=]
local code_DescendingOder_int = [=[

function XG_QuickSort_DescendingOrder_int__array_ takes integer left, integer right returns nothing
    local integer temp = 0
    local integer ptrLeft = left + 1
    local integer ptrRight = right
    loop

        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrLeft] < _array_[left]
            set ptrLeft = ptrLeft + 1
        endloop
        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrRight] > _array_[left]
            set ptrRight = ptrRight - 1
        endloop

        exitwhen ptrLeft >= ptrRight

        set temp = _array_[ptrLeft]
        set _array_[ptrLeft] = _array_[ptrRight]
        set _array_[ptrRight] = temp

        set ptrLeft = ptrLeft + 1
        set ptrRight = ptrRight - 1
    endloop

    set temp = _array_[left]
    set _array_[left] = _array_[ptrRight]
    set _array_[ptrRight] = temp

    if left < ptrRight - 1 then
        call XG_QuickSort_DescendingOrder_int__array_( left, ptrRight - 1 )
    endif

    if ptrLeft < right then
        call XG_QuickSort_DescendingOrder_int__array_( ptrLeft, right )
    endif
endfunction

]=]

local code_AscendingOder_real = [==[

function XG_QuickSort_AscendingOrder_real__array_ takes integer left, integer right returns nothing
    local real temp = 0
    local integer ptrLeft = left + 1
    local integer ptrRight = right
    loop

        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrLeft] >= _array_[left]
            set ptrLeft = ptrLeft + 1
        endloop
        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrRight] <= _array_[left]
            set ptrRight = ptrRight - 1
        endloop

        exitwhen ptrLeft >= ptrRight

        set temp = _array_[ptrLeft]
        set _array_[ptrLeft] = _array_[ptrRight]
        set _array_[ptrRight] = temp

        set ptrLeft = ptrLeft + 1
        set ptrRight = ptrRight - 1
    endloop

    set temp = _array_[left]
    set _array_[left] = _array_[ptrRight]
    set _array_[ptrRight] = temp

    if left < ptrRight - 1 then
        call XG_QuickSort_AscendingOrder_real__array_( left, ptrRight - 1 )
    endif

    if ptrLeft < right then
        call XG_QuickSort_AscendingOrder_real__array_( ptrLeft, right )
    endif

endfunction

]==]

local code_DescendingOder_real = [==[

function XG_QuickSort_DescendingOrder_real__array_ takes integer left, integer right returns nothing
    local real temp = 0
    local integer ptrLeft = left + 1
    local integer ptrRight = right
    loop

        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrLeft] < _array_[left]
            set ptrLeft = ptrLeft + 1
        endloop
        loop
            exitwhen ptrLeft > ptrRight or _array_[ptrRight] > _array_[left]
            set ptrRight = ptrRight - 1
        endloop

        exitwhen ptrLeft >= ptrRight

        set temp = _array_[ptrLeft]
        set _array_[ptrLeft] = _array_[ptrRight]
        set _array_[ptrRight] = temp

        set ptrLeft = ptrLeft + 1
        set ptrRight = ptrRight - 1
    endloop

    set temp = _array_[left]
    set _array_[left] = _array_[ptrRight]
    set _array_[ptrRight] = temp

    if left < ptrRight - 1 then
        call XG_QuickSort_DescendingOrder_real__array_( left, ptrRight - 1 )
    endif

    if ptrLeft < right then
        call XG_QuickSort_DescendingOrder_real__array_( ptrLeft, right )
    endif

endfunction

]==]


local map = {}
local code = {
    AscendingOrder_int = code_AscendingOder_int,
    DescendingOrder_int = code_DescendingOder_int,
    AscendingOrder_real = code_AscendingOder_real,
    DescendingOrder_real = code_DescendingOder_real
}

local jassLine = __JASS__ or __jass_result__

-- 数组、排序方式、变量类型
-- XG_QuickSort_Lua( 'udg_array', 'AscendingOrder', 'int' )
-- XG_QuickSort_Lua( 'udg_array', 'DescendingOrder', 'int' )
-- XG_QuickSort_Lua( 'udg_array', 'AscendingOrder', 'real' )
-- XG_QuickSort_Lua( 'udg_array', 'DescendingOrder', 'real' )
XG_QuickSort_Lua = function( in_array, in_order, in_varType )

    assert(in_array, 'XG_QuickSort_Lua: in_array is nil')
    assert(in_order, 'XG_QuickSort_Lua: in_order is nil')
    assert(in_varType, 'XG_QuickSort_Lua: in_varType is nil')

    local s = in_array:match('^%s*(.-)%s*%[') --去除索引
    if  s then
        -- 从T 传入的变量名带索引
        -- udg_array[1]
        in_array = s
    end

    local key = ('%s_%s_%s'):format( in_order , in_varType, in_array)

    assert( code[ in_order .. '_' .. in_varType ], 'XG_QuickSort_Lua: paramsInvalid')

    local newFunctionName = map[ key ]
    if newFunctionName then
        return newFunctionName
    end

    newFunctionName = "XG_QuickSort_" .. key
    map[ key ] = newFunctionName
    assert( jassLine, 'XG_QuickSort_Lua: jassLine is nil')

    for _i, jass in ipairs(jassLine) do
        local start1, end1 = jass:find( '\n+%s*endglobals%s*\r*\n' )
        if start1 then
            jass = jass:sub( 1, end1 ) .. code[ in_order .. '_' .. in_varType ]:gsub( '_array_', in_array ) .. jass:sub( end1 )
            jassLine[ _i ] = jass
            break
        end
    end -- for jass

    return newFunctionName
end --func


end

?>
