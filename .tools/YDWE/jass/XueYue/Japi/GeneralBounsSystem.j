#ifndef JAPIXGGeneralBonusSystemIncluded
#define JAPIXGGeneralBonusSystemIncluded

//===========================================================================
//  雪月万能属性系统 Japi优化版
//===========================================================================
#include "japi\\YDWEAbilityState.j"
$include "XueYue\\SystemLibs\\GarbageCollect\\init.j"
library XGGeneralBonusSystem initializer Initialize requires YDWEAbilityState,userdataGC

globals
    private hashtable htb = InitHashtable()
    private integer array BonusAbilitys
    integer array XGGeneralBonusSystem__Data

endglobals

//以下函数仅仅是让技能ID出现在代码里，不然SLK优化器会删除这些技能
private function DisplayAllAbilityId takes nothing returns nothing
    local integer aid=0
    <?
local idx = {
'0','1','2','3','4','5','6','7','8','9',
'a','b','c','d','e','f','g',
'h','i','j','k','l','m','n',
'o','p','q','r','s','t','u'
}
local slk = require 'slk'
local ss={}
data = {}
for i = 1, 1 do
	local o = slk.ability.AId2:new('XGc'..idx[i])--护甲
	local v = 0
	o.Name = '雪月万能属性 护甲'
	o.DataA1 = v
    o.levels = 2
	table.insert(ss,'XGc'..idx[i])
    table.insert(data,108)
end
for i = 1, 1 do
	local o = slk.ability.AItg:new('XGd'..idx[i])--攻击
	local v = 0
	o.Name = '雪月万能属性 攻击'
	o.DataA1 = v
    o.levels = 2
	table.insert(ss,'XGd'..idx[i])
    table.insert(data,108)
end
for i = 1, 1 do
	local o = slk.ability.AIs2:new('XGe'..idx[i])--攻速
	local v = 0 //0.01
	o.Name = '雪月万能属性 攻速'
	o.DataA1 = v
    o.levels = 2
	table.insert(ss,'XGe'..idx[i])
    table.insert(data,108)
end
--[[
for i = 1, 1 do
	local o = slk.ability.AIgx:new('XGf'..idx[i])--回血
	local v = 0
	o.Name = '雪月万能属性 生命恢复'
    o.item = 1
    o.race = "other"
	o.DataA1 = v
    o.DataB1 = 0
    o.Targs1 = "self"
    o.Targs2 = "self"
    o.BuffID1 = ''
    o.BuffID2 = ''
    o.levels = 2
	table.insert(ss,'XGf'..idx[i])
    table.insert(data,108)
end
for i = 1, 1 do
	local o = slk.ability.ANre:new('XGg'..idx[i])--回蓝
	local v = 0
	o.Name = '雪月万能属性 法力恢复'
    o.item = 1
    o.race = "other"
	o.DataA1 = v
    o.DataB1 = 0
    o.Targs1 = "self"
    o.Targs2 = "self"
    o.BuffID1 = ''
    o.BuffID2 = ''
    o.hero = 0
    o.levels = 2
	table.insert(ss,'XGg'..idx[i])
    table.insert(data,108)
end
]]
table.insert(data,108) --占位
table.insert(data,108) --占位
for i = 1, 1 do
	local o = slk.ability.Aamk:new('XGh'..idx[i])--力量
	local v = 0
	o.Name = '雪月万能属性 力量'
    o.hero = 0
    o.item = 1
    o.race = "other"
    o.hero = 0
    o.DataA1 = v
    o.DataA2 = v
    o.DataB1 = v
    o.DataB2 = v
	o.DataC1 = v
    o.DataC2 = v
    o.DataD1 = 1
    o.DataD2 = 1
    o.levels = 2
	table.insert(ss,'XGh'..idx[i])
    table.insert(data,110)
end
for i = 1, 1 do
	local o = slk.ability.Aamk:new('XGi'..idx[i])--敏捷
	local v = 0
	o.Name = '雪月万能属性 敏捷'
    o.hero = 0
    o.item = 1
    o.race = "other"
    o.DataA1 = v
    o.DataA2 = v
    o.DataB1 = v
    o.DataB2 = v
	o.DataC1 = v
    o.DataC2 = v
    o.DataD1 = 1
    o.DataD2 = 1
    o.levels = 2
	table.insert(ss,'XGi'..idx[i])
    table.insert(data,108)
