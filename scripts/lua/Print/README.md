## Print
This script prints text with optional ANSI color.

### Arguments
- `message`: The text to print (one or more words).
- `--color`: Foreground color (black, red, green, yellow, blue, magenta, cyan, white).
- `--no-newline`: Do not print a trailing newline.

### Example Usage
```lua
lua print.lua "Hello World" --color red
lua print.lua "Text" --color blue --no-newline
```
