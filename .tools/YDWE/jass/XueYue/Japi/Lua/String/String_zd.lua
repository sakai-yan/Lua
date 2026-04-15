local XGJAPI = XGJAPI
function Xg_String_zd(all, l, r)
	local _,l2 = all:find( l, 1, true )
	if not l2 then return "" end

	local r1,_ = all:find( r, l2+1, true )
	if not r1 then return "" end

	return all:sub( l2+1, r1-1 )
end
function Xg_StringReplace_zd(all, l, r, str)
	local _,l2 = all:find( l, 1, true )
	if not l2 then return "" end

	local r1,_ = all:find( r, l2+1, true )
	if not r1 then return "" end

	return all:sub( 1, l2 ) .. str .. all:sub(r1)
end
Xfunc['Xg_String_zd']=function ()

    XGJAPI.string[0] = Xg_String_zd(
		XGJAPI.string[1] or '',
		XGJAPI.string[2] or '',
		XGJAPI.string[3] or '')
	or ""
end
Xfunc['Xg_StringReplace_zd']=function ()
    XGJAPI.string[0] = Xg_StringReplace_zd(
		XGJAPI.string[1] or '',
		XGJAPI.string[2] or '',
		XGJAPI.string[3] or '',
		XGJAPI.string[4] or '')
	or ""
end
