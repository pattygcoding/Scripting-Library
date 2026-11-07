# Count Files

Count the number of files in the current directory and its subdirectories, grouped by extension.

## Dependencies

- `find` command

## Parameters

- `--includenode` - Include files in `node_modules` directories

## Usage

```bash
count-files [--includenode]
```

## Example

```bash
count-files
# Output: Total number of files: 42
# Output: Files by extension:
# Output: .sh: 41
# Output: .md: 1
```
