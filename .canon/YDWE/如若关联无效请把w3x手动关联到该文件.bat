@rem "关联w3x w3m"
@rem "By 雪月灬雪歌"
@echo off
@cls

set ydpath=%~dp0%
set ydpath=%ydpath:~0,-1%

set we=雪月WE.exe
cd /d "%~dp0"
echo %~dp0
echo %cd%

start %we% -loadfile "%1"