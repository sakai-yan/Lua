#ifndef XGRecipe_included
#define XGRecipe_included

/* 结构
    XGRecipe = {
        [TargetItem] = {
            id, num,
        },
        
    }
*/

library XGRecipe
    globals
        private hashtable htRecipe = InitHashtable()
    endglobals

    function XGRecipe_Add takes integer it1, integer num1, integer it2, integer num2, integer it3, integer num3 \
        integer it4, integer num4, integer it5, integer num5, integer it6, integer num6 returns nothing
        
        
    endfunction



endlibrary
#endif
