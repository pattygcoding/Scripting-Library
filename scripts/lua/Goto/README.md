## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` table.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(lua goto.lua repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```lua
cd "$(lua goto.lua repos)"
```
