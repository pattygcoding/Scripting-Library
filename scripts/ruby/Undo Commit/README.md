## Undo Commit
This script undoes the last Git commit using different reset modes. It supports hard, mixed, or soft reset modes and force pushes the changes.

### Arguments
- `mode`: The reset mode to use (`hard`, `mixed`, or `soft`). Defaults to `hard` if not specified.
  - `hard`: Removes commit and discards all changes
  - `mixed`: Removes commit but keeps changes in working directory
  - `soft`: Removes commit but keeps changes staged

### Example Usage
```ruby
ruby undo-commit.rb
ruby undo-commit.rb soft
ruby undo-commit.rb mixed
```

**Warning:** This operation force pushes changes and may affect the remote repository.