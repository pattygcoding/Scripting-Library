# Vsc

Search for a file by name in the current directory and its subdirectories, then open it in Visual Studio Code.

## Dependencies

- VS Code (`code`)
- `find` command

## Parameters

- `$1` - File name to search for (required)

## Usage

```bash
vsc <file-name>
```

## Example

```bash
vsc Program.js
# Output: Opening ./src/Program.js in VS Code
```
