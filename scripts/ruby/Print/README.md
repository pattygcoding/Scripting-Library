## Print
This script prints text with optional ANSI color, a small color-enabled wrapper around `print`.

### Arguments
- `message`: The text to print (one or more words).
- `--color`: Foreground color (black, red, green, yellow, blue, magenta, cyan, white).
- `--no-newline`: Do not print a trailing newline.

### Example Usage
```
ruby print.rb "Hello World" --color red
ruby print.rb "Text" --color blue --no-newline
```
