## Rebase Git All
This script rebases every local branch onto its upstream, checking out each branch in turn. It stops if a rebase fails so conflicts can be resolved manually.

### Dependencies
- **Git**: Must be in your PATH

### Example Usage
```lua
lua rebase-git-all.lua
```
