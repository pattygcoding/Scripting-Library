# Compress Git

Compress multiple commits into a single commit by soft resetting to origin/main and recommitting.

## Description

This script allows you to compress multiple commits on your current branch into a single commit. It's useful for cleaning up commit history before merging or when you want to squash several development commits into one coherent commit.

## Dependencies

- Git repository
- `git` command
- Push access to the remote repository

## Parameters

- `$1` - **Commit message** (required): The commit message for the compressed commit

## Usage

```bash
compress-git "commit message"
```

## How it works

1. Fetches the latest changes from origin
2. Performs a soft reset to `origin/main`, preserving all changes in the staging area
3. Creates a single new commit with all the changes and the provided message
4. Force pushes the changes to the remote repository

## Example

```bash
# Compress multiple commits into one
compress-git "Feature: Add user authentication system"
```

**Output:**
```bash
compress-git: Fetching...
compress-git: Staging changes for compression...
compress-git: Committing changes...
compress-git: Pushing changes...
compress-git: Compress git complete.
```

## Before and After Example

**Before compression:**
```
* abc123f Fix typo in login form
* def456g Add password validation
* ghi789h Add login form structure
* jkl012i Update dependencies
* origin/main
```

**After compression:**
```
* mno345p Feature: Add user authentication system
* origin/main
```

## Safety Considerations

⚠️ **Warning**: This is a destructive operation that rewrites commit history.

- **Force push**: The script uses `git push --force`, which overwrites remote history
- **Lost history**: Individual commit messages and history will be lost
- **Team coordination**: Ensure team members are aware before compressing shared branches
- **Backup recommended**: Consider creating a backup branch before compression

## Best Practices

1. **Use on feature branches**: Avoid compressing commits on shared branches like `main` or `develop`
2. **Meaningful messages**: Provide clear, descriptive commit messages that summarize all changes
3. **Review changes**: Use `git status` and `git diff --staged` to review what will be committed
4. **Team communication**: Inform team members before compressing commits on shared feature branches

## Use Cases

- Cleaning up development commits before creating a pull request
- Combining related commits into logical units
- Preparing feature branches for merge
- Simplifying commit history for easier review

## Notes

- All changes from multiple commits are preserved, only the history is simplified
- The script resets to `origin/main` - ensure your branch is up to date with main first
- Failed compression may require manual intervention to resolve conflicts
- Consider using interactive rebase (`git rebase -i`) for more granular control