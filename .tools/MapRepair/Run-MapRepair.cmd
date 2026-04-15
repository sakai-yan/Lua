@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "EXE_PATH=%SCRIPT_DIR%publish\win-x64-self-contained\MapRepair.exe"

if not exist "%EXE_PATH%" (
    echo MapRepair.exe not found:
    echo   %EXE_PATH%
    echo.
    echo Please build the package first or check the publish folder.
    pause
    exit /b 1
)

start "" "%EXE_PATH%"
exit /b 0
