#ifndef XGJumpTagIncluded
#define XGJumpTagIncluded

#include "XueYue\Base.j"
library XGJumpTag requires XGbase
    //OriginHeitht为初始高度
    //MaxHeitht为最高高度
    //CurrentTime为当前运动时刻
    //TotalTime为总运动时间
    //返回初始高度为OriginHeight，最高高度为MaxHeight，总跳跃时间为TotalTime的跳跃运动在CurrentTime时刻的高度
    //By:霖湙
    private function getZ takes real OriginHeight, real MaxHeight, real CurrentTime, real TotalTime returns real
        local real Speed
        local real SpeedX    
        if CurrentTime < (TotalTime / 2) then
            set Speed = ((MaxHeight - OriginHeight) / (TotalTime / 2)) * 2
            set SpeedX = Speed / (TotalTime / 2)
            return OriginHeight + (Speed * CurrentTime) - (0.5 * (SpeedX * Pow(CurrentTime, 2)))
        endif

        set SpeedX = (MaxHeight - OriginHeight) / Pow((TotalTime / 2), 2)
        set Speed = SpeedX * (CurrentTime - (TotalTime / 2))
        return MaxHeight - ((Speed * (CurrentTime - (TotalTime / 2))) + 0.5 * (SpeedX * Pow(CurrentTime - (TotalTime / 2), 2)))
    endfunction

    private function Timer_JumpText takes nothing returns nothing
        local timer t = GetExpiredTimer()
        local integer key = GetHandleId(t)
        local texttag tag = LoadTextTagHandle(Xg_htb, key, 0)
        local real x = LoadReal(Xg_htb,key , 1)
        local real y = LoadReal(Xg_htb,key , 2)
        local real time = LoadReal(Xg_htb, key , 3)
        local boolean switch = LoadBoolean(Xg_htb, key , 4)
        local real z //= LoadReal(Xg_htb, key , 5)
        local real tome = LoadReal(Xg_htb, key , 8)
        local boolean zoom = LoadBoolean(Xg_htb, key , 9)
        local real ex
        local real ey
        local real dist = LoadReal(Xg_htb, key , 10) + 0.75
        local real angle = LoadReal(Xg_htb, key , 11)
        call SaveReal(Xg_htb, key , 10, dist)

        if(time >= tome)then
            call DestroyTextTag(tag)
            call FlushChildHashtable( Xg_htb, key )
            call PauseTimer(t)
            call DestroyTimer(t)
        else
            set ex = x + dist * Cos(angle * bj_DEGTORAD)
            set ey = y + dist * Sin(angle * bj_DEGTORAD)

            set time = time + tome / 150

            set z = getZ( 0.00, 180.00, time, tome )

            if zoom then
                call SetTextTagText(tag, LoadStr(Xg_htb, key , 6), LoadReal(Xg_htb, key , 7) * .023 *  z / 180.00 / 7.00 )
            endif
            call SetTextTagPos(tag, ex, ey, z)
            call SetTextTagColor(tag, LoadInteger(Xg_htb, key, -1), LoadInteger(Xg_htb,key,-2), LoadInteger(Xg_htb,key,-3), LoadInteger(Xg_htb,key,-4))
            call SaveReal(Xg_htb, key , 1, x)
            call SaveReal(Xg_htb, key , 2, y)
            call SaveReal(Xg_htb, key , 3, time)
            call SaveBoolean(Xg_htb, key , 4, switch)
            //call SaveReal(Xg_htb, key , 5, z)
        endif
        set tag = null
        set t = null
    endfunction

    private function init_timer takes timer t, texttag tag, real x, real y, string s, real size, real time, integer red, integer green, integer blue, integer alpha, boolean zoom, real angle returns nothing
        local integer key = GetHandleId(t)

        call SaveInteger(Xg_htb, key, -1, red)
        call SaveInteger(Xg_htb, key, -2, green)
        call SaveInteger(Xg_htb, key, -3, blue)
        call SaveInteger(Xg_htb, key, -4, alpha)
        call SaveTextTagHandle(Xg_htb, key, 0, tag)
        call SaveReal(Xg_htb, key, 1, x)
        call SaveReal(Xg_htb, key, 2, y)
        call SaveBoolean(Xg_htb, key, 4, true)
        //call SaveReal(Xg_htb, key, 5, 5)
        if zoom then
            call SaveStr(Xg_htb, key, 6, s)
            call SaveReal(Xg_htb, key, 7, size)
        endif
        call SaveReal(Xg_htb, key, 8, time)
        call SaveBoolean(Xg_htb, key, 9, zoom)

        call SaveReal(Xg_htb, key, 10, 50)
        call SaveReal(Xg_htb, key, 11, angle)

        call TimerStart(t, time / 150, true, function Timer_JumpText)
    endfunction

    function XG_CreateJumpTextFormLoc takes location p, string s, real size, real time, integer red, integer green, integer blue, integer alpha, boolean zoom returns nothing
        local texttag tag = CreateTextTag()
        local real x = GetLocationX(p)
        local real y = GetLocationY(p)
        
        call SetTextTagText(tag, s, size * .023 / 10)
        call SetTextTagPos(tag, x, y, 0)
        call SetTextTagColor(tag, red, green, blue, alpha)
        call SetTextTagPermanent(tag, false)
        call SetTextTagLifespan(tag, time)
        call SetTextTagFadepoint(tag,time / 6)

        call init_timer(CreateTimer(), tag, x, y, s, size, time, red, green, blue, alpha, zoom, 180.00)

        set bj_lastCreatedTextTag = tag
        set tag = null
    endfunction

    function XG_CreateJumpTextFormLoc_Angle takes location p, real angle, string s, real size, real time, integer red, integer green, integer blue, integer alpha, boolean zoom returns nothing
        local texttag tag = CreateTextTag()
        local real x = GetLocationX(p)
        local real y = GetLocationY(p)
        
        call SetTextTagText(tag, s, size * .023 / 10)
        call SetTextTagPos(tag, x, y, 0)
        call SetTextTagColor(tag, red, green, blue, alpha)
        call SetTextTagPermanent(tag, false)
        call SetTextTagLifespan(tag, time)
        call SetTextTagFadepoint(tag,time / 6)

        call init_timer(CreateTimer(), tag, x, y, s, size, time, red, green, blue, alpha, zoom, angle)

        set bj_lastCreatedTextTag = tag
        set tag = null
    endfunction

endlibrary


#endif
