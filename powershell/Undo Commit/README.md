## Undo Commit
Undoes the last commit using git reset. Supports different reset modes (hard, mixed, soft) and automatically pushes the changes.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-mode`: Reset mode - "hard", "mixed", or "soft" (default: "hard")

### Example Usage
```powershell
undo-commit
undo-commit -mode "soft"
```