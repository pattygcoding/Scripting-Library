## Rebase Git
This script rebases the current Git branch onto another branch (default is `master`) and pushes the changes using force-with-lease to maintain a clean linear history.

### Arguments  
- `branch`: The branch to rebase onto (default is `master`)

### Example Usage
```lua
lua rebase-git.lua develop
```