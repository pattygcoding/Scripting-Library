# Clear Git

Delete local git branches that don't have corresponding origin remotes (orphaned branches).

## Description

This script identifies and deletes local git branches that no longer have corresponding remote branches on origin. It helps clean up your local repository by removing orphaned branches that were likely deleted on the remote but still exist locally.

## Dependencies

- Git repository
- `git` command
- `awk` command for text processing

## Usage

```bash
clear-git
```

## How it works

1. Uses `git branch -vv` to list all local branches with their remote tracking information
2. Filters branches that don't have `[origin/` in their tracking info (orphaned branches)
3. Deletes each orphaned branch using `git branch -D`
4. Provides colored output showing the cleanup progress

## Example

```bash
clear-git
```

**Sample Output:**
```bash
clear-git: Deleting orphan branch: feature-old-implementation
clear-git: Deleting orphan branch: bugfix-login-issue
clear-git: Deleting orphan branch: experimental-feature
clear-git: No local branches without origin found.
```

**If no orphaned branches exist:**
```bash
clear-git: No local branches without origin found.
```

## What branches get deleted

This script will delete branches that:
- Exist only locally (never pushed to origin)
- Had their remote counterparts deleted (merged/closed pull requests)
- Are not tracking any remote branch

## What branches are preserved

This script will **NOT** delete:
- Branches with active remote tracking (showing `[origin/branch-name]`)
- The currently checked out branch
- Branches that are tracking remote branches

## Safety Notes

- This script uses `git branch -D` (force delete) to remove branches
- Make sure you don't have important uncommitted work on orphaned branches
- Consider using `git branch -a` to review your branches before running this script
- The script only affects local branches, never remote branches

## Use Cases

- Cleaning up after merged pull requests
- Removing experimental branches that were never pushed
- Maintaining a clean local branch list
- Preparing repository for handoff or backup