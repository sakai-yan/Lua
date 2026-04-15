#ifndef Used_XG_DistanceBetweenCoords
#define Used_XG_DistanceBetweenCoords

library HcDistanceBetweenCoords
    //2坐标之间的距离
    function XG_DistanceBetweenCoords takes real x1, real y1, real x2, real y2 returns real
        set x1 = x1 - x2
        set y1 = y1 - y2
        return SquareRoot(x1*x1 + y1*y1)
    endfunction
endlibrary
#endif
