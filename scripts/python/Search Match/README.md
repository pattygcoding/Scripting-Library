## Search Match
This script searches for patterns in files within the current directory and its subdirectories. It supports various options, including uncapped results, cross-term search, full directory display, and filtering based on function call patterns.

### Arguments
- `extension`: File extension to search (e.g., `.txt`).
- `terms`: One or more terms to search for in the files.
- `--uncapped`: List more than the limit of 3000 results.
- `--cross`: Only search for files that contain all of the specified terms.
- `--dir`: Display the full file directories, not just the file names.
- `--calls`: Display only if there is a period (.) before the string. Useful for locating function calls.

### Example Usage
```
python search_match.py .cs Term1 Term2
```
