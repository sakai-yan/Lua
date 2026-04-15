$ifdef XG_JAPI
    $include "XueYue\\Japi\\GeneralBounsSystem.j"
$else
#ifndef XGGeneralBonusSystemIncluded
#define XGGeneralBonusSystemIncluded


//===========================================================================
//  雪月万能属性系统
//===========================================================================
#include "XueYue\\Base.j"
$include "XueYue\\SystemLibs\\GarbageCollect\\init.j"
library XGGeneralBonusSystem initializer Initialize uses userdataGC

globals
    private hashtable htb = InitHashtable()
    private integer array ABILITY_COUNT
    private integer array ABILITY_NUM
    private integer array BonusAbilitys
    private integer array PowersOf2
    private integer array MaxBonus
    private integer array MinBonus
endglobals

//以下函数仅仅是让技能ID出现在代码里，不然SLK优化器会删除这些技能
private function DisplayAllAbilityId takes nothing returns nothing
    local integer aid=0
    <?

local idx = {
'0','1','2','3','4','5','6','7','8','9',
'a','b','c','d','e','f','g',
'h','i','j','k','l','m','n',
'o','p','q','r','s','t','u',
'v','w','x','y','z'
}
local slk = require 'slk'
local ss={}
for i = 1, 24 do
	local o = slk.ability.AId2:new('XGc'..idx[i])--护甲
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 Arm'
	o.DataA1 = v
	table.insert(ss,'XGc'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AItg:new('XGd'..idx[i])--攻击
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 Atk'
	o.DataA1 = v
	table.insert(ss,'XGd'..idx[i])
end
for i = 1, 12 do
	local o = slk.ability.AIs2:new('XGe'..idx[i])--攻速
	local v = 2^(i-1)*0.01
	if i == 12 then
		v = -v
	end
	o.Name = '雪月万能属性 AtS'
	o.DataA1 = v
	table.insert(ss,'XGe'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.Arel:new('XGf'..idx[i])--回血
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 LfB'
	o.DataA1 = v
	table.insert(ss,'XGf'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AIrm:new('XGg'..idx[i])--回蓝
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 MaB'
	o.DataA1 = v
	table.insert(ss,'XGg'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AIs1:new('XGh'..idx[i])--力量
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 Str'
	o.DataC1 = v
	table.insert(ss,'XGh'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AIa1:new('XGi'..idx[i])--敏捷
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 Agi'
	o.DataA1 = v
	table.insert(ss,'XGi'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AIi1:new('XGj'..idx[i])--智力
	local v = 2^(i-1)
	if i == 24 then
		v = -v
	end
	o.Name = '雪月万能属性 Int'
	o.DataB1 = v
	table.insert(ss,'XGj'..idx[i])
end
--[[AId2 DataA 护甲
AItg DataA 攻击
AIl1 DataA 血量
AImv DataA 魔法
AIs2 DataA 攻速
Arel DataA 回血
AIrm DataA 回魔
]]
for i = 1, 24 do
	local o = slk.ability.AIl1:new('XGa'..idx[i])--生命
	local v = 2^(i-1)
	o.Name = '雪月万能属性 Life'
	o.levels = 3
	o.DataA1 = 0
	o.DataA2 = v
	o.DataA3 = -v
	table.insert(ss,'XGa'..idx[i])
end
for i = 1, 24 do
	local o = slk.ability.AImv:new('XGb'..idx[i])--法力
	local v = 2^(i-1)
	o.Name = '雪月万能属性 Mana'
	o.levels = 3
	o.DataA1 = 0
	o.DataA2 = v
	o.DataA3 = -v
	table.insert(ss,'XGb'..idx[i])
end
 for i=1,#ss do
 ?><?="set aid='"..ss[i].."'\n"?>
<?
 end
?>
endfunction
private function gc_unit_callback takes nothing returns nothing
    local unit u = GetGCunit()
    call FlushChildHashtable( htb, GetHandleId(u) )
    set u = null
endfunction
function XG_UnitGetBonus takes unit u, integer bonusType returns integer
   return LoadInteger(htb,GetHandleId(u),bonusType)
endfunction
private function SetUnitState takes unit u,unitstate t,integer x,integer n returns nothing
    local integer hid = GetHandleId(u)
    local integer num = n-LoadInteger(htb, hid,x)
    local integer v = 2
    local integer aid
    local integer i=1
    if num > 0 then
       set v = 3
    endif
    loop
       if num == 0 then
          call SaveInteger(htb, hid,x,n)
          if n == 0 then
             call SaveBoolean(htb, hid,0,false)
          endif
          exitwhen true
       elseif num > 0 then
         set aid = ABILITY_COUNT[x]+1-i
         if num < PowersOf2[aid] then
           set i = i + 1
         else
           set num=num-PowersOf2[aid]
          // call BJDebugMsg("雪月万能属性: "+I2S(aid)+" 增加 " + I2S(PowersOf2[aid]) + " 生命")
           set aid = BonusAbilitys[aid]
           call UnitAddAbility(u, aid)
           call SetUnitAbilityLevel(u,aid,v)
           call UnitRemoveAbility(u,aid)
           
         endif
       else
         set aid = ABILITY_COUNT[x]+1-i
         if -num < PowersOf2[aid] then
           set i = i + 1
         else
           set num=num+PowersOf2[aid]
           set aid = BonusAbilitys[aid]
           call UnitAddAbility(u, aid)
           call SetUnitAbilityLevel(u,aid,v)
           call UnitRemoveAbility(u,aid)
         endif
       endif
    endloop
endfunction
private function UnitClearBonus takes unit u,integer y returns nothing
    local integer i = ABILITY_COUNT[y-1]+ABILITY_NUM[y]
    loop
        exitwhen i <= ABILITY_COUNT[y-1]
        call UnitRemoveAbility(u,BonusAbilitys[i])
        set i = i - 1
    endloop
    call SaveInteger(htb, GetHandleId(u), y, 0)
    call SaveBoolean(htb,GetHandleId(u),0,false)
endfunction

function XG_UnitSetBonus takes unit u, integer bonusType, integer ammount returns boolean
    local integer i
    local integer fx = 0
    if bonusType == 1 then //Life
        call SetUnitState(u,UNIT_STATE_MAX_LIFE,bonusType,ammount)
        return true
    elseif bonusType == 2 then //Mana
        call SetUnitState(u,UNIT_STATE_MAX_MANA,bonusType,ammount)
        return true
    elseif bonusType>10 or bonusType<1 then
        debug call BJDebugMsg("雪月万能属性系统: 属性无效 (" + I2S(bonusType) + ")")
        return false
    endif
    //设置属性为0不进行Loop
    if  ammount==0 then
        call UnitClearBonus(u,bonusType)
        return false
    endif
    if ammount < MinBonus[bonusType] or ammount > MaxBonus[bonusType] then
        debug call BJDebugMsg("雪月万能属性系统: 属性值越界 (" + I2S(ammount) + ")")
        return false
    endif

    call SaveInteger(htb, GetHandleId(u), bonusType, ammount)
    if ammount < 0 then
        set ammount = MaxBonus[bonusType] + ammount + 1
        if bonusType != 8 then
            call UnitAddAbility(u, BonusAbilitys[ ABILITY_COUNT[bonusType-1]+ABILITY_NUM[bonusType] ])
            call UnitMakeAbilityPermanent(u, true, BonusAbilitys[ABILITY_COUNT[bonusType-1]+ABILITY_NUM[bonusType]])
        else
            set fx = BonusAbilitys[ ABILITY_COUNT[bonusType-1]+ABILITY_NUM[bonusType] ]
        endif
      else
        call UnitRemoveAbility(u,BonusAbilitys[ABILITY_COUNT[bonusType-1]+ABILITY_NUM[bonusType]])
    endif
    set i = ABILITY_COUNT[bonusType-1]+ABILITY_NUM[bonusType]-1
    loop
        exitwhen i <= ABILITY_COUNT[bonusType-1]
        if ammount >= PowersOf2[i] then
            call UnitAddAbility(u,BonusAbilitys[i])
            call UnitMakeAbilityPermanent(u, true, BonusAbilitys[i])
            set ammount = ammount - PowersOf2[i]
        else
            call UnitRemoveAbility(u,BonusAbilitys[i])
        endif
        set i = i - 1
    endloop

    if not LoadBoolean(htb,GetHandleId(u),0) then
        call SaveBoolean(htb,GetHandleId(u),0,true)
      //  set UnitCount = UnitCount + 1
     //   set Units[UnitCount] = u
    endif
    if fx > 0 then
            call UnitAddAbility(u, fx)
            call UnitMakeAbilityPermanent(u, true, fx)
    endif
    return true
endfunction

function XG_UnitSetBonusEx takes unit u, integer bonusType, integer setMethod, integer ammount returns boolean
    if setMethod == 0 then //设置
        return XG_UnitSetBonus(u, bonusType, ammount)
    elseif setMethod == 1 then //增加
        return XG_UnitSetBonus(u, bonusType, ammount + LoadInteger(htb, GetHandleId(u), bonusType) )
    elseif setMethod == 2 then //减少
        return XG_UnitSetBonus(u, bonusType, LoadInteger(htb, GetHandleId(u), bonusType) - ammount )
    endif
    return false
endfunction

private function Initialize takes nothing returns nothing
    local integer i = 1
    local unit u
    local integer n=1
    local integer add=1
    local integer array c
    call _gc_bind_unit( function gc_unit_callback )
    loop
       set c[i]='0'-1+i
       set i=i+1
       exitwhen i>10
    endloop
    set i=1
    loop
       set c[i+10]='a'-1+i
       set i=i+1
       exitwhen i>26 //26+10
    endloop
    set ABILITY_NUM[1]=24
    set ABILITY_NUM[2]=24
    set ABILITY_NUM[3]=24
    set ABILITY_NUM[4]=24
    set ABILITY_NUM[5]=24
    set ABILITY_NUM[6]=24
    set ABILITY_NUM[7]=12
	set ABILITY_NUM[8]=24
	set ABILITY_NUM[9]=24
	set ABILITY_NUM[10]=24
	
    set ABILITY_COUNT[0]=0
    set ABILITY_COUNT[1]=24
    set ABILITY_COUNT[2]=24*2
    set ABILITY_COUNT[3]=24*3
    set ABILITY_COUNT[4]=24*4
    set ABILITY_COUNT[5]=24*5
    set ABILITY_COUNT[6]=24*6
    set ABILITY_COUNT[7]=24*7
	set ABILITY_COUNT[8]=24*8
	set ABILITY_COUNT[9]=24*9
	set ABILITY_COUNT[10]=24*10
    set i = 1
    loop
       set BonusAbilitys[i+24*0]='XGa0'-'0'+c[i]
       set BonusAbilitys[i+24*1]='XGb0'-'0'+c[i]
       set BonusAbilitys[i+24*2]='XGd0'-'0'+c[i]
       set BonusAbilitys[i+24*3]='XGc0'-'0'+c[i]
       set BonusAbilitys[i+24*4]='XGf0'-'0'+c[i]
       set BonusAbilitys[i+24*5]='XGg0'-'0'+c[i]
	   set BonusAbilitys[i+24*7]='XGh0'-'0'+c[i]
	   set BonusAbilitys[i+24*8]='XGi0'-'0'+c[i]
	   set BonusAbilitys[i+24*9]='XGj0'-'0'+c[i]
       set i=i+1
       exitwhen i>24
    endloop
	
    set i = 1
    loop // 7-1
       set BonusAbilitys[i+24*6]='XGe0'-'0'+c[i]
       set i=i+1
       exitwhen i>12
    endloop
    loop
        set i=1
        set PowersOf2[add] = 1
            loop
                set PowersOf2[add+1] = PowersOf2[add] * 2
                set add=add+1
                set i = i + 1
				if i >= ABILITY_NUM[n] then
					set add = ABILITY_COUNT[n-1]+ABILITY_NUM[n]
					exitwhen true
				endif
            endloop
        set MaxBonus[n] = PowersOf2[add] - 1
        set MinBonus[n] = -PowersOf2[add]
		set add = ABILITY_COUNT[n]+1
        set n=n+1
        exitwhen n>10
    endloop
    //预读技能
        set u = CreateUnit(Player(15), 'hpea', 0, 0, 0)
        set i = 0
        loop
            exitwhen i == ABILITY_COUNT[10]
			if BonusAbilitys[i] != 0 then
				call UnitAddAbility(u, BonusAbilitys[i])
			endif
            set i = i + 1
        endloop
        call RemoveUnit(u)
        set u = null
    //回收数据
    //call TimerStart(CreateTimer(), 10, true, function FlushUnits)
endfunction
endlibrary

#endif
$endif
