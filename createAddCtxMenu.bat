@echo off
setlocal enabledelayedexpansion

:: Search for UnRen bat file in current directory
set "foundFile="
for /f "delims=" %%F in ('dir /b *.bat ^| findstr /i "UnRen.*bat"') do (
    set "foundFile=%%F"
    goto :found
)

:found
if not defined foundFile (
    echo No UnRen bat file found in current directory!
    pause
    exit /b 1
)

:: Escape backslashes in current directory
set "cwd=%cd%"
set "cwd=%cwd:\=\\%"

:: Generate registry file
(
echo Windows Registry Editor Version 5.00
echo(
echo [HKEY_CLASSES_ROOT\Directory\shell\_UnRen]
echo @="&Run UnRen Script"
echo "Icon"="%%SystemRoot%%\\System32\\shell32.dll,71"
echo(
echo [HKEY_CLASSES_ROOT\Directory\shell\_UnRen\command]
echo @="\"%cwd%\\%foundFile%\" \"%%1\""
) > registerContextMenu.reg

echo Successfully wrote registerContextMenu.reg!
echo Run it to add UnRen to the Windows context menu.
pause
