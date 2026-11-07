# Ruby Scripts by Patrick Goodwin
[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)

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
```ruby
ruby angular-start.rb
```

## Cache Visual Studio Index
This script builds and updates an index of `.cs` files under a directory tree. It maps each file's base name to the directories that contain it and reports the entries that were added, removed, or changed.

### Arguments
- `--root`: Root directory to scan. Defaults to the current directory.
- `--index-file`: Path to the index file to create or update (required).

### Example Usage
```ruby
ruby cache-vsindex.rb --root "C:\MyProject" --index-file index.txt
```

## Clear Downloads
This script permanently deletes everything inside the Downloads folder.

### Arguments
- `directory`: Folder to clear. Defaults to `~/Downloads`.

### Example Usage
```ruby
ruby clear-downloads.rb
```

## Clear Git
This script deletes all local branches that are not tracking an origin branch, helping to clean up your local Git repository.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```ruby
ruby clear-git.rb
```

## Compare Diff
This script compares two files line by line and highlights the differences. It also has an optional feature to ignore timestamps during the comparison.

### Arguments
- `file1`: The first file to compare. Defaults to `TestFile1.txt`.
- `file2`: The second file to compare. Defaults to `TestFile2.txt`.
- `--notime`: Optional flag to remove timestamps before comparing.

### Example Usage
```ruby
ruby compare-diff.rb file1.txt file2.txt
```

## Compress Git
This script squashes all changes on the current branch into a single commit by resetting to `origin/main` and committing everything, then force-pushing.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `message`: Commit message for the squashed commit (required).

### Example Usage
```ruby
ruby compress-git.rb "Feature implementation"
```

## Connect Four
This script plays a two-player game of Connect Four in the console, with color-coded pieces and win detection.

### Arguments
- `--p1`: First player name. Defaults to `Player 1`.
- `--p2`: Second player name. Defaults to `Player 2`.

