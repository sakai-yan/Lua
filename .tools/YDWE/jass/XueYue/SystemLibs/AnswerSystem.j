#ifndef HcAnswerSystemIncluded
#define HcAnswerSystemIncluded
library HcAnswerSystem
 globals
   private hashtable array htb
   private integer Lib = 0
   private integer Num = 0 //问题id
 endglobals
//创建题库
 function XG_Answer_CreateQuestionLib takes nothing returns integer
  if Lib == 0 then
     set htb[0] = InitHashtable() //库，题目 -> id
     set htb[1] = InitHashtable() //id，选项 -> str
     //set htb[2] = InitHashtable()
  endif
  set Lib = Lib + 1
  return Lib
 endfunction
 //添加题目 返回id
 function XG_Answer_AddQuestion takes integer lib, string s returns integer
  local integer i=LoadInteger(htb[0],lib,0)+1
  set Num = Num + 1
  call SaveInteger(htb[0],lib,0,i)
  call SaveInteger(htb[0],lib,i,Num)
  call SaveStr(htb[1], Num, 0, s) //题目
  return Num
 endfunction
  //添加选项
 function XG_Answer_AddAnswer takes integer q, string s, boolean b returns nothing
  local integer n = LoadInteger(htb[1], q, 0) + 1
  if q > 0 then
   call SaveInteger(htb[1], q, 0, n)
   call SaveStr(htb[1], q, n, s)
    if b then
     //call SaveInteger(htb[1], q, -1, n)//正确答案
     call SaveBoolean(htb[1],q,n,true)
    endif
  endif
 endfunction
 //挑出选题 指定库,指定/0随机题,是否打乱选项
 function XG_Answer_TakeQuestion takes integer lib,integer t,boolean z returns integer
  local integer q
  local integer array x
  local integer i=1
  if t<=0 then
    set t=GetRandomInt(1,LoadInteger(htb[0],lib,0))//随机选题
  endif
  set x[8191]=LoadInteger(htb[0],lib,t) //选题ID
  set q = LoadInteger(htb[1],x[8191],0) //选项数
  
  loop
    exitwhen i>q
    set x[i]=i
    set i=i+1
  endloop
  call SaveInteger(htb[0],lib,-1,q) 
  loop
    set i=i-1
    exitwhen i<1
    if z then
      set x[0]=GetRandomInt(1,i)
    else
      set x[0]=i
    endif
    call SaveInteger(htb[0],lib,-1*i-1,x[x[0]])
    call SaveStr( htb[0],lib,-1*i-1,LoadStr(htb[1],x[8191],x[x[0]]) )
    call SaveBoolean( htb[0],lib,-1*i-1,LoadBoolean(htb[1],x[8191],x[x[0]]) )
    set x[x[0]]=x[i]
  endloop
  call SaveStr( htb[0],lib,-1,LoadStr(htb[1],x[8191],0) )
  return lib
 endfunction
 //从已选题中获取数据
 function XG_Answer_GetStr_A takes integer lib,integer i returns string
   return LoadStr(htb[0],lib,-1*i-1)
 endfunction
 function XG_Answer_GetInt_A takes integer lib,integer i returns integer
   return LoadInteger(htb[0],lib,-1*i-1)
 endfunction
 function XG_Answer_GetBool_A takes integer lib,integer i returns boolean
   return LoadBoolean(htb[0],lib,-1*i-1)
 endfunction
  //从题库题目中获取数据
 function XG_Answer_GetStr_B takes integer id,integer i returns string
   return LoadStr(htb[1],id,i)
 endfunction
 function XG_Answer_GetInt_B takes integer id,integer i returns integer
   return LoadInteger(htb[1],id,i)
 endfunction
 function XG_Answer_GetBool_B takes integer id,integer i returns boolean
   return LoadBoolean(htb[1],id,i)
 endfunction
 
endlibrary
#endif