end
for i = 1, 1 do
	local o = slk.ability.Aamk:new('XGj'..idx[i])--智力
	local v = 0
	o.Name = '雪月万能属性 智力'
    o.hero = 0
    o.item = 1
    o.race = "other"
    o.DataA1 = v
    o.DataA2 = v
    o.DataB1 = v
    o.DataB2 = v
	o.DataC1 = v
    o.DataC2 = v
    o.DataD1 = 1
    o.DataD2 = 1
    o.levels = 2
	table.insert(ss,'XGj'..idx[i])
    table.insert(data,109)
end
--[[AId2 DataA 护甲
AItg DataA 攻击
AIl1 DataA 血量
AImv DataA 魔法
AIs2 DataA 攻速
Arel DataA 回血
AIrm DataA 回魔
]]

 for i=1,#ss do?>
 <?="set aid='"..ss[i].."'"?>
<?end?>
endfunction

function XG_UnitGetBonus takes unit u, integer bonusType returns integer
 //  if not LoadBoolean(htb,GetHandleId(u),0) then
    //  return 0
 //  endif
   return LoadInteger(htb,GetHandleId(u),bonusType)
endfunction

function XG_UnitSetBonus takes unit u, integer bonusType, integer ammount returns boolean
    local integer i
    local integer lv=0
    local real r
    local real cur
    local integer hid = GetHandleId(u)
    
    if ammount > 2147483519 then
        set ammount = 2147483519
    endif
    if ammount < -2147483519 then
        set ammount = -2147483519
    endif

    if bonusType == 1 then //Life
        set cur = GetUnitState(u, UNIT_STATE_MAX_LIFE)

        set r = GetUnitState(u, UNIT_STATE_LIFE) / cur

        set cur = cur + ammount - LoadInteger(htb, hid, bonusType)
        call SetUnitState(u, UNIT_STATE_MAX_LIFE, cur )
        call SetUnitState(u, UNIT_STATE_LIFE, cur * r)

        call SaveInteger(htb, hid, bonusType, ammount)
        return true
    elseif bonusType == 2 then //Mana
        set cur = GetUnitState(u, UNIT_STATE_MAX_MANA)
        
        //记录当前蓝量百分比
        if cur > 0.00 then
            set r = GetUnitState(u, UNIT_STATE_MANA) / cur
        else
            //原本没有蓝量
            set r = 0.00
        endif
        
        set cur = cur + ammount - LoadInteger(htb, hid,bonusType)
        call SetUnitState(u, UNIT_STATE_MAX_MANA, cur )

        call SaveInteger(htb, hid, bonusType, ammount)

        call SetUnitState(u, UNIT_STATE_MANA, cur * r)
        return true
    elseif bonusType == 5 or bonusType == 6 then //生命法力恢复
        if LoadInteger(htb, bonusType, hid) == 0 then
            set i = LoadInteger( htb, bonusType, 0 ) + 1 //数组大小
            call SaveInteger( htb, bonusType, 0, i ) //添加一个新成员
            call SaveUnitHandle( htb, bonusType, i , u ) //映射handle
            call SaveInteger( htb, bonusType, hid, i ) //映射id
        endif
        call SaveInteger( htb, hid, bonusType, ammount )
        return true
    elseif bonusType>10 or bonusType<1 then
        debug call BJDebugMsg("雪月万能属性系统: 属性无效 (" + I2S(bonusType) + ")")
        return false
    endif
    
    set lv = GetUnitAbilityLevel(u,BonusAbilitys[bonusType])
    if lv <= 0 then
        set lv = 2
        call UnitAddAbility(u, BonusAbilitys[bonusType])
        call UnitMakeAbilityPermanent(u, true, BonusAbilitys[bonusType])
    else
        if lv == 1 then
            set lv = 2
        else
            set lv = 1
        endif
    endif
    call SaveInteger(htb, hid, bonusType, ammount)
    
    if bonusType == 7 then //攻速 转化百分比
        set r = ammount * 0.01
    else
        set r = I2R(ammount)
    endif

    call YDWESetUnitAbilityDataReal( u, BonusAbilitys[bonusType], lv, XGGeneralBonusSystem__Data[bonusType], r )
    call SetUnitAbilityLevel(u, BonusAbilitys[bonusType], lv )
    
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

