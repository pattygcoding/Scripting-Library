# Create File

Create a new empty file with the specified name, automatically adding .txt extension if none is provided.

## Description

This script provides a simple way to create empty files in the current directory. It automatically appends a `.txt` extension if the filename doesn't already contain an extension, making it convenient for quickly creating text files.

## Dependencies

- Bash shell environment
- File system write permissions

## Parameters

- `$1` - **Filename** (required): Name for the new file to create

## Usage

```bash
create-file <filename>
```

## How it works

1. **Input validation**: Checks if a filename is provided
2. **Extension handling**: If no extension is detected (no dot in filename), appends `.txt`
3. **File creation**: Creates an empty file using the `: >` operator

## Examples

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

## Use Cases

- **Quick file creation**: Rapidly create empty files for development
- **Template preparation**: Create placeholder files for projects
- **Script setup**: Generate empty script files with proper extensions
- **Documentation**: Create empty markdown or text files

## Error Handling

**No filename provided:**
```bash
create-file
# Output: Usage: create-file <filename>
# Exit code: 1
```

## Notes

- Files are created in the current working directory
- If a file with the same name already exists, it will be overwritten with an empty file
- The script uses the `: >` operator which is more portable than `touch` for creating empty files
- File permissions follow system defaults