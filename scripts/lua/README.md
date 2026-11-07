# Lua Scripts by Patrick Goodwin
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)

## Table of Contents
- [Angular Start](#angular-start)
- [Cache Visual Studio Index](#cache-visual-studio-index)
- [Clear Downloads](#clear-downloads)
- [Clear Git](#clear-git)
- [Compare Diff](#compare-diff)
- [Compress Git](#compress-git)
- [Connect Four](#connect-four)
- [Count Files](#count-files)
- [Create File](#create-file)
- [Dotnet Analysis](#dotnet-analysis)
- [Gensql Col](#gensql-col)
- [Gensql Count](#gensql-count)
- [Goto](#goto)
- [India Time](#india-time)
- [Ip](#ip)
- [JSON to CSV](#json-to-csv)
- [Neovim](#neovim)
- [New Branch](#new-branch)
- [Nginx](#nginx)
- [Print](#print)
- [Random Password](#random-password)
- [React Start](#react-start)
- [Rebase Git](#rebase-git)
- [Rebase Git All](#rebase-git-all)
- [Regvim](#regvim)
- [Reset Git](#reset-git)
- [Safe Unzip](#safe-unzip)
- [Search Match](#search-match)
- [Stack Trace](#stack-trace)
- [Start Mod](#start-mod)
- [Svelte Start](#svelte-start)
- [Time](#time)
- [Undo Commit](#undo-commit)
- [Unit Tests](#unit-tests)
- [Update Git](#update-git)
- [Update Git All](#update-git-all)
- [Vs](#vs)
- [Vsc](#vsc)
- [Vue Start](#vue-start)

## Angular Start
This script starts an Angular development server and opens it in Chrome.

### Dependencies
- **Angular CLI**: `npm install -g @angular/cli`

### Arguments
- `--port`: Dev server port. Defaults to `4200`.
- `--command`: Command to run. Defaults to `ng serve`.

### Example Usage
```lua
lua angular-start.lua
```

## Cache Visual Studio Index
This script builds and updates an index of `.cs` files under a directory tree. It maps each file's base name to the directories that contain it and reports the entries that were added, removed, or changed.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`

### Arguments
- `--root`: Root directory to scan. Defaults to the current directory.
- `--index-file`: Path to the index file to create or update (required).

### Example Usage
```lua
lua cache-vsindex.lua --root "C:\MyProject" --index-file index.txt
```

## Clear Downloads
This script permanently deletes everything inside the Downloads folder.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`

### Arguments
- `directory`: Folder to clear. Defaults to `~/Downloads`.

### Example Usage
```lua
lua clear-downloads.lua
```

## Clear Git
This script cleans up local Git branches by deleting branches that don't have upstream tracking. It helps maintain a clean local repository by removing branches that are no longer connected to remote branches.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```lua
lua clear-git.lua
```

## Compare Diff
This script compares two files line by line and highlights the differences. It also has an optional feature to ignore timestamps during the comparison.

### Arguments
- `file1`: The first file to compare. Defaults to `TestFile1.txt`.
- `file2`: The second file to compare. Defaults to `TestFile2.txt`.
- `--notime`: Optional flag to remove timestamps before comparing.

### Example Usage
```lua
lua compare-diff.lua file1.txt file2.txt
```

## Compress Git
This script squashes all changes on the current branch into a single commit by resetting to `origin/main` and committing everything, then force-pushing.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `message`: Commit message for the squashed commit (required).

### Example Usage
```lua
lua compress-git.lua "Feature implementation"
```

## Connect Four
This script plays a two-player game of Connect Four in the console, with color-coded pieces and win detection.

### Arguments
- `--p1`: First player name. Defaults to `Player 1`.
- `--p2`: Second player name. Defaults to `Player 2`.

### Example Usage
```lua
lua connect-four.lua --p1 Bob --p2 Ryan
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```lua
lua count_files.lua
```

## Create File
This script creates a new file. If no extension is given, `.txt` is appended.

### Arguments
- `name`: Name of the file to create (required).

### Example Usage
```lua
lua create-file.lua myfile
lua create-file.lua document.txt
```

## Dotnet Analysis
This script analyzes .NET application log files to extract and display executed action methods, actions, endpoints, and database commands. It provides colored output and groups similar database operations for better readability.

### Arguments
- `filename`: The log file to analyze. Defaults to `TestFile1.txt`.

### Dependencies
- Standard Lua libraries (no external dependencies required)

### Example Usage
```lua
lua dotnet-analysis.lua logfile.txt
```

## Gensql Col
This script generates a SQL script you can use to search for every occurrence of a column name in a database.

### Arguments
- `-c`, `--column`: The column name (or fragment) to search for (required).

### Example Usage
```lua
lua gensql-col.lua -c NewId
```

## Gensql Count
This script generates a SQL script you can use to count the number of entries in a given table.

### Arguments
- `-t`, `--table`: The table name (optionally schema-qualified) (required).

### Example Usage
```lua
lua gensql-count.lua -t "[db].[Table]"
```

## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` table.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(lua goto.lua repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```lua
cd "$(lua goto.lua repos)"
```

## India Time
This script converts a time to India Standard Time (IST). With no argument it shows the current time in India.

### Arguments
- `time`: Local time to convert, e.g. `8:26 AM`. If omitted, the current time is shown.

### Example Usage
```lua
lua india-time.lua
lua india-time.lua "8:26 AM"
```

## Ip
This script returns your IP address on demand.

### Example Usage
```lua
lua ip.lua
```

## JSON to CSV
This script converts JSON files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers derived from the object keys.

### Dependencies
- `dkjson`: `luarocks install dkjson`

### Arguments
- `json_file`: Input JSON file. Defaults to `data.json`.
- `csv_file`: Output CSV file. Defaults to `data.csv`.

### Example Usage
```lua
lua json_to_csv.lua data.json data.csv
```

## Neovim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Neovim.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Neovim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua neovim.lua example.txt
```

## New Branch
This script creates a new Git branch from `origin/master`, merges the latest changes, and pushes the new branch to the remote.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `branch`: Name of the new branch to create (required).

### Example Usage
```lua
lua new-branch.lua feature-branch
```

## Nginx
This script starts or reloads an Nginx server. If Nginx is already running it reloads the configuration; otherwise it starts a new instance.

### Dependencies
- **Nginx**: Must be installed, with its path passed with `--base`.

### Arguments
- `--base`: Nginx installation directory.

### Example Usage
```lua
lua nginx.lua --base "C:\nginx"
```

## Print
This script prints text with optional ANSI color.

### Arguments
- `message`: The text to print (one or more words).
- `--color`: Foreground color (black, red, green, yellow, blue, magenta, cyan, white).
- `--no-newline`: Do not print a trailing newline.

### Example Usage
```lua
lua print.lua "Hello World" --color red
lua print.lua "Text" --color blue --no-newline
```

## Random Password
This script generates a random password with customizable length using a mix of lowercase letters, uppercase letters, numbers, and special characters.

### Arguments
- `length`: Optional parameter to specify password length. Defaults to `12`.

### Example Usage
```lua
lua random_password.lua
lua random_password.lua 24
```

## React Start
This script starts a React development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `3000`.
- `--command`: Command to run. Defaults to `npm start`.

### Example Usage
```lua
lua react-start.lua
```

## Rebase Git
This script rebases the current Git branch onto another branch (default is `master`) and pushes the changes using force-with-lease to maintain a clean linear history.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `branch`: The branch to rebase onto. Defaults to `master`.

### Example Usage
```lua
lua rebase-git.lua develop
```

## Rebase Git All
This script rebases every local branch onto its upstream, checking out each branch in turn. It stops if a rebase fails so conflicts can be resolved manually.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```lua
lua rebase-git-all.lua
```

## Regvim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Vim.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Vim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua regvim.lua example.txt
```

## Reset Git
This script resets the current Git branch to match the state of `origin/main` and force pushes the changes. This is useful for completely resetting a branch to its remote state.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```lua
lua reset-git.lua
```

### Warning
This operation is destructive and will permanently remove any local changes or commits that haven't been pushed to the remote branch.

## Safe Unzip
This script safely extracts a ZIP file, rejecting unsafe (path-traversal) entries and aborting if the file count or total uncompressed size exceeds the configured limits. It reads the ZIP central directory to validate the archive before extracting.

### Dependencies
- Windows: PowerShell (`Expand-Archive`)
- POSIX: `unzip`

### Arguments
- `zip_path`: Path to the ZIP file to extract (required).
- `--max-file-count`: Maximum number of files allowed. Defaults to `1000`.
- `--max-total-size`: Maximum total uncompressed size in bytes. Defaults to `524288000` (500 MB).

### Example Usage
```lua
lua safe-unzip.lua archive.zip
lua safe-unzip.lua archive.zip --max-file-count 500 --max-total-size 104857600
```

## Search Match
This script searches for patterns in files within the current directory and its subdirectories. It supports various options, including uncapped results, cross-term search, full directory display, and filtering based on function call patterns.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`

### Arguments
- `extension`: File extension to search (e.g., `.txt`).
- `terms`: One or more terms to search for in the files.
- `--uncapped`: List more than the limit of 3000 results.
- `--cross`: Only search for files that contain all of the specified terms.
- `--dir`: Display the full file directories, not just the file names.
- `--calls`: Display only if there is a period (.) before the string. Useful for locating function calls.

### Example Usage
```lua
lua search-match.lua .cs Term1 Term2
```

## Stack Trace
This script parses a stack trace file and prints the relative file path from each frame, filtering out Microsoft framework calls for cleaner debugging output.

### Arguments
- `path`: Path to the stack trace file. Defaults to `test.txt`.

### Example Usage
```lua
lua stack-trace.lua
lua stack-trace.lua error.txt
```

## Start Mod
This script builds and launches a Minecraft mod client via the Gradle wrapper (`gradlew clean build` then `gradlew runClient`). Run it from the mod project directory.

### Arguments
- `--skip-build`: Skip `gradlew clean build` and only run the client.

### Example Usage
```lua
lua start-mod.lua
```

## Svelte Start
This script starts a Svelte development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```lua
lua svelte-start.lua
```

## Time
This script times any operation, printing how long the given command took to run.

### Dependencies
- `socket` (LuaSocket): `luarocks install luasocket` (optional; enables high-resolution timing)

### Arguments
- `command`: The command to run and time (required).

### Example Usage
```lua
lua time.lua ping example.com
```

## Undo Commit
This script undoes the last Git commit using different reset modes and force pushes the changes to the remote repository.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `mode`: The reset mode to use - `hard`, `mixed`, or `soft` (default is `hard`)
  - `hard`: Resets index and working tree (removes all changes)
  - `mixed`: Resets index but not working tree (keeps file changes unstaged)
  - `soft`: Keeps index and working tree (keeps file changes staged)

### Example Usage
```lua
lua undo-commit.lua soft
```

## Unit Tests
This script cleans, builds, and tests a .NET unit test project with `dotnet clean`, `dotnet build`, and `dotnet test`.

### Dependencies
- **.NET SDK**: `dotnet` must be in your PATH

### Arguments
- `--project`: Path to the `.csproj` to test. Defaults to the `PROJECT_PATH` constant.

### Example Usage
```lua
lua unit-tests.lua --project MyProject.Tests.csproj
```

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```lua
lua update_git.lua --branch develop
```

## Update Git All
This script updates all local branches by checking out each branch and running the update-git steps on it, fetching and merging the latest changes.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```lua
lua update-git-all.lua
```

## Vs
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio. A bare class name is treated as `<name>.cs`.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Visual Studio**: `devenv.exe` must be in your PATH

### Arguments
- `file`: File name or C# class name to search for (required).

### Example Usage
```lua
lua vs.lua example.cs
lua vs.lua Program
```

## Vsc
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio Code.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **VS Code**: `code` must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua vsc.lua example.js
```

## Vue Start
This script starts a Vue development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```lua
lua vue-start.lua
```
