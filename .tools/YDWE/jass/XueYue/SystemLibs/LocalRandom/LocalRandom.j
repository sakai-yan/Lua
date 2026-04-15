#ifndef INCLUDED_XGLocalRandom
#define INCLUDED_XGLocalRandom

library XGLocalRandom
    globals
        //随机数种子
        private integer seed = 0
        //时间种子
        private integer tseed = 0
    endglobals
    //异步获取随机整数
    function XGLocalRandom_GetInt takes integer i, integer j returns integer
        local integer t
        if i > j then
            set t = i
            set i = j
            set j = t
        endif
        set seed = ModuloInteger ( (16807 * (seed*1+1) + tseed*2 ) , 214748 )
        return ModuloInteger( seed , (j - i + 1) ) + i
    endfunction
    //异步获取随机实数
    function XGLocalRandom_GetReal takes real i, real j returns real
        local real ret
        if i > j then
            set ret = i
            set i = j
            set j = ret
        endif

        set seed = ModuloInteger ( (16807 * (seed*1+1) + tseed*2 ) , 214748 )
        set ret = ModuloInteger( seed , R2I(j - i + 1.0) ) + i
        
        if ret >= i and ret < j then
            return ret + XGLocalRandom_GetInt(1, 100) * 0.01
        endif

        return ret
    endfunction
    //异步设置时间种子
    function XGLocalRandom_SetTimeSeed takes integer i returns nothing
        set tseed = i
    endfunction
    //异步设置种子
    function XGLocalRandom_SetSeed takes integer i returns nothing
        set seed = i
    endfunction
endlibrary

#endif
