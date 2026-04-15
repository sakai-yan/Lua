@echo off
cd /d %~dp0


if not exist bin\ydbase.dll (
	echo 把这个文件放到编辑器目录运行
	goto end
)

tasklist|find /i "worldeditydwe.exe" >nul
if %errorlevel%==0 (
	echo 请先关闭编辑器！
	goto end
)

cd %~dp0\plugin


if not exist bgColor (
	goto pluginNotExist
)
if not exist PathSelector (
	goto pluginNotExist
)

echo %cd%
echo.
echo 有的用户由于系统原因不兼容插件,导致打不开编辑器、打开地图、新建地图闪退，临时解决办法为禁用雪月插件
echo 其中包含: 雪月颜色插件、字体插件、虚拟MPQ路径选择器
echo.
echo 禁用插件前可手动尝试:打开编辑器目录下的XueYue文件夹，更改ico图标默认打开方式为照片或画图

echo.
echo 1.禁用
echo 2.重新启用
echo.
echo.
set /p inpt=请输入选项序号并确认:


if %inpt%==1 (
    goto disable
) else if %inpt%==2 (
    goto enable
)


goto end

:disable
ren bgColor\*.plcfg *.disable 2>nul
ren PathSelector\*plcfg *.disable 2>nul
goto end

:enable
ren bgColor\*.disable *.plcfg 2>nul
ren PathSelector\*disable *.plcfg 2>nul
goto end

:pluginNotExist
echo.
echo.
echo 未检测到插件,该补丁不适用于此版本

:end
echo.
echo.
echo 如无效请尝试右键 使用管理员身份运行
echo.
pause