#ifndef HC_GetTerrainZ_Used
#define HC_GetTerrainZ_Used

library HCGetTerrainZ

	globals
		private location p = Location( 0.0, 0.0 )
	endglobals

	function XG_GetTerrainZ takes real x, real y returns real
		call MoveLocation(p, x, y)
		return GetLocationZ(p)
	endfunction
		
endlibrary
#endif
