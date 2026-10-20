## Compress Git
Compresses all changes in your current branch into a single commit by resetting to origin/main and making a new commit with all changes. This is useful for squashing multiple commits.

### Dependencies
- **Git**: Must be in your PATH as an environment variable

### Parameters
- `-message`: Commit message for the compressed commit (mandatory)

### Example Usage
```powershell
Compress-Git -message "Feature implementation"
```