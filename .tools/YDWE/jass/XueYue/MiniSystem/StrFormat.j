<?
Strs={}
function split( str,reps )
    local resultStrList = {}
    string.gsub(str,'[^'..reps..']+',function ( w )
        table.insert(resultStrList,w)
    end)
    return resultStrList
end


--获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

--返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end
--截取中英混合的UTF8字符串，endIndex可缺省
function SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end
function XG_Sub(str,left,right)
	if left > right then
		return ''
	end
	return str:sub(left,right)
end
function XG_StrFormat_Reg_Lua(name,code,f)
  Strs[name]={
			[1]=code,
			[2]=f}
  return 'DoNothing()'
end
function XG_StrFormat_complie(s,a)
	local str,p,m = '',1
	local q,f = '',true
	for i=1,#a do
		m,_=s:find("%s")
		if m==nil then
			break
		end

		if Strs[a[i]][2] then //连接
		return tostring(m)
			if p <= m then
				q=''
			else
				q=XG_Sub(s,p,m)
			end	
			str = str..q..Strs[a[i]][1]..'+'
			s=s:sub(m+2)
		else //格式化
			if p >= m then
				q=''
			else
				q=XG_Sub(s,p,m)
			end	
			str=str..'"'..q..Strs[a[i]][1]..'"'
			s=s:sub(m+2)
		end
		
		a[i]='"'..Strs[a[i]][1]..'"'
		
	end
	return str..s
end
function XG_StrFormat_Do_Lua(s,c)
  local a,b=split(c,","),''
  for i=1,#a do
    if a[i]==nil then
       b='."雪月：参数'.. i ..'错误！"'
       break
    end
  end
  if #a==0 then
     b='."雪月：未传入参数！"'
  end
  return b..XG_StrFormat_complie(s,a)
  --[[return b..'"'..load('return string.format("'..s..'",'..table.concat(a,',')..')')()..'"']]
end

?>
