package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

const reg = `Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\shell\_UnRen]
@="&Run UnRen Script"
"Icon"="%SystemRoot%\\System32\\shell32.dll,71"

[HKEY_CLASSES_ROOT\Directory\shell\_UnRen\command]
@="\"{CWD}\\{UNREN}\" \"%1\""
`

// adds context menu for UnRen.bat from https://f95zone.to/threads/unren-bat-v1-0-11d-rpa-extractor-rpyc-decompiler-console-developer-menu-enabler.3083/
func main() {
	cwd, err := os.Getwd()
	if err != nil {
		fmt.Println("Error getting current working directory:", err)
		return
	}

	pattern := regexp.MustCompile(`(?i)UnRen.*bat`)
	var foundFile string

	err = filepath.Walk(cwd, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.IsDir() && pattern.MatchString(info.Name()) {
			foundFile = info.Name()
			return filepath.SkipAll
		}
		return nil
	})

	if err != nil {
		fmt.Println("Error walking directory:", err)
		return
	}

	if foundFile == "" {
		fmt.Println("No file containing 'UnRen' found in the current directory")
	}

	escaped := strings.Replace(cwd, `\`, `\\`, -1)
	replaced := strings.Replace(reg, "{CWD}", escaped, -1)
	replaced = strings.Replace(replaced, `{UNREN}`, foundFile, -1)
	err = os.WriteFile(`registerContextMenu.reg`, []byte(replaced), 0770)
	if err != nil {
		fmt.Println("Error writing registerContextMenu.reg:", err)
		return
	}

	fmt.Println("Successfully wrote registerContextMenu.reg! Run it to add UnRen to the windows context menu.")
}
