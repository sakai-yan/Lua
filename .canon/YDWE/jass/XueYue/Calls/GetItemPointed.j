#ifndef HcXGGetItemPointedIncluded
#define HcXGGetItemPointedIncluded
#include "DzAPI.j"
#include "XueYue\Base.j"
library XGGetItemPointed requires BzAPI,XGbase

        #define XG_ItPointed 659453611
    function XG_GetItemPointed takes nothing returns item
        call FlushChildHashtable( Xg_htb, XG_ItPointed )
        call SaveFogStateHandle( Xg_htb, XG_ItPointed, 1, ConvertFogState(GetHandleId(DzGetUnitUnderMouse())) )
        return LoadItemHandle( Xg_htb, XG_ItPointed, 1)
    endfunction
        #undef XG_ItPointed
endlibrary
#endif
