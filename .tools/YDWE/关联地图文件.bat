@rem "关联w3x w3m"
@rem "By 雪月灬雪歌"
@echo off
@cls

set ydpath=%~dp0%
set ydpath=%ydpath:~0,-1%

set we=雪月WE.exe
echo "---- 创建菜单 ----"
REG ADD HKCR\YDWEMap /ve /t REG_SZ /d "YDWE Map File" /f
REG ADD HKCR\YDWEMap\DefaultIcon /ve /t REG_SZ /d "%ydpath%\bin\logo.ico" /f
REG ADD HKCR\YDWEMap\shell\open\command /ve /t REG_SZ /d "\"%ydpath%\%we%\" -loadfile \"%%1\"" /f
REG ADD HKCR\YDWEMap\shell\run_war3 /ve /t REG_SZ /d "使用雪月WE测试地图" /f
REG ADD HKCR\YDWEMap\shell\run_war3\command /ve /t REG_SZ /d "\"%ydpath%\bin\ydweconfig.exe\" -launchwar3 -loadfile \"%%1\"" /f

echo.

echo "---- 关联到 w3x ----"
REG ADD HKCR\.w3x /ve /t REG_SZ /d "YDWEMap" /f

echo.

echo "---- 关联到 w3m ----"
REG ADD HKCR\.w3m /ve /t REG_SZ /d "YDWEMap" /f

echo.
@echo 10秒后将自动关闭执行结果窗口
@echo 按任意键提前关闭窗口
@echo.
@echo.
@echo 如若关联无效,请尝试右键管理员身份运行
@echo.
@timeout 10