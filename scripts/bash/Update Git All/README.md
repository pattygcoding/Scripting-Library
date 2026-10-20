# Update Git All

Update all local branches by merging latest changes from their respective upstream branches.

## Description

This script automates the process of updating all local git branches with the latest changes from their upstream branches. It iterates through every local branch, switches to it, and runs the `update-git` function to merge the latest changes, ensuring your entire repository stays synchronized.

## Dependencies

- Git repository with multiple branches
- `git` command
- `update-git` function must be available in your environment
- Network access for fetching updates

## Usage

```bash
update-git-all
```

## How it works

1. Discovers all local branches using `git for-each-ref`
2. Iterates through each branch sequentially
3. Checks out each branch (silently)
4. Calls the `update-git` function for each branch
5. Provides status updates showing current branch being processed
6. Reports completion when all branches are updated

## Prerequisites

**Required Function:**
The `update-git` function must be loaded in your environment. Make sure to source the update-git script first:

```bash
source /path/to/update-git.sh
```

## Example

```bash
update-git-all
```

**Sample Output:**
```bash
Currently on branch: main
update-git: Fetching...
update-git: Merging origin/master into the current branch...
update-git: Auto-merge complete. Your branch is now up to date with master.

Currently on branch: feature-authentication
update-git: Fetching...
update-git: Merging origin/master into the current branch...
update-git: Auto-merge complete. Your branch is now up to date with master.

Currently on branch: develop
update-git: Fetching...
update-git: Merging origin/master into the current branch...
update-git: Auto-merge complete. Your branch is now up to date with master.

Finished processing all branches.
```

## Branch Discovery

The script finds branches using:
```bash
git for-each-ref --format='%(refname:short)' refs/heads/
```

This includes:
- Main/master branches
- Feature branches  
- Development branches
- Release branches
- Any custom named branches

## Conflict Handling

If merge conflicts occur on any branch:

1. **Script stops on the conflicted branch**
2. **You remain on the problematic branch**
3. **Manual resolution required:**
   ```bash
   # Resolve conflicts in affected files
   git add resolved-files
   git commit
   git push
   
   # Then continue with remaining branches manually or re-run script
   ```

## Use Cases

**Development Team Synchronization:**
```bash
# Start of day - sync all branches
update-git-all
```

**Pre-Release Preparation:**
```bash
# Ensure all branches are up to date before release
update-git-all
```

**Repository Maintenance:**
```bash
# Weekly maintenance to keep all branches current
update-git-all
```

**After Major Updates:**
```bash
# After important changes are merged to master
update-git-all
```

## Safety Considerations

**Before running:**
```bash
# Check for uncommitted changes across branches
git status

# Check which branches exist
git branch -a

# Ensure no pending work on any branch
git stash list
```

**Best practices:**
- Run during low-activity periods
- Ensure no team members are actively working on shared branches
- Consider creating backup branches for important work
- Be prepared to resolve conflicts manually

## Performance Notes

- **Sequential Processing**: Branches are updated one at a time
- **Network Intensive**: Multiple fetch operations (one per branch)
- **Time Varies**: Depends on number of branches and network speed
- **No Parallelization**: Safe but slower than parallel updates

## Repository States

**Before update-git-all:**
```
main: 3 commits behind origin/master
feature-a: 1 commit behind origin/master  
feature-b: 5 commits behind origin/master
develop: 2 commits behind origin/master
```

**After update-git-all:**
```
main: up to date with origin/master
feature-a: up to date with origin/master
feature-b: up to date with origin/master  
develop: up to date with origin/master
```

## Error Recovery

If the script fails partway through:

```bash
# Check current branch
git branch

# Check status of current branch
git status

# If in middle of merge, resolve and continue:
git add resolved-files
git commit
git push

# Re-run update-git-all to continue with remaining branches
update-git-all
```

## Customization

To update branches from different upstream branches, modify the `update-git` function or create branch-specific logic:

```bash
# Example: Update develop branches from develop, others from master
case $branch_name in
  develop|integration)
    update-git develop
    ;;
  *)
    update-git
    ;;
esac
```

## Notes

- Branch checkouts are silent (`> /dev/null 2>&1`) to reduce output noise
- Script assumes all branches should be updated from master by default
- No branches are created or deleted, only updated
- Network access required for each branch update
- Compatible with most git workflows and branching strategies