## Compress Git
This script squashes all changes on the current branch into a single commit by resetting to `origin/main` and committing everything, then force-pushing.

### Dependencies
- **Git**: Must be in your PATH

### Arguments
- `message`: Commit message for the squashed commit (required).

### Example Usage
```
ruby compress-git.rb "Feature implementation"
```
