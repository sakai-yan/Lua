#ifndef XGR2I_Included
#define XGR2I_Included

/*

制作ing...

*/

library XGR2I

    function XG_GetIntLen takes integer n returns integer
        local integer i = 0
        if n < 0 then
            set n = -n
        endif

        loop
            exitwhen n <= 0
            set n = R2I(n * 0.1)
            set i = i * 10
        endloop

        return i
    endfunction

    //获取精确实数
    function XG_GetRealPrecise takes real r returns integer
        local real rt = r * 1000
        local integer i = R2I(rt)
        //1234.56
        //1234.559994
        //1234559.8750
        if rt - i > 0.001 then
            set i = i + 1
        endif

        return i
    endfunction

    function XG_R2I takes real r returns integer
        local integer i = XG_GetRealPrecise(r)
        return R2I(i * 0.001)
    endfunction

    function XG_R2I_Ceil takes real r returns integer
        local real rt = r * 1000
        local integer i = R2I(rt)
        local integer bit

        if rt - i > 0.0 then
            set i = i + 1000
        elseif i > 100 then
            set i = i + 1000
        endif

        set bit = XG_GetIntLen( i )



        set r = R2I( i*0.001 - R2I(i*0.001) )

        if r > 0.0 then
            set i = i + 1000
        endif

        return R2I(i * 0.001)
    endfunction

    function XG_R2I_Floor takes real r returns integer
        local real rt = r * 1000
        local integer i = R2I(rt)

        if rt - i > 0.0 then
            set i = i + 1000
        elseif i > 100 then
            set i = i + 1000
        endif

        set r = R2I( i*0.001 - R2I(i*0.001) )

        if r > 0.0 then
            set i = i - 1000
        endif

        return R2I(i * 0.001)
    endfunction
    
endlibrary

#endif

