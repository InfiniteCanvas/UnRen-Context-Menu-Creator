@echo off
setlocal

:: --- Config ----------------------------------------------------------------
set "ZIP_URL=https://github.com/Lurmel/UnRen-forall/releases/download/main/UnRen-forall-la_0.77-le_9.7.60-cu_9.7.80.zip"
set "CACHE_DIR=%LOCALAPPDATA%\UnRen-ContextMenu"
set "ZIP_FILE=%CACHE_DIR%\UnRen-forall.zip"

set "TARGET=%~1"
if not defined TARGET (
    echo No folder was passed to the launcher.
    pause
    exit /b 1
)
if not exist "%TARGET%\" (
    echo Folder does not exist: "%TARGET%"
    pause
    exit /b 1
)
if "%TARGET:~-1%"=="\" set "TARGET=%TARGET:~0,-1%"

:: Paths get interpolated into single-quoted PowerShell strings, so double any single quotes
set "TARGET_PS=%TARGET:'=''%"
set "ZIP_PS=%ZIP_FILE:'=''%"
set "URL_PS=%ZIP_URL:'=''%"

if not exist "%ZIP_FILE%" (
    call :download
    if errorlevel 1 exit /b 1
)

:extract
echo Extracting UnRen into "%TARGET%"...
powershell.exe -nologo -noprofile -noninteractive -command "try { Expand-Archive -Force '%ZIP_PS%' '%TARGET_PS%' } catch { exit 1 }"
if errorlevel 1 (
    if defined RETRY (
        echo Extraction failed again. Please delete "%CACHE_DIR%" and run the installer again.
        pause
        exit /b 1
    )
    echo Extraction failed - the cached zip looks corrupt. Re-downloading it...
    del "%ZIP_FILE%"
    call :download
    if errorlevel 1 exit /b 1
    set "RETRY=1"
    goto :extract
)

:: The zip may carry a top-level folder, so also look one level deep
set "FORALL=%TARGET%\UnRen-forall.bat"
if not exist "%FORALL%" (
    for /d %%D in ("%TARGET%\*") do (
        if not exist "%FORALL%" if exist "%%D\UnRen-forall.bat" set "FORALL=%%D\UnRen-forall.bat"
    )
)
if not exist "%FORALL%" (
    echo Could not find UnRen-forall.bat in "%TARGET%".
    pause
    exit /b 1
)

cd /d "%TARGET%"
call "%FORALL%" "%TARGET%"
exit /b %errorlevel%

:download
if not exist "%CACHE_DIR%" mkdir "%CACHE_DIR%"
echo Downloading UnRen zip...
echo   from: %ZIP_URL%
echo   to:   %ZIP_FILE%
powershell.exe -nologo -noprofile -noninteractive -command "try { [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%URL_PS%','%ZIP_PS%') } catch { exit 1 }"
if errorlevel 1 (
    echo Download failed. Check your internet connection.
    pause
    exit /b 1
)
exit /b 0
