#pragma once
// by Asphodelus



#ifdef JapiPlaceHolderAddon
#error "[MemHack]自定义JapiPlaceHolderAddon被视作禁止行为"
#else
#define JapiPlaceHolderAddon call ConvertRace(0) YDNL return
#endif

#define MHAddonConvertHttpError(a)                      (a)

#ifndef MEMHACK_ADDON_INCLUDE_ALL
#define MEMHACK_ADDON_INCLUDE_ALL 1
#endif
