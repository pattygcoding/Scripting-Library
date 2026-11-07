## Rebase Git
This script rebases the current branch onto `origin/master` (or a specified branch) and force-pushes with lease, keeping a linear history with no merge commit.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-b`, `--branch`: Branch to rebase onto. Defaults to `master`.

### Example Usage
```
python rebase_git.py
python rebase_git.py --branch main
```
