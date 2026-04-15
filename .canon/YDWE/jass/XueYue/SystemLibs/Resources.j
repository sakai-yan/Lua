#ifndef XGResourcesIncluded
#define XGResourcesIncluded

library XGResources
globals
  private hashtable htb = InitHashtable()
endglobals
  function XG_Resource_Chg takes player p,string t,integer y,real val returns nothing
    local integer x=1
    local integer h = StringHash(t)
    //0设置  +1增加  -1减少
    if y >= 1 then
      set y = 1
    elseif y <= -1 then
      set y = -1
    else
       set x = 0
	   set y = 1
    endif
    if val < 0 then
      set val = -val
    endif
    call SaveReal(htb, GetPlayerId(p), h, LoadReal(htb,GetPlayerId(p),h)*x + y*val)
  endfunction
  function XG_Resource_Get takes player p,string t returns real
    return LoadReal(htb,GetPlayerId(p),StringHash(t))
  endfunction
  function XG_Resource_xGet takes player p,string t,real val returns boolean
    local real r = LoadReal(htb, GetPlayerId(p),StringHash(t))
    call SaveReal(htb,GetHandleId(GetTriggeringTrigger()),StringHash(t),val)
    return r >= val
  endfunction
  function XG_Resource_tGet takes string t returns real
    return LoadReal(htb, GetHandleId(GetTriggeringTrigger()),StringHash(t))
  endfunction
endlibrary
#endif
