# Lua Scripts by Patrick Goodwin
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)

## Table of Contents
- [Clear Git](#clear-git)
- [Count Files](#count-files)
- [Dotnet Analysis](#dotnet-analysis)
- [JSON to CSV](#json-to-csv)
- [Random Password](#random-password)
- [Rebase Git](#rebase-git)
- [Reset Git](#reset-git)
- [Undo Commit](#undo-commit)
- [Update Git](#update-git)

## Clear Git
This script cleans up local Git branches by deleting branches that don't have upstream tracking. It helps maintain a clean local repository by removing branches that are no longer connected to remote branches.

### Example Usage
```lua
lua clear-git.lua
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```
lua count_files.lua
```

## Dotnet Analysis
This script analyzes .NET application log files to extract and display executed action methods, actions, endpoints, and database commands. It provides colored output and groups similar database operations for better readability.

### Arguments
- `filename`: The log file to analyze (default is `TestFile1.txt`)

### Dependencies
- Standard Lua libraries (no external dependencies required)

### Example Usage
```lua
lua dotnet-analysis.lua logfile.txt
```

## JSON to CSV
This script converts JSON files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers derived from the object keys.

### Dependencies
- `dkjson`: JSON parsing library for Lua

### Example Usage
```lua
lua json_to_csv.lua
```

### Notes
- Input file: `data.json` (expected to contain an array of objects)
- Output file: `data.csv` (created automatically)
- Make sure the `dkjson` library is installed before running

## Random Password
This script generates a random password with customizable length using a mix of lowercase letters, uppercase letters, numbers, and special characters.

### Arguments
- `length`: Optional parameter to specify password length (default is 12)

### Example Usage
```lua
lua random_password.lua
```

## Rebase Git
This script rebases the current Git branch onto another branch (default is `master`) and pushes the changes using force-with-lease to maintain a clean linear history.

### Arguments  
- `branch`: The branch to rebase onto (default is `master`)

### Example Usage
```lua
lua rebase-git.lua develop
```

## Reset Git
This script resets the current Git branch to match the state of `origin/main` and force pushes the changes. This is useful for completely resetting a branch to its remote state.

### Example Usage
```lua
lua reset-git.lua
```

### Warning
This operation is destructive and will permanently remove any local changes or commits that haven't been pushed to the remote branch.

## Undo Commit
This script undoes the last Git commit using different reset modes and force pushes the changes to the remote repository.

### Arguments
- `mode`: The reset mode to use - `hard`, `mixed`, or `soft` (default is `hard`)
  - `hard`: Resets index and working tree (removes all changes)
  - `mixed`: Resets index but not working tree (keeps file changes unstaged)  
  - `soft`: Keeps index and working tree (keeps file changes staged)

### Example Usage
```lua
lua undo-commit.lua soft
```

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Arguments
- `-branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```
lua update_git.lua -branch develop
```
