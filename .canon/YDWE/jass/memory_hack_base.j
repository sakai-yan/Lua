#pragma once
// by vcccv, Asphodelus



#include <boost/preprocessor/cat.hpp>

#ifdef JapiPlaceHolder
#error "[MemHack]自定义JapiPlaceHolder被视作禁止行为"
#else
#define JapiPlaceHolder call ConvertRace(0) YDNL return
#endif

#define __MEMHACK_COUNT_ARGS_IMPL(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,_11,_12,_13,_14,_15,_16,N,...) N
#define __MEMHACK_COUNT_ARGS(...) __MEMHACK_COUNT_ARGS_IMPL(__VA_ARGS__,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0)

#define MHConvertEventID(a)                         (a)
#define MHConvertGameOption(a)                      (a)
#define MHConvertTargetAllow(a)                     (a)
#define MHConvertArmourType(a)                      (a)
#define MHConvertCheatFlag(a)                       (a)
#define MHConvertCollisionType(a)                   (a)
#define MHConvertCastType(a)                        (a)
#define MHConvertHashtableChangeType(a)             (a)
#define MHConvertLocalOrderFlag(a)                  (a)
#define MHConvertLayerStyle(a)                      (a)
#define MHConvertTextFlag(a)                        (a)
#define MHConvertTextStyle(a)                       (a)
#define MHConvertBorderFlag(a)                      (a)
#define MHConvertVirtualKey(a)                      (a)
#define MHConvertAttackType(a)                      ConvertAttackType(a)
#define MHConvertDamageType(a)                      ConvertDamageType(a)
#define MHConvertWeaponType(a)                      ConvertWeaponType(a)

#define MHCompareAttackType(lhs, rhs)               ((lhs) == (rhs))
#define MHCompareDamageType(lhs, rhs)               ((lhs) == (rhs))
#define MHCompareWeaponType(lhs, rhs)               ((lhs) == (rhs))



library zMHInit
#ifndef MEMHACK_INCLUDE_ALL
#define MEMHACK_INCLUDE_ALL 1
#endif

#ifndef MEMHACK_DISABLE_WENHAO
#define MEMHACK_DISABLE_WENHAO 0
#endif
#ifndef MEMHACK_DISABLE_MEMHACK
#define MEMHACK_DISABLE_MEMHACK 0
#endif
#ifndef MEMHACK_DISABLE_JAPI_DAMAGE
#define MEMHACK_DISABLE_JAPI_DAMAGE 1
#endif

#ifndef MEMHACK_MAIN_HOOK_ON_START
#define MEMHACK_MAIN_HOOK_ON_START call DoNothing()
#endif

#ifndef MEMHACK_MAIN_HOOK_ON_FINISH
#if MEMHACK_DISABLE_WENHAO
#define MEMHACK_MAIN_HOOK_ON_FINISH call DoNothing()
#else
#define MEMHACK_MAIN_HOOK_ON_FINISH call SetOwner("问号") YDNL call AbilityId("exec-lua:plugin_main")
#endif
#endif

    globals
        constant integer    MEMHACK_FLAG_DISABLE_WENHAO         = MEMHACK_DISABLE_WENHAO
        constant integer    MEMHACK_FLAG_DISABLE_MEMHACK        = MEMHACK_DISABLE_MEMHACK
        constant integer    MEMHACK_FLAG_DISABLE_JAPI_DAMAGE    = MEMHACK_DISABLE_JAPI_DAMAGE
        private boolean     MEMHACK_INITIALIZED                 = false
    endglobals

    function memhack_init takes nothing returns nothing
        if (MEMHACK_INITIALIZED) then
            return
        endif
        set MEMHACK_INITIALIZED = true

        call ExecuteFunc("DoNothing")
        call StartCampaignAI(Player(PLAYER_NEUTRAL_AGGRESSIVE), "tiara.ai")
        call ExecuteFunc("DoNothing")

        MEMHACK_MAIN_HOOK_ON_FINISH
        call I2R(MEMHACK_FLAG_DISABLE_WENHAO + MEMHACK_FLAG_DISABLE_MEMHACK + MEMHACK_FLAG_DISABLE_JAPI_DAMAGE)
    endfunction
    
#ifndef MEMHACK_DISABLE_MAIN_HOOK
#ifdef SetCameraBounds
#undef SetCameraBounds
#endif
#define SetCameraBounds(a,b,c,d,e,f,g,h) memhack_init() YDNL call SetCameraBounds(a,b,c,d,e,f,g,h)
#endif
endlibrary
