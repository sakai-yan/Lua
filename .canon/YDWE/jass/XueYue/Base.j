#ifndef XGbaseIncluded
#define XGbaseIncluded
/*
#ifndef DZAPIINCLUDE
#define DZAPIINCLUDE
library DzAPI
endlibrary
#endif
*/
#define XGHtbIncluded
library XGbase initializer InitXG
	globals
		hashtable Xg_htb = InitHashtable()
		real array XG_Map_Loc
	endglobals


	function XG_B2I takes boolean b returns integer
        if b then
            return 1
        endif
        return 0
    endfunction

    function XG_IsLower_soft takes string s returns boolean
        return StringCase(s,false) == s
    endfunction

	function InitXG takes nothing returns nothing
		set XG_Map_Loc[1] = GetCameraBoundMinX() - GetCameraMargin(CAMERA_MARGIN_LEFT) //MinX
		set XG_Map_Loc[2] = GetCameraBoundMinY() - GetCameraMargin(CAMERA_MARGIN_BOTTOM) //MinY
		set XG_Map_Loc[3] = GetCameraBoundMaxX() + GetCameraMargin(CAMERA_MARGIN_RIGHT) //MaxX
		set XG_Map_Loc[4] = GetCameraBoundMaxY() + GetCameraMargin(CAMERA_MARGIN_TOP) //MaxY
	endfunction

endlibrary

#endif
