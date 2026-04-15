#ifndef ItemsFormulaIncluded
#define ItemsFormulaIncluded

#include "XueYue\\Base.j"

library XGItemsFormula initializer Init
    globals
        private array integer part
        private integer partSize = 0
        private hashtable htb = InitHashtable()
    endglobals


    //双端快速排序 使用双指针 对part进行排序 降序
    private function QuickSort takes integer left, integer right returns nothing
        local integer Pivot = part[left]
        local integer ptrLeft = left
        local integer ptrRight = right

        loop
            //从右往左找
            exitwhen ptrLeft >= ptrRight
            if part[ptrRight] > Pivot then
                set part[ptrLeft] = part[ptrRight]
                set Pivot = part[ptrLeft]
                set ptrLeft = ptrLeft + 1
            endif
            set ptrRight = ptrRight - 1
        endloop

        loop
            //从左往右找
            exitwhen ptrLeft >= ptrRight
            if part[ptrLeft] < Pivot then
                set part[ptrRight] = part[ptrLeft]
                set Pivot = part[ptrRight]
                set ptrRight = ptrRight - 1
            endif
            set ptrLeft = ptrLeft + 1
        endloop

        set part[ptrLeft] = Pivot

        if left < ptrLeft - 1 then
            call QuickSort(left, ptrLeft - 1)
        endif

        if ptrRight + 1 < right then
            call QuickSort(ptrRight + 1, right)
        endif
    endfunction
    //为第一个物品配件绑定公式
    //获得物品时对物品栏进行排序，通过首个节点的物品类型来获得公式，减少公式遍历次数
    // part[1-6] 为合成配件，part[7]为最终合成物品

    private function allocNode takes nothing returns nothing
        local integer node = LoadInteger(htb, part[1], 0)
        if node == 0 then
            set node = CreateNodetree()
            call SaveInteger(htb, part[1], 0, node)
        endif
        
        
    endfunction


    endfunction

    private function alloc takes nothing returns nothing
        


    endfunction

    
    
    // call NewItemsFormula('rat6', 6, 'rat9', 5, 'ratc', 4, 'rde1', 3, 'rde2', 2, 'rde3', 1, 'mcou')
    function XG_NewItemsFormula takes integer type1, integer n1, integer type2, integer n2, integer type3, integer n3, /*
    */  integer type4, integer n4, integer type5, integer n5, integer type6, integer n6, integer eventually returns nothing
        local integer i = 0
        if n1 > 0 then
            set i = i + 1
            set part[i] = type1
        endif
        if n2 > 0 then
            set i = i + 1
            set part[i] = type2
        endif
        if n3 > 0 then
            set i = i + 1
            set part[i] = type3
        endif
        if n4 > 0 then
            set i = i + 1
            set part[i] = type4
        endif
        if n5 > 0 then
            set i = i + 1
            set part[i] = type5
        endif
        if n6 > 0 then
            set i = i + 1
            set part[i] = type6
        endif
        if i < 1 then
            return
        endif
        set part[7] = eventually
        set partSize = i
        call QuickSort(1, i)

        call alloc()

        

    endfunction
    private function Init takes nothing returns nothing
        
    endfunction

endlibrary

#endif /// ItemsFormulaIncluded
