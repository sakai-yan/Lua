#ifndef HcPointInPointDegreeIncluded
#define HcPointInPointDegreeIncluded

library XGPointInPointDegree
	// 点在点 的 指定角度内 
	function XG_PointInPointDegree takes location pe, location ps, real f, real a, real b returns boolean
		local real r = bj_RADTODEG * Atan2(GetLocationY(ps) - GetLocationY(pe), GetLocationX(ps) - GetLocationX(pe))
		return (r<=f+a) and (r>=f-b)
	endfunction

endlibrary

#endif
