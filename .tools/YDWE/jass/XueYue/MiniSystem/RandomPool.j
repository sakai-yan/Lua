#ifndef Hc_RandomPool_Used
#define Hc_RandomPool_Used

#include "XueYue\\Define\\RandomPool.cons"
library HcRandomPool
	globals
		private hashtable htb = InitHashtable()
		private integer ID = 0
	endglobals
	function XG_Destroy_RandomPool takes integer p returns nothing
		call FlushChildHashtable(htb, p)
	endfunction
	function XG_GetElementNum_RandomPool takes integer p returns integer
		return LoadInteger(htb, p, RandomPool_ElementCount_ALL)
	endfunction
	//取得元素
	function XG_TakeElement_RandomPool_Ex takes integer p,boolean bTake returns real
		local integer num = LoadInteger(htb, p, RandomPool_ElementCount_ALL)
		local integer ch
		local real val = -1
		local integer f
		local integer normalCount = LoadInteger(htb, p, RandomPool_ElementCount_Normal)
		local integer zeroCount = num - normalCount
		if num < 1 then
			return val //无元素可取出
		endif

		if normalCount > 0 then //比重大于0 剩余
			loop
				//序号
				set ch = GetRandomInt(zeroCount + 1, num)
				//比重
				set f = LoadInteger(htb, p, ch)

				if GetRandomInt(1, 100) <= f then
					set val = LoadReal(htb, p , ch)
					exitwhen true
				endif

			endloop

			if bTake then
				call SaveInteger(htb, p, RandomPool_ElementCount_Normal, normalCount - 1) //重计算 比重大于0的元素 数量
				call SaveReal(htb, p, ch, LoadReal(htb, p, num)) //前移补足
				call SaveInteger(htb, p, ch, LoadInteger( htb, p, num ) )
			endif
		else

			set ch = GetRandomInt(1, zeroCount)
			set val = LoadReal(htb, p , ch)
			if bTake then
				call SaveReal(htb, p, ch, LoadReal(htb, p, zeroCount)) //前移补足
				call SaveInteger(htb, p, ch, LoadInteger( htb, p, zeroCount ) )
				if zeroCount + 1 < num then
					//将零区后面的空位补足
					call SaveReal(htb, p, zeroCount, LoadReal(htb, p, num))
					call SaveInteger(htb, p, zeroCount, LoadInteger( htb, p, num ) )
				endif
			endif
		endif

		if bTake then //True 为取出 、 False 则仅仅获取 不会使该元素离开随机池
			call SaveInteger(htb, p, RandomPool_ElementCount_ALL, num - 1)
		endif

		return val
	endfunction

	//取得特定值元素
	function XG_TakeElement_ByVal takes integer p, real val returns real
		local integer num = LoadInteger(htb, p, RandomPool_ElementCount_ALL)
		local integer ch
		local integer f
		local integer normalCount = LoadInteger(htb, p, RandomPool_ElementCount_Normal)
		local integer zeroCount = num - normalCount

		loop
			//序号
			set ch = GetRandomInt(1, num)
			//比重
			set f = LoadInteger(htb, p, ch)

			if LoadReal(htb, p , ch) == val then

				if f <= 0.00 then //选中元素属于零区
					if ch < zeroCount then //零区前面:将最后一个元素前移
						call SaveReal(htb, p, ch, LoadReal(htb, p, zeroCount))
						call SaveInteger(htb, p, ch, LoadInteger( htb, p, zeroCount ) )
					endif
					//零区最后一个的空位将不再归属零区，将最后一个元素前移补足
					call SaveReal(htb, p, zeroCount, LoadReal(htb, p, num))
					call SaveInteger(htb, p, zeroCount, LoadInteger( htb, p, num ) )

					//set zeroCount = zeroCount - 1
				else
					if ch < normalCount then //比重区前面:将最后一个元素前移
						call SaveReal(htb, p, ch, LoadReal(htb, p, num))
						call SaveInteger(htb, p, ch, LoadInteger( htb, p, num ) )
					endif
				endif

				set num = num - 1
				call SaveInteger(htb, p, RandomPool_ElementCount_ALL, num)
				return val
			endif
		endloop

		return 0.00
	endfunction

	function XG_AddLoopInt_RandomPool takes integer p, integer min, integer max, real f returns nothing
		local integer num = LoadInteger(htb, p, RandomPool_ElementCount_ALL) //起始位置
		local integer normalCount = LoadInteger(htb, p, RandomPool_ElementCount_Normal)
		local integer zeroCount
		local integer x
		local integer n
		if max < min then
			set x = min
			set min = max
			set max = x
		endif

		set n = (max - min + 1) //新增数量

		set x = 1
		if f > 0.0 then
			call SaveInteger(htb, p, RandomPool_ElementCount_Normal, normalCount + n)
			
			loop
				exitwhen x > n

				call SaveReal(htb, p, num + x, I2R(min+x-1))
				call SaveInteger(htb, p, num + x, R2I(f * 100))
				
				set x = x + 1
			endloop
		else
			set zeroCount = num - normalCount
			
			loop
				exitwhen x > n
				//零区后移
				call SaveReal(htb, p, num+x, LoadReal( htb, p, zeroCount+x ) )
				call SaveInteger(htb, p, num+x, LoadInteger( htb, p, zeroCount+x ) )

				call SaveReal(htb, p, zeroCount + x, I2R(min+x-1))
				call SaveInteger(htb, p, zeroCount + x, R2I(f * 100))
				
				set x = x + 1
			endloop
		endif

		call SaveInteger(htb, p, RandomPool_ElementCount_ALL, num + n) //刷新池数量
	endfunction

	function XG_AddElement_RandomPool takes integer p, real val, real f returns nothing
		local integer num = LoadInteger(htb, p, RandomPool_ElementCount_ALL)
		local integer normalCount
		local integer zeroCount

		call SaveInteger(htb, p, RandomPool_ElementCount_ALL, num + 1)
		
		if f > 0.0 then
			call SaveReal(htb, p, num+1, val)
			call SaveInteger(htb, p, num+1, R2I(f * 100))

			call SaveInteger(htb, p, RandomPool_ElementCount_Normal, LoadInteger(htb, p, RandomPool_ElementCount_Normal) + 1)
		else
			set normalCount = LoadInteger(htb, p, RandomPool_ElementCount_Normal)
			set zeroCount = num - normalCount
			//零区后移
			call SaveReal(htb, p, num+1, LoadReal( htb, p, zeroCount+1 ) )
			call SaveInteger(htb, p, num+1, LoadInteger( htb, p, zeroCount+1 ) )

			call SaveReal(htb, p, zeroCount+1, val)
			call SaveInteger(htb, p, zeroCount+1, R2I(f * 100) )
		endif

	endfunction
	function XG_RandomPool_Create takes nothing returns integer
		set ID = ID + 1
		return ID
	endfunction
endlibrary
#endif
