## Rebase Git
This script rebases the current Git branch onto a specified branch (default is `master`). It fetches the latest changes, performs the rebase, and pushes the rebased changes using `--force-with-lease` for safety.

### Arguments
- `branch`: The branch to rebase onto (optional, defaults to `master`)

### Example Usage
```ruby
ruby rebase-git.rb
ruby rebase-git.rb develop
```