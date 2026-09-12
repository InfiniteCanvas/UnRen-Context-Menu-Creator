@echo off
setlocal

:: --- Config ----------------------------------------------------------------
set "ZIP_URL=https://github.com/Lurmel/UnRen-forall/releases/download/main/UnRen-forall-la_0.77-le_9.7.60-cu_9.7.80.zip"
set "CACHE_DIR=%LOCALAPPDATA%\UnRen-ContextMenu"
set "ZIP_FILE=%CACHE_DIR%\UnRen-forall.zip"
set "LAUNCHER_DST=%CACHE_DIR%\runUnRen.bat"

:: Paths get interpolated into single-quoted PowerShell strings, so double any single quotes
set "ZIP_PS=%ZIP_FILE:'=''%"
set "URL_PS=%ZIP_URL:'=''%"

:: The launcher must ship next to this installer
if not exist "%~dp0runUnRen.bat" (
    echo runUnRen.bat was not found next to createAddCtxMenu.bat.
    echo Both files must be in the same folder.
    pause
    exit /b 1
)

if not exist "%CACHE_DIR%" mkdir "%CACHE_DIR%"

echo Installing launcher to "%LAUNCHER_DST%"...
copy /Y "%~dp0runUnRen.bat" "%LAUNCHER_DST%"
if errorlevel 1 (
    echo Failed to copy the launcher.
    pause
    exit /b 1
)

:: Always re-download so users can refresh the cache after updating the repo
echo Downloading UnRen zip...
echo   from: %ZIP_URL%
echo   to:   %ZIP_FILE%
powershell.exe -nologo -noprofile -noninteractive -command "try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%URL_PS%','%ZIP_PS%') } catch { exit 1 }"
if errorlevel 1 (
    echo Download failed
    pause
    exit /b 1
)

:: Double the backslashes for the .reg string values
set "launcher=%LAUNCHER_DST%"
set "launcher=%launcher:\=\\%"

set "REG_FILE=%~dp0registerContextMenu.reg"
>"%REG_FILE%" echo Windows Registry Editor Version 5.00
>>"%REG_FILE%" echo(
>>"%REG_FILE%" echo [HKEY_CLASSES_ROOT\Directory\shell\_UnRen]
>>"%REG_FILE%" echo @="&Run UnRen Script"
>>"%REG_FILE%" echo "Icon"="%%SystemRoot%%\\System32\\shell32.dll,71"
>>"%REG_FILE%" echo(
>>"%REG_FILE%" echo [HKEY_CLASSES_ROOT\Directory\shell\_UnRen\command]
>>"%REG_FILE%" echo @="\"%launcher%\" \"%%1\""

echo.
echo Done!
echo Cache location:    %CACHE_DIR%
echo Reg file written:  %REG_FILE%
echo.
echo Run registerContextMenu.reg to register the context menu entry.
pause
