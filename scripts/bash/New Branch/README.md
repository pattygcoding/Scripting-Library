# New Branch

Create a new git branch from master, merge latest master changes, and push to origin.

## Description

This script automates the process of creating a new git branch based on the latest master branch. It ensures your new branch starts with the most recent changes from master and is immediately available on the remote repository.

## Dependencies

- Git repository
- `git` command
- Access to origin remote repository
- Proper git credentials for pushing

## Parameters

- `$1` - **Branch name** (required): Name for the new branch

## Usage

```bash
new-branch "branch-name"
```

## How it works

1. Validates that a branch name is provided
2. Fetches the latest changes from the remote repository
3. Creates and checks out a new branch based on `origin/master`
4. Merges latest master changes into the new branch
5. Pushes the new branch to origin with upstream tracking

## Example

```bash
new-branch "feature-user-authentication"
```

**Output:**
```bash
new-branch: Fetching...
new-branch: Checking out into new branch feature-user-authentication...
new-branch: Updating new branch feature-user-authentication with master...
new-branch: Pushing your new branch feature-user-authentication...
```

## Step-by-Step Process

1. **Fetch**: `git fetch` - Gets latest changes from remote
2. **Create**: `git checkout -b branch-name origin/master` - Creates new branch from latest master
3. **Merge**: `git merge origin/master` - Ensures branch has latest master changes
4. **Push**: `git push --set-upstream origin branch-name` - Pushes branch and sets up tracking

## Use Cases

- Starting new feature development
- Creating branches for bug fixes  
- Setting up branches for experiments
- Preparing branches for pull requests
- Creating branches for code reviews

## Best Practices

**Good branch naming:**
```bash
new-branch "feature-user-login"
new-branch "bugfix-memory-leak"
new-branch "hotfix-security-patch"
new-branch "refactor-user-service"
```

**Avoid these patterns:**
```bash
new-branch "temp"
new-branch "test123"
new-branch "my-branch"
```

## Error Handling

The script will display an error and usage information if no branch name is provided:

```bash
new-branch
# Output: new-branch: Branch name required.
# Usage: new-branch your-branch-name
```

## Safety Features

- **Latest master**: Always branches from the most recent master
- **Upstream tracking**: Sets up tracking so future pushes work seamlessly
- **Validation**: Requires branch name to prevent accidental execution
- **Fresh start**: Ensures new branch contains latest changes

## Notes

- Branch names should follow your team's naming conventions
- The script assumes `master` is your main branch name
- If your repository uses `main` instead of `master`, you may need to modify the script
- Network access is required for fetching and pushing
- Existing branches with the same name will cause git to error - choose unique names