### Example Usage
```ruby
ruby connect-four.rb --p1 Bob --p2 Ryan
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```ruby
ruby count_files.rb
```

## Create File
This script creates a new file. If no extension is given, `.txt` is appended.

### Arguments
- `name`: Name of the file to create (required).

### Example Usage
```ruby
ruby create-file.rb myfile
ruby create-file.rb document.txt
```

## Dotnet Analysis
This script analyzes .NET application log files to extract and group database commands, action methods, executed actions, and endpoints. It provides a structured view of application execution with color-coded output.

### Arguments
- `file`: The log file to analyze. Defaults to `TestFile1.txt`.

### Dependencies
- Ruby standard library (no external gems required)

### Example Usage
```ruby
ruby dotnet-analysis.rb logfile.txt
```

## Gensql Col
This script generates a SQL script you can use to search for every occurrence of a column name in a database.

### Arguments
- `-c`, `--column`: The column name (or fragment) to search for (required).

### Example Usage
```ruby
ruby gensql-col.rb -c NewId
```

## Gensql Count
This script generates a SQL script you can use to count the number of entries in a given table.

### Arguments
- `-t`, `--table`: The table name (optionally schema-qualified) (required).

### Example Usage
```ruby
ruby gensql-count.rb -t "[db].[Table]"
```

## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` map.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(ruby goto.rb repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```ruby
cd "$(ruby goto.rb repos)"
```

## India Time
This script converts a time to India Standard Time (IST). With no argument it shows the current time in India.

### Arguments
- `time`: Local time to convert, e.g. `8:26 AM`. If omitted, the current time is shown.

### Example Usage
```ruby
ruby india-time.rb
ruby india-time.rb "8:26 AM"
```

## Ip
This script returns your IP address on demand.

### Example Usage
```ruby
ruby ip.rb
```

## JSON to CSV
This script converts JSON data files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers from the object keys.

### Dependencies
- `json` gem (Ruby standard library)
- `csv` gem (Ruby standard library)

### Arguments
- `json_file`: Input JSON file. Defaults to `data.json`.
- `csv_file`: Output CSV file. Defaults to `data.csv`.

### Example Usage
```ruby
ruby json_to_csv.rb data.json data.csv
```

## Neovim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Neovim.

### Dependencies
- **Neovim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```ruby
ruby neovim.rb example.txt
```

## New Branch
This script creates a new Git branch from `origin/master`, merges the latest changes, and pushes the new branch to the remote.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `branch`: Name of the new branch to create (required).

### Example Usage
```ruby
ruby new-branch.rb feature-branch
```

## Nginx
This script starts or reloads an Nginx server. If Nginx is already running it reloads the configuration; otherwise it starts a new instance.

### Dependencies
- **Nginx**: Must be installed, with its path configured in `NGINX_BASE` or passed with `--base`.

### Arguments
- `--base`: Nginx installation directory. Defaults to the `NGINX_BASE` constant.

### Example Usage
```ruby
ruby nginx.rb --base "C:\nginx"
```

## Print
This script prints text with optional ANSI color, a small color-enabled wrapper around `print`.

### Arguments
- `message`: The text to print (one or more words).
- `--color`: Foreground color (black, red, green, yellow, blue, magenta, cyan, white).
- `--no-newline`: Do not print a trailing newline.

### Example Usage
```ruby
ruby print.rb "Hello World" --color red
ruby print.rb "Text" --color blue --no-newline
```

## Random Password
This script generates a random password.

### Arguments
- `-l`, `--length`: Password length. Defaults to `12`.

### Example Usage
```ruby
ruby random_password.rb --length 24
```

## React Start
This script starts a React development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `3000`.
- `--command`: Command to run. Defaults to `npm start`.

### Example Usage
```ruby
ruby react-start.rb
```

## Rebase Git
This script rebases the current Git branch onto a specified branch (default is `master`). It fetches the latest changes, performs the rebase, and pushes the rebased changes using `--force-with-lease` for safety.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: The branch to rebase onto (optional, defaults to `master`)

### Example Usage
```ruby
ruby rebase-git.rb
ruby rebase-git.rb --branch develop
```

## Rebase Git All
This script rebases every local branch onto its upstream, checking out each branch in turn. It stops if a rebase fails so conflicts can be resolved manually.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```ruby
ruby rebase-git-all.rb
```

## Regvim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Vim.

### Dependencies
- **Vim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```ruby
ruby regvim.rb example.txt
```

## Reset Git
This script performs a hard reset of the current Git branch to match the `origin/main` branch exactly. This will discard all local changes and commits that are not on the remote main branch.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```ruby
ruby reset-git.rb
```

**Warning:** This operation is destructive and will permanently remove local changes and commits.

## Safe Unzip
This script safely extracts a ZIP file, rejecting unsafe (path-traversal) entries and aborting if the file count or total uncompressed size exceeds the configured limits.

### Dependencies
- `rubyzip`: `gem install rubyzip`

### Arguments
- `zip_path`: Path to the ZIP file to extract (required).
- `--max-file-count`: Maximum number of files allowed. Defaults to `1000`.
- `--max-total-size`: Maximum total uncompressed size in bytes. Defaults to `524288000` (500 MB).

### Example Usage
```ruby
ruby safe-unzip.rb archive.zip
ruby safe-unzip.rb archive.zip --max-file-count 500 --max-total-size 104857600
```

## Search Match
This script searches for patterns in files within the current directory and its subdirectories. It supports various options, including uncapped results, cross-term search, full directory display, and filtering based on function call patterns.

### Arguments
- `extension`: File extension to search (e.g., `.txt`).
- `terms`: One or more terms to search for in the files.
- `--uncapped`: List more than the limit of 3000 results.
- `--cross`: Only search for files that contain all of the specified terms.
- `--dir`: Display the full file directories, not just the file names.
- `--calls`: Display only if there is a period (.) before the string. Useful for locating function calls.

### Example Usage
```ruby
ruby search-match.rb .cs Term1 Term2
```

## Stack Trace
This script parses a stack trace file and prints the relative file path from each frame, filtering out Microsoft framework calls for cleaner debugging output.

### Arguments
- `path`: Path to the stack trace file. Defaults to `test.txt`.

### Example Usage
```ruby
ruby stack-trace.rb
ruby stack-trace.rb error.txt
```

## Start Mod
This script builds and launches a Minecraft mod client via the Gradle wrapper (`gradlew clean build` then `gradlew runClient`). Run it from the mod project directory.

### Arguments
- `--skip-build`: Skip `gradlew clean build` and only run the client.

### Example Usage
```ruby
ruby start-mod.rb
```

## Svelte Start
This script starts a Svelte development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```ruby
ruby svelte-start.rb
```

## Time
This script times any operation, printing how long the given command took to run.

### Arguments
- `command`: The command to run and time (required).

### Example Usage
```ruby
ruby time.rb ping example.com
```

## Undo Commit
This script undoes the last Git commit using different reset modes. It supports hard, mixed, or soft reset modes and force pushes the changes.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-m`, `--mode`: The reset mode to use (`hard`, `mixed`, or `soft`). Defaults to `hard` if not specified.
  - `hard`: Removes commit and discards all changes
  - `mixed`: Removes commit but keeps changes in working directory
  - `soft`: Removes commit but keeps changes staged

### Example Usage
```ruby
ruby undo-commit.rb
ruby undo-commit.rb --mode soft
```

**Warning:** This operation force pushes changes and may affect the remote repository.

## Unit Tests
This script cleans, builds, and tests a .NET unit test project with `dotnet clean`, `dotnet build`, and `dotnet test`.

### Dependencies
- **.NET SDK**: `dotnet` must be in your PATH

### Arguments
- `--project`: Path to the `.csproj` to test. Defaults to the `PROJECT_PATH` constant.

### Example Usage
```ruby
ruby unit-tests.rb --project MyProject.Tests.csproj
```

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```ruby
ruby update_git.rb --branch develop
```

## Update Git All
This script updates all local branches by checking out each branch and running the update-git steps on it, fetching and merging the latest changes.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```ruby
ruby update-git-all.rb
```

## Vs
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio. A bare class name is treated as `<name>.cs`.

### Dependencies
- **Visual Studio**: `devenv.exe` must be in your PATH

### Arguments
- `file`: File name or C# class name to search for (required).

### Example Usage
```ruby
ruby vs.rb example.cs
ruby vs.rb Program
```

## Vsc
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio Code.

### Dependencies
- **VS Code**: `code` must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```ruby
ruby vsc.rb example.js
```

## Vue Start
This script starts a Vue development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```ruby
ruby vue-start.rb
```
