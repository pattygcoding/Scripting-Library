## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` map.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(ruby goto.rb repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```
cd "$(ruby goto.rb repos)"
```
