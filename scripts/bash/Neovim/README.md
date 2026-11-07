# Neovim

Search for files by name in the current directory and its subdirectories, then open each match in Neovim.

## Dependencies

- Neovim (`nvim`)
- `find` command

## Parameters

- `$1` - File name to search for (required)

## Usage

```bash
neovim <file-name>
```

## Example

```bash
neovim Program.cs
# Output: Opening ./src/Program.cs in nvim
```
