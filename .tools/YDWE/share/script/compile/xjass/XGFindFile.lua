local ffi = require 'ffi'
local stormlib = ffi.load('stormlib')
local uni = require 'ffi.unicode'
function XGFindFile (path,mpq,op,mp,y)    
	local counter = 0
	for p in fs.path(path):list_directory() do
		if fs.is_directory(p) then -- 递归枚举子目录
			counter = counter + XGFindFile(p:string(),mpq,op,mp,y)
		else
			counter = counter + 1
			local wpath = uni.u2w(p:string())
			local s = p:string():sub(mp:len()+2)
			if y:sub(-1)~="\\" then
				if y:len()~=0 then y=y.."\\" end
			end
			
			if stormlib.SFileAddFileEx(mpq.handle, wpath,y..s,
				0x00000200 | 0x80000000, -- MPQ_FILE_COMPRESS | MPQ_FILE_REPLACEEXISTING,
				0x02, -- MPQ_COMPRESSION_ZLIB,
				0x02 --MPQ_COMPRESSION_ZLIB
			) then
				log.trace(p:string(),y..s)
			else
				log.error(p:string(),y..s)
			end
		end
	end
	return counter
end

