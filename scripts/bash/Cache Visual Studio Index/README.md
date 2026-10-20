# Cache Visual Studio Index

Build and maintain an index of .cs files in a project directory for faster file searching in Visual Studio integration scripts.

## Description

This script creates and maintains an index file that maps C# class names to their file paths. It's designed to work with the `vs` script to provide fast file discovery when opening files in Visual Studio. The script efficiently tracks changes to .cs files and updates the index accordingly.

## Dependencies

- `find` command
- Bash associative arrays support
- File system with .cs files

## Parameters

- `$1` - **Root directory** (optional): Directory to search for .cs files. Defaults to current directory (`pwd`)
- `$2` - **Index file path** (optional): Path where the index file should be stored

## Usage

```bash
cache-vsindex [root_directory] [index_file]
```

## How it works

1. Reads existing index file (if it exists) into memory
2. Scans the specified directory for all .cs files
3. Creates a new index mapping class names to their directory paths
4. Compares the new index with the old one to detect changes
5. Updates the index file with additions, removals, and changes
6. Reports statistics on the changes made

## Examples

```bash
# Index current directory with default settings
cache-vsindex

# Index a specific project directory
cache-vsindex /path/to/my-project

# Index with custom index file location
cache-vsindex /path/to/project /custom/path/vs-index.txt

# Index current directory with specific index file
cache-vsindex . ./vs-cache.index
```

**Sample Output:**
```bash
Index updated: +25 / -3 / *5
# +25 = 25 new files added
# -3  = 3 files removed
# *5  = 5 files changed location
```

## Index File Format

The index file stores mappings in the format:
```
ClassName|/path/to/dir1;/path/to/dir2;/path/to/dir3
```

Example:
```
UserController|./Controllers;./Legacy/Controllers
ProductService|./Services
```

## Use Cases

- Preparing file index for Visual Studio integration
- Tracking C# class locations across large projects
- Optimizing file search performance in development tools
- Maintaining project file organization awareness

## Notes

- The script only indexes .cs files
- Multiple files with the same class name will have all their directories listed
- The index is sorted alphabetically by class name
- Changes are detected by comparing file paths, not content
- No changes detected will result in "No changes detected" message