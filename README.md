# Scripting Library by Patrick Goodwin

A single home for all of my scripting libraries.

**Live:** [scripts.pattygcoding.com](https://scripts.pattygcoding.com) - a Vue dashboard that browses
every script, its source and its README.

[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://docs.microsoft.com/en-us/powershell/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)
[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Google Sheets](https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=googlesheets&logoColor=white)](https://www.google.com/sheets/about/)
[![Excel](https://img.shields.io/badge/Microsoft%20Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white)](https://www.microsoft.com/microsoft-365/excel)

## Table of Contents

- [Bash](#bash) - [scripts/bash/](scripts/bash) - [README](scripts/bash/README.md)
- [Lua](#lua) - [scripts/lua/](scripts/lua) - [README](scripts/lua/README.md)
- [PowerShell](#powershell) - [scripts/powershell/](scripts/powershell) - [README](scripts/powershell/README.md)
- [Python](#python) - [scripts/python/](scripts/python) - [README](scripts/python/README.md)
- [Ruby](#ruby) - [scripts/ruby/](scripts/ruby) - [README](scripts/ruby/README.md)
- [VBA](#vba) - [scripts/vba/](scripts/vba) - [README](scripts/vba/README.md)

## Layout

Every language lives in its own directory under `scripts/`, and every script lives in its own folder
alongside a `README.md` that documents its dependencies, parameters, and example usage.

```
Scripting-Library/
├── scripts/               # Every language, one directory each
│   ├── bash/              # Shell scripts for development, git, and system utilities
│   ├── lua/               # Standalone Lua utilities
│   ├── powershell/        # Windows terminal and `$profile` helper functions
│   ├── python/            # General purpose Python utilities
│   ├── ruby/              # Ruby equivalents of the common utilities
│   └── vba/               # VBA, Google Apps Script, and Office Script
└── src/                   # The showcase dashboard that reads them
```

## Showcase site

[scripts.pattygcoding.com](https://scripts.pattygcoding.com) is a Vue 3 + TypeScript + Vite dashboard
that reads this repository and displays it. It lives at the repository root, beside the `scripts/`
tree it describes.

Three screens, each with its own address:

| Address | Screen |
| --- | --- |
| `/` | **Home** - the six language folders as cards, with a search across every script |
| `/powershell` | **One language** - that folder's scripts as cards, plus the folder's own `README.md` |
| `/powershell/update-git` | **One script** - its source and its folder's `README.md`, as tabs |

A banner across the top carries the home mark back to [pattygcoding.com](https://pattygcoding.com)
(the same corner mark the Turing Machines and Connect Four showcases use), the site's own home, the
six language types and a link to this repository, so the same navigation is one tap away from every
screen. `?tab=docs` (or a trailing `/docs`) opens a script on its documentation, and the flat
addresses of the first version (`/bash-clear-git`) still resolve.

- `tools/generate-data.mjs` walks the six folders under `scripts/` and writes
  `public/scripts-data.js`, so a script added to a folder appears on the site with no app change. Each
  script carries a `<language>/<script>` address, the first sentence of its README (what a card shows)
  and that README itself.
- `npm run data` regenerates that payload, `npm run dev` serves the dashboard, and `npm run build`
  runs the generator, `vue-tsc` and Vite.
- Every push to `main` rebuilds and republishes the site to GitHub Pages
  (`.github/workflows/deploy.yml`). `public/404.html` is the shim that makes a deep link such as
  `/powershell/update-git` work when it is opened or refreshed directly.

## Bash

Shell scripts for development, git operations, and system utilities. See the [full documentation](scripts/bash/README.md).

| Script | Description |
| --- | --- |
| [Angular Start](scripts/bash/Angular%20Start) | Start Angular development server and open browser |
| [Cache Visual Studio Index](scripts/bash/Cache%20Visual%20Studio%20Index) | Index .cs files for faster Visual Studio file searching |
| [Clear Git](scripts/bash/Clear%20Git) | Delete local branches that don't have corresponding origin remotes |
| [Compare Diff](scripts/bash/Compare%20Diff) | Compare two files with colorized diff output |
| [Compress Git](scripts/bash/Compress%20Git) | Compress multiple commits into a single commit |
| [Create File](scripts/bash/Create%20File) | Create a new empty file with automatic .txt extension |
| [Dotnet Analysis](scripts/bash/Dotnet%20Analysis) | Analyze .NET application logs and extract executed commands |
| [India Time](scripts/bash/India%20Time) | Convert time to India timezone or show current India time |
| [New Branch](scripts/bash/New%20Branch) | Create and checkout a new git branch from master |
| [Nginx](scripts/bash/Nginx) | Start or reload nginx server |
| [React Start](scripts/bash/React%20Start) | Start React development server and open browser |
| [Rebase Git](scripts/bash/Rebase%20Git) | Rebase current branch onto master or specified branch |
| [Rebase Git All](scripts/bash/Rebase%20Git%20All) | Rebase all local branches onto their upstream branches |
| [Reset Git](scripts/bash/Reset%20Git) | Hard reset current branch to origin state |
| [Safe Unzip](scripts/bash/Safe%20Unzip) | Safely extract zip files with security checks and limits |
| [Svelte Start](scripts/bash/Svelte%20Start) | Start Svelte development server and open browser |
| [Time](scripts/bash/Time) | Time the execution of any command |
| [Undo Commit](scripts/bash/Undo%20Commit) | Undo the last commit with configurable reset mode |
| [Update GIt](scripts/bash/Update%20GIt) | Merge latest changes from master or specified branch |
| [Update Git All](scripts/bash/Update%20Git%20All) | Update all local branches with latest changes |
| [Vs](scripts/bash/Vs) | Open files in Visual Studio using cached index for fast file discovery |
| [Vue Start](scripts/bash/Vue%20Start) | Start Vue development server and open browser |

## Lua

Standalone Lua utilities that only need the standard library (plus `dkjson` where noted).
See the [full documentation](scripts/lua/README.md).

| Script | Description |
| --- | --- |
| [Clear Git](scripts/lua/Clear%20Git) | Delete local branches that don't have upstream tracking |
| [Count Files](scripts/lua/Count%20Files) | Count files in the current directory and subdirectories |
| [Dotnet Analysis](scripts/lua/Dotnet%20Analysis) | Analyze .NET logs for actions, endpoints, and database commands |
| [JSON to CSV](scripts/lua/JSON%20to%20CSV) | Convert a JSON array of objects into CSV |
| [Random Password](scripts/lua/Random%20Password) | Generate a random password with a customizable length |
| [Rebase Git](scripts/lua/Rebase%20Git) | Rebase the current branch and force-with-lease push |
| [Reset Git](scripts/lua/Reset%20Git) | Reset the current branch to match `origin/main` |
| [Undo Commit](scripts/lua/Undo%20Commit) | Undo the last commit using a hard, mixed, or soft reset |
| [Update Git](scripts/lua/Update%20Git) | Fetch and merge the latest changes from a branch |

## PowerShell

A library of PowerShell helper functions built for the Windows terminal. Pairs well with the
`$profile` feature so every function is available in a new shell. See the
[full documentation](scripts/powershell/README.md).

| Script | Description |
| --- | --- |
| [Angular Start](scripts/powershell/Angular%20Start) | Start an Angular dev server and open Chrome |
| [Cache Visual Studio Index](scripts/powershell/Cache%20Visual%20Studio%20Index) | Build and update an index of .cs files |
| [Clear Downloads](scripts/powershell/Clear%20Downloads) | Clear the Downloads folder |
| [Clear Git](scripts/powershell/Clear%20Git) | Delete unpushed local branches |
| [Compare Diff](scripts/powershell/Compare%20Diff) | Compare two files line by line, optionally ignoring timestamps |
| [Compress Git](scripts/powershell/Compress%20Git) | Compress multiple commits into one |
| [Connect Four](scripts/powershell/Connect%20Four) | Play Connect Four in the terminal |
| [Count Files](scripts/powershell/Count%20Files) | Count files in a directory tree |
| [Create File](scripts/powershell/Create%20File) | Create a new file from the terminal |
| [Dotnet Analysis](scripts/powershell/Dotnet%20Analysis) | Analyze .NET logs for actions, endpoints, and database commands |
| [Gensql Col](scripts/powershell/Gensql%20Col) | Generate SQL from a header/value column pair |
| [Gensql Count](scripts/powershell/Gensql%20Count) | Generate a SQL count statement |
| [Goto](scripts/powershell/Goto) | Jump to a directory quickly |
| [India Time](scripts/powershell/India%20Time) | Show or convert to India time |
| [Ip](scripts/powershell/Ip) | Show the local public IP address |
| [Neovim](scripts/powershell/Neovim) | Launch Neovim |
| [New Branch](scripts/powershell/New%20Branch) | Create and checkout a new branch from master |
| [Nginx](scripts/powershell/Nginx) | Start or reload the nginx server |
| [Print](scripts/powershell/Print) | Print a file from the terminal |
| [Random Password](scripts/powershell/Random%20Password) | Generate a random password |
| [React Start](scripts/powershell/React%20Start) | Start a React dev server and open Chrome |
| [Rebase Git](scripts/powershell/Rebase%20Git) | Rebase the current branch onto master or another branch |
| [Rebase Git All](scripts/powershell/Rebase%20Git%20All) | Rebase all local branches onto their upstreams |
| [Regvim](scripts/powershell/Regvim) | Open the Neovim configuration |
| [Reset Git](scripts/powershell/Reset%20Git) | Hard reset the current branch to origin |
| [Safe Unzip](scripts/powershell/Safe%20Unzip) | Safely extract archives with limits |
| [Search Match](scripts/powershell/Search%20Match) | Search files in a tree for one or more terms |
| [Stack Trace](scripts/powershell/Stack%20Trace) | Parse stack traces and keep only your own frames |
| [Start Mod](scripts/powershell/Start%20Mod) | Start a Minecraft mod development environment |
| [Svelte Start](scripts/powershell/Svelte%20Start) | Start a Svelte dev server and open Chrome |
| [Time](scripts/powershell/Time) | Time any operation |
| [Undo Commit](scripts/powershell/Undo%20Commit) | Undo the last commit and push the rewrite |
| [Unit Tests](scripts/powershell/Unit%20Tests) | Run every unit test project in a folder |
| [Update Git](scripts/powershell/Update%20Git) | Fetch and merge the latest changes |
| [Update Git All](scripts/powershell/Update%20Git%20All) | Update every local branch |
| [Vs](scripts/powershell/Vs) | Find a file by name and open it in Visual Studio |
| [Vsc](scripts/powershell/Vsc) | Find a file by name and open it in VS Code |
| [Vue Start](scripts/powershell/Vue%20Start) | Start a Vue dev server and open Chrome |

## Python

General purpose Python utilities, most of which use nothing beyond the standard library.
See the [full documentation](scripts/python/README.md) for the third-party dependencies.

| Script | Description |
| --- | --- |
| [Backend File Explorer](scripts/python/Backend%20File%20Explorer) | GUI file explorer that opens files in Visual Studio, VS Code, or Android Studio |
| [Compare Diff](scripts/python/Compare%20Diff) | Compare two files line by line and highlight the differences |
| [Count Files](scripts/python/Count%20Files) | Count files in a directory tree |
| [Count Words](scripts/python/Count%20Words) | Count the words in a text file |
| [Generate QR Code](scripts/python/Generate%20QR%20Code) | Generate a QR code for a link |
| [Get Directory Size](scripts/python/Get%20Directory%20Size) | Return the byte size of a directory |
| [Get Links](scripts/python/Get%20Links) | Return the links inside a URL |
| [Get System Info](scripts/python/Get%20System%20Info) | Return the system information of the machine |
| [Get Weather](scripts/python/Get%20Weather) | Return the weather for a city |
| [Instant Gui](scripts/python/Instant%20Gui) | Generate an instant GUI |
| [JSON to CSV](scripts/python/JSON%20to%20CSV) | Convert a JSON file to CSV |
| [Merge PDFs](scripts/python/Merge%20PDFs) | Merge multiple PDFs into one |
| [Organize Directory](scripts/python/Organize%20Directory) | Organize a directory by file extension |
| [Print Directory Tree](scripts/python/Print%20Directory%20Tree) | Print the current directory tree |
| [Random Password](scripts/python/Random%20Password) | Generate a random password |
| [Read Pics](scripts/python/Read%20Pics) | OCR text out of PNG images |
| [Resize Image](scripts/python/Resize%20Image) | Resize an image |
| [Search Match](scripts/python/Search%20Match) | Search a directory tree for one or more terms |
| [Send Email](scripts/python/Send%20Email) | Send an email |
| [Shorten URL](scripts/python/Shorten%20URL) | Shorten a URL |
| [Update Git](scripts/python/Update%20Git) | Fetch and merge the latest changes |
| [Venn Diagram](scripts/python/Venn%20Diagram) | Draw a Venn diagram of two sets |

## Ruby

Ruby equivalents of the common utilities. See the [full documentation](scripts/ruby/README.md).

| Script | Description |
| --- | --- |
| [Clear Git](scripts/ruby/Clear%20Git) | Delete local branches without a remote origin branch |
| [Count Files](scripts/ruby/Count%20Files) | Count files in a directory tree |
| [Dotnet Analysis](scripts/ruby/Dotnet%20Analysis) | Analyze .NET logs for database commands and endpoints |
| [JSON to CSV](scripts/ruby/JSON%20to%20CSV) | Convert a JSON file to CSV |
| [Random Password](scripts/ruby/Random%20Password) | Generate a random password |
| [Rebase Git](scripts/ruby/Rebase%20Git) | Rebase the current branch and force-with-lease push |
| [Reset Git](scripts/ruby/Reset%20Git) | Hard reset the current branch to `origin/main` |
| [Undo Commit](scripts/ruby/Undo%20Commit) | Undo the last commit using a hard, mixed, or soft reset |
| [Update Git](scripts/ruby/Update%20Git) | Fetch and merge the latest changes |

## VBA

Scripts I use in Excel and on Google Sheets to compare SQL output when Microsoft SQL Server can't
do it for me. Each script ships in all three formats: VBA (`.vba`), Google Apps Script (`.gs`), and
Office Script (`.ts`). See the [full documentation](scripts/vba/README.md) for install steps in both apps.

| Script | Description |
| --- | --- |
| [Compare Columns](scripts/vba/Compare%20Columns) | Compare two columns and return the differences |
| [Compare Rows](scripts/vba/Compare%20Rows) | Compare two rows and return the differences |
| [Delete Duplicate Rows](scripts/vba/Delete%20Duplicate%20Rows) | Delete duplicate rows from a sheet |
| [Obtain SQL](scripts/vba/Obtain%20SQL) | Build the SQL format for a header and value row |

## Usage

Clone the repository and run or source the script you need:

```bash
git clone https://github.com/pattygcoding/Scripting-Library.git
```

```bash
# Bash
source Scripting-Library/scripts/bash/Update%20Git/update-git.sh
```

```powershell
# PowerShell
. .\Scripting-Library\scripts\powershell\Update Git\update-git.ps1
```

```bash
# Lua, Python, Ruby
lua    Scripting-Library/scripts/lua/Clear Git/clear-git.lua
python "Scripting-Library/scripts/python/Count Words/count_words.py"
ruby   "Scripting-Library/scripts/ruby/Clear Git/clear-git.rb"
```

For the `scripts/vba/` scripts, open the sheet, then either go to **Extensions -> Apps Script** in Google Sheets
or press **Alt + F11** in Excel and paste in the `.gs` / `.vba` file.

## Notes

Each language folder was consolidated from its own repository, which is kept intact:

| Folder | Original repository |
| --- | --- |
| `scripts/bash/` | [pattygcoding/Bash-Scripts](https://github.com/pattygcoding/Bash-Scripts) |
| `scripts/lua/` | [pattygcoding/Lua-Scripts](https://github.com/pattygcoding/Lua-Scripts) |
| `scripts/powershell/` | [pattygcoding/Powershell-Scripts](https://github.com/pattygcoding/Powershell-Scripts) |
| `scripts/python/` | [pattygcoding/Python-Scripts](https://github.com/pattygcoding/Python-Scripts) |
| `scripts/ruby/` | [pattygcoding/Ruby-Scripts](https://github.com/pattygcoding/Ruby-Scripts) |
| `scripts/vba/` | [pattygcoding/Spreadsheet-Scripts](https://github.com/pattygcoding/Spreadsheet-Scripts) |
