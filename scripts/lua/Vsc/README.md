## Vsc
This script searches for a file by name in the current directory and its subdirectories, then opens it in Visual Studio Code.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **VS Code**: `code` must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua vsc.lua example.js
```
