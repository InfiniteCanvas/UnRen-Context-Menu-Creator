# UnRen Context Menu Creator
Generates a .reg file that generates a windows context menu entry.<br>
That command points to the modified UnRen .bat file and executes it.<br>
It was modified to set the working folders properly.<br>

## How to use

1. Run `createAddCtxMenu.bat` (do it in a console to get logs)
2. A `registerContextMenu.reg` file will be generated; run it
3. Now a new context menu should pop up when you right-click a folder - use it to run UnRen

It should work as long as you click on the game's main folder or the `game` folder in it.

## How do I update this?

If you have git, you can use `git pull`, if not, just download the new release files.

## What did I modify in the UnRen.bat?

Windows passes the selected folder into the UnRen.bat file as a `%~1` positional argument, but that is never used in the original UnRen.bat versions. I'm simply using the passed in argument to set the current directory to the selected folder.