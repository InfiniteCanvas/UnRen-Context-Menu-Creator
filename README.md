# UnRen Context Menu Creator
Generates a .reg file that generates a windows context menu entry.<br>
That command points to the modified UnRen .bat file and executes it.<br>
It was modified to set the working folders properly.<br>

## How to use

1. Run `UnRenContextMenuCreator.exe` (do it in a console to get logs)
2. A `registerContextMenu.reg` file will be generated; run it
3. Now a new context menu should pop up when you right-click a folder - use it to run UnRen

It should work as long as you click on the game's main folder or the `game` folder in it.

## Why did you write a whole app for this?

At first I was just going to share the .reg file I made and explain how to set the path properly. But I might as well just use 15 minutes to make this easier for everyone and easier for me to update, if UnRen gets updated.

## How do I update this?

If you have git, you can use `git pull`, if not, just download the new .exe and .bat files.

## What did I modify in the UnRen.bat?

This is the git diff
```
diff --git "a/.\\UnRen-1.0.11d.bat" "b/.\\UnRen-1.0.11d_modified.bat"

index 9445730..403d18b 100644

--- "a/.\\UnRen-1.0.11d.bat"

+++ "b/.\\UnRen-1.0.11d_modified.bat"

@@ -197,10 +197,12 @@ set "PY3=py3-%PY%"

 set python3=false

 set "_os_bitness=x86_64"

 set "_python_bitness=i686"

-set "currentdir=%~dp0%"

+set "currentdir=%~1"

+if not "%currentdir:~-1%"=="\" set "currentdir=%currentdir%\"

+cd /d "%~1"



 REM Start by guessing we began in the game\ directory

-for %%d in ("%~dp0.") do set "maindir=%%~dpd"

+set "maindir=%~1\..\"

 set "pythondir=%maindir%lib\"

 set "pythonlibdir=%maindir%lib\"

 set "renpydir=%maindir%renpy\"

@@ -999,4 +1001,4 @@ REM Restore the original codepage

 chcp %cporig%>nul



 endlocal

-rem exit

\ No newline at end of file

+rem exit
```
