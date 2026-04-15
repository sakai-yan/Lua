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
        --              转化函数块为代码行
        --                  预编译
        ----------------------------------------------------
        function XG_Macro_Compile(m)
            
            --for k, v in pairs(XG_Macro_Func) do
            --    if k == m then      --函数
                    
                    return 'XG_Macro_FuncX("' .. XG_Macro [ m ] .. '")'
                    
            --    end
            --end 
        end
        
        ----------------------------------------------------
        --                  宏定义与调用
        ----------------------------------------------------
        function XG_Macro_Set ( m, c )
            c = c:lighter()     --去首尾空
            if c:find("function") then      --传入函数
                c = c:match( "function ([_*%w]+)" )      --去除函数头 增加括号 可用于直接调用
                XG_Macro_Func[ m ] = true       --记录函数名 后期处理
                log.trace("function match",m,XG_Macro_Func[ m ])
            end
            XG_Macro [ m ] = c
        end
        function XG_Macro_Get ( m )
            if XG_Macro_Func[ m ] then 
                return XG_Macro_Compile ( m )
            end
            return XG_Macro [ m ]
        end
        ----------------------------------------------------
        --              编译阶段
        ----------------------------------------------------
        function XG_Macro_FuncX(m)
                local jass = pass_string
                local ss
                local rsz
                log.trace(m)
                local start,eee = jass:find( "function *" .. m .. " *takes" )
                if start then
                    
                    ss = start --删除的开始位置
                    start = jass:find( "\n",start )
                    
                    if start then
                        --start + 1
                        es,ee = jass:find( "endfunction" ,start)
                        rsz = jass:sub(start+1,es-2)
                        pass_int = jass:sub(ss,ee):len() --偏移
                        pass_string = jass:sub(1,ss-1) .. jass:sub(ee+1)
                    end
                    
                    --特殊处理
                    if rsz:sub(1,3) == "set" then
                        rsz = "DoNothing()\n" .. rsz
                    elseif rsz:sub(1,6) == "return" then
                        rsz = rsz:sub(7):lighter()
                    end
                    XG_Macro_Func[ m ] = rsz
                elseif XG_Macro_Func[ m ] then
                    rsz = XG_Macro_Func[ m ]
                end
                
            if not rsz then    
                rsz = '"XG_Macro: '.. m .. ' 未声明  |  '.. m .. '  undefined"'
            end
            return rsz
            
        end
        function XG_Macro_Compile_Do(jass)
            local start,last,j,chr,quo,func
            while true do 
                start,last = jass:find ( "XG_Macro_FuncX%(" )        --寻找宏标记
                if last then
                    j = 1;  quo = {0,0}
                    for i = last+1,jass:len() do
                        chr = jass:sub(i,i)
                        if chr == '(' and not(quo[1]%2==1 or quo[2]%2==1) then
                            j = j + 1
                        elseif chr == ')' and not(quo[1]%2==1 or quo[2]%2==1) then
                            j = j - 1               -- 当 j = 0 时括号匹配完成
                            if j == 0 then
                                last = i
                                break
                            end
                        elseif chr == "'" then
                            quo[1] = quo[1] + 1
                        elseif chr == '"' then
                            quo[2] = quo[2] + 1
                        end
                    end
                    if j == 0 then
                        pass_string = jass
                        pass_int = 0
                        func = load("return " .. jass:sub(start,last) )
                        local rsz = func()
			            jass = pass_string:sub(1,start-1-pass_int) .. rsz .. pass_string:sub(last+1-pass_int)
                    end
                else
                    break
                end
            
            end
            return jass
        end
        