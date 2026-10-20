# Undo Commit

Undo the last git commit with configurable reset mode.

## Description

This script provides a convenient way to undo the most recent git commit with different reset options. It allows you to specify how you want the changes from the undone commit to be handled - whether to keep them staged, unstaged, or discard them entirely.

## Dependencies

- Git repository
- `git` command
- Push access to origin remote

## Parameters

- `$1` - **Reset mode** (optional): How to handle the undone commit's changes
  - `hard` - Discard all changes (default)
  - `mixed` - Keep changes unstaged  
  - `soft` - Keep changes staged

## Usage

```bash
undo-commit [mode]
```

## How it works

1. Validates the reset mode parameter
2. Performs `git reset --[mode] HEAD~1` to undo the last commit
3. Force pushes the changes to origin
4. Provides colored status updates

## Examples

```bash
# Undo commit and discard all changes (default behavior)
undo-commit
# or explicitly:
undo-commit hard
```

**Output:**
```bash
undo-commit: Undoing the last commit with --hard...
undo-commit: Pushing changes...
undo-commit: Undo last commit complete.
```

```bash
# Undo commit but keep changes staged for recommit
undo-commit soft
```

**Output:**
```bash
undo-commit: Undoing the last commit with --soft...
undo-commit: Pushing changes...
undo-commit: Undo last commit complete.
```

```bash
# Undo commit and keep changes unstaged
undo-commit mixed
```

**Output:**
```bash
undo-commit: Undoing the last commit with --mixed...
undo-commit: Pushing changes...
undo-commit: Undo last commit complete.
```

## Reset Mode Details

### Hard Reset (`hard`)
- **Commit**: ❌ Removed
- **Staged changes**: ❌ Discarded
- **Working directory**: ❌ Discarded
- **Result**: Clean working directory

### Mixed Reset (`mixed`)  
- **Commit**: ❌ Removed
- **Staged changes**: ❌ Unstaged
- **Working directory**: ✅ Preserved
- **Result**: Changes ready to be re-staged

### Soft Reset (`soft`)
- **Commit**: ❌ Removed  
- **Staged changes**: ✅ Preserved
- **Working directory**: ✅ Preserved
- **Result**: Changes ready to be recommitted

## Use Cases

**Hard reset - when you want to completely discard the commit:**
```bash
undo-commit hard
# Useful for: Accidental commits, commits with errors you don't want to fix
```

**Soft reset - when you want to recommit with changes:**
```bash
undo-commit soft
git commit -m "Better commit message"
# Useful for: Fixing commit messages, adding forgotten files
```

**Mixed reset - when you want to modify and re-stage:**
```bash
undo-commit mixed
# Edit files as needed
git add modified-files
git commit -m "Updated commit"
# Useful for: Partial recommits, file modifications
```

## Error Handling

**Invalid reset mode:**
```bash
undo-commit invalid
# Output: Invalid mode specified. Use 'hard', 'mixed', or 'soft'.
# Exit code: 1
```

## Before and After Examples

**Before undo-commit:**
```
* abc123f (HEAD) Fix login bug      <- This will be removed
* def456g Add user authentication
* ghi789h Initial project setup
```

**After undo-commit soft:**
```
* def456g (HEAD) Add user authentication
* ghi789h Initial project setup

# Changes from "Fix login bug" are staged
git status:
Changes to be committed:
  modified: login.js
```

**After undo-commit mixed:**
```
* def456g (HEAD) Add user authentication  
* ghi789h Initial project setup

# Changes from "Fix login bug" are unstaged
git status:
Changes not staged for commit:
  modified: login.js
```

**After undo-commit hard:**
```
* def456g (HEAD) Add user authentication
* ghi789h Initial project setup

# All changes are gone
git status:
nothing to commit, working tree clean
```

## ⚠️ Safety Warnings

- **Force push**: This script uses `git push --force`, which overwrites remote history
- **Destructive with hard**: Hard reset permanently deletes changes
- **Team coordination**: Notify team members when undoing commits on shared branches
- **Backup recommended**: Consider creating a backup branch before undoing important commits

## Recovery

If you need to recover an undone commit:

```bash
# View recent git operations
git reflog

# Restore to previous state (replace HEAD@{n} with desired entry)
git reset --hard HEAD@{n}
```

## Notes

- Only affects the most recent commit (`HEAD~1`)
- Uses force push to update remote repository  
- Default mode is `hard` if no mode specified
- Cannot undo multiple commits with a single command
- Preserves repository integrity while modifying history