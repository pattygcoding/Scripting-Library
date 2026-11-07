# Regvim

Search for files by name in the current directory and its subdirectories, then open each match in Vim.

## Dependencies

- Vim (`vim`)
- `find` command

## Parameters

- `$1` - File name to search for (required)

## Usage

```bash
regvim <file-name>
```

## Example

```bash
regvim Program.cs
# Output: Opening ./src/Program.cs in vim
```
