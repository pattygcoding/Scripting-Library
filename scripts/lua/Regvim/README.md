## Regvim
This script searches for files by name in the current directory and its subdirectories, then opens each match in Vim.

### Dependencies
- `lfs` (LuaFileSystem): `luarocks install luafilesystem`
- **Vim**: Must be in your PATH

### Arguments
- `file`: The file name to search for (required).

### Example Usage
```lua
lua regvim.lua example.txt
```
