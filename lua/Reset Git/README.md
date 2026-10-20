## Reset Git
This script resets the current Git branch to match the state of `origin/main` and force pushes the changes. This is useful for completely resetting a branch to its remote state.

### Example Usage
```lua
lua reset-git.lua
```

### Warning
This operation is destructive and will permanently remove any local changes or commits that haven't been pushed to the remote branch.