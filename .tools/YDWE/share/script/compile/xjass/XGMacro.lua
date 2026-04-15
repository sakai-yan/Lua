        ----------------------------------------------------
        --                  声明
        ----------------------------------------------------
        XG_Macro = setmetatable(
            {}
            ,
            {
                __index = function(t,k)
                    return  '"XG_Macro: '.. k .. ' 未声明  |  '.. k .. '  undefined"'
                end
            }

        )
        XG_Macro_Func = {}

        pass_string = ''
        pass_int = 0


        ----------------------------------------------------
        --                  宏定义与调用
        ----------------------------------------------------
        function XG_Macro_FuncX(m)
                local jass = pass_string
                local ss
                local rsz
                local start,eee = jass:find( "function *" .. m .. " *takes" )
                if start then

                    ss = start --删除的开始位置
                    start = jass:find( "\n",start )

                    if start then
                        --start + 1
                        es,ee = jass:find( "endfunction" ,start)
                        if jass:sub(es-2,es) == '\r\n' then
                            rsz = jass:sub(start+1,es-3)
                        else
                            rsz = jass:sub(start+1,es-2)
                        end
                        rsz = rsz:lighter()
                        pass_int = jass:sub(ss,ee):len() --偏移
                        pass_string = jass:sub(1,ss-1) .. jass:sub(ee+1)
                    end

                    --特殊处理
                    if rsz:sub(1,3) == "set" then
                        rsz = "DoNothing()\n" .. rsz
                    elseif rsz:sub(1,6) == "return" then
                        rsz = rsz:sub(7):lighter()
                    elseif rsz:sub(1,4) == "call" then
                        rsz = rsz:sub(6):lighter() --加上空格5 从6开始截取
                    end
                    XG_Macro_Func[ m ] = rsz
                elseif XG_Macro_Func[ m ] then
                    rsz = XG_Macro_Func[ m ]
                end

            if not rsz then
                rsz = '"XG_Macro: '.. m .. ' 未声明  |  ' .. m .. '  undefined"'
            end

            return rsz

        end

        function XG_Macro_Set ( m, c )
            m = m:lighter()
            c = c:lighter()     --去首尾空

            if c:find("function") then      --传入函数

                c = c:match( "function ([_*%w]+)" )      --去除函数头 增加括号 可用于直接调用

                c = XG_Macro_FuncX(c)

                --XG_Macro_Func[ m ] = true       --记录 表明已经处理过了

                --log.trace("function match",m,XG_Macro_Func [ m ])
            end

            XG_Macro [ m ] = c
            return "DoNothing()"
        end
        function XG_Macro_Get ( m )
            m = m:lighter()
            return XG_Macro [ m ] .. " " --加个空格兼容cj的清除冗余空格,不然会报错
        end
        ----------------------------------------------------
        --              编译阶段
        ----------------------------------------------------

        local _env_XG_Macro_Get = { XG_Macro_Get = XG_Macro_Get}
        function XG_Macro_Compile_Do(jass)
            local start,last,func,rsz,flast
            local j
            local params
            --------------设置
            j = 0
            while true do
                j = j + 1
                if j > 100000 then
                    log.trace("XG_Macro_Set","endless loop")
                    break
                end
                start,flast = jass:find ( "XG_Macro_Set.-%(" )        --寻找宏标记
                if flast then
                    local skip, params, last = getExpression(jass,start)
                    if #params > 0 then
                        pass_string = jass
                        pass_int = 0
                        local param = params[1] or ''
                        for i=2, #params  do
                            params[i] =  "[[" .. params[i] .. "]]"
                            param = param .. ',' .. params[i]
                        end

                        func = load("return XG_Macro_Set(" .. param ..')' )
                        if func then
                            rsz = func()
                            jass = pass_string:sub(1,start-1-pass_int) .. rsz .. pass_string:sub(last+1-pass_int)
                        end

                    end
                else
                    break
                end
            end
            -----------------
            --------------获取调用
            j = 0
            local abandon
            while true do
                j = j + 1
                if j > 100000 then
                    log.trace("XG_Macro_Get", "endless loop")
                    break
                end
                start, flast = jass:find ( "XG_Macro_Get.-%(" , start)        --寻找宏标记
                if not flast then
                    break
                end
                abandon, params, last = getExpression(jass, flast)
                if params[1] then -- 替代 #table > 0
                    local param = params[1] or '""'
                    func = load("return XG_Macro_Get(" .. param .. ')', nil, nil, _env_XG_Macro_Get )
                    if func then
                        rsz = func()
                        jass = jass:sub(1, start-1) .. rsz .. jass:sub(last+1)
                    end
                end
            end

            return jass
        end
