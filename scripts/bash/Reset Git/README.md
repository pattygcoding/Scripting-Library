# Reset Git

Hard reset the current branch to match the origin/main state and force push.

## Description

This script performs a destructive git operation that completely resets your current branch to match the exact state of `origin/main`. It's designed for situations where you need to completely discard local changes and commits, reverting to the remote main branch state.

## Dependencies

- Git repository
- `git` command  
- Push access to origin remote
- Network access for fetching

## Usage

```bash
reset-git
```

## How it works

1. Fetches the latest changes from origin
2. Performs a hard reset to `origin/main`, discarding all local changes
3. Force pushes the reset state back to origin
4. Provides status updates throughout the process

## Example

```bash
reset-git
```

**Output:**
```bash
reset-git: Fetching...
reset-git: Resetting branch to original state...
reset-git: Pushing changes...
reset-git: Reset git complete.
```

## ⚠️ DANGER - Destructive Operation

**This script will permanently delete:**
- All uncommitted changes (modified, staged, untracked files)
- All local commits not in origin/main
- All local branch history divergent from origin/main

**Before running, ensure:**
- You have no important uncommitted work
- Any commits you want to keep are pushed to other branches
- You understand this operation cannot be easily undone

## Use Cases

**Legitimate uses:**
- Recovering from corrupted local repository state
- Discarding experimental changes you no longer want
- Syncing feature branch with main after major changes
- Cleaning up after failed merges or rebases
- Preparing branch for fresh start

**NOT recommended for:**
- Regular development workflow
- Shared branches with other developers
- When you have any uncommitted work worth keeping

## Before Running - Safety Checklist

```bash
# 1. Check current status
git status

# 2. Review uncommitted changes
git diff
git diff --staged

# 3. Check unpushed commits
git log origin/main..HEAD

# 4. Backup important changes (if any)
git stash push -m "backup before reset"
# or
git checkout -b backup-branch

# 5. Confirm you're on the correct branch
git branch
```

## Recovery Options

**If you need to recover after running:**

```bash
# Check reflog for previous state
git reflog

# Reset to previous state (replace HEAD@{n} with desired entry)
git reset --hard HEAD@{n}

# Recover stashed changes (if you stashed before)
git stash pop
```

## Alternative Safe Operations

**Instead of `reset-git`, consider:**

```bash
# Soft reset (keeps changes staged)
git reset --soft origin/main

# Mixed reset (keeps changes unstaged)  
git reset --mixed origin/main

# Reset specific files only
git checkout origin/main -- filename

# Create new branch from main
git checkout -b new-branch origin/main
```

## Branch Assumptions

The script assumes:
- Your main branch is named `main` (not `master`)
- You want to reset to `origin/main` specifically
- You have proper access to push to origin

**If your main branch is `master`:**
You'll need to modify the script to use `origin/master` instead.

## Notes

- Uses `git push --force` which overwrites remote branch history
- Operation affects only the current branch
- Network connection required for fetch and push operations
- No confirmation prompt - executes immediately
- Cannot be undone without using git reflog or backups