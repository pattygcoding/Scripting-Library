## Reset Git
This script performs a hard reset of the current Git branch to match the `origin/main` branch exactly. This will discard all local changes and commits that are not on the remote main branch.

### Example Usage
```ruby
ruby reset-git.rb
```

**Warning:** This operation is destructive and will permanently remove local changes and commits.