# Bash-Scripts

A collection of useful Bash scripts for development, git operations, and system utilities. Each script is designed to simplify common tasks and improve productivity for developers working in Unix/Linux environments.

## Table of Contents

### Development Tools
- [Angular Start](#angular-start) - Start Angular development server and open browser
- [Cache Visual Studio Index](#cache-visual-studio-index) - Index .cs files for faster Visual Studio file searching
- [Dotnet Analysis](#dotnet-analysis) - Analyze .NET application logs and extract executed commands
- [React Start](#react-start) - Start React development server and open browser
- [Svelte Start](#svelte-start) - Start Svelte development server and open browser
- [Vs](#vs) - Open files in Visual Studio using cached index for fast file discovery
- [Vue Start](#vue-start) - Start Vue development server and open browser

### Git Utilities
- [Clear Git](#clear-git) - Delete local branches that don't have corresponding origin remotes
- [Compress Git](#compress-git) - Compress multiple commits into a single commit
- [New Branch](#new-branch) - Create and checkout a new git branch from master
- [Rebase Git](#rebase-git) - Rebase current branch onto master or specified branch
- [Rebase Git All](#rebase-git-all) - Rebase all local branches onto their upstream branches
- [Reset Git](#reset-git) - Hard reset current branch to origin state
- [Undo Commit](#undo-commit) - Undo the last commit with configurable reset mode
- [Update Git](#update-git) - Merge latest changes from master or specified branch
- [Update Git All](#update-git-all) - Update all local branches with latest changes

### System Tools
- [Compare Diff](#compare-diff) - Compare two files with colorized diff output
- [Create File](#create-file) - Create a new empty file with automatic .txt extension
- [India Time](#india-time) - Convert time to India timezone or show current India time
- [Nginx](#nginx) - Start or reload nginx server
- [Safe Unzip](#safe-unzip) - Safely extract zip files with security checks and limits
- [Time](#time) - Time the execution of any command

## Script Documentation

### Angular Start

Start an Angular development server and automatically open the application in the default browser.

**Dependencies:**
- Angular CLI (`ng`)
- `xdg-open` or `open` command for browser launching

**Usage:**
```bash
angular-start
```

**Example:**
```bash
# Navigate to your Angular project directory
cd my-angular-app

# Start the development server
angular-start
# Output: Starting Angular app on port 4200...
# Opens http://localhost:4200 in browser
```

---

### Cache Visual Studio Index

Build and maintain an index of .cs files in a project directory for faster file searching in Visual Studio integration scripts.

**Dependencies:**
- `find` command
- File system with .cs files

**Parameters:**
- `$1` - Root directory to search (optional, defaults to current directory)
- `$2` - Index file path (optional)

**Usage:**
```bash
cache-vsindex [root_directory] [index_file]
```

**Examples:**
```bash
# Index current directory
cache-vsindex

# Index specific directory with custom index file
cache-vsindex /path/to/project /path/to/index.txt

# Example output
Index updated: +25 / -3 / *5
```

---

### Clear Git

Delete local git branches that don't have corresponding origin remotes (orphaned branches).

**Dependencies:**
- Git repository
- `git` command

**Usage:**
```bash
clear-git
```

**Example:**
```bash
clear-git
# Output: clear-git: Deleting orphan branch: feature-old
# Output: clear-git: Deleting orphan branch: bugfix-completed
# Output: clear-git: No local branches without origin found.
```

---

### Compare Diff

Compare two files with colorized diff output, with option to ignore timestamps.

**Dependencies:**
- `diff` command
- `sed` command for timestamp filtering

**Parameters:**
- `$1` - First file (optional, defaults to TestFile1.txt)
- `$2` - Second file (optional, defaults to TestFile2.txt)
- `$3` - `--notime` flag to ignore timestamps (optional)

**Usage:**
```bash
compare-diff [file1] [file2] [--notime]
```

**Examples:**
```bash
# Compare default test files
compare-diff

# Compare specific files
compare-diff app.log app2.log

# Compare files ignoring timestamps
compare-diff log1.txt log2.txt --notime
```

---

### Create File

Create a new empty file with the specified name, automatically adding .txt extension if none is provided.

**Dependencies:**
- Bash shell environment
- File system write permissions

**Parameters:**
- `$1` - Filename (required): Name for the new file to create

**Usage:**
```bash
create-file <filename>
```

**Examples:**
```bash
# Create a text file with automatic .txt extension
create-file myfile
# Creates: myfile.txt

# Create a file with specific extension
create-file script.sh
# Creates: script.sh

# Create a configuration file  
create-file config.json
# Creates: config.json
```

---

### Compress Git

Compress multiple commits into a single commit by soft resetting to origin/main and recommitting.

**Dependencies:**
- Git repository
- `git` command

**Parameters:**
- `$1` - Commit message (required)

**Usage:**
```bash
compress-git "commit message"
```

**Example:**
```bash
compress-git "Feature: Add user authentication system"
# Output: compress-git: Fetching...
# Output: compress-git: Staging changes for compression...
# Output: compress-git: Committing changes...
# Output: compress-git: Pushing changes...
# Output: compress-git: Compress git complete.
```

---

### Dotnet Analysis

Analyze .NET application log files to extract and categorize executed database commands, action methods, actions, and endpoints.

**Dependencies:**
- Log file with .NET application output
- `awk`, `sort`, `grep` commands

**Parameters:**
- `$1` - Log file path (optional, defaults to TestFile1.txt)

**Usage:**
```bash
dotnet-analysis [log_file]
```

**Example:**
```bash
# Analyze default log file
dotnet-analysis

# Analyze specific log file
dotnet-analysis application.log
# Output: --- Executed DbCommands ---
# Output: --- Executed Action Methods ---
# Output: --- Executed Actions ---
# Output: --- Executed Endpoints ---
```

---

### India Time

Convert local time to India timezone (IST) or display current India time.

**Dependencies:**
- `date` command with timezone support

**Parameters:**
- `$1` - Time in HH:MM AM/PM format (optional)

**Usage:**
```bash
india-time [time]
```

**Examples:**
```bash
# Show current India time
india-time
# Output: Current time in India: 02:30 PM

# Convert specific time to India time
india-time "9:00 AM"
# Output: Inputted time in India: 02:30 PM
```

---

### New Branch

Create a new git branch from master, merge latest master changes, and push to origin.

**Dependencies:**
- Git repository
- `git` command
- Access to origin remote

**Parameters:**
- `$1` - Branch name (required)

**Usage:**
```bash
new-branch "branch-name"
```

**Example:**
```bash
new-branch "feature-user-login"
# Output: new-branch: Fetching...
# Output: new-branch: Checking out into new branch feature-user-login...
# Output: new-branch: Updating new branch feature-user-login with master...
# Output: new-branch: Pushing your new branch feature-user-login...
```

---

### Nginx

Start nginx server or reload configuration if already running.

**Dependencies:**
- Nginx installation
- PowerShell (for Windows environments)
- Properly configured `nginx_base` path

**Usage:**
```bash
nginx
```

**Note:** This script requires configuration of the `nginx_base` variable to point to your nginx installation directory.

---

### React Start

Start a React development server and automatically open the application in the default browser.

**Dependencies:**
- Node.js and npm
- React project with `npm start` script
- `xdg-open` or `open` command for browser launching

**Usage:**
```bash
react-start
```

**Example:**
```bash
# Navigate to your React project directory
cd my-react-app

# Start the development server
react-start
# Output: Starting React app on port 3000...
# Opens http://localhost:3000 in browser
```

---

### Rebase Git

Rebase the current branch onto master or a specified branch.

**Dependencies:**
- Git repository
- `git` command

**Parameters:**
- `$1` - Target branch name (optional, defaults to master)

**Usage:**
```bash
rebase-git [branch]
```

**Examples:**
```bash
# Rebase onto master
rebase-git
# Output: rebase-git: Fetching latest changes...
# Output: rebase-git: Rebasing onto origin/master...

# Rebase onto specific branch
rebase-git develop
# Output: rebase-git: Rebasing onto origin/develop...
```

---

### Rebase Git All

Rebase all local branches onto their respective upstream branches.

**Dependencies:**
- Git repository with multiple branches
- `git` command
- `rebase-git` function must be available

**Usage:**
```bash
rebase-git-all
```

**Example:**
```bash
rebase-git-all
# Output: Currently on branch: main
# Output: Currently on branch: feature-auth
# Output: Currently on branch: develop
# Output: Finished rebasing all branches onto their upstreams.
```

---

### Reset Git

Hard reset the current branch to match the origin/main state and force push.

**Dependencies:**
- Git repository
- `git` command
- Push access to origin

**Usage:**
```bash
reset-git
```

**Example:**
```bash
reset-git
# Output: reset-git: Fetching...
# Output: reset-git: Resetting branch to original state...
# Output: reset-git: Pushing changes...
# Output: reset-git: Reset git complete.
```

**Warning:** This operation is destructive and will remove all local changes and commits not in origin/main.

---

### Safe Unzip

Safely extract zip files with built-in security checks to prevent zip bombs and directory traversal attacks.

**Dependencies:**
- `unzip` command
- `zipinfo` command
- `awk`, `grep` commands

**Parameters:**
- `$1` - Zip file path (required)
- `$2` - Maximum file count (optional, defaults to 1000)
- `$3` - Maximum total size in bytes (optional, defaults to 500MB)

**Usage:**
```bash
safe-unzip <zip-path> [max-files] [max-bytes]
```

**Examples:**
```bash
# Extract with default limits
safe-unzip archive.zip

# Extract with custom limits
safe-unzip large-archive.zip 2000 1073741824
# Output: Extracted to: archive_unzipped

# Security check example
safe-unzip malicious.zip
# Output: Aborted: Unsafe path detected: ../../../etc/passwd
```

---

### Svelte Start

Start a Svelte development server using Windows Terminal or PowerShell and open in browser.

**Dependencies:**
- Node.js and npm
- Svelte project with `npm run dev` script
- Windows Terminal (`wt.exe`) or PowerShell
- Chrome browser or `xdg-open`/`start` command

**Usage:**
```bash
svelte-start
```

**Example:**
```bash
# Navigate to your Svelte project directory
cd my-svelte-app

# Start the development server
svelte-start
# Opens new terminal with npm run dev
# Opens http://localhost:5173 in browser
```

---

### Time

Measure and display the execution time of any command.

**Dependencies:**
- `date` command with nanosecond precision
- `bc` calculator for floating-point arithmetic

**Parameters:**
- `$@` - Command and arguments to time (required)

**Usage:**
```bash
time command [args...]
```

**Examples:**
```bash
# Time a simple command
time ls -la
# Output: [command output]
# Output: The task took 0.023456 seconds to complete.

# Time a complex operation
time find /usr -name "*.txt" | wc -l
# Output: 1247
# Output: The task took 2.345678 seconds to complete.
```

---

### Undo Commit

Undo the last git commit with configurable reset mode.

**Dependencies:**
- Git repository
- `git` command

**Parameters:**
- `$1` - Reset mode: 'hard', 'mixed', or 'soft' (optional, defaults to 'hard')

**Usage:**
```bash
undo-commit [mode]
```

**Examples:**
```bash
# Undo commit with hard reset (default)
undo-commit
# Output: undo-commit: Undoing the last commit with --hard...

# Undo commit keeping changes staged
undo-commit soft
# Output: undo-commit: Undoing the last commit with --soft...

# Undo commit keeping changes unstaged
undo-commit mixed
# Output: undo-commit: Undoing the last commit with --mixed...
```

---

### Update Git

Merge the latest changes from master or a specified branch into the current branch.

**Dependencies:**
- Git repository
- `git` command

**Parameters:**
- `$1` - Source branch name (optional, defaults to master)

**Usage:**
```bash
update-git [branch]
```

**Examples:**
```bash
# Update from master
update-git
# Output: update-git: Fetching...
# Output: update-git: Merging origin/master into the current branch...

# Update from specific branch
update-git develop
# Output: update-git: Merging origin/develop into the current branch...
```

---

### Update Git All

Update all local branches by merging latest changes from their respective upstream branches.

**Dependencies:**
- Git repository with multiple branches
- `git` command
- `update-git` function must be available

**Usage:**
```bash
update-git-all
```

**Example:**
```bash
update-git-all
# Output: Currently on branch: main
# Output: Currently on branch: feature-auth
# Output: Currently on branch: develop
# Output: Finished processing all branches.
```

---

### Vs

Open files in Visual Studio using a cached index for fast file discovery. Searches for .cs files by name.

**Dependencies:**
- Visual Studio (`devenv.exe`)
- PowerShell
- Cached index file (created by `cache-vsindex`)

**Parameters:**
- `$1` - File name to search for (required, .cs extension optional)
- `$2` - Index file path (optional)

**Usage:**
```bash
vs filename [index_file]
```

**Examples:**
```bash
# Open a specific class file
vs UserController
# Output: Opened (cache): ./Controllers/UserController.cs

# Open file using filesystem search (if not in cache)
vs AuthService.cs
# Output: Opened (fs): ./Services/AuthService.cs

# Search for file with custom index
vs Product /custom/path/index.txt
```

---

### Vue Start

Start a Vue development server and automatically open the application in the default browser.

**Dependencies:**
- Node.js and npm
- Vue project with `npm run dev` script
- `xdg-open` or `open` command for browser launching

**Usage:**
```bash
vue-start
```

**Example:**
```bash
# Navigate to your Vue project directory
cd my-vue-app

# Start the development server
vue-start
# Output: Starting Vue app on port 5173...
# Opens http://localhost:5173 in browser
```

## Installation and Setup

1. Clone this repository:
```bash
git clone https://github.com/pattygcoding/Bash-Scripts.git
cd Bash-Scripts
```

2. Source the scripts you want to use in your shell profile (`.bashrc`, `.zshrc`, etc.):
```bash
# Add to your shell profile
source /path/to/Bash-Scripts/[Script Name]/[script-name].sh
```

3. Or create symbolic links to make scripts globally available:
```bash
# Example for making scripts available system-wide
sudo ln -s /path/to/Bash-Scripts/[Script Name]/[script-name].sh /usr/local/bin/[script-name]
```

## Contributing

Feel free to contribute by:
1. Adding new useful scripts
2. Improving existing scripts
3. Enhancing documentation
4. Reporting bugs or issues

## License

This project is open source and available under the [MIT License](LICENSE).