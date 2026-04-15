#ifndef XG_DisplayLocalMultiBoardIncluded
#define XG_DisplayLocalMultiBoardIncluded

#include "XueYue\SystemLibs\LocalMutiBoard\LocalMultiBoard.j"
library DisplayLocalMultiBoard requires XGLocalMultiBoard
	function XG_DisplayLocalMultiBoard takes integer i, boolean show returns nothing
		local multiboard b=null
		if Player(XGLocalMultiBoard_Ownner[i]) == GetLocalPlayer() then
		  set b=XGLocalMultiBoard_Board[i]
		endif
  	call MultiboardDisplay(b,show)
	set b=null
	endfunction
endlibrary

#endif
