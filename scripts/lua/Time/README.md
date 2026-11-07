## Time
This script times any operation, printing how long the given command took to run.

### Dependencies
- `socket` (LuaSocket): `luarocks install luasocket` (optional; enables high-resolution timing)

### Arguments
- `command`: The command to run and time (required).

### Example Usage
```lua
lua time.lua ping example.com
```
