# Ruby Scripts by Patrick Goodwin
[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)

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
This script deletes all local branches that do not have a corresponding remote origin branch, helping to clean up your local Git repository.

### Example Usage
```ruby
ruby clear-git.rb
```

## Count Files
This script counts the number of files in the current directory and its subdirectories. It can optionally exclude the `node_modules` directory.

### Arguments
- `--includenode`: Include files in the `node_modules` directory.

### Example Usage
```ruby
ruby count_files.rb
```

## Dotnet Analysis
This script analyzes .NET application log files to extract and group database commands, action methods, executed actions, and endpoints. It provides a structured view of application execution with color-coded output.

### Arguments
- `file`: The log file to analyze (defaults to "TestFile1.txt" if not provided)

### Dependencies
- Ruby standard library (no external gems required)

### Example Usage
```ruby
ruby dotnet-analysis.rb logfile.txt
```

## JSON to CSV
This script converts JSON data files to CSV format. It reads a JSON file containing an array of objects and converts it to a CSV file with headers from the object keys.

### Dependencies
- `json` gem (Ruby standard library)
- `csv` gem (Ruby standard library)

### Example Usage
```ruby
ruby json_to_csv.rb
```

**Note:** By default, the script looks for `data.json` in the current directory and outputs `data.csv`. Modify the file paths in the script as needed.

## Random Password
This script generates a random password.

### Example Usage
```ruby
ruby random_password.rb
```

## Rebase Git
This script rebases the current Git branch onto a specified branch (default is `master`). It fetches the latest changes, performs the rebase, and pushes the rebased changes using `--force-with-lease` for safety.

### Arguments
- `branch`: The branch to rebase onto (optional, defaults to `master`)

### Example Usage
```ruby
ruby rebase-git.rb
ruby rebase-git.rb develop
```

## Reset Git
This script performs a hard reset of the current Git branch to match the `origin/main` branch exactly. This will discard all local changes and commits that are not on the remote main branch.

### Example Usage
```ruby
ruby reset-git.rb
```

**Warning:** This operation is destructive and will permanently remove local changes and commits.

## Undo Commit
This script undoes the last Git commit using different reset modes. It supports hard, mixed, or soft reset modes and force pushes the changes.

### Arguments
- `mode`: The reset mode to use (`hard`, `mixed`, or `soft`). Defaults to `hard` if not specified.
  - `hard`: Removes commit and discards all changes
  - `mixed`: Removes commit but keeps changes in working directory
  - `soft`: Removes commit but keeps changes staged

### Example Usage
```ruby
ruby undo-commit.rb
ruby undo-commit.rb soft
ruby undo-commit.rb mixed
```

**Warning:** This operation force pushes changes and may affect the remote repository.

## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Arguments
- `-branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```ruby
ruby update_git.rb -branch develop
```
