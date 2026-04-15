#ifndef XGBetterCreateTextTagIncluded
#define XGBetterCreateTextTagIncluded


library XGBetterCreateTextTag
//对【全部玩家】【排泄】在【x,y】高度偏移【z】显示【空字符串】，持续【2】秒，移动方向和速率【0，80.00】，大小【8.00】，RGBA(100%，100%，100%，0%)
//可以用最后创建的漂浮文字捕捉
function XG_CreateTextTagByParamsForPlayer_xy takes force players, boolean removeForce, real x, real y, real z, string s, real sec, real fade, real angle, real speed, real size, integer red,integer green,integer blue,integer alpha returns nothing
    local texttag tag = CreateTextTag()
    local real vel = speed * 0.071 / 128
    local real edg2rad = 3.14159 / 180.0
    //改变文字内容 字高
    call SetTextTagText( tag, s, size * 0.023 / 10 )
    //设置显示玩家
    call SetTextTagVisibility( tag, IsPlayerInForce(GetLocalPlayer(), players) )
    //设置xy 高度偏移
    call SetTextTagPos( tag, x, y, z )
    //设置颜色
    call SetTextTagColor( tag, red, green, blue, alpha )
    //设置永久性
    call SetTextTagPermanent( tag, false )
    //设置消逝周期
    call SetTextTagLifespan( tag, sec )
    //消逝淡化点
    if fade == -1.00 then
        set fade = sec / 3.00
    endif
    call SetTextTagFadepoint( tag, fade )
    //设置速率
    call SetTextTagVelocity( tag, vel * Cos(angle * edg2rad), vel * Sin(angle * edg2rad) )
    //排泄
    set bj_lastCreatedTextTag = tag
    set tag = null
    if removeForce then
        call DestroyForce(players)
    endif
endfunction

//对【全部玩家】【排泄】在【点】高度偏移【z】【排泄】显示【空字符串】，持续【2】秒，移动方向和速率【0，80.00】，大小【8.00】，RGBA(100%，100%，100%，0%)
//可以用最后创建的漂浮文字捕捉
function XG_CreateTextTagByParamsForPlayer_Location takes force players, boolean removeForce, location loc, boolean remLoc, real z, string s,real sec, real fade, real angle, real speed, real size,integer red,integer green,integer blue,integer alpha returns nothing
    if z == -1 then
        set z = GetLocationZ(loc)
    endif
    call XG_CreateTextTagByParamsForPlayer_xy( players, removeForce, GetLocationX(loc), GetLocationY(loc), z, s, sec, fade, angle, speed, size, red, green, blue, alpha)
    if remLoc then
        call RemoveLocation(loc)
    endif
endfunction

//对【全部玩家】【排泄】在【单位】头上 高度偏移【z】【排泄】显示【空字符串】，持续【2】秒，移动方向和速率【0，80.00】，大小【8.00】，RGBA(100%，100%，100%，0%)
//可以用最后创建的漂浮文字捕捉
function XG_CreateTextTagByParamsForPlayer_Unit takes force players, boolean removeForce, unit u,real z, string s,real sec, real fade, real angle, real speed, real size,integer red,integer green,integer blue,integer alpha returns nothing
    local texttag tag = CreateTextTag()
    local real vel = speed * 0.071 / 128
    local real edg2rad = 3.14159 / 180.0
    //改变文字内容 字高
    call SetTextTagText( tag, s, size * 0.023 / 10 )
    //设置显示玩家
    call SetTextTagVisibility( tag, IsPlayerInForce(GetLocalPlayer(), players) )
    //设置xy 高度偏移
    call SetTextTagPosUnit( tag, u, z )
    //设置颜色
    call SetTextTagColor( tag, red, green, blue, alpha )
    //设置永久性
    call SetTextTagPermanent( tag, false )
    //设置消逝周期
    call SetTextTagLifespan( tag, sec )
    //消逝淡化点
    if fade == -1.00 then
        set fade = sec / 3.00
    endif
    call SetTextTagFadepoint( tag, fade )
    //设置速率
    call SetTextTagVelocity( tag, vel * Cos(angle * edg2rad), vel * Sin(angle * edg2rad) )
    //排泄
    set bj_lastCreatedTextTag = tag
    set tag = null
    if removeForce then
        call DestroyForce(players)
    endif
    
endfunction

endlibrary


#endif
