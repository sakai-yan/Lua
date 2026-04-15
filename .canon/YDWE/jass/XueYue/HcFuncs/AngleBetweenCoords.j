#ifndef Used_XG_AngleBetweenCoords
#define Used_XG_AngleBetweenCoords

library HcAngleBetweenCoords
//某坐标到某坐标的角度
function XG_AngleBetweenCoords takes real x1, real y1, real x2, real y2 returns real
    return bj_RADTODEG * Atan2(y2 - y1, x2 - x1)
endfunction

endlibrary

#endif
