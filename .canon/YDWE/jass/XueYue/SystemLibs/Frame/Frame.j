#ifndef LIB_XGFRAME_H
#define LIB_XGFRAME_H

#include "BlizzardAPI.j"

#define kSystemIdx -1008611
#define kNodeIdx 999999

library XGFrame initializer Init requires BzAPI
    globals
        private hashtable ht = InitHashtable()
        private real defaultWidth = 1920.0
        private real defaultHeight = 1080.0
        private integer uuid = 0
    endglobals

    private function getNode_unsafe takes string p, string c returns integer
        return LoadInteger(ht, StringHash(p), StringHash(c))
    endfunction

    private function getNode takes string p, string c returns integer
        local integer node = LoadInteger(ht, StringHash(p), StringHash(c))
        local integer cur
        if node == 0 then
            set cur = LoadInteger(ht, kSystemIdx, kNodeIdx) + 1
            set node = cur
            call SaveInteger(ht, kSystemIdx, kNodeIdx, cur)
            call SaveInteger(ht, StringHash(p), StringHash(c), node)
        endif
        return node
    endfunction

    function XG_FrameCreateByTag takes \
            string saveName, string childName, integer idx, \
            string frameType, string name, \
            integer parent, string template, \
            integer id \
        returns integer

        local integer f = DzCreateFrameByTagName(frameType, name, parent, template, id)
        local integer node = getNode(saveName, childName)
        call SaveInteger(ht, node, idx, f)
        return f
    endfunction

    function XG_FrameCreateByTagWithParams takes \
            string saveName, string childName, integer idx, \
            string frameType, string name, \
            integer parent, string template, \
            integer id, \
            boolean rel, integer anchorS, integer frameT, integer anchorT, \
            real x, real y, real w, real h, boolean visible \
        returns integer
            // [相对] [锚点] 绑定 [frame] [锚点] [x] [y]

        local integer f = XG_FrameCreateByTag(saveName, childName, idx, frameType, name, parent, template, id)

        if rel then
            call DzFrameSetPoint(f, anchorS, frameT, anchorT, x, y)
        else
            call DzFrameSetAbsolutePoint(f, anchorS, x, y)
        endif

        call DzFrameSetSize(f, w, h)
        call DzFrameShow(f, visible)

        return f
    endfunction

    function XG_FrameGet takes string saveName, string childName, integer idx returns integer
        local integer node = getNode_unsafe(saveName, childName)
        if node == 0 then
            return 0
        endif
        return LoadInteger(ht, node, idx)
    endfunction

    function XG_FrameSetTextAlignment takes integer f, integer align returns nothing
        call DzFrameSetTextAlignment(f, 100 )
        call DzFrameSetTextAlignment(f, align )
    endfunction

    function XG_FrameSetTextFont takes integer f, string fontName, real height, integer flag returns nothing
        call DzFrameSetFont( f, fontName, height, flag )
    endfunction

    function XG_FrameSetTextrue takes integer f, string tex, integer flag returns nothing
        call DzFrameSetTexture(f, tex, flag)
    endfunction

    function XG_FrameCalcWidthPixel takes integer r returns real
        return r / defaultWidth * 0.8
    endfunction

    function XG_FrameCalcHeightPixel takes integer r returns real
        return r / defaultHeight * 0.6
    endfunction

    function XG_FrameCalcWidthPercent takes integer per returns real
        return per / 100.0 * 0.8
    endfunction

    function XG_FrameCalcHeightPercent takes integer per returns real
        return per / 100.0 * 0.6
    endfunction

    function XG_FrameSetScreenWidth takes integer w_scr returns nothing
        if w_scr == 0 then
            return
        endif
        set defaultWidth = w_scr
    endfunction

    function XG_FrameSetScreenHeight takes integer h_scr returns nothing
        if h_scr == 0 then
            return
        endif
        set defaultHeight = I2R(h_scr)
    endfunction

    function XG_FrameGenNameUUID takes nothing returns string
        set uuid = uuid + 1
        return "XGFrameName_" + I2S(uuid)
    endfunction

    private function Init takes nothing returns nothing
        call XG_ImportFile("XueYue\\SystemLibs\\Frame\\Frame.toc", "XueYue\\Frame\\Frame.toc")
        call DzLoadToc("XueYue\\Frame\\Frame.toc")
    endfunction

endlibrary

#undef kSystemIdx
#undef kNodeIdx

#endif // LIB_FRAME_H

