## Goto
This script prints the path of a frequently used directory, configured in the `DESTINATIONS` map.

A child process cannot change its parent shell's working directory, so it prints the destination instead. Use it as `cd "$(python goto.py repos)"`.

### Arguments
- `target`: The destination to look up.

### Example Usage
```
cd "$(python goto.py repos)"
```
