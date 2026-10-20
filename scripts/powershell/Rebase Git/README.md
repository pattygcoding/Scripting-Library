## Rebase Git
Rebases the current branch onto origin/master or a specified branch. Maintains a clean commit history by applying commits on top of the target branch.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-branch`: Branch to rebase onto (default: "master")

### Example Usage
```powershell
rebase-git
rebase-git -branch "main"
```