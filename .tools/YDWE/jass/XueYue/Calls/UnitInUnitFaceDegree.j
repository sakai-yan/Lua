#ifndef HcUnitInUnitFaceDegreeIncluded
#define HcUnitInUnitFaceDegreeIncluded

library XGUnitInUnitFaceDegree
	// 单位在 指定单位面向的 a -> b 度之间
	function XG_UnitInUnitFaceDegree takes unit ue, unit us, real a, real b returns boolean
		local real r = bj_RADTODEG * Atan2(GetUnitY(us) - GetUnitY(ue), GetUnitX(us) - GetUnitX(ue))
		local real f = GetUnitFacing(us)
		if f > 180 then
		  set f =f-360
		endif
		return r <= f+a and r >= f-b
	endfunction

endlibrary

#endif
