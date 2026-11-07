# Python Scripts by Patrick Goodwin
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org/)

## Table of Contents
- [Angular Start](#angular-start)
- [Backend File Explorer](#backend-file-explorer)
- [Cache Visual Studio Index](#cache-visual-studio-index)
- [Clear Downloads](#clear-downloads)
- [Clear Git](#clear-git)
- [Compare Diff](#compare-diff)
- [Compress Git](#compress-git)
- [Connect Four](#connect-four)
- [Count Files](#count-files)
- [Count Words](#count-words)
- [Create File](#create-file)
- [Dotnet Analysis](#dotnet-analysis)
- [Generate QR Code](#generate-qr-code)
- [Gensql Col](#gensql-col)
- [Gensql Count](#gensql-count)
- [Get Directory Size](#get-directory-size)
- [Get Links](#get-links)
- [Get System Info](#get-system-info)
- [Get Weather](#get-weather)
- [Goto](#goto)
- [India Time](#india-time)
- [Instant GUI](#instant-gui)
- [Ip](#ip)
- [JSON to CSV](#json-to-csv)
- [Merge PDFs](#merge-pdfs)
- [Neovim](#neovim)
- [New Branch](#new-branch)
- [Nginx](#nginx)
- [Organize Directory](#organize-directory)
- [Print](#print)
- [Print Directory Tree](#print-directory-tree)
- [Random Password](#random-password)
- [React Start](#react-start)
- [Read Pics](#read-pics)
- [Rebase Git](#rebase-git)
- [Rebase Git All](#rebase-git-all)
- [Regvim](#regvim)
- [Reset Git](#reset-git)
- [Resize Image](#resize-image)
- [Safe Unzip](#safe-unzip)
- [Search Match](#search-match)
- [Send Email](#send-email)
- [Shorten URL](#shorten-url)
- [Stack Trace](#stack-trace)
- [Start Mod](#start-mod)
- [Svelte Start](#svelte-start)
- [Time](#time)
- [Undo Commit](#undo-commit)
- [Unit Tests](#unit-tests)
- [Update Git](#update-git)
- [Update Git All](#update-git-all)
- [Venn Diagram](#venn-diagram)
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
```
python angular_start.py
```

## Backend File Explorer
This script provides a GUI-based file explorer for opening files in different editors. It supports multiple file extensions and can open files in Visual Studio, VS Code, or Android Studio.

### Dependencies
- `tkinter`: Built-in Python GUI library
- `win32com.client`: For Visual Studio integration

### Features
- Supports multiple file extensions (.cs, .c, .java, .dart, .vue, .php, .ts, .js, .py, .html, .css, .json, .xml, .cpp)
- Search and autocomplete functionality
- Integration with Visual Studio, VS Code, and Android Studio
- Ignores common directories like node_modules, .git, build, dist, vendor, __pycache__

### Example Usage
```
python backend_file_explorer.py
```

## Cache Visual Studio Index
This script builds and updates an index of `.cs` files under a directory tree. It maps each file's base name to the directories that contain it and reports the entries that were added, removed, or changed.

### Arguments
- `--root`: Root directory to scan. Defaults to the current directory.
- `--index-file`: Path to the index file to create or update (required).

### Example Usage
```
python cache_vsindex.py --root "C:\MyProject" --index-file index.txt
```

## Clear Downloads
This script permanently deletes everything inside the Downloads folder.

### Arguments
- `directory`: Folder to clear. Defaults to `~/Downloads`.

### Example Usage
```
python clear_downloads.py
```

## Clear Git
This script deletes all local branches that are not tracking an origin branch. Branches that were never pushed will be lost, so do not use it if you keep unpushed work.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```
python clear_git.py
```

## Compare Diff
This script compares two files line by line and highlights the differences. It also has an optional feature to ignore timestamps during the comparison.

### Arguments
- `file1`: The first file to compare. Defaults to `TestFile1.txt`.
- `file2`: The second file to compare. Defaults to `TestFile2.txt`.
- `--notime`: Optional flag to remove timestamps before comparing.

### Example Usage
```
python compare_diff.py file1.txt file2.txt
```

## Compress Git
This script squashes all changes on the current branch into a single commit by resetting to `origin/main` and committing everything, then force-pushing.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `message`: Commit message for the squashed commit (required).

### Example Usage
```
python compress_git.py "Feature implementation"
```

## Connect Four
This script plays a two-player game of Connect Four in the console, with color-coded pieces and win detection.

### Arguments
- `--p1`: First player name. Defaults to `Player 1`.
- `--p2`: Second player name. Defaults to `Player 2`.

### Example Usage
```
python connect_four.py --p1 Bob --p2 Ryan
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```
python count_files.py
```

## Count Words
This script counts the number of words in a specified text file.

### Arguments
- `file`: The text file to read. Defaults to `textfile.txt`.

### Example Usage
```
python count_words.py textfile.txt
```

## Create File
This script creates a new file. If no extension is given, `.txt` is appended.

### Arguments
- `name`: Name of the file to create (required).

### Example Usage
```
python create_file.py myfile
python create_file.py document.txt
```

## Dotnet Analysis
This script analyzes captured .NET (ASP.NET Core) console output and prints four grouped sections with line numbers: executed DbCommands (with their database and joined tables), action methods, actions, and endpoints.

### Arguments
- `file`: The log file to analyze. Defaults to `TestFile1.txt`.

### Example Usage
```
python dotnet_analysis.py log.txt
```

## Generate QR Code
This script generates a QR code for a link or some text.

### Dependencies
- `qrcode`: QR code library (`pip install qrcode pillow`)

### Arguments
- `data`: Text or URL to encode. Defaults to `https://www.example.com`.
- `-o`, `--output`: Output image path. Defaults to `qrcode.png`.

### Example Usage
```
python generate_qr_code.py "https://www.example.com" -o qrcode.png
```

## Gensql Col
This script generates a SQL script you can use to search for every occurrence of a column name in a database.

### Arguments
- `-c`, `--column`: The column name (or fragment) to search for (required).

### Example Usage
```
python gensql_col.py -c NewId
```

## Gensql Count
This script generates a SQL script you can use to count the number of entries in a given table.

### Arguments
- `-t`, `--table`: The table name (optionally schema-qualified) (required).

### Example Usage
```
python gensql_count.py -t "[db].[Table]"
```

## Get Directory Size
This script returns the total byte size of a directory tree.

### Arguments
- `directory`: Directory to measure. Defaults to the current directory.

### Example Usage
```
python get_directory_size.py .
```

## Get Links
This script returns the links inside a URL.

### Dependencies
- `requests`, `beautifulsoup4`: `pip install requests beautifulsoup4`

### Arguments
- `url`: The page to scan. Defaults to `https://example.com`.

### Example Usage
```
python get_links.py https://example.com
```

## Get System Info
This script returns your computer's system information.

### Dependencies
- `psutil`: `pip install psutil`

### Example Usage
```
python get_system_info.py
```

## Get Weather
This script returns the weather of a given city using the OpenWeatherMap API.

### Dependencies
- `requests`: `pip install requests`

### Arguments
- `city`: City name. Defaults to `London`.
- `--api-key`: OpenWeatherMap API key. Defaults to `$OPENWEATHER_API_KEY`.

### Example Usage
```
python get_weather.py London --api-key YOUR_KEY
```

## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` map.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(python goto.py repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```
cd "$(python goto.py repos)"
```

## India Time
This script converts a time to India Standard Time (IST). With no argument it shows the current time in India.

### Arguments
- `time`: Local time to convert, e.g. `8:26 AM`. If omitted, the current time is shown.

### Example Usage
```
python india_time.py
python india_time.py "8:26 AM"
```

## Instant GUI
This script generates an instant GUI.

### Example Usage
```
python instant_gui.py
```

## Ip
This script returns your IP address on demand.

### Example Usage
```
python ip.py
```

## JSON to CSV
This script converts a JSON file to CSV.

### Arguments
- `json_file`: Input JSON file. Defaults to `data.json`.
- `csv_file`: Output CSV file. Defaults to `data.csv`.

### Example Usage
```
python json_to_csv.py data.json data.csv
```

## Merge PDFs
This script merges the contents of multiple PDFs into one.

### Dependencies
- `pypdf` (or `PyPDF2`): `pip install pypdf`

### Arguments
- `pdfs`: PDF files to merge, in order (required).
- `-o`, `--output`: Output file. Defaults to `merged.pdf`.

### Example Usage
```
python merge_pdfs.py file1.pdf file2.pdf file3.pdf --output merged.pdf
```

## Neovim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Neovim.

### Dependencies
- **Neovim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```
python neovim.py example.txt
```

## New Branch
This script creates a new Git branch from `origin/master`, merges the latest changes, and pushes the new branch to the remote.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `branch`: Name of the new branch to create (required).

### Example Usage
```
python new_branch.py feature-branch
```

## Nginx
This script starts or reloads an Nginx server. If Nginx is already running it reloads the configuration; otherwise it starts a new instance.

### Dependencies
- **Nginx**: Must be installed, with its path configured in `NGINX_BASE` or passed with `--base`.

### Arguments
- `--base`: Nginx installation directory. Defaults to the `NGINX_BASE` constant.

### Example Usage
```
python nginx.py --base "C:\nginx"
```

## Organize Directory
This script organizes your directory by moving files into subfolders named after their file extension.

### Arguments
- `directory`: Directory to organize. Defaults to the current directory.

### Example Usage
```
python organize_directory.py .
```

## Print
This script prints text with optional ANSI color, a small color-enabled wrapper around `print`.

### Arguments
- `message`: The text to print (one or more words).
- `--color`: Foreground color (black, red, green, yellow, blue, magenta, cyan, white).
- `--no-newline`: Do not print a trailing newline.

### Example Usage
```
python print.py "Hello World" --color red
python print.py "Text" --color blue --no-newline
```

## Print Directory Tree
This script prints your current directory tree on the terminal.

### Arguments
- `directory`: Directory to print. Defaults to the current directory.

### Example Usage
```
python print_directory_tree.py .
```

## Random Password
This script generates a random password.

### Arguments
- `-l`, `--length`: Password length. Defaults to `12`.

### Example Usage
```
python random_password.py --length 24
```

## React Start
This script starts a React development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `3000`.
- `--command`: Command to run. Defaults to `npm start`.

### Example Usage
```
python react_start.py
```

## Read Pics
This script reads text from PNG images using Optical Character Recognition (OCR). It processes all PNG files in a 'PicturesToRead' folder and extracts text content from them.

### Dependencies
- `easyocr`: OCR library for text recognition

### Requirements
- A folder named 'PicturesToRead' containing PNG images
- Install easyocr: `pip install easyocr`

### Arguments
- `folder`: Folder of PNGs. Defaults to `PicturesToRead`.

### Example Usage
```
python read_pics.py PicturesToRead
```

## Rebase Git
This script rebases the current branch onto `origin/master` (or a specified branch) and force-pushes with lease, keeping a linear history with no merge commit.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: Branch to rebase onto. Defaults to `master`.

### Example Usage
```
python rebase_git.py
python rebase_git.py --branch main
```

## Rebase Git All
This script rebases every local branch onto its upstream, checking out each branch in turn. It stops if a rebase fails so conflicts can be resolved manually.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```
python rebase_git_all.py
```

## Regvim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Vim.

### Dependencies
- **Vim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```
python regvim.py example.txt
```

## Reset Git
This script resets the current branch to match `origin/main` exactly, discarding all local changes, then force-pushes. This is a destructive operation.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```
python reset_git.py
```

## Resize Image
This script resizes an image.

### Dependencies
- `pillow`: `pip install pillow`

### Arguments
- `input`: Input image path (required).
- `output`: Output image path (required).
- `--width`: Target width. Defaults to `800`.
- `--height`: Target height. Defaults to `600`.

### Example Usage
```
python resize_image.py input.jpg output.jpg --width 800 --height 600
```

## Safe Unzip
This script safely extracts a ZIP file, rejecting unsafe (path-traversal) entries and aborting if the file count or total uncompressed size exceeds the configured limits.

### Arguments
- `zip_path`: Path to the ZIP file to extract (required).
- `--max-file-count`: Maximum number of files allowed. Defaults to `1000`.
- `--max-total-size`: Maximum total uncompressed size in bytes. Defaults to `524288000` (500 MB).

### Example Usage
```
python safe_unzip.py archive.zip
python safe_unzip.py archive.zip --max-file-count 500 --max-total-size 104857600
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
```
python search_match.py .cs Term1 Term2
```

## Send Email
This script sends an email from Python.

### Arguments
- `subject`: Email subject (required).
- `body`: Email body (required).
- `to`: Recipient address (required).
- `--host`: SMTP host. Defaults to `$SMTP_HOST` or `smtp.example.com`.
- `--port`: SMTP port. Defaults to `$SMTP_PORT` or `465`.
- `--from`: Sender address. Defaults to `$SMTP_USER`.
- `--password`: Sender password. Defaults to `$SMTP_PASSWORD`.

### Example Usage
```
python send_email.py "Subject" "Body" recipient@example.com --from me@example.com --password secret
```

## Shorten URL
This script shortens a URL.

### Dependencies
- `requests`: `pip install requests`

### Arguments
- `url`: The URL to shorten. Defaults to `https://www.example.com`.

### Example Usage
```
python shorten_url.py https://www.example.com
```

## Stack Trace
This script parses a stack trace file and prints the relative file path from each frame, filtering out Microsoft framework calls for cleaner debugging output.

### Arguments
- `path`: Path to the stack trace file. Defaults to `test.txt`.

### Example Usage
```
python stack_trace.py
python stack_trace.py error.txt
```

## Start Mod
This script builds and launches a Minecraft mod client via the Gradle wrapper (`gradlew clean build` then `gradlew runClient`). Run it from the mod project directory.

### Arguments
- `--skip-build`: Skip `gradlew clean build` and only run the client.

### Example Usage
```
python start_mod.py
```

## Svelte Start
This script starts a Svelte development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```
python svelte_start.py
```

## Time
This script times any operation, printing how long the given command took to run.

### Arguments
- `command`: The command to run and time (required).

### Example Usage
```
python timer.py ping example.com
```

## Undo Commit
This script undoes the last commit using `git reset` and force-pushes the rewrite. Supports the `hard`, `mixed`, and `soft` reset modes.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-m`, `--mode`: Reset mode: `hard`, `mixed`, or `soft`. Defaults to `hard`.

### Example Usage
```
python undo_commit.py
python undo_commit.py --mode soft
```

## Unit Tests
This script cleans, builds, and tests a .NET unit test project with `dotnet clean`, `dotnet build`, and `dotnet test`.

### Dependencies
- **.NET SDK**: `dotnet` must be in your PATH

### Arguments
- `--project`: Path to the `.csproj` to test. Defaults to the `PROJECT_PATH` constant.

### Example Usage
```
python unit_tests.py --project MyProject.Tests.csproj
```

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```
python update_git.py --branch develop
```

## Update Git All
This script updates all local branches by checking out each branch and running the update-git steps on it, fetching and merging the latest changes.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```
python update_git_all.py
```

## Venn Diagram
This script creates a visual Venn diagram showing the relationship between two sets. It displays items that are unique to each set as well as items that are shared between them.

### Dependencies
- `matplotlib`: Plotting library
- `matplotlib_venn`: Venn diagram extension for matplotlib

### Requirements
- Install dependencies: `pip install matplotlib matplotlib-venn`

### Arguments
- `set_a`: Comma-separated items in the first set.
- `set_b`: Comma-separated items in the second set.
- `--label-a`: Label for the first set. Defaults to `Set A`.
- `--label-b`: Label for the second set. Defaults to `Set B`.

### Example Usage
```
python venn_diagram.py "A1,A2,Shared" "B1,B2,Shared"
```

## Vs
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio. A bare class name is treated as `<name>.cs`.

### Dependencies
- **Visual Studio**: `devenv.exe` must be in your PATH (integration uses `pywin32`)

### Arguments
- `file`: File name or C# class name to search for (required).

### Example Usage
```
python vs.py example.cs
python vs.py Program
```

## Vsc
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio Code.

### Dependencies
- **VS Code**: `code` must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```
python vsc.py example.js
```

## Vue Start
This script starts a Vue development server and opens it in Chrome.

### Dependencies
- **Node.js/npm**: Must be installed

### Arguments
- `--port`: Dev server port. Defaults to `5173`.
- `--command`: Command to run. Defaults to `npm run dev`.

### Example Usage
```
python vue_start.py
```
