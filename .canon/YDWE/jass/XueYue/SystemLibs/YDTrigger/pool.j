#ifndef INCLUDED_XGYDTriggerLocalVariablePool
#define INCLUDED_XGYDTriggerLocalVariablePool

library XGYDTriggerLocalVariablePool
    //声明一个索引池,一个申请函数，一个释放函数
    globals
        private integer array g_YDTrigger_IndexPool
        //当前索引存货量
        //正常的空闲时间 它应该等于index
        //如果很长一段连续时间内不成立，并且你没有等待动作，很有可能发生奇怪的bug了
        //比如申请了但是没有释放，所以请检查你的代码逻辑
        private integer g_YDTrigger_IndexPool_Size = 0
        //当前索引池索引【当前已使用的索引数量】
        private integer g_YDTrigger_IndexPool_Index = 0
        integer XG_YDTrigger_StackIdx = 0
    endglobals

    //申请函数：申请一个索引，如果索引池为空，新建一个索引，否则返回最后一个可用索引
    function XG_YDLocalIndex_Alloc takes nothing returns integer
        local integer index

        if g_YDTrigger_IndexPool_Size == 0 then
            //如果索引池为空，新建一个索引
            set g_YDTrigger_IndexPool_Index = g_YDTrigger_IndexPool_Index + 1
            set g_YDTrigger_IndexPool[g_YDTrigger_IndexPool_Index] = g_YDTrigger_IndexPool_Index
            set index = g_YDTrigger_IndexPool_Index //省一层嵌套的效率，反正 array[index] = index
        else
            //如果索引池不为空，返回最后一个可用索引
            set index = g_YDTrigger_IndexPool[g_YDTrigger_IndexPool_Size]
            set g_YDTrigger_IndexPool_Size = g_YDTrigger_IndexPool_Size - 1
        endif
        //call BJDebugMsg( "申请idx："+I2S(index) )
        set XG_YDTrigger_StackIdx = XG_YDTrigger_StackIdx + 1
        return index
    endfunction

    //释放函数：释放一个索引，将索引放入索引池
    //注意：为了提高效率将不判断传入的索引，释放的索引必须由Alloc函数申请，且请勿重复释放，否则将会出错、污染池子
    function XG_YDLocalIndex_Release takes integer index returns nothing
        set g_YDTrigger_IndexPool_Size = g_YDTrigger_IndexPool_Size + 1

        set g_YDTrigger_IndexPool[g_YDTrigger_IndexPool_Size] = index
        set XG_YDTrigger_StackIdx = XG_YDTrigger_StackIdx - 1
    endfunction

    function XG_YDLocalIndex_Debug takes nothing returns nothing
        call BJDebugMsg( "最大元素数量 = " + I2S(g_YDTrigger_IndexPool_Index) )
        call BJDebugMsg( "剩余元素数量 = " + I2S(g_YDTrigger_IndexPool_Size) )
    endfunction

endlibrary

#endif
