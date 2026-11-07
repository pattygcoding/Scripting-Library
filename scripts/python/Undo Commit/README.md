## Undo Commit
This script undoes the last commit using `git reset` and force-pushes the rewrite. Supports the `hard`, `mixed`, and `soft` reset modes.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `-m`, `--mode`: Reset mode: `hard`, `mixed`, or `soft`. Defaults to `hard`.

### Example Usage
```
python undo_commit.py
python undo_commit.py --mode soft
```
