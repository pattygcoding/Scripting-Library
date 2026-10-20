# Update Git

Merge the latest changes from master or a specified branch into the current branch.

## Description

This script automates the process of updating your current branch with the latest changes from master or another specified branch. It fetches the latest changes and merges them into your current branch, maintaining a clean merge history with descriptive commit messages.

## Dependencies

- Git repository
- `git` command
- Network access for fetching changes
- Access to origin remote

## Parameters

- `$1` - **Source branch name** (optional): Branch to merge from. Defaults to `master`

## Usage

```bash
update-git [branch]
```

## How it works

1. Fetches the latest changes from origin
2. Determines the source branch (master by default, or specified branch)
3. Merges `origin/[branch]` into the current branch
4. Creates an automatic merge commit with descriptive message
5. Pushes the updated branch to origin
6. Provides colored status updates throughout

## Examples

```bash
# Update current branch with latest master changes
update-git
```

**Output:**
```bash
update-git: Fetching...
update-git: Merging origin/master into the current branch...
update-git: Pushing changes...
update-git: Auto-merge complete. Your branch is now up to date with master.
```

```bash
# Update current branch with changes from develop branch
update-git develop
```

**Output:**
```bash
update-git: Fetching...
update-git: Merging origin/develop into the current branch...
update-git: Pushing changes...
update-git: Auto-merge complete. Your branch is now up to date with develop.
```

## Auto-Generated Commit Messages

The script creates descriptive merge commit messages:

**For master branch:**
```
Auto-merge update: Merged master to branch using update-git Bash function (git fetch; git merge origin/master; git push;)
```

**For specified branch:**
```
Auto-merge update: Merged develop to branch using update-git Bash function (git fetch; git merge origin/develop; git push;)
```

## Use Cases

**Feature Development:**
```bash
# Keep feature branch up to date with master
git checkout feature-user-auth
update-git
```

**Integration Branches:**
```bash  
# Update integration branch with latest develop
git checkout integration
update-git develop
```

**Maintenance:**
```bash
# Update hotfix branch with master changes
git checkout hotfix-security-patch
update-git
```

## Merge vs Rebase

This script uses **merge** (not rebase):

**Merge advantages:**
- ✅ Preserves branch history
- ✅ Shows when integration happened
- ✅ Safe for shared branches
- ✅ Clear merge commit messages

**Merge considerations:**
- Creates merge commits
- May result in more complex history
- Can cause merge conflicts

## Conflict Resolution

If merge conflicts occur:

1. **Git will pause the merge:**
   ```bash
   Auto-merging file.txt
   CONFLICT (content): Merge conflict in file.txt
   Automatic merge failed; fix conflicts and then commit the result.
   ```

2. **Resolve conflicts manually:**
   - Edit conflicted files
   - Remove conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
   - Save resolved files

3. **Complete the merge:**
   ```bash
   git add resolved-file.txt
   git commit  # Uses default merge message
   git push
   ```

## Branch Workflow Integration

**Git Flow compatibility:**
```bash
# Update develop branch
git checkout develop  
update-git

# Update feature from develop
git checkout feature-branch
update-git develop
```

**GitHub Flow compatibility:**
```bash
# Update feature branch with main
git checkout feature-branch
update-git main  # if your main branch is 'main'
```

## Safety Features

- **Fetch first**: Always gets latest remote information
- **Automatic push**: Ensures remote is updated
- **Status messages**: Clear progress indication
- **Descriptive commits**: Auto-generated meaningful commit messages

## Best Practices

1. **Regular updates**: Run frequently to avoid large merge conflicts
2. **Clean working directory**: Commit or stash changes before updating
3. **Feature branches**: Primarily use on feature branches, not main branches
4. **Team communication**: Coordinate updates on shared branches

## Pre-Update Checklist

```bash
# Check current status
git status

# Ensure no uncommitted changes
# Either commit:
git add . && git commit -m "WIP: Save progress"
# Or stash:
git stash push -m "Temporary changes"

# Then update:
update-git
```

## Notes

- The script assumes standard git remote naming (`origin`)
- Network connection required for fetch and push operations
- Merge conflicts may require manual resolution
- Creates merge commits that appear in project history
- Compatible with most git workflows and branching strategies