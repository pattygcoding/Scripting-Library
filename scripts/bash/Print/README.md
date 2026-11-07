# Print

Print text with optional ANSI color.

## Parameters

- `$1...` - Text to print
- `--color <name>` - Foreground color (`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`)
- `--no-newline` - Do not print a trailing newline

## Usage

```bash
print <text> [--color name] [--no-newline]
```

## Example

```bash
print "Hello World" --color red
print "Text" --color blue --no-newline
```
