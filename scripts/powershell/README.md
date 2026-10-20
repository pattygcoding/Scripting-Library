# PowerShell Scripts by Patrick Goodwin
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://docs.microsoft.com/en-us/powershell/)

## Table of Contents
- [Angular Start](#angular-start)
- [Cache Visual Studio Index](#cache-visual-studio-index)
- [Clear Git](#clear-git)
- [Compare Diff](#compare-diff)
- [Compress Git](#compress-git)
- [Connect Four](#connect-four)
- [Count Files](#count-files)
- [Create File](#create-file)
- [Dotnet Analysis](#dotnet-analysis)
- [Gensql Col](#gensql-col)
- [Gensql Count](#gensql-count)
- [India Time](#india-time)
- [Ip](#ip)
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
- [Svelte Start](#svelte-start)
- [Time](#time)
- [Undo Commit](#undo-commit)
- [Unit Tests](#unit-tests)
- [Update Git](#update-git)
- [Update Git All](#update-git-all)
- [Vs](#vs)
- [Vsc](#vsc)
- [Vue Start](#vue-start)
    

# Angular Start
Starts an Angular development server and automatically opens the application in Chrome browser.

### Dependencies
- **Angular CLI**: Must be installed (`npm install -g @angular/cli`)
- **Chrome**: Must be installed and accessible from PATH

### Parameters
- None.

### Example Usage
```
ng-start
```

## Cache Visual Studio Index
Creates and updates an index of .cs files in the current directory tree. Tracks changes in file locations and reports additions, deletions, and modifications.

### Dependencies
Must have write access to an index file in the directory you are executing

### Parameters
- `-Root`: Root directory to scan (default: current location)
- `-IndexFile`: Path to the index file (must be specified)

### Example Usage
```
cache-vsindex -Root "C:\MyProject" -IndexFile "index.txt"
```

## Clear Git
This script deletes all local branches that are not currently published. I like to use this branch because there is a Visual Studio bug that sometimes causes many past branches to locally respawn upon rebooting the app, causing unwanted clutter.

**NOTE:** You should not use this command if you don't regularly push your changes. I almost always push my commits immediately after creating them, so this is practical for me, but if you have unpublished branches with many commits, don't use this command until you publish them (or else you will lose your branch). Also, this command will not delete any branches you are currently checked out on.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- None.

### Example Usage
```
Clear-Git
```

## Compare Diff
Compares two files line by line and highlights the differences. It can also ignore timestamps if specified.

### Dependencies
Must have 2 named .txt files in the same directory you are executing in (see parameters)

### Parameters
- `-f1`: First file to compare (default: "TestFile1.txt").
- `-f2`: Second file to compare (default: "TestFile2.txt").
- `-notime`: Switch to ignore timestamps in the comparison.

### Example Usage
```
compare-diff -f1 "File1.txt" -f2 "File2.txt" -notime
```
## Connect Four
A fully functional Connect Four game, complete with color coded pieces and win checking.

### Parameters
- `-p1`: First player name (default: "Player 1").
- `-p2`: Second player name (default: "Player 2").

### Example Usage
```
connect-four -p1 "Bob" -p2 "Ryan"
```

## Compress Git
Compresses all changes in your current branch into a single commit by resetting to origin/main and making a new commit with all changes. This is useful for squashing multiple commits.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-message`: Commit message for the compressed commit (mandatory)

### Example Usage
```
Compress-Git -message "Feature implementation"
```

## Count Files
Counts and groups files by their extensions in the current directory and its subdirectories. It can exclude files in node_modules unless specified.

### Parameters
- `-includenode`: Switch to include files in node_modules.

### Example Usage
```
count-files -includenode
```

## Create File
Creates a new file with the specified name. Automatically adds .txt extension if no file extension is provided.

### Parameters
- `-Name`: Name of the file to create (mandatory)

### Example Usage
```
create-file "myfile"
create-file "document.txt"
```

## Dotnet Analysis
Analyzes dotnet backend output on the terminal and sorts outputs to find specific calls to APIs and methods.

### Dependencies
Must have a named .txt files in the same directory you are executing in (see parameters)

### Parameters
- `-f`: File to read (default: "TestFile1.txt").

### Example Usage
```
dotnet-analysis -f "file.txt"
```

## Gensql Col
Generates a SQL script that you can use to search for all instances in your DB of that column name

### Parameters:
`-c`: The name of the column to search

### Example usage:
```
gensql-col -c "NewId"
```

## Gensql Count
Generates a SQL script that you can use to count the number of entries in a given table

### Parameters:
`-t`: The name of the table

### Example usage:
```
gensql-count -c "[db].[Table]"
```

## Ip
Returns your IP address on demand.

### Example Usage
```
ip
```

## India Time
Converts time to India Standard Time (IST). Can show current time in India or convert a specified time to IST.

### Parameters
- `-InputTime`: Time to convert in format 'HH:MM AM/PM' (optional - shows current time if omitted)

### Example Usage
```
india-time
india-time -InputTime "8:26 AM"
```

## Neovim
Searches for a specified file in the current directory and its subdirectories, then opens it in Neovim.

### Dependencies
Neovim (must have it in your PATH as an environment variable)

### Parameters
- `-f`: The name of the file to search for (mandatory).

### Example Usage
```
neovim -f "example.txt"
```

## New Branch
Creates a new Git branch from origin/master, merges the latest changes, and pushes the new branch to the remote repository.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-branch`: Name of the new branch to create (mandatory)

### Example Usage
```
new-branch "feature-branch"
```

## Nginx
Starts or reloads an Nginx server. If Nginx is already running, it reloads the configuration. Otherwise, it starts a new Nginx instance.

### Dependencies
- **Nginx**: Must be installed and configured with the correct path in the script

### Parameters
- None.

### Example Usage
```
nginx
```

## Print
Enhanced Write-Host function with color support and parameter flexibility. Allows colored output with foreground/background colors.

### Parameters
- `-Object`: Objects to print (accepts multiple values)
- `-ForegroundColor`: Text color
- `-BackgroundColor`: Background color
- `-NoNewline`: Switch to suppress newline

### Example Usage
```
print "Hello World" -ForegroundColor Red
print "Text" -BackgroundColor Blue -NoNewline
```

## Random Password
Prints a random password.

### Parameters
- `-l`: The maximum length of the password allowed (default: 12).

### Example Usage
```
random-password
```

## React Start
Starts a React development server and automatically opens the application in Chrome browser.

### Dependencies
- **Node.js/npm**: Must be installed
- **Chrome**: Must be installed and accessible from PATH

### Parameters
- None.

### Example Usage
```
react-start
```

## Rebase Git
Rebases the current branch onto origin/master or a specified branch. Maintains a clean commit history by applying commits on top of the target branch.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-branch`: Branch to rebase onto (default: "master")

### Example Usage
```
rebase-git
rebase-git -branch "main"
```

## Rebase Git All
Rebases all local branches in the repository onto their respective upstream branches. Processes each branch automatically.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- None.

### Example Usage
```
rebase-git-all
```

## Regvim
Searches for a specified file in the current directory and its subdirectories, then opens it in Vim.

### Parameters
- `-f`: The name of the file to search for (mandatory).

### Example Usage
```
regvim -f "example.txt"
```

## Reset Git
Resets the current branch to match origin/main exactly, discarding all local changes. This is a destructive operation that removes uncommitted changes.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- None.

### Example Usage
```
Reset-Git
```

## Safe Unzip
Safely extracts ZIP files with security checks to prevent zip bombs and directory traversal attacks. Limits file count and total extraction size.

### Parameters
- `-ZipPath`: Path to the ZIP file to extract (mandatory)
- `-MAX_FILE_COUNT`: Maximum number of files allowed (default: 1000)
- `-MAX_TOTAL_SIZE_BYTES`: Maximum total extraction size in bytes (default: 500MB)

### Example Usage
```
safe-unzip "archive.zip"
safe-unzip "archive.zip" -MAX_FILE_COUNT 500 -MAX_TOTAL_SIZE_BYTES 104857600
```

## Search Match
Searches for files with a specific extension containing specified strings. It can limit results, perform cross-term searches, display full directories, and filter for method calls.

### Dependencies
Vim (must have it in your PATH as an environment variable)

### Parameters
- `-e`: File extension to search for.
- `-s`: Array of strings to search for within the files.
- `-uncapped`: Switch to list more than 3000 results.
- `-cross`: Switch to search for files containing all strings.
- `-dir`: Switch to display the full file directories.
- `-calls`: Switch to filter for lines where the string is used as a method call.

### Example Usage
```
search-match -e ".cs" -s "SearchTerm1", "SearchTerm2" -cross -dir
```

## Stack Trace
Parses stack trace files to extract and display relative file paths, filtering out Microsoft framework calls for cleaner debugging output.

### Parameters
- `-Path`: Path to the stack trace file (default: "test.txt")

### Example Usage
```
stack-trace
stack-trace -Path "error.txt"
```

## Svelte Start
Starts a Svelte development server and automatically opens the application in Chrome browser.

### Dependencies
- **Node.js/npm**: Must be installed
- **Chrome**: Must be installed and accessible from PATH

### Parameters
- None.

### Example Usage
```
svelte-start
```

## Time
Outputs the time of any operation.

### Parameters
- `-f`: The operation to measure

### Example Usage
```
time -f { Write-Output "Hello World" }
```
## Unit-Tests
Runs all of the unit tests in the specified folder with `.csproj`.

### Dependencies
- You must be in the base folder for the unit test project.

### Parameters
- None. (for now)

### Example Usage
```
Unit-Tests
```

## Undo Commit
Undoes the last commit using git reset. Supports different reset modes (hard, mixed, soft) and automatically pushes the changes.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-mode`: Reset mode - "hard", "mixed", or "soft" (default: "hard")

### Example Usage
```
undo-commit
undo-commit -mode "soft"
```

## Update Git
Fetches the latest changes from the remote repository and merges them into the current branch. Can specify a branch to merge from.

### Dependencies
Git

### Parameters
- `-branch`: The branch to merge into the current branch (default: "master").

### Example Usage
```
update-git
```

## Update Git All
Updates all local branches in the repository by checking out each branch and running update-git on it. Processes all branches automatically.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- None.

### Example Usage
```
Update-Git-All
```

## Vs
Searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio.

### Dependencies
Visual Studio (must have it in your PATH as an environment variable)

### Parameters
- `-f`: Name of the file to search for (mandatory).

### Example Usage
```
vs -f "example.cs"
```
## Vsc
Searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio Code.

### Dependencies
Visual Studio Code (must have it in your PATH as an environment variable)

### Parameters
- `-f`: Name of the file to search for (mandatory).

### Example Usage
```
vsc -f "example.js"
```

## Vue Start
Starts a Vue development server and automatically opens the application in Chrome browser.

### Dependencies
- **Node.js/npm**: Must be installed
- **Chrome**: Must be installed and accessible from PATH

### Parameters
- None.

### Example Usage
```
vue-start
```
