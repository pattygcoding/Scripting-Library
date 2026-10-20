# Rebase Git

Rebase the current branch onto master or a specified branch.

## Description

This script performs a git rebase operation to apply commits from the current branch on top of the latest changes from master (or a specified branch). Rebasing creates a cleaner, linear commit history compared to merging.

## Dependencies

- Git repository
- `git` command
- Network access for fetching latest changes

## Parameters

- `$1` - **Target branch name** (optional): Branch to rebase onto. Defaults to `master`

## Usage

```bash
rebase-git [branch]
```

## How it works

1. Fetches the latest changes from the remote repository
2. Identifies the target branch (master by default or specified branch)
3. Rebases the current branch onto `origin/target-branch`
4. If rebase succeeds, force pushes the rebased branch to origin
5. Provides colored status updates throughout the process

## Examples

```bash
# Rebase current branch onto master
rebase-git
```

**Output:**
```bash
rebase-git: Fetching latest changes...
rebase-git: Rebasing onto origin/master...
rebase-git: Rebase successful. Pushing rebased changes...
rebase-git: Rebase complete. Your branch is now up to date with master (no merge commit).
```

```bash
# Rebase onto a specific branch
rebase-git develop
```

**Output:**
```bash
rebase-git: Fetching latest changes...
rebase-git: Rebasing onto origin/develop...
rebase-git: Rebase successful. Pushing rebased changes...
rebase-git: Rebase complete. Your branch is now up to date with develop (no merge commit).
```

## Conflict Resolution

If conflicts occur during rebase:

**Script Output:**
```bash
rebase-git: Rebase failed. Resolve conflicts and run 'git rebase --continue' manually.
```

**Manual Resolution Steps:**
1. Edit conflicted files to resolve conflicts
2. Stage resolved files: `git add <file>`
3. Continue rebase: `git rebase --continue`
4. Push changes: `git push --force-with-lease`

## Rebase vs Merge

**Rebase Advantages:**
- ✅ Linear commit history
- ✅ Cleaner project history
- ✅ No merge commits
- ✅ Easier to follow development flow

**Rebase Considerations:**
- ⚠️ Rewrites commit history
- ⚠️ Requires force push
- ⚠️ Can be complex with conflicts
- ⚠️ Not suitable for shared branches

## Safety Features

- **Force with lease**: Uses `git push --force-with-lease` for safer force pushing
- **Conflict detection**: Stops execution if conflicts occur
- **Status reporting**: Clear messages about each step
- **Error handling**: Returns appropriate exit codes on failure

## Best Practices

1. **Feature branches only**: Use rebase on feature branches, not shared branches
2. **Regular rebasing**: Rebase frequently to avoid large conflict sets
3. **Clean commits**: Ensure commits are ready before rebasing
4. **Team communication**: Inform team members about rebased branches

## Use Cases

- Updating feature branches with latest master changes
- Preparing clean history before pull requests
- Integrating upstream changes without merge commits
- Maintaining linear project history

## Notes

- This operation rewrites commit history using force push
- Team members working on the same branch will need to reset their local copies
- Failed rebases require manual intervention to resolve conflicts
- The script assumes standard branch naming (`master`, `origin/master`)
- Consider using interactive rebase (`git rebase -i`) for more control over commit history