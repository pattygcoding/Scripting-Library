## Update Git
This script updates the current Git branch by fetching the latest changes and merging them from a specified branch (default is `master`).

### Arguments
- `-b`, `--branch`: The branch to merge into the current branch. If not specified, `master` is used.

### Example Usage
```ruby
ruby update_git.rb --branch develop
```
