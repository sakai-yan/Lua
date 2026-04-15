#ifndef HC_GetUnitZ_Used
#define HC_GetUnitZ_Used

#include "XueYue\\HcFuncs\\GetTerrainZ.j"
library HCGetUnitZ requires HCGetTerrainZ

	function Xg_GetUnitZ takes unit u returns real

		return GetUnitFlyHeight(u) + XG_GetTerrainZ( GetUnitX(u), GetUnitY(u) )
		
	endfunction

endlibrary


#endif