private function Simulation takes nothing returns nothing
    local unit u
    local integer i = 1
    local integer e = LoadInteger(htb, 5, 0)
    local real r
    local real hp
    
    loop
        exitwhen i > e
        set u = LoadUnitHandle(htb, 5, i)
        set hp = GetUnitState(u, UNIT_STATE_LIFE)
        if hp >= 0.405 then
            set r = I2R( LoadInteger(htb, GetHandleId(u), 5) )
            call SetUnitState(u, UNIT_STATE_LIFE, hp + r * 0.2 )
        endif
        set i = i + 1
    endloop
    
    set i = 1
    set e = LoadInteger(htb, 6, 0)
    loop
        exitwhen i > e
        set u = LoadUnitHandle(htb, 6, i)
        set hp = GetUnitState(u, UNIT_STATE_LIFE)
        if hp >= 0.405 then
            set r = LoadInteger(htb, GetHandleId(u), 6)
            call SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MANA) + r * 0.2 )
        endif
        set i = i + 1
    endloop
    
endfunction

private function gc_unit_callback takes nothing returns nothing
    local unit u = GetGCunit()
    local unit u2
    local integer hid = GetHandleId(u)
    local integer size
    local integer id

    if hid == 0 then
        //call DisplayTimedTextToPlayer(GetLocalPlayer(), 0.0, 0.0, 1.0, "万能属性系统-清理错误: 单位id为0 [已跳过]")
        set u = null
        return
    endif

    //清除模拟属性

    //刷新生命恢复池子
    set size = LoadInteger(htb, 5, 0) // 5生命恢复  6 法力恢复
    set id = LoadInteger(htb, 5, hid) //取出handle 对应id
    if id > 0 then
        call RemoveSavedInteger(htb, 5, hid) //去除原有单位id

        set u2 = LoadUnitHandle(htb, 5, size)
        call SaveUnitHandle(htb, 5, id,  u2 ) //将最后一位成员替换到当前位置
        call SaveInteger(htb, 5, GetHandleId(u2), id) //将刚刚移位的成员id 刷新
        
        call SaveInteger(htb, 5, 0, size - 1)   //刷新数组大小
    endif


    //法力恢复池子
    set size = LoadInteger(htb, 6, 0)
    set id = LoadInteger(htb, 6, hid)
    if id > 0 then
        call RemoveSavedInteger(htb, 6, hid) //去除原有单位id映射

        set u2 = LoadUnitHandle( htb, 6, size )
        call SaveUnitHandle( htb, 6, id,  u2 )
        call SaveInteger( htb, 6, GetHandleId(u2), id ) //将刚刚移位的成员id 刷新

        call SaveInteger( htb, 6, 0, size - 1 )
    endif

    //清除通用属性
    call FlushChildHashtable( htb, hid )

    set u = null
    set u2 = null
endfunction

private function Initialize takes nothing returns nothing
    local integer i = 1
    local unit u
    call _gc_bind_unit( function gc_unit_callback )
    <?for i=1,#data do?>
                                            //+2 前面的生命 法力不是使用技能。所以占位     中间的生命法力恢复也另外占位了
    <?="set XGGeneralBonusSystem__Data["..tostring(i+2).."] = "..tostring(data[i]).."\n"?>
    <?end?>
       set BonusAbilitys[1]     = 0         //'XGa0'-'0'+c[i] //生命
       set BonusAbilitys[2]     = 0         //'XGb0'-'0'+c[i] //法力
       set BonusAbilitys[3]     = 'XGd0'    //攻击力
       set BonusAbilitys[4]     = 'XGc0'    //护甲
       set BonusAbilitys[5]     = 0         //'XGf0' //生命恢复
       set BonusAbilitys[6]     = 0         //'XGg0' //魔法恢复
       set BonusAbilitys[7]     = 'XGe0'    //攻速
	   set BonusAbilitys[8]     = 'XGh0'    //力量
	   set BonusAbilitys[9]     = 'XGi0'    //敏捷
	   set BonusAbilitys[10]    = 'XGj0'    //智力
    //预读技能
        set u = CreateUnit(Player(15), 'hpea', 0, 0, 0)
        set i = 1
        loop
            exitwhen i == 11
			if BonusAbilitys[i] != 0 then
				call UnitAddAbility(u, BonusAbilitys[i])
			endif
            set i = i + 1
        endloop
        call RemoveUnit(u)
        set u = null
    //模拟恢复
    call TimerStart(CreateTimer(), 0.2, true, function Simulation)

endfunction
endlibrary

#endif
