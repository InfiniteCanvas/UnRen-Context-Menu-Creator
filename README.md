# UnRen Context Menu Creator

Adds a Windows right-click context menu entry on folders that extracts the upstream UnRen-forall tool (from https://github.com/Lurmel/UnRen-forall) into the selected folder and runs it. The zip and a small launcher script are cached in `%LOCALAPPDATA%\UnRen-ContextMenu\`, so this repo folder is not needed after install.

## How to use

1. Run `createAddCtxMenu.bat` (do it in a console to get logs). It downloads the UnRen zip to the cache, installs the launcher there, and generates `registerContextMenu.reg`.
2. Run the generated `registerContextMenu.reg` (needs admin) to add the context menu entry.
3. Right-click a Ren'Py game's root folder and pick "Run UnRen Script" - the tool is extracted into that folder and started on it.

## How do I update this?

`git pull` (or download the new release files), then re-run `createAddCtxMenu.bat` - it overwrites the cached zip and launcher with the new version.

## Note

The UnRen files are extracted into the game folder and left there.
