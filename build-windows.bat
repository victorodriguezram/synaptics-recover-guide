@echo off
rem Double-click this file to build synaptics-recover. Full guide: HOW-TO-BUILD.md
cd /d "%~dp0"
set "PATH=%~dp0w64devkit\bin;%PATH%"
set FAILED=0

where g++ >nul 2>nul
if errorlevel 1 (
    echo.
    echo ERROR: The compiler was not found.
    echo Extract w64devkit into this folder first, so that a folder named
    echo "w64devkit" is next to this file. See HOW-TO-BUILD.md, step 2.
    set FAILED=1
    goto end
)

sh build.sh
if errorlevel 1 (
    echo.
    echo ERROR: The build failed. Read the messages above.
    set FAILED=1
    goto end
)

echo.
echo SUCCESS! Your program is in the "out" folder:
dir /b out\*.exe
if not defined CI explorer out

:end
echo.
if not defined CI pause
exit /b %FAILED%
