        ----------------------------------------------------
        --                  声明
        ----------------------------------------------------
        
        ----------------------------------------------------
        --                  宏定义与调用
        ----------------------------------------------------
        
        ----------------------------------------------------
        --              编译阶段
        ----------------------------------------------------
        
        function XG_fkDoNothing_Do(jass,fkdn)
            local start,last
            local str = "call *DoNothing *%( *%) *"
            if fkdn <= 1 then
                str = "%s*call *DoNothing *%( *%) *"
            elseif fkdn == 2 then
                str = "call *DoNothing *%( *%) *"

            end
            --------------设置
            while fkdn ~= 3 do
                start,last = jass:find ( str )        --寻找宏标记
                if last then
			            jass = jass:sub(1,start - 1)  .. jass:sub(last+1)
                else
                    break
                end
            end
            -----------------
            return jass
        end
        