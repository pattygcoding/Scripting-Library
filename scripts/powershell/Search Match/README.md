## Search Match

Searches for files with a specific extension containing specified strings. It can limit results, perform cross-term searches, display full directories, and filter for method calls.

### Parameters
- `-e`: File extension to search for.
- `-s`: Array of strings to search for within the files.
- `-uncapped`: Switch to list more than 3000 results.
- `-cross`: Switch to search for files containing all strings.
- `-dir`: Switch to display the full file directories.
- `-calls`: Switch to filter for lines where the string is used as a method call.

### Example Usage
```powershell
search-match -e ".php" -s "SearchTerm1", "SearchTerm2" -cross -dir
```
