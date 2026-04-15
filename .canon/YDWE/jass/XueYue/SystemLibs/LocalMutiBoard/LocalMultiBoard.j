#ifndef XGLocalMultiBoardIncluded
#define XGLocalMultiBoardIncluded
#include "XueYue\Base.j"
library XGLocalMultiBoard requires XGbase
	globals
		public multiboard	array	Board
		public integer		array	Ownner
		public boolean		array	Display
	endglobals
	function XG_CreateLocalMultiBoard takes integer i, player ply, integer rows, integer cols, string title returns nothing
		local multiboard b = null
		set Board[i] = CreateMultiboard()
		set Ownner[i] = GetPlayerId(ply)
		if ply == GetLocalPlayer() then
			set Display[GetPlayerId(ply)]=true
			set b = Board[i]
		else
			set Display[GetPlayerId(ply)]=false
		endif
		call MultiboardDisplay(b, Display[GetPlayerId(GetLocalPlayer())])
		call MultiboardSetRowCount(Board[i], rows)
		call MultiboardSetColumnCount(Board[i], cols)
		call MultiboardSetTitleText(Board[i], title)
		set b =null
	endfunction
endlibrary
#endif
