#ifndef XG_userdataGC_once
#define XG_userdataGC_once
/*
    雪月灬雪歌
    GC系统 1.0

*/


library userdataGC
//#include "XueYue\\SystemLibs\\GarbageCollect\\init.lua"
$def XGuserdataGC

globals
    private hashtable ht = InitHashtable()
    private triggercondition array codes
    private integer count = 0
    private unit curUnit = null
    private item curItem = null
    constant trigger userdataGC__pocessUnit = CreateTrigger()
    constant trigger userdataGC__pocessItem = CreateTrigger()
endglobals

# // table
# define gc_Class_Unit 1
#   define gc_ExprCount 0
#
# //--------

function gc_bind_unit takes code lpCallback returns triggeraction
    return _gc_bind_unit(lpCallback)
endfunction

function gc_bind_item takes code lpCallback returns triggeraction
    return _gc_bind_item(lpCallback)
endfunction

function gc_remove_unit takes triggeraction hCallback returns nothing
    call _gc_remove_unit(hCallback)
endfunction

function gc_remove_item takes triggeraction hCallback returns nothing
    call _gc_remove_item(hCallback)
endfunction

function gc_unit takes unit u returns nothing
    set curUnit = u
    call _gc_unit()
    set curUnit = null
endfunction

function gc_item takes item it returns nothing
    set curItem = it
    call _gc_item()
    set curItem = null
endfunction

//获取本次GC要排泄的单位
function GetGCunit takes nothing returns unit
    return curUnit
endfunction
//获取本次GC要排泄的物品
function GetGCitem takes nothing returns item
    return curItem
endfunction

#undef gc
endlibrary

#endif
