# Scripting Library by Patrick Goodwin

A single home for all of my scripting libraries.

[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://docs.microsoft.com/en-us/powershell/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)
[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Google Sheets](https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=googlesheets&logoColor=white)](https://www.google.com/sheets/about/)
[![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)

## Table of Contents

- [Bash](#bash) - [bash/](bash) - [README](bash/README.md)
- [Lua](#lua) - [lua/](lua) - [README](lua/README.md)
- [PowerShell](#powershell) - [powershell/](powershell) - [README](powershell/README.md)
- [Python](#python) - [python/](python) - [README](python/README.md)
- [Ruby](#ruby) - [ruby/](ruby) - [README](ruby/README.md)
- [VBA](#vba) - [vba/](vba) - [README](vba/README.md)

## Layout

Every language lives in its own directory, and every script lives in its own folder alongside a `README.md`
that documents its dependencies, parameters, and example usage.

```
Scripting-Library/
├── bash/            # Shell scripts for development, git, and system utilities
├── lua/             # Standalone Lua utilities
├── powershell/      # Windows terminal and `$profile` helper functions
├── python/          # General purpose Python utilities
├── ruby/            # Ruby equivalents of the common utilities
└── vba/             # VBA, Google Apps Script, and Office Script
```

## Bash

Shell scripts for development, git operations, and system utilities. See the [full documentation](bash/README.md).

| Script | Description |
| --- | --- |
| [Angular Start](bash/Angular%20Start) | Start Angular development server and open browser |
| [Cache Visual Studio Index](bash/Cache%20Visual%20Studio%20Index) | Index .cs files for faster Visual Studio file searching |
| [Clear Git](bash/Clear%20Git) | Delete local branches that don't have corresponding origin remotes |
| [Compare Diff](bash/Compare%20Diff) | Compare two files with colorized diff output |
| [Compress Git](bash/Compress%20Git) | Compress multiple commits into a single commit |
| [Create File](bash/Create%20File) | Create a new empty file with automatic .txt extension |
| [Dotnet Analysis](bash/Dotnet%20Analysis) | Analyze .NET application logs and extract executed commands |
| [India Time](bash/India%20Time) | Convert time to India timezone or show current India time |
| [New Branch](bash/New%20Branch) | Create and checkout a new git branch from master |
| [Nginx](bash/Nginx) | Start or reload nginx server |
| [React Start](bash/React%20Start) | Start React development server and open browser |
| [Rebase Git](bash/Rebase%20Git) | Rebase current branch onto master or specified branch |
| [Rebase Git All](bash/Rebase%20Git%20All) | Rebase all local branches onto their upstream branches |
| [Reset Git](bash/Reset%20Git) | Hard reset current branch to origin state |
| [Safe Unzip](bash/Safe%20Unzip) | Safely extract zip files with security checks and limits |
| [Svelte Start](bash/Svelte%20Start) | Start Svelte development server and open browser |
| [Time](bash/Time) | Time the execution of any command |
| [Undo Commit](bash/Undo%20Commit) | Undo the last commit with configurable reset mode |
| [Update GIt](bash/Update%20GIt) | Merge latest changes from master or specified branch |
| [Update Git All](bash/Update%20Git%20All) | Update all local branches with latest changes |
| [Vs](bash/Vs) | Open files in Visual Studio using cached index for fast file discovery |
| [Vue Start](bash/Vue%20Start) | Start Vue development server and open browser |

## Lua

Standalone Lua utilities that only need the standard library (plus `dkjson` where noted).
See the [full documentation](lua/README.md).

| Script | Description |
| --- | --- |
| [Clear Git](lua/Clear%20Git) | Delete local branches that don't have upstream tracking |
| [Count Files](lua/Count%20Files) | Count files in the current directory and subdirectories |
| [Dotnet Analysis](lua/Dotnet%20Analysis) | Analyze .NET logs for actions, endpoints, and database commands |
| [JSON to CSV](lua/JSON%20to%20CSV) | Convert a JSON array of objects into CSV |
| [Random Password](lua/Random%20Password) | Generate a random password with a customizable length |
| [Rebase Git](lua/Rebase%20Git) | Rebase the current branch and force-with-lease push |
| [Reset Git](lua/Reset%20Git) | Reset the current branch to match `origin/main` |
| [Undo Commit](lua/Undo%20Commit) | Undo the last commit using a hard, mixed, or soft reset |
| [Update Git](lua/Update%20Git) | Fetch and merge the latest changes from a branch |

## PowerShell

A library of PowerShell helper functions built for the Windows terminal. Pairs well with the
`$profile` feature so every function is available in a new shell. See the
[full documentation](powershell/README.md).

| Script | Description |
| --- | --- |
| [Angular Start](powershell/Angular%20Start) | Start an Angular dev server and open Chrome |
| [Cache Visual Studio Index](powershell/Cache%20Visual%20Studio%20Index) | Build and update an index of .cs files |
| [Clear Downloads](powershell/Clear%20Downloads) | Clear the Downloads folder |
| [Clear Git](powershell/Clear%20Git) | Delete unpushed local branches |
| [Compare Diff](powershell/Compare%20Diff) | Compare two files line by line, optionally ignoring timestamps |
| [Compress Git](powershell/Compress%20Git) | Compress multiple commits into one |
| [Connect Four](powershell/Connect%20Four) | Play Connect Four in the terminal |
| [Count Files](powershell/Count%20Files) | Count files in a directory tree |
| [Create File](powershell/Create%20File) | Create a new file from the terminal |
| [Dotnet Analysis](powershell/Dotnet%20Analysis) | Analyze .NET logs for actions, endpoints, and database commands |
| [Gensql Col](powershell/Gensql%20Col) | Generate SQL from a header/value column pair |
| [Gensql Count](powershell/Gensql%20Count) | Generate a SQL count statement |
| [Goto](powershell/Goto) | Jump to a directory quickly |
| [India Time](powershell/India%20Time) | Show or convert to India time |
| [Ip](powershell/Ip) | Show the local public IP address |
| [Neovim](powershell/Neovim) | Launch Neovim |
| [New Branch](powershell/New%20Branch) | Create and checkout a new branch from master |
| [Nginx](powershell/Nginx) | Start or reload the nginx server |
| [Print](powershell/Print) | Print a file from the terminal |
| [Random Password](powershell/Random%20Password) | Generate a random password |
| [React Start](powershell/React%20Start) | Start a React dev server and open Chrome |
| [Rebase Git](powershell/Rebase%20Git) | Rebase the current branch onto master or another branch |
| [Rebase Git All](powershell/Rebase%20Git%20All) | Rebase all local branches onto their upstreams |
| [Regvim](powershell/Regvim) | Open the Neovim configuration |
| [Reset Git](powershell/Reset%20Git) | Hard reset the current branch to origin |
| [Safe Unzip](powershell/Safe%20Unzip) | Safely extract archives with limits |
| [Search Match](powershell/Search%20Match) | Search files in a tree for one or more terms |
| [Stack Trace](powershell/Stack%20Trace) | Parse stack traces and keep only your own frames |
| [Start Mod](powershell/Start%20Mod) | Start a Minecraft mod development environment |
| [Svelte Start](powershell/Svelte%20Start) | Start a Svelte dev server and open Chrome |
| [Time](powershell/Time) | Time any operation |
| [Undo Commit](powershell/Undo%20Commit) | Undo the last commit and push the rewrite |
| [Unit Tests](powershell/Unit%20Tests) | Run every unit test project in a folder |
| [Update Git](powershell/Update%20Git) | Fetch and merge the latest changes |
| [Update Git All](powershell/Update%20Git%20All) | Update every local branch |
| [Vs](powershell/Vs) | Find a file by name and open it in Visual Studio |
| [Vsc](powershell/Vsc) | Find a file by name and open it in VS Code |
| [Vue Start](powershell/Vue%20Start) | Start a Vue dev server and open Chrome |

## Python

General purpose Python utilities, most of which use nothing beyond the standard library.
See the [full documentation](python/README.md) for the third-party dependencies.

| Script | Description |
| --- | --- |
| [Backend File Explorer](python/Backend%20File%20Explorer) | GUI file explorer that opens files in Visual Studio, VS Code, or Android Studio |
| [Compare Diff](python/Compare%20Diff) | Compare two files line by line and highlight the differences |
| [Count Files](python/Count%20Files) | Count files in a directory tree |
| [Count Words](python/Count%20Words) | Count the words in a text file |
| [Generate QR Code](python/Generate%20QR%20Code) | Generate a QR code for a link |
| [Get Directory Size](python/Get%20Directory%20Size) | Return the byte size of a directory |
| [Get Links](python/Get%20Links) | Return the links inside a URL |
| [Get System Info](python/Get%20System%20Info) | Return the system information of the machine |
| [Get Weather](python/Get%20Weather) | Return the weather for a city |
| [Instant Gui](python/Instant%20Gui) | Generate an instant GUI |
| [JSON to CSV](python/JSON%20to%20CSV) | Convert a JSON file to CSV |
| [Merge PDFs](python/Merge%20PDFs) | Merge multiple PDFs into one |
| [Organize Directory](python/Organize%20Directory) | Organize a directory by file extension |
| [Print Directory Tree](python/Print%20Directory%20Tree) | Print the current directory tree |
| [Random Password](python/Random%20Password) | Generate a random password |
| [Read Pics](python/Read%20Pics) | OCR text out of PNG images |
| [Resize Image](python/Resize%20Image) | Resize an image |
| [Search Match](python/Search%20Match) | Search a directory tree for one or more terms |
| [Send Email](python/Send%20Email) | Send an email |
| [Shorten URL](python/Shorten%20URL) | Shorten a URL |
| [Update Git](python/Update%20Git) | Fetch and merge the latest changes |
| [Venn Diagram](python/Venn%20Diagram) | Draw a Venn diagram of two sets |

## Ruby

Ruby equivalents of the common utilities. See the [full documentation](ruby/README.md).

| Script | Description |
| --- | --- |
| [Clear Git](ruby/Clear%20Git) | Delete local branches without a remote origin branch |
| [Count Files](ruby/Count%20Files) | Count files in a directory tree |
| [Dotnet Analysis](ruby/Dotnet%20Analysis) | Analyze .NET logs for database commands and endpoints |
| [JSON to CSV](ruby/JSON%20to%20CSV) | Convert a JSON file to CSV |
| [Random Password](ruby/Random%20Password) | Generate a random password |
| [Rebase Git](ruby/Rebase%20Git) | Rebase the current branch and force-with-lease push |
| [Reset Git](ruby/Reset%20Git) | Hard reset the current branch to `origin/main` |
| [Undo Commit](ruby/Undo%20Commit) | Undo the last commit using a hard, mixed, or soft reset |
| [Update Git](ruby/Update%20Git) | Fetch and merge the latest changes |

## VBA

Scripts I use in Excel and on Google Sheets to compare SQL output when Microsoft SQL Server can't
do it for me. Each script ships in all three formats: VBA (`.vba`), Google Apps Script (`.gs`), and
Office Script (`.ts`). See the [full documentation](vba/README.md) for install steps in both apps.

| Script | Description |
| --- | --- |
| [Compare Columns](vba/Compare%20Columns) | Compare two columns and return the differences |
| [Compare Rows](vba/Compare%20Rows) | Compare two rows and return the differences |
| [Delete Duplicate Rows](vba/Delete%20Duplicate%20Rows) | Delete duplicate rows from a sheet |
| [Obtain SQL](vba/Obtain%20SQL) | Build the SQL format for a header and value row |

## Usage

Clone the repository and run or source the script you need:

```bash
git clone https://github.com/pattygcoding/Scripting-Library.git
```

```bash
# Bash
source Scripting-Library/bash/Update%20Git/update-git.sh
```

```powershell
# PowerShell
. .\Scripting-Library\powershell\Update Git\update-git.ps1
```

```bash
# Lua, Python, Ruby
lua    Scripting-Library/lua/Clear Git/clear-git.lua
python "Scripting-Library/python/Count Words/count_words.py"
ruby   "Scripting-Library/ruby/Clear Git/clear-git.rb"
```

For the `vba/` scripts, open the sheet, then either go to **Extensions -> Apps Script** in Google Sheets
or press **Alt + F11** in Excel and paste in the `.gs` / `.vba` file.

## Notes

Each language folder was consolidated from its own repository, which is kept intact:

| Folder | Original repository |
| --- | --- |
| `bash/` | [pattygcoding/Bash-Scripts](https://github.com/pattygcoding/Bash-Scripts) |
| `lua/` | [pattygcoding/Lua-Scripts](https://github.com/pattygcoding/Lua-Scripts) |
| `powershell/` | [pattygcoding/Powershell-Scripts](https://github.com/pattygcoding/Powershell-Scripts) |
| `python/` | [pattygcoding/Python-Scripts](https://github.com/pattygcoding/Python-Scripts) |
| `ruby/` | [pattygcoding/Ruby-Scripts](https://github.com/pattygcoding/Ruby-Scripts) |
| `vba/` | [pattygcoding/Spreadsheet-Scripts](https://github.com/pattygcoding/Spreadsheet-Scripts) |
