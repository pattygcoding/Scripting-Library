# Rebase Git All

Rebase all local branches onto their respective upstream branches.

## Description

This script automates the process of rebasing all local git branches onto their upstream branches. It iterates through every local branch, switches to it, and performs a rebase operation, helping maintain a clean and up-to-date repository with linear history across all branches.

## Dependencies

- Git repository with multiple branches
- `git` command
- `rebase-git` function must be available in your environment
- Network access for fetching updates

## Usage

```bash
rebase-git-all
```

## How it works

1. Discovers all local branches using `git for-each-ref`
2. Checks out each branch sequentially
3. Calls the `rebase-git` function for each branch
4. Provides status updates for each branch processed
5. Reports completion when all branches are processed

## Example

```bash
rebase-git-all
```

**Sample Output:**
```bash
Currently on branch: main
rebase-git: Fetching latest changes...
rebase-git: Rebasing onto origin/main...
rebase-git: Rebase complete. Your branch is now up to date with main (no merge commit).

Currently on branch: feature-authentication
rebase-git: Fetching latest changes...
rebase-git: Rebasing onto origin/master...
rebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).

Currently on branch: develop
rebase-git: Fetching latest changes...
rebase-git: Rebasing onto origin/develop...
rebase-git: Rebase complete. Your branch is now up to date with develop (no merge commit).

Finished rebasing all branches onto their upstreams.
```

## Prerequisites

**Required Function:**
The `rebase-git` function must be loaded in your environment. Make sure to source the rebase-git script first:

```bash
source /path/to/rebase-git.sh
```

## Error Handling

If a rebase fails on any branch:

**Script Output:**
```bash
Currently on branch: problematic-branch
rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.
Rebase failed on branch 'problematic-branch'. Resolve manually and continue.
```

The script will:
1. Stop execution on the failed branch
2. Leave you on the branch with conflicts
3. Provide instructions for manual resolution
4. Return exit code 1

## Branch Discovery

The script finds branches using:
```bash
git for-each-ref --format='%(refname:short)' refs/heads/
```

This includes:
- All local branches
- Feature branches
- Development branches  
- Main/master branches
- Any custom named branches

## Safety Considerations

⚠️ **Important Warnings:**

1. **Destructive Operation**: Rebasing rewrites commit history
2. **Force Pushes**: Each branch may be force pushed to origin
3. **Team Coordination**: Notify team members before running
4. **Backup Recommended**: Consider backing up important branches
5. **Conflict Resolution**: Be prepared to resolve conflicts manually

## Best Practices

1. **Clean Working Directory**: Ensure no uncommitted changes before running
2. **Fetch First**: Run `git fetch` to get latest remote information
3. **Team Communication**: Coordinate with team on shared branches
4. **Conflict Planning**: Be available to resolve conflicts that may arise

## Use Cases

- Bulk updating all feature branches with latest changes
- Preparing repository for releases
- Maintaining clean history across multiple branches  
- Syncing all branches after major updates
- Repository maintenance and cleanup

## Recovery Steps

If something goes wrong:

```bash
# View current branch and status
git status

# If in middle of rebase
git rebase --abort  # Cancel current rebase
# or
git rebase --continue  # Continue after resolving conflicts

# Check reflog for recent changes
git reflog

# Reset branch to previous state if needed
git reset --hard HEAD@{n}  # where n is reflog entry
```

## Notes

- The script processes branches sequentially, not in parallel
- Each branch checkout is silent (`> /dev/null 2>&1`)
- No branches are created or deleted, only rebased
- The script assumes standard git repository structure
- Network access required for fetching upstream changes
- Execution time depends on number of branches and conflicts encountered