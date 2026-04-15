#ifndef HcUnitInUnitDegreeIncluded
#define HcUnitInUnitDegreeIncluded

library XGUnitInUnitDegree
    
    // 单位到单位 的 指定角度内
	function XG_UnitInUnitDegree takes unit ue, unit us, real f, real a, real b returns boolean
		local real r = bj_RADTODEG * Atan2(GetUnitY(ue) - GetUnitY(us), GetUnitX(ue) - GetUnitX(us))
        if r < 0 then
            set r = 360 + r
        endif
        if r > 360 then
            set r = r - 360
        endif
		return (r<=f+a) and (r>=f-b)
	endfunction

endlibrary

#endif
