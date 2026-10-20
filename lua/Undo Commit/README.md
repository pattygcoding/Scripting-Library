## Undo Commit
This script undoes the last Git commit using different reset modes and force pushes the changes to the remote repository.

### Arguments
- `mode`: The reset mode to use - `hard`, `mixed`, or `soft` (default is `hard`)
  - `hard`: Resets index and working tree (removes all changes)
  - `mixed`: Resets index but not working tree (keeps file changes unstaged)  
  - `soft`: Keeps index and working tree (keeps file changes staged)

### Example Usage
```lua
lua undo-commit.lua soft
```