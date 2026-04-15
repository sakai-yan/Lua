#ifndef SBKK_MISSING_INCLUDED
#define SBKK_MISSING_INCLUDED

//======================
//  修补被SBKK删掉的函数
//======================
library SBKK

    function YDWEDistanceBetweenUnitAndPoint takes unit a, location b returns real
        local real x = GetUnitX(a) - GetLocationX(b)
        local real y = GetUnitY(a) - GetLocationY(b)
        return SquareRoot(x * x + y * y)
    endfunction

    function YDWEAngleBetweenUnitAndPoint takes unit a, location b returns real
        return bj_RADTODEG * Atan2(GetLocationY(b) - GetUnitY(a), GetLocationX(b) - GetUnitX(a))
    endfunction

endlibrary

#endif
