local reload = function ( lua )
    lua = 'compile.xjass.' .. lua
    package.loaded[lua] = nil
    return require (lua)
end


---@return string arg wave参数
function xjass:wave( op )
    local arg = ""
    cjhook = reload 'cjhook'
    ----------------------
    reload 'XGVarProcess'
    local f = io.open(op.input,"a+b")
    ---@type string
    local jass = Hc_XG_BxL(f:read("*a"))
    f:close()
    local t = {
        "XG_AutoAttr_SetClassA",
        "XG_AutoAttr_AddAttrA",
        "XG_AutoAttr_StartA",
        "XG_AutoAttr_GetAttrNum",
        "XG_AutoAttr_GetAttrKey",
        "XG_AutoAttr_GetAttrVal"
    }
    for i = 1,#t do
        local s,q =  jass:find(t[i], nil, true)
        if s then
            s,q = jass:find("endglobals", nil, true)
            local j = io.open(wave.jass_include_path /"XueYue"/"SystemLibs"/"AutoGetAttr.j","a+b")
            if not j then
                break
            end
            jass = jass:sub(1,q) .. "\r\n" .. j:read("*a") .. jass:sub(q+1,jass:len())
            --jass = '#include "XueYue\\SystemLibs\\AutoGetAttr.j"\r\n'..jass
            j:close()
            break
        end
    end
    ---------------------------
    local t={
        "XG_GetHeroMainAttr"
    }
    for i=1,#t do
        local s, q = jass:find(t[i],nil, true)
        if s then
            s,q = jass:find("endglobals", nil, true)
            j=io.open(wave.jass_include_path /"XueYue"/"Calls"/"GetHeroMainAttr.j","a+b")
            jass = jass:sub(1,q) .. "\r\n" .. j:read("*a") .. jass:sub(q+1,jass:len())
            j:close()
            break
        end
    end
    ---------------------------
    local t = {
        "XG_Macro_Set",
        "XG_Macro_Get"
    }
    for i = 1,#t do
        local s,q = jass:find(t[i], nil, true)
        if s then
            reload 'XGMacro'
            break
        end
    end
    if XG_Macro then
        jass = XG_Macro_Compile_Do(jass)
    end
    --------------------
    local regexp = "XG_StrFormat_.-%s*%b()"
    
    local loc_st, loc_end =  jass:find( regexp )
    if loc_st then
        reload 'XGStrFormat'
        log.trace(">StrFormat")
        --arg = arg ..  string.format('--forceinclude=%s ',    "XueYue\\XGStrFormat.h" )

        --#define XG_StrFormat_Reg(key, format) <?=XG_StrFormat_Reg_Lua(key,[==[format]==])?>
        --#define XG_StrFormat_AIO(str) <?=XG_StrFormat_AIO_Lua(str)?>
        --#define XG_StrFormat_Do(str, format) <?=XG_StrFormat_Do_Lua(str, format)?>
        local map_pocess = {
            XG_StrFormat_Reg = function (params)
                local param = {}
                if #params < 2 then
                    return param
                end
                param[1] = params[1]:gsub('^%s*(.+)%s*$', '%1'):sub(2,-2) 
                param[2] = params[2]:gsub('^%s*(.+)%s*$', '%1')
                return param
            end,
            XG_StrFormat_AIO = function (params)
                local param = {}
                if #params < 1 then
                    return param
                end
                param[1] = params[1]:gsub('^%s*(.+)%s*$', '%1'):sub(2,-2)
                return param
            end,
            XG_StrFormat_Do = function (params)
                local param = {}
                if #params < 2 then
                    return param
                end
                param[1] = params[1]:gsub('^%s*(.+)%s*$', '%1'):sub(2,-2)
                param[2] = params[2]:gsub('^%s*(.+)%s*$', '%1'):sub(2,-2)
                return param
            end,
        }
        local map_Func = {
            XG_StrFormat_Reg = XG_StrFormat_Reg_Lua,
            XG_StrFormat_AIO = XG_StrFormat_AIO_Lua,
            XG_StrFormat_Do = XG_StrFormat_Do_Lua,
        }
        local regexp_match = "(XG_StrFormat_.-)%s*%b()"
        local getExpression = getExpression
        while loc_st do
            local funcName = jass:sub(loc_st, loc_end):match(regexp_match)
            local skip_len = #funcName
            --log.debug( 'funcName', funcName )
            if not map_pocess[funcName] then
                log.error( 'XG_StrFormat funcName', funcName )
                
            else
                --funcName	XG_StrFormat_Reg( "atk", R2S( (YDLocal1Get(real, "f") * YDLocal1Get(real, "value"))))
                --funcName	XG_StrFormat_Reg
                local skip,params, _end =  getExpression(jass, loc_st, loc_end)
                local param = map_pocess[funcName](params)
                --log.debug( table.concat(param, ",") )
                --"atk"," R2S( (YDLocal1Get(real, \"f\") * YDLocal1Get(real, \"value\")))"
                --log.debug(map_Func[funcName]( table.unpack(param) ))
                -- "攻击力 %s", "atk"
                --""攻击力  R2S( (YDLocal1Get(real, \"f\") * YDLocal1Get(real, \"value\")))""
                jass = jass:sub(1,loc_st-1) .. map_Func[funcName]( table.unpack(param) ) .. jass:sub(loc_end+1)

            end

            loc_st, loc_end =  jass:find( regexp, loc_st +  skip_len )
        end

    end
    ----------------------------------------------------------------------
    --local lpath = package.path
    --log.debug( package.path )
    local t = {
        "XG_QuickSort_",
    }
    for i=1, #t do
        local s,q =  jass:find(t[i], nil, true)
        if s then
            local j = io.open(wave.jass_include_path / "XueYue" / "Actions" / "QuickSort.j", "a+b")
            if not j then
                break
            end
            jass =  j:read("*a") .. jass
            j:close()

            log.trace(">QuickSort")

            break
        end
    end

    ----------------------------------------------------------------------
    if tonumber(xjass.def['xjass']['XG_JAPI']) == 1 then
        --JAPI优化
        log.trace("XGJAPI forceinclude")
        arg = arg ..  string.format('--forceinclude=%s ',    "XueYue\\XGJAPI.h" )
    end
    ----------------------------------------------------------------------
    if tonumber(xjass.def['xjass']['XGJASSCALL']) == 1 then
        --JAPI优化
        log.trace("XGJASSCALL forceinclude")
        local _abandon, x = jass:find("function config takes .-\n")
        local localStart, localEnd
        if x then
            local y = jass:find("\n%s*endfunction", x)
            local config = jass:sub(x+1, y-1)
            localStart, localEnd = config:find("local %w- .-\n")
            if localStart then
                --找到最后一个local行
                while true do
                    local locS, locE = jass:find("\n%s*local %w- .-\n", localEnd + 1)
                    if not locS then
                        break
                    end
                    localEnd = locE
                    x = locE
                end
                --local z = jass:find("\n%s*endfunction", y)
            end
            jass = jass:sub(1, x+1) .. [[
            if XG_JassCall_IsLoaded then
                call XG_JassCall_Redirect()
                return
            else
                set XG_JassCall_IsLoaded = true
            endif
            ]] .. jass:sub(x+1)
        end

    end
    ----------------------------------------------------------------------
    if tonumber(xjass.def['xjass']['XGuserdataGC']) == 1 then
        --JAPI优化
        log.trace("XGuserdataGC forceinclude")
        arg = arg ..  string.format('--forceinclude=%s ',    "XueYue\\XGuserdataGC.h" )

        reload 'userdataGC'
    end
    ----------------------------------------------------------------------
    if tonumber(xjass.def['xjass']['XGUITipToolAbilityBasic']) == 1 then
        --JAPI优化
        log.trace("XGUITipToolAbilityBasic forceinclude")
        arg = arg ..  string.format('--forceinclude=%s ',    "XueYue\\XGUITipToolAbilityBasic.h" )

        reload 'XGUITipToolAbilityBasic'
    end
    ----------------------------------------------------------------------
    if tonumber(xjass.def['xjass']['WenHao__Japi']) == 1 then
        log.trace("WenHao__Japi forceinclude")
        arg = arg ..  string.format('--forceinclude=%s ',   "XueYue\\WenHaoJapi_xjass.h" )
    end
    ----------------------------------------------------------------------
    
    if (xjass.def['xjass']['TestOn11']) then
        log.trace("TestOn11 replace dzapi bzapi")
        arg = arg ..  string.format('--define=DZAPIINCLUDE=\\"%s\\" ', tostring(""))
        arg = arg ..  string.format('--define=BZAPIINCLUDE=\\"%s\\" ', tostring(""))
    end

    --[[
    local xg_import = 1
    local ffi = require 'ffi'
    local stormlib = ffi.load('stormlib')
    require 'compile.XGFindFile'
    local mpq = op.map_handle
    if mpq then
        local XgMapPath = op.map_path:string():match(".+\\")
        
            jass = jass:gsub("call%s-XG_ImportFolder%s*%(%s*\"(.-)\"%s*,%s*\"(.-)\"%s*%)",
            function(x,y)
                --log.trace("SetMaxFileCount",tostring(stormlib.SFileSetMaxFileCount(mpq.handle,0x1000))) --导致读不到文件
                local n = XGFindFile(XgMapPath..x, mpq, op, XgMapPath..x, y)
                log.trace("xg_import["..tostring(n).."]: "..XgMapPath..x..' -> '..y)
                    return ''
            end)
    end
    ]]
    jass='    <?XG={["damplus"]={}}?>\r\n'..jass
    f=io.open(op.input,"w+b")
    f:write(jass)
    f:close()
    return arg
end